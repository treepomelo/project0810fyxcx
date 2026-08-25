package cn.iocoder.yudao.module.marketplace.service.order;

import cn.hutool.core.util.IdUtil;
import cn.hutool.crypto.digest.DigestUtil;
import cn.iocoder.yudao.framework.common.enums.CommonStatusEnum;
import cn.iocoder.yudao.framework.common.pojo.PageParam;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.module.marketplace.config.MarketplaceOrderProperties;
import cn.iocoder.yudao.module.marketplace.controller.app.order.vo.AppMarketplaceOrderCancelReqVO;
import cn.iocoder.yudao.module.marketplace.controller.app.order.vo.AppMarketplaceOrderReqVO;
import cn.iocoder.yudao.module.marketplace.controller.app.order.vo.AppMarketplaceOrderRespVO;
import cn.iocoder.yudao.module.marketplace.controller.app.order.vo.AppMarketplaceOrderPayRespVO;
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
import cn.iocoder.yudao.module.product.api.property.dto.ProductPropertyValueDetailRespDTO;
import cn.iocoder.yudao.module.product.api.sku.ProductSkuApi;
import cn.iocoder.yudao.module.product.api.sku.dto.ProductSkuRespDTO;
import cn.iocoder.yudao.module.product.api.sku.dto.ProductSkuUpdateStockReqDTO;
import cn.iocoder.yudao.module.product.api.spu.ProductSpuApi;
import cn.iocoder.yudao.module.product.api.spu.dto.ProductSpuRespDTO;
import cn.iocoder.yudao.module.product.enums.spu.ProductSpuStatusEnum;
import cn.iocoder.yudao.module.trade.api.cart.CartApi;
import cn.iocoder.yudao.module.trade.api.cart.dto.CartItemRespDTO;
import cn.iocoder.yudao.framework.common.enums.UserTypeEnum;
import cn.iocoder.yudao.module.pay.api.notify.dto.PayOrderNotifyReqDTO;
import cn.iocoder.yudao.module.pay.api.order.PayOrderApi;
import cn.iocoder.yudao.module.pay.api.order.dto.PayOrderCreateReqDTO;
import cn.iocoder.yudao.module.pay.api.order.dto.PayOrderRespDTO;
import cn.iocoder.yudao.module.pay.enums.order.PayOrderStatusEnum;
import jakarta.annotation.Resource;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.env.Environment;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import com.baomidou.mybatisplus.core.conditions.update.LambdaUpdateWrapper;
import cn.iocoder.yudao.framework.common.exception.ServiceException;

import java.time.LocalDateTime;
import java.util.*;
import java.util.function.Function;
import java.util.stream.Collectors;

import static cn.iocoder.yudao.framework.common.exception.util.ServiceExceptionUtil.exception;
import static cn.iocoder.yudao.module.marketplace.enums.ErrorCodeConstants.*;
import static cn.iocoder.yudao.module.product.enums.ErrorCodeConstants.SKU_STOCK_NOT_ENOUGH;

/**
 * Historical Marketplace order core, intentionally excluding payment, shipping, receiving,
 * after-sale and finance flows. Product price and stock are always recomputed server-side.
 */
@Service
public class MarketplaceOrderServiceImpl implements MarketplaceOrderService {
    private static final Logger log = LoggerFactory.getLogger(MarketplaceOrderServiceImpl.class);

    @Resource private CartApi cartApi;
    @Resource private ProductSkuApi skuApi;
    @Resource private ProductSpuApi spuApi;
    @Resource private MemberAddressApi addressApi;
    @Resource private MarketplaceProductRelationMapper relationMapper;
    @Resource private MarketplaceMerchantMapper merchantMapper;
    @Resource private MarketplaceShopMapper shopMapper;
    @Resource private MarketplaceOrderMapper orderMapper;
    @Resource private MarketplaceMerchantOrderMapper merchantOrderMapper;
    @Resource private MarketplaceOrderItemMapper itemMapper;
    @Resource private MarketplaceOrderProperties orderProperties;
    @Resource private PayOrderApi payOrderApi;
    @Value("${marketplace.pay.app-key:heritage-marketplace}") private String payAppKey;
    @Resource private Environment environment;

