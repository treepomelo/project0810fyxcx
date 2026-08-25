package cn.iocoder.yudao.module.marketplace.service.aftersale;

import cn.iocoder.yudao.module.marketplace.controller.app.aftersale.vo.AppMarketplaceAfterSaleCreateReqVO;
import cn.iocoder.yudao.module.marketplace.dal.dataobject.aftersale.MarketplaceAfterSaleDO;
import cn.iocoder.yudao.module.marketplace.dal.dataobject.order.*;
import cn.iocoder.yudao.module.marketplace.dal.mysql.aftersale.MarketplaceAfterSaleMapper;
import cn.iocoder.yudao.module.marketplace.dal.mysql.order.*;
import cn.iocoder.yudao.module.pay.api.notify.dto.PayRefundNotifyReqDTO;
import cn.iocoder.yudao.module.pay.api.refund.PayRefundApi;
import cn.iocoder.yudao.module.pay.api.refund.dto.PayRefundRespDTO;
import cn.iocoder.yudao.module.pay.enums.refund.PayRefundStatusEnum;
import cn.iocoder.yudao.module.marketplace.service.finance.MarketplaceFinanceService;
import org.junit.jupiter.api.Test;

import java.time.LocalDateTime;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

class MarketplaceAfterSaleServiceImplTest {
    @Test void createUsesServerItemSnapshotAndNeverClientAmount() {
        MarketplaceAfterSaleServiceImpl service = new MarketplaceAfterSaleServiceImpl();
        MarketplaceAfterSaleMapper afterSaleMapper = mock(MarketplaceAfterSaleMapper.class); MarketplaceOrderMapper orderMapper = mock(MarketplaceOrderMapper.class);
        MarketplaceMerchantOrderMapper merchantOrderMapper = mock(MarketplaceMerchantOrderMapper.class); MarketplaceOrderItemMapper itemMapper = mock(MarketplaceOrderItemMapper.class);
        inject(service, "afterSaleMapper", afterSaleMapper); inject(service, "orderMapper", orderMapper); inject(service, "merchantOrderMapper", merchantOrderMapper); inject(service, "itemMapper", itemMapper); inject(service, "payRefundApi", mock(PayRefundApi.class));
        when(itemMapper.selectById(7L)).thenReturn(new MarketplaceOrderItemDO().setId(7L).setPlatformOrderId(1L).setMerchantOrderId(2L).setMerchantId(3L).setShopId(4L).setPrice(5000L).setCount(2));
        when(orderMapper.selectById(1L)).thenReturn(new MarketplaceOrderDO().setId(1L).setMemberId(9L).setStatus("PAID"));
        when(merchantOrderMapper.selectById(2L)).thenReturn(new MarketplaceMerchantOrderDO().setId(2L).setMerchantId(3L).setStatus("WAIT_SHIP"));
        when(afterSaleMapper.selectActiveApplyCount(7L)).thenReturn(0); doAnswer(invocation -> { invocation.<cn.iocoder.yudao.module.marketplace.dal.dataobject.aftersale.MarketplaceAfterSaleDO>getArgument(0).setId(99L); return 1; }).when(afterSaleMapper).insert(org.mockito.ArgumentMatchers.<cn.iocoder.yudao.module.marketplace.dal.dataobject.aftersale.MarketplaceAfterSaleDO>any());
        AppMarketplaceAfterSaleCreateReqVO req = new AppMarketplaceAfterSaleCreateReqVO(); req.setOrderItemId(7L); req.setCount(2); req.setType("REFUND_ONLY"); req.setRequestId("one");
        assertEquals(99L, service.create(9L, req)); verify(afterSaleMapper).insert(org.mockito.ArgumentMatchers.<cn.iocoder.yudao.module.marketplace.dal.dataobject.aftersale.MarketplaceAfterSaleDO>argThat(value -> value.getApplyAmount() == 10000L));
    }
    @Test void createRejectsOtherMemberOrderItem() {
        MarketplaceAfterSaleServiceImpl service = new MarketplaceAfterSaleServiceImpl(); MarketplaceOrderItemMapper itemMapper = mock(MarketplaceOrderItemMapper.class); MarketplaceOrderMapper orderMapper = mock(MarketplaceOrderMapper.class);
        inject(service, "itemMapper", itemMapper); inject(service, "orderMapper", orderMapper); inject(service, "afterSaleMapper", mock(MarketplaceAfterSaleMapper.class)); inject(service, "merchantOrderMapper", mock(MarketplaceMerchantOrderMapper.class)); inject(service, "payRefundApi", mock(PayRefundApi.class));
        when(itemMapper.selectById(7L)).thenReturn(new MarketplaceOrderItemDO().setPlatformOrderId(1L)); when(orderMapper.selectById(1L)).thenReturn(new MarketplaceOrderDO().setMemberId(10L));
        AppMarketplaceAfterSaleCreateReqVO req = new AppMarketplaceAfterSaleCreateReqVO(); req.setOrderItemId(7L); req.setCount(1); req.setType("REFUND_ONLY"); req.setRequestId("two");
        assertThrows(RuntimeException.class, () -> service.create(9L, req));
    }
    @Test void createRejectsCountBeyondOutstandingAfterSales() {
        MarketplaceAfterSaleServiceImpl service = new MarketplaceAfterSaleServiceImpl(); MarketplaceAfterSaleMapper mapper = mock(MarketplaceAfterSaleMapper.class); MarketplaceOrderItemMapper itemMapper = mock(MarketplaceOrderItemMapper.class); MarketplaceOrderMapper orderMapper = mock(MarketplaceOrderMapper.class); MarketplaceMerchantOrderMapper merchantMapper = mock(MarketplaceMerchantOrderMapper.class);
        inject(service, "afterSaleMapper", mapper); inject(service, "itemMapper", itemMapper); inject(service, "orderMapper", orderMapper); inject(service, "merchantOrderMapper", merchantMapper); inject(service, "payRefundApi", mock(PayRefundApi.class)); inject(service, "afterSaleApplyDays", 7);
        when(itemMapper.selectById(7L)).thenReturn(new MarketplaceOrderItemDO().setId(7L).setPlatformOrderId(1L).setMerchantOrderId(2L).setMerchantId(3L).setCount(2)); when(orderMapper.selectById(1L)).thenReturn(new MarketplaceOrderDO().setMemberId(9L).setStatus("PAID")); when(merchantMapper.selectById(2L)).thenReturn(new MarketplaceMerchantOrderDO().setMerchantId(3L).setStatus("WAIT_SHIP")); when(mapper.selectActiveApplyCount(7L)).thenReturn(2);
        AppMarketplaceAfterSaleCreateReqVO req = new AppMarketplaceAfterSaleCreateReqVO(); req.setOrderItemId(7L); req.setCount(1); req.setType("REFUND_ONLY"); req.setRequestId("three"); assertThrows(RuntimeException.class, () -> service.create(9L, req));
    }
    @Test void refundNotificationUpdatesItemAggregateOnlyOnce() {
        MarketplaceAfterSaleServiceImpl service = new MarketplaceAfterSaleServiceImpl(); MarketplaceAfterSaleMapper mapper = mock(MarketplaceAfterSaleMapper.class);
        MarketplaceOrderItemMapper itemMapper = mock(MarketplaceOrderItemMapper.class); PayRefundApi refundApi = mock(PayRefundApi.class);
        MarketplaceFinanceService financeService = mock(MarketplaceFinanceService.class);
        inject(service, "afterSaleMapper", mapper); inject(service, "itemMapper", itemMapper); inject(service, "payRefundApi", refundApi); inject(service, "financeService", financeService);
        MarketplaceAfterSaleDO afterSale = new MarketplaceAfterSaleDO().setId(3L).setAfterSaleNo("AS-1").setOrderItemId(7L).setApplyCount(1).setApplyAmount(5000L);
        when(mapper.selectOne(any(com.baomidou.mybatisplus.core.toolkit.support.SFunction.class), eq("AS-1"))).thenReturn(afterSale); when(mapper.markRefunded(eq(3L), eq(11L), any())).thenReturn(1).thenReturn(0);
        PayRefundRespDTO refund = new PayRefundRespDTO(); refund.setStatus(PayRefundStatusEnum.SUCCESS.getStatus()); refund.setRefundPrice(5000); when(refundApi.getRefund(11L)).thenReturn(refund);
        PayRefundNotifyReqDTO notify = new PayRefundNotifyReqDTO("PO-1", "AS-1", 11L);
        service.updateRefunded(notify); service.updateRefunded(notify);
        verify(itemMapper, times(1)).addRefunded(7L, 1, 5000L);
        verify(financeService, times(1)).recordRefund(afterSale);
    }
    @Test void createIsIdempotentByMemberAndRequestId() {
        MarketplaceAfterSaleServiceImpl service = new MarketplaceAfterSaleServiceImpl(); MarketplaceAfterSaleMapper mapper = mock(MarketplaceAfterSaleMapper.class);
        inject(service, "afterSaleMapper", mapper);
        when(mapper.selectByMemberAndRequestId(9L, "same")).thenReturn(new MarketplaceAfterSaleDO().setId(77L));
        AppMarketplaceAfterSaleCreateReqVO req = new AppMarketplaceAfterSaleCreateReqVO(); req.setRequestId("same");
        assertEquals(77L, service.create(9L, req)); verify(mapper).selectByMemberAndRequestId(9L, "same"); verifyNoMoreInteractions(mapper);
    }
    @Test void returnRefundAcceptsShippedMerchantOrder() {
        MarketplaceAfterSaleServiceImpl service = new MarketplaceAfterSaleServiceImpl(); MarketplaceAfterSaleMapper mapper = mock(MarketplaceAfterSaleMapper.class); MarketplaceOrderItemMapper itemMapper = mock(MarketplaceOrderItemMapper.class); MarketplaceOrderMapper orderMapper = mock(MarketplaceOrderMapper.class); MarketplaceMerchantOrderMapper merchantMapper = mock(MarketplaceMerchantOrderMapper.class);
        inject(service, "afterSaleMapper", mapper); inject(service, "itemMapper", itemMapper); inject(service, "orderMapper", orderMapper); inject(service, "merchantOrderMapper", merchantMapper); inject(service, "payRefundApi", mock(PayRefundApi.class)); inject(service, "afterSaleApplyDays", 7);
        when(itemMapper.selectById(7L)).thenReturn(new MarketplaceOrderItemDO().setId(7L).setPlatformOrderId(1L).setMerchantOrderId(2L).setMerchantId(3L).setShopId(4L).setPrice(5000L).setCount(2));
        when(orderMapper.selectById(1L)).thenReturn(new MarketplaceOrderDO().setId(1L).setMemberId(9L).setStatus("PAID").setPayTime(LocalDateTime.now()));
        when(merchantMapper.selectById(2L)).thenReturn(new MarketplaceMerchantOrderDO().setId(2L).setMerchantId(3L).setStatus("SHIPPED")); when(mapper.selectActiveApplyCount(7L)).thenReturn(0);
        AppMarketplaceAfterSaleCreateReqVO req = new AppMarketplaceAfterSaleCreateReqVO(); req.setOrderItemId(7L); req.setCount(1); req.setType("RETURN_REFUND"); req.setRequestId("return");
        service.create(9L, req); verify(mapper).insert(org.mockito.ArgumentMatchers.<MarketplaceAfterSaleDO>argThat(value -> "RETURN_REFUND".equals(value.getType())));
    }
    @Test void cancelledOrderAndExpiredWindowAreProtected() {
        MarketplaceAfterSaleServiceImpl service = new MarketplaceAfterSaleServiceImpl(); MarketplaceAfterSaleMapper mapper = mock(MarketplaceAfterSaleMapper.class); MarketplaceOrderItemMapper itemMapper = mock(MarketplaceOrderItemMapper.class); MarketplaceOrderMapper orderMapper = mock(MarketplaceOrderMapper.class); MarketplaceMerchantOrderMapper merchantMapper = mock(MarketplaceMerchantOrderMapper.class);
        inject(service, "afterSaleMapper", mapper); inject(service, "itemMapper", itemMapper); inject(service, "orderMapper", orderMapper); inject(service, "merchantOrderMapper", merchantMapper); inject(service, "payRefundApi", mock(PayRefundApi.class)); inject(service, "afterSaleApplyDays", 7);
        when(itemMapper.selectById(7L)).thenReturn(new MarketplaceOrderItemDO().setId(7L).setPlatformOrderId(1L).setMerchantOrderId(2L).setMerchantId(3L).setCount(1)); when(merchantMapper.selectById(2L)).thenReturn(new MarketplaceMerchantOrderDO().setMerchantId(3L).setStatus("SHIPPED"));
        AppMarketplaceAfterSaleCreateReqVO req = new AppMarketplaceAfterSaleCreateReqVO(); req.setOrderItemId(7L); req.setCount(1); req.setType("REFUND_ONLY"); req.setRequestId("blocked");
        when(orderMapper.selectById(1L)).thenReturn(new MarketplaceOrderDO().setMemberId(9L).setStatus("CANCELLED")); assertThrows(RuntimeException.class, () -> service.create(9L, req));
        when(orderMapper.selectById(1L)).thenReturn(new MarketplaceOrderDO().setMemberId(9L).setStatus("PAID").setPayTime(LocalDateTime.now().minusDays(8))); assertThrows(RuntimeException.class, () -> service.create(9L, req));
    }
    private static void inject(Object target, String name, Object value) { try { var field = target.getClass().getDeclaredField(name); field.setAccessible(true); field.set(target, value); } catch (ReflectiveOperationException e) { throw new AssertionError(e); } }
}
