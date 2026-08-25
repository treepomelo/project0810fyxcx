package cn.iocoder.yudao.module.marketplace.service.order;

import cn.iocoder.yudao.framework.common.enums.CommonStatusEnum;
import cn.iocoder.yudao.module.marketplace.config.MarketplaceOrderProperties;
import cn.iocoder.yudao.module.marketplace.controller.app.order.vo.AppMarketplaceOrderCancelReqVO;
import cn.iocoder.yudao.module.marketplace.controller.app.order.vo.AppMarketplaceOrderReqVO;
import cn.iocoder.yudao.module.marketplace.controller.app.order.vo.AppMarketplaceMerchantOrderReceiveReqVO;
import cn.iocoder.yudao.module.marketplace.controller.admin.order.vo.MarketplaceMerchantOrderShipReqVO;
import cn.iocoder.yudao.module.marketplace.dal.dataobject.MarketplaceMerchantDO;
import cn.iocoder.yudao.module.marketplace.dal.dataobject.MarketplaceProductRelationDO;
import cn.iocoder.yudao.module.marketplace.dal.dataobject.MarketplaceShopDO;
import cn.iocoder.yudao.module.marketplace.dal.dataobject.order.MarketplaceMerchantOrderDO;
import cn.iocoder.yudao.module.marketplace.dal.dataobject.order.MarketplaceOrderDO;
import cn.iocoder.yudao.module.marketplace.dal.dataobject.order.MarketplaceOrderItemDO;
import cn.iocoder.yudao.module.marketplace.dal.mysql.MarketplaceMerchantMapper;
import cn.iocoder.yudao.module.marketplace.dal.mysql.MarketplaceProductRelationMapper;
import cn.iocoder.yudao.module.marketplace.dal.mysql.MarketplaceShopMapper;
import cn.iocoder.yudao.module.marketplace.dal.mysql.order.MarketplaceMerchantOrderMapper;
import cn.iocoder.yudao.module.marketplace.dal.mysql.order.MarketplaceOrderItemMapper;
import cn.iocoder.yudao.module.marketplace.dal.mysql.order.MarketplaceOrderMapper;
import cn.iocoder.yudao.module.member.api.address.MemberAddressApi;
import cn.iocoder.yudao.module.member.api.address.dto.MemberAddressRespDTO;
import cn.iocoder.yudao.module.product.api.sku.ProductSkuApi;
import cn.iocoder.yudao.module.product.api.sku.dto.ProductSkuRespDTO;
import cn.iocoder.yudao.module.product.api.sku.dto.ProductSkuUpdateStockReqDTO;
import cn.iocoder.yudao.module.product.api.spu.ProductSpuApi;
import cn.iocoder.yudao.module.product.api.spu.dto.ProductSpuRespDTO;
import cn.iocoder.yudao.module.product.enums.spu.ProductSpuStatusEnum;
import cn.iocoder.yudao.module.trade.api.cart.CartApi;
import cn.iocoder.yudao.module.trade.api.cart.dto.CartItemRespDTO;
import cn.iocoder.yudao.module.pay.api.notify.dto.PayOrderNotifyReqDTO;
import cn.iocoder.yudao.module.pay.api.order.PayOrderApi;
import cn.iocoder.yudao.module.pay.api.order.dto.PayOrderCreateReqDTO;
import cn.iocoder.yudao.module.pay.api.order.dto.PayOrderRespDTO;
import cn.iocoder.yudao.module.pay.enums.order.PayOrderStatusEnum;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.test.util.ReflectionTestUtils;