    @Override
    public AppMarketplaceOrderRespVO preview(Long memberId, AppMarketplaceOrderReqVO req) {
        return toPreview(prepare(memberId, req));
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Long create(Long memberId, AppMarketplaceOrderReqVO req) {
        if (req.getRequestId() == null || req.getRequestId().isBlank()) throw exception(ORDER_REQUEST_ID_REQUIRED);
        String requestHash = requestHash(req);
        MarketplaceOrderDO existing = orderMapper.selectByMemberAndRequestKey(memberId, req.getRequestId());
        if (existing != null) {
            if (!Objects.equals(existing.getRequestHash(), requestHash)) throw exception(ORDER_IDEMPOTENCY_CONFLICT);
            return existing.getId();
        }
        Prepared prepared = prepare(memberId, req);
        MarketplaceOrderDO order = new MarketplaceOrderDO().setOrderNo(number("PO"))
                .setMemberId(memberId).setOrderType("PRODUCT").setStatus("WAIT_PAY")
                .setTotalAmount(prepared.total).setDiscountAmount(0L).setDeliveryAmount(0L).setPayAmount(prepared.total)
                .setReceiverName(prepared.address.getName()).setReceiverMobile(prepared.address.getMobile())
                .setReceiverAreaId(prepared.address.getAreaId()).setReceiverDetailAddress(prepared.address.getDetailAddress())
                .setUserRemark(req.getUserRemark()).setRequestKey(req.getRequestId()).setRequestHash(requestHash).setVersion(0);
        orderMapper.insert(order);

        Map<Long, MarketplaceMerchantOrderDO> groups = new LinkedHashMap<>();
        for (PreparedItem item : prepared.items) {
            MarketplaceMerchantOrderDO merchantOrder = groups.computeIfAbsent(item.relation.getMerchantId(), merchantId -> {
                MarketplaceMerchantDO merchant = prepared.merchants.get(merchantId);
                MarketplaceShopDO shop = prepared.shops.get(item.relation.getShopId());
                MarketplaceMerchantOrderDO bean = new MarketplaceMerchantOrderDO().setMerchantOrderNo(number("MO"))
                        .setPlatformOrderId(order.getId()).setMerchantId(merchantId).setShopId(shop.getId()).setStatus("WAIT_PAY")
                        .setGoodsAmount(0L).setDiscountAmount(0L).setDeliveryAmount(0L).setPayAmount(0L).setRefundAmount(0L)
                        .setMerchantNameSnapshot(merchant.getName()).setShopNameSnapshot(shop.getName()).setVersion(0);
                merchantOrderMapper.insert(bean);
                return bean;
            });
            merchantOrder.setGoodsAmount(add(merchantOrder.getGoodsAmount(), item.amount))
                    .setPayAmount(add(merchantOrder.getPayAmount(), item.amount));
            merchantOrderMapper.updateById(merchantOrder);
            itemMapper.insert(new MarketplaceOrderItemDO().setPlatformOrderId(order.getId()).setMerchantOrderId(merchantOrder.getId())
                    .setSpuId(item.sku.getSpuId()).setSkuId(item.sku.getId()).setProductName(item.spu.getName())
                    .setSkuProperties(properties(item.sku)).setPicUrl(item.sku.getPicUrl() == null ? item.spu.getPicUrl() : item.sku.getPicUrl())
                    .setPrice((long) item.sku.getPrice()).setCount(item.cart.getCount()).setTotalAmount(item.amount)
                    .setMerchantId(item.relation.getMerchantId()).setShopId(item.relation.getShopId())
                    .setRefundStatus("NONE").setRefundAmount(0L));
        }
        skuApi.updateSkuStock(new ProductSkuUpdateStockReqDTO(prepared.items.stream().map(item -> {
            ProductSkuUpdateStockReqDTO.Item stock = new ProductSkuUpdateStockReqDTO.Item();
            stock.setId(item.sku.getId()).setIncrCount(-item.cart.getCount());
            return stock;
        }).toList()));
        cartApi.deleteCartItems(memberId, req.getCartItemIds());
        return order.getId();
    }

    @Override public AppMarketplaceOrderRespVO get(Long memberId, Long id) { return assemble(requireOrder(id, memberId)); }
    @Override public PageResult<AppMarketplaceOrderRespVO> page(Long memberId, PageParam req) { return mapPage(orderMapper.selectPage(req, memberId)); }
    @Override public AppMarketplaceOrderRespVO adminGet(Long id) { return assemble(requireOrder(id, null)); }
    @Override public PageResult<AppMarketplaceOrderRespVO> adminPage(Long memberId, PageParam req) { return mapPage(orderMapper.selectPage(req, memberId)); }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void cancel(Long memberId, AppMarketplaceOrderCancelReqVO req) {
        MarketplaceOrderDO order = requireOrder(req.getId(), memberId);
        if ("CANCELLED".equals(order.getStatus())) return;
        if (!closeWaitPayOrder(order, req.getReason())) throw exception(ORDER_STATUS_INVALID);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void devPay(Long orderId) {
        if (!environment.matchesProfiles("local", "dev")) {
            throw new ServiceException(ORDER_STATUS_INVALID.getCode(), "开发环境模拟支付仅允许 local/dev profile 调用");
        }
        MarketplaceOrderDO order = requireOrder(orderId, null);
        LocalDateTime now = LocalDateTime.now();
        int updated = orderMapper.update(null, new LambdaUpdateWrapper<MarketplaceOrderDO>()
                .eq(MarketplaceOrderDO::getId, orderId).eq(MarketplaceOrderDO::getStatus, "WAIT_PAY")
                .set(MarketplaceOrderDO::getStatus, "PAID").set(MarketplaceOrderDO::getPayTime, now));
        if (updated != 1) throw exception(ORDER_STATUS_INVALID);
        List<MarketplaceMerchantOrderDO> merchantOrders = merchantOrderMapper.selectByPlatformOrderId(orderId);
        if (merchantOrders.isEmpty() || merchantOrderMapper.markAllWaitShip(orderId) != merchantOrders.size()) {
            throw exception(ORDER_STATUS_INVALID);
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public AppMarketplaceOrderPayRespVO preparePayment(Long memberId, Long orderId, String userIp) {
        MarketplaceOrderDO order = requireOrder(orderId, memberId);
        if (!"WAIT_PAY".equals(order.getStatus())) throw exception(ORDER_STATUS_INVALID);
        int payPrice = toPayPrice(order.getPayAmount());
        if (order.getPayOrderId() != null) {
            PayOrderRespDTO existing = payOrderApi.getOrder(order.getPayOrderId());
            validatePayReference(order, order.getPayOrderId(), existing);
            return new AppMarketplaceOrderPayRespVO().setOrderId(order.getId()).setPayOrderId(existing.getId())
                    .setPayAmount(order.getPayAmount()).setPayStatus(existing.getStatus());
        }
        Long payOrderId = payOrderApi.createOrder(new PayOrderCreateReqDTO()
                .setAppKey(payAppKey).setUserIp(userIp).setUserId(memberId).setUserType(UserTypeEnum.MEMBER.getValue())
                .setMerchantOrderId(order.getOrderNo()).setSubject(paymentSubject(order)).setBody("非遗平台商品订单")
                .setPrice(payPrice).setExpireTime(LocalDateTime.now().plusMinutes(orderProperties.getPayTimeoutMinutes())));
        PayOrderRespDTO payOrder = payOrderApi.getOrder(payOrderId);
        validatePayReference(order, payOrderId, payOrder);
        if (orderMapper.bindPayOrder(order.getId(), memberId, payOrderId) != 1) {
            MarketplaceOrderDO latest = requireOrder(order.getId(), memberId);
            if (!"WAIT_PAY".equals(latest.getStatus()) || !Objects.equals(latest.getPayOrderId(), payOrderId)) {
                throw exception(ORDER_STATUS_INVALID);
            }
        }
        return new AppMarketplaceOrderPayRespVO().setOrderId(order.getId()).setPayOrderId(payOrderId)
                .setPayAmount(order.getPayAmount()).setPayStatus(payOrder.getStatus());
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void updatePaid(PayOrderNotifyReqDTO req) {
        MarketplaceOrderDO order = orderMapper.selectByOrderNo(req.getMerchantOrderId());
        if (order == null) throw exception(ORDER_NOT_EXISTS);
        PayOrderRespDTO payOrder = payOrderApi.getOrder(req.getPayOrderId());
        validatePayReference(order, req.getPayOrderId(), payOrder);
        if (!PayOrderStatusEnum.isSuccess(payOrder.getStatus())) throw exception(ORDER_PAY_NOT_SUCCESS);
        if ("PAID".equals(order.getStatus()) && Objects.equals(order.getPayOrderId(), req.getPayOrderId())) return;
        if (orderMapper.markPaid(order.getId(), req.getPayOrderId(), payOrder.getSuccessTime()) != 1) {
            MarketplaceOrderDO latest = orderMapper.selectById(order.getId());
            if (latest != null && "PAID".equals(latest.getStatus()) && Objects.equals(latest.getPayOrderId(), req.getPayOrderId())) return;
            throw exception(ORDER_STATUS_INVALID);
        }
        List<MarketplaceMerchantOrderDO> merchantOrders = merchantOrderMapper.selectByPlatformOrderId(order.getId());
        if (merchantOrders.isEmpty() || merchantOrderMapper.markAllWaitShip(order.getId()) != merchantOrders.size()) {
            throw exception(ORDER_STATUS_INVALID);
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void ship(Long merchantOrderId, MarketplaceMerchantOrderShipReqVO req) {
        MarketplaceMerchantOrderDO merchantOrder = requireMerchantOrder(merchantOrderId);
        MarketplaceOrderDO platformOrder = requireOrder(merchantOrder.getPlatformOrderId(), null);
        if (!"PAID".equals(platformOrder.getStatus()) || !"WAIT_SHIP".equals(merchantOrder.getStatus())) throw exception(ORDER_STATUS_INVALID);
        String shippingType = req.getShippingType().trim().toUpperCase(Locale.ROOT);
        String companyCode = null, companyName = null, trackingNo = null;
        if ("EXPRESS".equals(shippingType)) {
            companyCode = requireText(req.getLogisticsCompanyCode());
            companyName = requireText(req.getLogisticsCompanyName());
            trackingNo = requireText(req.getTrackingNo());
        } else if (!"NO_EXPRESS".equals(shippingType)) throw exception(ORDER_SHIPPING_TYPE_INVALID);
        if (merchantOrderMapper.ship(merchantOrderId, shippingType, companyCode, companyName, trackingNo,
                trimToNull(req.getDeliveryRemark()), LocalDateTime.now()) != 1) throw exception(ORDER_STATUS_INVALID);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void receive(Long memberId, AppMarketplaceMerchantOrderReceiveReqVO req) {
        MarketplaceMerchantOrderDO merchantOrder = requireMerchantOrder(req.getMerchantOrderId());
        MarketplaceOrderDO platformOrder = requireOrder(merchantOrder.getPlatformOrderId(), memberId);
        if (!"PAID".equals(platformOrder.getStatus()) || !"SHIPPED".equals(merchantOrder.getStatus())) throw exception(ORDER_STATUS_INVALID);
        LocalDateTime now = LocalDateTime.now();
        if (merchantOrderMapper.receive(merchantOrder.getId(), now) != 1) throw exception(ORDER_STATUS_INVALID);
        if (merchantOrderMapper.countNotCompletedByPlatformOrderId(platformOrder.getId()) == 0) orderMapper.markCompleted(platformOrder.getId(), now);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int closeExpiredWaitPayOrders() {
        int count = 0;
        LocalDateTime cutoff = LocalDateTime.now().minusMinutes(orderProperties.getPayTimeoutMinutes());
        for (MarketplaceOrderDO order : orderMapper.selectExpiredWaitPay(cutoff, orderProperties.getTimeoutBatchSize())) {
            if (closeWaitPayOrder(order, "PAY_TIMEOUT")) count++;
        }
        return count;
    }

    private boolean closeWaitPayOrder(MarketplaceOrderDO order, String reason) {
        if (orderMapper.closeWaitPay(order.getId(), reason) != 1) return false;
        List<MarketplaceOrderItemDO> items = itemMapper.selectByPlatformOrderId(order.getId());
        skuApi.updateSkuStock(new ProductSkuUpdateStockReqDTO(items.stream().map(item -> {
            ProductSkuUpdateStockReqDTO.Item stock = new ProductSkuUpdateStockReqDTO.Item();
            stock.setId(item.getSkuId()).setIncrCount(item.getCount());
            return stock;
        }).toList()));
        List<MarketplaceMerchantOrderDO> merchantOrders = merchantOrderMapper.selectByPlatformOrderId(order.getId());
        if (merchantOrders.isEmpty() || merchantOrderMapper.cancelAllWaitPay(order.getId()) != merchantOrders.size()) {
            throw exception(ORDER_STATUS_INVALID);
        }
        return true;
    }

    private void validatePayReference(MarketplaceOrderDO order, Long payOrderId, PayOrderRespDTO payOrder) {
        if (payOrder == null || !Objects.equals(payOrder.getId(), payOrderId)
                || !Objects.equals(payOrder.getMerchantOrderId(), order.getOrderNo())
                || order.getPayOrderId() != null && !Objects.equals(order.getPayOrderId(), payOrderId)) {
            throw exception(ORDER_PAY_REFERENCE_INVALID);
        }
        if (!Objects.equals(payOrder.getPrice(), toPayPrice(order.getPayAmount()))) throw exception(ORDER_PAY_AMOUNT_MISMATCH);
    }

    private int toPayPrice(Long amount) {
        if (amount == null || amount <= 0 || amount > Integer.MAX_VALUE) throw exception(ORDER_PAY_AMOUNT_INVALID);
        return amount.intValue();
    }

    private String paymentSubject(MarketplaceOrderDO order) {
        String subject = "非遗平台订单-" + order.getOrderNo();
        return subject.length() <= PayOrderCreateReqDTO.SUBJECT_MAX_LENGTH ? subject : subject.substring(0, PayOrderCreateReqDTO.SUBJECT_MAX_LENGTH);
    }

    private Prepared prepare(Long memberId, AppMarketplaceOrderReqVO req) {
        if (req.getCartItemIds() == null || req.getCartItemIds().isEmpty()) {
            throw exception(ORDER_CART_INVALID);
        }
        log.info("[MarketplaceOrderPreview] cartItemIds={}, addressId={}", req.getCartItemIds(), req.getAddressId());
        List<CartItemRespDTO> carts = cartApi.getCartItems(memberId, req.getCartItemIds());
        if (carts.size() != new HashSet<>(req.getCartItemIds()).size()
                || carts.stream().anyMatch(cart -> !Boolean.TRUE.equals(cart.getSelected()) || cart.getCount() == null || cart.getCount() <= 0)) {
            throw exception(ORDER_CART_INVALID);
        }
        carts.forEach(cart -> log.debug("[MarketplaceOrderPreview] cartItem id={}, spuId={}, skuId={}, count={}",
                cart.getId(), cart.getSpuId(), cart.getSkuId(), cart.getCount()));
        MemberAddressRespDTO address = addressApi.getAddress(req.getAddressId(), memberId);
        Set<Long> skuIds = carts.stream().map(CartItemRespDTO::getSkuId).filter(Objects::nonNull)
                .collect(Collectors.toCollection(LinkedHashSet::new));
        if (skuIds.isEmpty()) {
            throw exception(PRODUCT_NOT_SALEABLE);
        }
        Map<Long, ProductSkuRespDTO> skus = skuApi.getSkuMap(skuIds);
        if (skus.size() != skuIds.size()) {
            throw exception(PRODUCT_NOT_SALEABLE);
        }
        Set<Long> spuIds = skus.values().stream().map(ProductSkuRespDTO::getSpuId).filter(Objects::nonNull)
                .collect(Collectors.toCollection(LinkedHashSet::new));
        if (spuIds.isEmpty()) {
            throw exception(PRODUCT_NOT_SALEABLE);
        }
        Map<Long, ProductSpuRespDTO> spus = spuApi.getSpuList(spuIds)
                .stream().collect(Collectors.toMap(ProductSpuRespDTO::getId, Function.identity()));
        if (spus.size() != spuIds.size()) {
            throw exception(PRODUCT_NOT_SALEABLE);
        }
        for (CartItemRespDTO cart : carts) {
            ProductSkuRespDTO sku = skus.get(cart.getSkuId());
            ProductSpuRespDTO spu = sku == null ? null : spus.get(sku.getSpuId());
            if (sku == null || spu == null || !Objects.equals(cart.getSpuId(), sku.getSpuId())
                    || !ProductSpuStatusEnum.isEnable(spu.getStatus())) {
                throw exception(PRODUCT_NOT_SALEABLE);
            }
            if (sku.getStock() == null || sku.getStock() < cart.getCount()) {
                throw exception(SKU_STOCK_NOT_ENOUGH);
            }
        }
        List<MarketplaceProductRelationDO> relations = relationMapper.selectListBySpuIds(spuIds);
        Map<Long, List<MarketplaceProductRelationDO>> bySpu = relations.stream()
                .filter(relation -> CommonStatusEnum.isEnable(relation.getStatus()))
                .collect(Collectors.groupingBy(MarketplaceProductRelationDO::getSpuId));
        List<MarketplaceProductRelationDO> activeRelations = new ArrayList<>();
        for (Long spuId : spuIds) {
            List<MarketplaceProductRelationDO> matches = bySpu.getOrDefault(spuId, List.of());
            if (matches.size() != 1) {
                log.warn("[MarketplaceOrderPreview] code={}, message={}, spuId={}, validRelationCount={}, source=MarketplaceOrderServiceImpl.prepare",
                        ORDER_PRODUCT_RELATION_INVALID.getCode(), ORDER_PRODUCT_RELATION_INVALID.getMsg(), spuId, matches.size());
                throw exception(ORDER_PRODUCT_RELATION_INVALID);
            }
            activeRelations.add(matches.get(0));
        }
        Set<Long> merchantIds = activeRelations.stream().map(MarketplaceProductRelationDO::getMerchantId)
                .filter(Objects::nonNull).collect(Collectors.toCollection(LinkedHashSet::new));
        Set<Long> shopIds = activeRelations.stream().map(MarketplaceProductRelationDO::getShopId)
                .filter(Objects::nonNull).collect(Collectors.toCollection(LinkedHashSet::new));
        if (merchantIds.isEmpty() || shopIds.isEmpty()) {
            throw exception(ORDER_PRODUCT_RELATION_INVALID);
        }
        Map<Long, MarketplaceMerchantDO> merchants = merchantMapper.selectByIds(merchantIds).stream()
                .collect(Collectors.toMap(MarketplaceMerchantDO::getId, Function.identity()));
        Map<Long, MarketplaceShopDO> shops = shopMapper.selectByIds(shopIds).stream()
                .collect(Collectors.toMap(MarketplaceShopDO::getId, Function.identity()));
        long total = 0;
        List<PreparedItem> items = new ArrayList<>();
        for (CartItemRespDTO cart : carts) {
            ProductSkuRespDTO sku = skus.get(cart.getSkuId());
            ProductSpuRespDTO spu = sku == null ? null : spus.get(sku.getSpuId());
            if (sku == null || spu == null || !Objects.equals(cart.getSpuId(), sku.getSpuId())
                    || !ProductSpuStatusEnum.isEnable(spu.getStatus())) throw exception(PRODUCT_NOT_SALEABLE);
            List<MarketplaceProductRelationDO> matches = bySpu.getOrDefault(spu.getId(), List.of());
            if (matches.size() != 1) throw exception(ORDER_PRODUCT_RELATION_INVALID);
            MarketplaceProductRelationDO relation = matches.get(0);
            MarketplaceMerchantDO merchant = merchants.get(relation.getMerchantId());
            MarketplaceShopDO shop = shops.get(relation.getShopId());
            if (merchant == null || shop == null || !CommonStatusEnum.isEnable(merchant.getStatus())
                    || !CommonStatusEnum.isEnable(shop.getStatus()) || !Objects.equals(shop.getMerchantId(), merchant.getId())) {
                throw exception(ORDER_PRODUCT_RELATION_INVALID);
            }
            long amount = multiply(sku.getPrice(), cart.getCount());
            total = add(total, amount);
            items.add(new PreparedItem(cart, sku, spu, relation, amount));
        }
        return new Prepared(address, items, merchants, shops, total);
    }

    private AppMarketplaceOrderRespVO toPreview(Prepared prepared) {
        AppMarketplaceOrderRespVO response = new AppMarketplaceOrderRespVO().setOrderType("PRODUCT").setStatus("PREVIEW")
                .setGoodsAmount(prepared.total).setDiscountAmount(0L).setDeliveryAmount(0L).setPayAmount(prepared.total)
                .setReceiverName(prepared.address.getName()).setReceiverMobile(prepared.address.getMobile())
                .setReceiverAreaId(prepared.address.getAreaId()).setReceiverDetailAddress(prepared.address.getDetailAddress());
        response.setMerchantOrders(prepared.items.stream().collect(Collectors.groupingBy(item -> item.relation.getMerchantId(), LinkedHashMap::new, Collectors.toList()))
                .entrySet().stream().map(entry -> {
                    List<PreparedItem> items = entry.getValue();
                    MarketplaceProductRelationDO relation = items.get(0).relation;
                    AppMarketplaceOrderRespVO.MerchantGroup group = new AppMarketplaceOrderRespVO.MerchantGroup();
                    group.setMerchantId(entry.getKey()).setShopId(relation.getShopId()).setMerchantName(prepared.merchants.get(entry.getKey()).getName())
                            .setShopName(prepared.shops.get(relation.getShopId()).getName()).setStatus("PREVIEW");
                    group.setGoodsAmount(items.stream().mapToLong(item -> item.amount).sum()).setPayAmount(group.getGoodsAmount());
                    group.setItems(items.stream().map(this::item).toList());
                    return group;
                }).toList());
        return response;
    }

    private AppMarketplaceOrderRespVO.Item item(PreparedItem item) {
        return new AppMarketplaceOrderRespVO.Item().setSpuId(item.sku.getSpuId()).setSkuId(item.sku.getId())
                .setProductName(item.spu.getName()).setSkuProperties(properties(item.sku))
                .setPicUrl(item.sku.getPicUrl() == null ? item.spu.getPicUrl() : item.sku.getPicUrl())
                .setPrice((long) item.sku.getPrice()).setCount(item.cart.getCount()).setTotalAmount(item.amount);
    }

    private MarketplaceOrderDO requireOrder(Long id, Long memberId) {
        MarketplaceOrderDO order = orderMapper.selectById(id);
        if (order == null || memberId != null && !Objects.equals(memberId, order.getMemberId())) throw exception(ORDER_NOT_EXISTS);
        return order;
    }
    private MarketplaceMerchantOrderDO requireMerchantOrder(Long id) {
        MarketplaceMerchantOrderDO merchantOrder = merchantOrderMapper.selectById(id);
        if (merchantOrder == null) throw exception(MERCHANT_ORDER_NOT_EXISTS);
        return merchantOrder;
    }
    private String requireText(String value) {
        String text = trimToNull(value);
        if (text == null) throw exception(ORDER_EXPRESS_INFORMATION_REQUIRED);
        return text;
    }
    private String trimToNull(String value) {
        if (value == null) return null;
        String text = value.trim();
        return text.isEmpty() ? null : text;
    }
    private AppMarketplaceOrderRespVO assemble(MarketplaceOrderDO order) {
        List<MarketplaceMerchantOrderDO> merchantOrders = merchantOrderMapper.selectByPlatformOrderId(order.getId());
        AppMarketplaceOrderRespVO response = new AppMarketplaceOrderRespVO().setId(order.getId()).setOrderNo(order.getOrderNo())
                .setOrderType(order.getOrderType()).setStatus(displayStatus(order, merchantOrders)).setGoodsAmount(order.getTotalAmount())
                .setDiscountAmount(order.getDiscountAmount()).setDeliveryAmount(order.getDeliveryAmount()).setPayAmount(order.getPayAmount())
                .setPayOrderId(order.getPayOrderId()).setPayTime(order.getPayTime()).setReceiverName(order.getReceiverName())
                .setReceiverMobile(order.getReceiverMobile()).setReceiverAreaId(order.getReceiverAreaId())
                .setReceiverDetailAddress(order.getReceiverDetailAddress()).setCreateTime(order.getCreateTime());
        Map<Long, List<MarketplaceOrderItemDO>> items = itemMapper.selectByPlatformOrderId(order.getId()).stream()
                .collect(Collectors.groupingBy(MarketplaceOrderItemDO::getMerchantOrderId));
        response.setMerchantOrders(merchantOrders.stream().map(merchantOrder -> {
            AppMarketplaceOrderRespVO.MerchantGroup group = new AppMarketplaceOrderRespVO.MerchantGroup().setId(merchantOrder.getId())
                    .setMerchantId(merchantOrder.getMerchantId()).setShopId(merchantOrder.getShopId())
                    .setMerchantName(merchantOrder.getMerchantNameSnapshot()).setShopName(merchantOrder.getShopNameSnapshot())
                    .setGoodsAmount(merchantOrder.getGoodsAmount()).setPayAmount(merchantOrder.getPayAmount()).setStatus(merchantOrder.getStatus())
                    .setShippingType(merchantOrder.getShippingType()).setLogisticsCompanyCode(merchantOrder.getLogisticsCompanyCode())
                    .setLogisticsCompanyName(merchantOrder.getLogisticsCompanyName()).setTrackingNo(merchantOrder.getTrackingNo())
                    .setDeliveryRemark(merchantOrder.getDeliveryRemark()).setShipTime(merchantOrder.getShipTime())
                    .setReceiveTime(merchantOrder.getReceiveTime()).setFinishTime(merchantOrder.getFinishTime());
            group.setItems(items.getOrDefault(merchantOrder.getId(), List.of()).stream().map(item -> new AppMarketplaceOrderRespVO.Item()
                    .setId(item.getId()).setSpuId(item.getSpuId()).setSkuId(item.getSkuId()).setProductName(item.getProductName())
                    .setSkuProperties(item.getSkuProperties()).setPicUrl(item.getPicUrl()).setPrice(item.getPrice())
                    .setCount(item.getCount()).setTotalAmount(item.getTotalAmount())).toList());
            return group;
        }).toList());
        return response;
    }
    private String displayStatus(MarketplaceOrderDO order, List<MarketplaceMerchantOrderDO> merchantOrders) {
        if ("WAIT_PAY".equals(order.getStatus()) || "CANCELLED".equals(order.getStatus()) || "COMPLETED".equals(order.getStatus())) return order.getStatus();
        if (!merchantOrders.isEmpty() && merchantOrders.stream().allMatch(item -> "WAIT_SHIP".equals(item.getStatus()))) return "WAIT_SHIP";
        if (!merchantOrders.isEmpty() && merchantOrders.stream().allMatch(item -> "SHIPPED".equals(item.getStatus()))) return "WAIT_RECEIVE";
        return order.getStatus();
    }
    private PageResult<AppMarketplaceOrderRespVO> mapPage(PageResult<MarketplaceOrderDO> page) {
        return new PageResult<>(page.getList().stream().map(this::assemble).toList(), page.getTotal());
    }
    private String properties(ProductSkuRespDTO sku) {
        return sku.getProperties() == null ? "" : sku.getProperties().stream()
                .map(ProductPropertyValueDetailRespDTO::getValueName).collect(Collectors.joining(" / "));
    }
    private String number(String prefix) { return prefix + IdUtil.fastSimpleUUID().toUpperCase(Locale.ROOT); }
    private String requestHash(AppMarketplaceOrderReqVO req) {
        return DigestUtil.sha256Hex(req.getCartItemIds().stream().distinct().sorted().map(String::valueOf).collect(Collectors.joining(","))
                + "|" + req.getAddressId() + "|" + Objects.toString(req.getUserRemark(), ""));
    }
    private long multiply(int price, int count) { try { return Math.multiplyExact((long) price, (long) count); } catch (ArithmeticException e) { throw exception(ORDER_AMOUNT_OVERFLOW); } }
    private long add(long first, long second) { try { return Math.addExact(first, second); } catch (ArithmeticException e) { throw exception(ORDER_AMOUNT_OVERFLOW); } }
    private record Prepared(MemberAddressRespDTO address, List<PreparedItem> items, Map<Long, MarketplaceMerchantDO> merchants, Map<Long, MarketplaceShopDO> shops, long total) {}
    private record PreparedItem(CartItemRespDTO cart, ProductSkuRespDTO sku, ProductSpuRespDTO spu, MarketplaceProductRelationDO relation, long amount) {}
}
