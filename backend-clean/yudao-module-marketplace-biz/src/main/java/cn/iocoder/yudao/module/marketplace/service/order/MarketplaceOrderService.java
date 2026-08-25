package cn.iocoder.yudao.module.marketplace.service.order;

import cn.iocoder.yudao.framework.common.pojo.PageParam;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.module.marketplace.controller.app.order.vo.AppMarketplaceOrderCancelReqVO;
import cn.iocoder.yudao.module.marketplace.controller.app.order.vo.AppMarketplaceOrderReqVO;
import cn.iocoder.yudao.module.marketplace.controller.app.order.vo.AppMarketplaceOrderRespVO;
import cn.iocoder.yudao.module.marketplace.controller.app.order.vo.AppMarketplaceOrderPayRespVO;
import cn.iocoder.yudao.module.marketplace.controller.app.order.vo.AppMarketplaceMerchantOrderReceiveReqVO;
import cn.iocoder.yudao.module.marketplace.controller.admin.order.vo.MarketplaceMerchantOrderShipReqVO;
import cn.iocoder.yudao.module.pay.api.notify.dto.PayOrderNotifyReqDTO;

/** Marketplace order core only: preview, create, query, cancel and timeout close. */
public interface MarketplaceOrderService {
    AppMarketplaceOrderRespVO preview(Long memberId, AppMarketplaceOrderReqVO req);
    Long create(Long memberId, AppMarketplaceOrderReqVO req);
    AppMarketplaceOrderRespVO get(Long memberId, Long id);
    PageResult<AppMarketplaceOrderRespVO> page(Long memberId, PageParam req);
    void cancel(Long memberId, AppMarketplaceOrderCancelReqVO req);
    void devPay(Long orderId);
    AppMarketplaceOrderPayRespVO preparePayment(Long memberId, Long orderId, String userIp);
    void updatePaid(PayOrderNotifyReqDTO req);
    void ship(Long merchantOrderId, MarketplaceMerchantOrderShipReqVO req);
    void receive(Long memberId, AppMarketplaceMerchantOrderReceiveReqVO req);
    int closeExpiredWaitPayOrders();
    AppMarketplaceOrderRespVO adminGet(Long id);
    PageResult<AppMarketplaceOrderRespVO> adminPage(Long memberId, PageParam req);
}