import java.util.*;
import java.util.concurrent.atomic.AtomicLong;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class MarketplaceOrderCoreTest {
    @Mock CartApi cartApi; @Mock ProductSkuApi skuApi; @Mock ProductSpuApi spuApi; @Mock MemberAddressApi addressApi;
    @Mock MarketplaceProductRelationMapper relationMapper; @Mock MarketplaceMerchantMapper merchantMapper; @Mock MarketplaceShopMapper shopMapper;
    @Mock MarketplaceOrderMapper orderMapper; @Mock MarketplaceMerchantOrderMapper merchantOrderMapper; @Mock MarketplaceOrderItemMapper itemMapper;
    @Mock PayOrderApi payOrderApi;
    @InjectMocks MarketplaceOrderServiceImpl service;
    private AtomicLong ids;

    @BeforeEach void setup() {
        ids = new AtomicLong(100);
        ReflectionTestUtils.setField(service, "orderProperties", new MarketplaceOrderProperties());
        lenient().doAnswer(invocation -> { invocation.<MarketplaceOrderDO>getArgument(0).setId(ids.incrementAndGet()); return 1; }).when(orderMapper).insert(any(MarketplaceOrderDO.class));
        lenient().doAnswer(invocation -> { invocation.<MarketplaceMerchantOrderDO>getArgument(0).setId(ids.incrementAndGet()); return 1; }).when(merchantOrderMapper).insert(any(MarketplaceMerchantOrderDO.class));
    }

    @Test void createSplitsTwoMerchantsAndUsesServerPrices() {
        mockTwoMerchantContext();
        assertNotNull(service.create(7L, req(List.of(11L, 12L), "multi-1")));
        verify(merchantOrderMapper, times(2)).insert(any(MarketplaceMerchantOrderDO.class));
        ArgumentCaptor<MarketplaceOrderItemDO> items = ArgumentCaptor.forClass(MarketplaceOrderItemDO.class);
        verify(itemMapper, times(2)).insert(items.capture());
        assertEquals(Set.of(1000L, 4000L), new HashSet<>(items.getAllValues().stream().map(MarketplaceOrderItemDO::getTotalAmount).toList()));
        verify(cartApi).deleteCartItems(7L, List.of(11L, 12L));
        verify(skuApi).updateSkuStock(argThat(stock -> stock.getItems().stream().map(ProductSkuUpdateStockReqDTO.Item::getIncrCount).toList().equals(List.of(-2, -1))));
    }
    @Test void duplicateRequestIsIdempotent() {
        AppMarketplaceOrderReqVO req = req(List.of(11L), "same");
        when(orderMapper.selectByMemberAndRequestKey(7L, "same")).thenReturn(new MarketplaceOrderDO().setId(99L).setRequestHash(hash(req)));
        assertEquals(99L, service.create(7L, req)); verifyNoInteractions(skuApi, cartApi);
    }
    @Test void addressOwnershipUsesAuthenticatedMember() {
        mockTwoMerchantContext(); service.preview(7L, req(List.of(11L, 12L), "address")); verify(addressApi).getAddress(88L, 7L);
    }
    @Test void singleMerchantCreatesOneMerchantOrder() {
        mockSingleMerchantContext(); service.create(7L, req(List.of(11L), "single")); verify(merchantOrderMapper, times(1)).insert(any(MarketplaceMerchantOrderDO.class));
    }
    @Test void stockFailureDoesNotDeleteCart() {
        mockSingleMerchantContext(); doThrow(new RuntimeException("stock insufficient")).when(skuApi).updateSkuStock(any());
        assertThrows(RuntimeException.class, () -> service.create(7L, req(List.of(11L), "stock"))); verify(cartApi, never()).deleteCartItems(anyLong(), anyList());
    }
    @Test void memberCannotReadAnotherMembersOrder() {
        when(orderMapper.selectById(1L)).thenReturn(new MarketplaceOrderDO().setId(1L).setMemberId(7L));
        assertThrows(RuntimeException.class, () -> service.get(8L, 1L));
    }
    @Test void cancellationRestoresStockOnlyOnce() {
        MarketplaceOrderDO order = new MarketplaceOrderDO().setId(1L).setMemberId(7L).setStatus("WAIT_PAY");
        when(orderMapper.selectById(1L)).thenReturn(order, new MarketplaceOrderDO().setId(1L).setMemberId(7L).setStatus("CANCELLED"));
        when(orderMapper.closeWaitPay(1L, "changed mind")).thenReturn(1);
        when(itemMapper.selectByPlatformOrderId(1L)).thenReturn(List.of(new MarketplaceOrderItemDO().setSkuId(21L).setCount(2)));
        when(merchantOrderMapper.selectByPlatformOrderId(1L)).thenReturn(List.of(new MarketplaceMerchantOrderDO().setId(11L)));
        when(merchantOrderMapper.cancelAllWaitPay(1L)).thenReturn(1);
        AppMarketplaceOrderCancelReqVO req = new AppMarketplaceOrderCancelReqVO().setId(1L).setReason("changed mind");
        service.cancel(7L, req); service.cancel(7L, req);
        verify(skuApi, times(1)).updateSkuStock(argThat(stock -> stock.getItems().get(0).getIncrCount() == 2));
    }
    @Test void prepareCreatesOnePayOrderFromPlatformAmount() {
        MarketplaceOrderDO order = waitingOrder(1L, 7L, 5000L); when(orderMapper.selectById(1L)).thenReturn(order);
        when(payOrderApi.createOrder(any())).thenReturn(900L); when(payOrderApi.getOrder(900L)).thenReturn(payOrder(900L, order, 5000, PayOrderStatusEnum.WAITING.getStatus()));
        when(orderMapper.bindPayOrder(1L, 7L, 900L)).thenReturn(1);
        assertEquals(900L, service.preparePayment(7L, 1L, "127.0.0.1").getPayOrderId());
        ArgumentCaptor<PayOrderCreateReqDTO> request = ArgumentCaptor.forClass(PayOrderCreateReqDTO.class); verify(payOrderApi).createOrder(request.capture());
        assertEquals(5000, request.getValue().getPrice()); assertEquals(order.getOrderNo(), request.getValue().getMerchantOrderId());
    }
    @Test void repeatedPrepareReusesExistingPayOrder() {
        MarketplaceOrderDO order = waitingOrder(1L, 7L, 5000L).setPayOrderId(900L); when(orderMapper.selectById(1L)).thenReturn(order);
        when(payOrderApi.getOrder(900L)).thenReturn(payOrder(900L, order, 5000, PayOrderStatusEnum.WAITING.getStatus()));
        assertEquals(900L, service.preparePayment(7L, 1L, "127.0.0.1").getPayOrderId()); verify(payOrderApi, never()).createOrder(any());
    }
    @Test void paymentSuccessMovesAllMerchantOrdersOnlyOnce() {
        MarketplaceOrderDO order = waitingOrder(1L, 7L, 5000L).setPayOrderId(900L);
        when(orderMapper.selectByOrderNo(order.getOrderNo())).thenReturn(order, new MarketplaceOrderDO().setId(1L).setStatus("PAID").setPayOrderId(900L).setOrderNo(order.getOrderNo()).setPayAmount(5000L));
        when(payOrderApi.getOrder(900L)).thenReturn(payOrder(900L, order, 5000, PayOrderStatusEnum.SUCCESS.getStatus())); when(orderMapper.markPaid(eq(1L), eq(900L), any())).thenReturn(1);
        when(merchantOrderMapper.selectByPlatformOrderId(1L)).thenReturn(List.of(new MarketplaceMerchantOrderDO().setId(11L), new MarketplaceMerchantOrderDO().setId(12L))); when(merchantOrderMapper.markAllWaitShip(1L)).thenReturn(2);
        PayOrderNotifyReqDTO callback = PayOrderNotifyReqDTO.builder().merchantOrderId(order.getOrderNo()).payOrderId(900L).build(); service.updatePaid(callback); service.updatePaid(callback);
        verify(orderMapper, times(1)).markPaid(eq(1L), eq(900L), any()); verify(merchantOrderMapper, times(1)).markAllWaitShip(1L);
    }
    @Test void cancelledOrderCannotBecomePaid() {
        MarketplaceOrderDO order = waitingOrder(1L, 7L, 5000L).setStatus("CANCELLED").setPayOrderId(900L); when(orderMapper.selectByOrderNo(order.getOrderNo())).thenReturn(order, order);
        when(payOrderApi.getOrder(900L)).thenReturn(payOrder(900L, order, 5000, PayOrderStatusEnum.SUCCESS.getStatus())); when(orderMapper.markPaid(eq(1L), eq(900L), any())).thenReturn(0);
        assertThrows(RuntimeException.class, () -> service.updatePaid(PayOrderNotifyReqDTO.builder().merchantOrderId(order.getOrderNo()).payOrderId(900L).build()));
    }
    @Test void waitPayNotExpiredIsNotClosed() {
        when(orderMapper.selectExpiredWaitPay(any(), anyInt())).thenReturn(List.of());
        assertEquals(0, service.closeExpiredWaitPayOrders()); verify(orderMapper, never()).closeWaitPay(anyLong(), anyString());
    }
    @Test void expiredWaitPayClosesAndRestoresStockOnlyOnce() {
        MarketplaceOrderDO order = waitingOrder(1L, 7L, 5000L);
        when(orderMapper.selectExpiredWaitPay(any(), anyInt())).thenReturn(List.of(order), List.of(order));
        when(orderMapper.closeWaitPay(1L, "PAY_TIMEOUT")).thenReturn(1, 0);
        when(itemMapper.selectByPlatformOrderId(1L)).thenReturn(List.of(new MarketplaceOrderItemDO().setSkuId(21L).setCount(2)));
        when(merchantOrderMapper.selectByPlatformOrderId(1L)).thenReturn(List.of(new MarketplaceMerchantOrderDO().setId(11L), new MarketplaceMerchantOrderDO().setId(12L)));
        when(merchantOrderMapper.cancelAllWaitPay(1L)).thenReturn(2);
        assertEquals(1, service.closeExpiredWaitPayOrders()); assertEquals(0, service.closeExpiredWaitPayOrders());
        verify(skuApi, times(1)).updateSkuStock(any()); verify(merchantOrderMapper, times(1)).cancelAllWaitPay(1L);
    }
    @Test void manualCancelThenTimeoutDoesNotRestoreAgain() {
        MarketplaceOrderDO order = waitingOrder(1L, 7L, 5000L);
        when(orderMapper.selectById(1L)).thenReturn(order); when(orderMapper.closeWaitPay(1L, "manual")).thenReturn(1);
        when(itemMapper.selectByPlatformOrderId(1L)).thenReturn(List.of(new MarketplaceOrderItemDO().setSkuId(21L).setCount(1)));
        when(merchantOrderMapper.selectByPlatformOrderId(1L)).thenReturn(List.of(new MarketplaceMerchantOrderDO().setId(11L))); when(merchantOrderMapper.cancelAllWaitPay(1L)).thenReturn(1);
        service.cancel(7L, new AppMarketplaceOrderCancelReqVO().setId(1L).setReason("manual"));
        when(orderMapper.selectExpiredWaitPay(any(), anyInt())).thenReturn(List.of(order)); when(orderMapper.closeWaitPay(1L, "PAY_TIMEOUT")).thenReturn(0);
        assertEquals(0, service.closeExpiredWaitPayOrders()); verify(skuApi, times(1)).updateSkuStock(any());
    }
    @Test void paidOrderIsProtectedFromTimeout() {
        MarketplaceOrderDO order = waitingOrder(1L, 7L, 5000L).setStatus("PAID");
        when(orderMapper.selectExpiredWaitPay(any(), anyInt())).thenReturn(List.of(order)); when(orderMapper.closeWaitPay(1L, "PAY_TIMEOUT")).thenReturn(0);
        assertEquals(0, service.closeExpiredWaitPayOrders()); verifyNoInteractions(skuApi);
    }
    @Test void timeoutThenPayCallbackCannotMarkPaid() {
        MarketplaceOrderDO order = waitingOrder(1L, 7L, 5000L).setPayOrderId(900L);
        when(orderMapper.selectExpiredWaitPay(any(), anyInt())).thenReturn(List.of(order)); when(orderMapper.closeWaitPay(1L, "PAY_TIMEOUT")).thenReturn(1);
        when(itemMapper.selectByPlatformOrderId(1L)).thenReturn(List.of(new MarketplaceOrderItemDO().setSkuId(21L).setCount(1)));
        when(merchantOrderMapper.selectByPlatformOrderId(1L)).thenReturn(List.of(new MarketplaceMerchantOrderDO().setId(11L))); when(merchantOrderMapper.cancelAllWaitPay(1L)).thenReturn(1);
        assertEquals(1, service.closeExpiredWaitPayOrders());
        when(orderMapper.selectByOrderNo(order.getOrderNo())).thenReturn(order); when(payOrderApi.getOrder(900L)).thenReturn(payOrder(900L, order, 5000, PayOrderStatusEnum.SUCCESS.getStatus())); when(orderMapper.markPaid(eq(1L), eq(900L), any())).thenReturn(0); when(orderMapper.selectById(1L)).thenReturn(new MarketplaceOrderDO().setId(1L).setStatus("CANCELLED"));
        assertThrows(RuntimeException.class, () -> service.updatePaid(PayOrderNotifyReqDTO.builder().merchantOrderId(order.getOrderNo()).payOrderId(900L).build()));
    }
    @Test void paidMerchantOrderShipsWithLogisticsSnapshot() {
        MarketplaceMerchantOrderDO merchantOrder = new MarketplaceMerchantOrderDO().setId(11L).setPlatformOrderId(1L).setStatus("WAIT_SHIP");
        when(merchantOrderMapper.selectById(11L)).thenReturn(merchantOrder); when(orderMapper.selectById(1L)).thenReturn(new MarketplaceOrderDO().setId(1L).setStatus("PAID")); when(merchantOrderMapper.ship(eq(11L), eq("EXPRESS"), eq("SF"), eq("SF Express"), eq("SF123"), any(), any())).thenReturn(1);
        MarketplaceMerchantOrderShipReqVO req = new MarketplaceMerchantOrderShipReqVO(); req.setMerchantOrderId(11L); req.setShippingType("EXPRESS"); req.setLogisticsCompanyCode("SF"); req.setLogisticsCompanyName("SF Express"); req.setTrackingNo("SF123");
        service.ship(11L, req); verify(merchantOrderMapper).ship(eq(11L), eq("EXPRESS"), eq("SF"), eq("SF Express"), eq("SF123"), any(), any());
    }
    @Test void waitPayAndCancelledOrdersCannotShip() {
        MarketplaceMerchantOrderDO merchantOrder = new MarketplaceMerchantOrderDO().setId(11L).setPlatformOrderId(1L).setStatus("WAIT_SHIP"); when(merchantOrderMapper.selectById(11L)).thenReturn(merchantOrder);
        MarketplaceMerchantOrderShipReqVO req = new MarketplaceMerchantOrderShipReqVO(); req.setMerchantOrderId(11L); req.setShippingType("NO_EXPRESS");
        when(orderMapper.selectById(1L)).thenReturn(new MarketplaceOrderDO().setId(1L).setStatus("WAIT_PAY"), new MarketplaceOrderDO().setId(1L).setStatus("CANCELLED"));
        assertThrows(RuntimeException.class, () -> service.ship(11L, req)); assertThrows(RuntimeException.class, () -> service.ship(11L, req)); verify(merchantOrderMapper, never()).ship(anyLong(), anyString(), any(), any(), any(), any(), any());
    }
    @Test void shippedOrderReceivesOnlyForOwnerAndCompletesSingleMerchantPlatformOrder() {
        MarketplaceMerchantOrderDO merchantOrder = new MarketplaceMerchantOrderDO().setId(11L).setPlatformOrderId(1L).setStatus("SHIPPED"); when(merchantOrderMapper.selectById(11L)).thenReturn(merchantOrder);
        when(orderMapper.selectById(1L)).thenReturn(new MarketplaceOrderDO().setId(1L).setMemberId(7L).setStatus("PAID")); when(merchantOrderMapper.receive(eq(11L), any())).thenReturn(1); when(merchantOrderMapper.countNotCompletedByPlatformOrderId(1L)).thenReturn(0L);
        AppMarketplaceMerchantOrderReceiveReqVO req = new AppMarketplaceMerchantOrderReceiveReqVO(); req.setMerchantOrderId(11L); service.receive(7L, req); verify(orderMapper).markCompleted(eq(1L), any()); assertThrows(RuntimeException.class, () -> service.receive(8L, req));
    }
    @Test void multiMerchantPartialCompletionDoesNotCompletePlatformOrder() {
        MarketplaceMerchantOrderDO merchantOrder = new MarketplaceMerchantOrderDO().setId(11L).setPlatformOrderId(1L).setStatus("SHIPPED"); when(merchantOrderMapper.selectById(11L)).thenReturn(merchantOrder); when(orderMapper.selectById(1L)).thenReturn(new MarketplaceOrderDO().setId(1L).setMemberId(7L).setStatus("PAID")); when(merchantOrderMapper.receive(eq(11L), any())).thenReturn(1); when(merchantOrderMapper.countNotCompletedByPlatformOrderId(1L)).thenReturn(1L);
        AppMarketplaceMerchantOrderReceiveReqVO req = new AppMarketplaceMerchantOrderReceiveReqVO(); req.setMerchantOrderId(11L); service.receive(7L, req); verify(orderMapper, never()).markCompleted(anyLong(), any());
    }

    private void mockTwoMerchantContext() {
        when(cartApi.getCartItems(eq(7L), anyList())).thenReturn(List.of(cart(11,31,21,2), cart(12,32,22,1)));
        mockAddress(); ProductSkuRespDTO first = sku(21,31,500), second = sku(22,32,4000); when(skuApi.getSkuMap(anyList())).thenReturn(Map.of(21L, first, 22L, second));
        when(spuApi.getSpuList(anyList())).thenReturn(List.of(spu(31,"A"), spu(32,"B"))); when(relationMapper.selectListBySpuIds(anyCollection())).thenReturn(List.of(rel(31,1,1),rel(32,2,2)));
        when(merchantMapper.selectByIds(anyCollection())).thenReturn(List.of(merchant(1,"Merchant A"), merchant(2,"Merchant B"))); when(shopMapper.selectByIds(anyCollection())).thenReturn(List.of(shop(1,1,"Shop A"), shop(2,2,"Shop B")));
    }
    private void mockSingleMerchantContext() {
        when(cartApi.getCartItems(eq(7L), anyList())).thenReturn(List.of(cart(11,31,21,2))); mockAddress();
        when(skuApi.getSkuMap(anyList())).thenReturn(Map.of(21L, sku(21,31,500))); when(spuApi.getSpuList(anyList())).thenReturn(List.of(spu(31,"A")));
        when(relationMapper.selectListBySpuIds(anyCollection())).thenReturn(List.of(rel(31,1,1))); when(merchantMapper.selectByIds(anyCollection())).thenReturn(List.of(merchant(1,"Merchant A"))); when(shopMapper.selectByIds(anyCollection())).thenReturn(List.of(shop(1,1,"Shop A")));
    }
    private void mockAddress() { when(addressApi.getAddress(88L,7L)).thenReturn(new MemberAddressRespDTO().setId(88L).setUserId(7L).setName("Test").setMobile("13800000000").setAreaId(320200).setDetailAddress("Test address")); }
    private AppMarketplaceOrderReqVO req(List<Long> ids, String key) { return new AppMarketplaceOrderReqVO().setCartItemIds(ids).setAddressId(88L).setRequestId(key); }
    private String hash(AppMarketplaceOrderReqVO req) { return cn.hutool.crypto.digest.DigestUtil.sha256Hex(req.getCartItemIds().stream().distinct().sorted().map(String::valueOf).collect(java.util.stream.Collectors.joining(",")) + "|" + req.getAddressId() + "|"); }
    private CartItemRespDTO cart(long id,long spu,long sku,int count) { return new CartItemRespDTO().setId(id).setSpuId(spu).setSkuId(sku).setCount(count).setSelected(true); }
    private ProductSkuRespDTO sku(long id,long spu,int price) { return new ProductSkuRespDTO().setId(id).setSpuId(spu).setPrice(price).setStock(10).setProperties(List.of()); }
    private ProductSpuRespDTO spu(long id,String name) { return new ProductSpuRespDTO().setId(id).setName(name).setPicUrl("test.png").setStatus(ProductSpuStatusEnum.ENABLE.getStatus()); }
    private MarketplaceProductRelationDO rel(long spu,long merchant,long shop) { return new MarketplaceProductRelationDO().setSpuId(spu).setMerchantId(merchant).setShopId(shop).setStatus(CommonStatusEnum.ENABLE.getStatus()); }
    private MarketplaceMerchantDO merchant(long id,String name) { return new MarketplaceMerchantDO().setId(id).setName(name).setStatus(CommonStatusEnum.ENABLE.getStatus()); }
    private MarketplaceShopDO shop(long id,long merchant,String name) { return new MarketplaceShopDO().setId(id).setMerchantId(merchant).setName(name).setStatus(CommonStatusEnum.ENABLE.getStatus()); }
    private MarketplaceOrderDO waitingOrder(long id, long member, long amount) { return new MarketplaceOrderDO().setId(id).setMemberId(member).setOrderNo("PO-" + id).setStatus("WAIT_PAY").setPayAmount(amount); }
    private PayOrderRespDTO payOrder(long id, MarketplaceOrderDO order, int price, int status) { return new PayOrderRespDTO().setId(id).setMerchantOrderId(order.getOrderNo()).setPrice(price).setStatus(status).setSuccessTime(java.time.LocalDateTime.now()); }
}
