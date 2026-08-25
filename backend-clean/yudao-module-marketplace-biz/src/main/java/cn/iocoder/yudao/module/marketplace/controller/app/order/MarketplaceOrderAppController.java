package cn.iocoder.yudao.module.marketplace.controller.app.order;

import cn.iocoder.yudao.framework.common.pojo.CommonResult;
import cn.iocoder.yudao.framework.common.pojo.PageParam;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.security.core.util.SecurityFrameworkUtils;
import cn.iocoder.yudao.module.marketplace.controller.app.order.vo.AppMarketplaceOrderCancelReqVO;
import cn.iocoder.yudao.module.marketplace.controller.app.order.vo.AppMarketplaceOrderReqVO;
import cn.iocoder.yudao.module.marketplace.controller.app.order.vo.AppMarketplaceOrderRespVO;
import cn.iocoder.yudao.module.marketplace.controller.app.order.vo.AppMarketplaceOrderPayReqVO;
import cn.iocoder.yudao.module.marketplace.controller.app.order.vo.AppMarketplaceOrderPayRespVO;
import cn.iocoder.yudao.module.marketplace.controller.app.order.vo.AppMarketplaceMerchantOrderReceiveReqVO;
import cn.iocoder.yudao.module.marketplace.service.order.MarketplaceOrderService;
import cn.iocoder.yudao.module.pay.api.notify.dto.PayOrderNotifyReqDTO;
import jakarta.annotation.Resource;
import jakarta.annotation.security.PermitAll;
import jakarta.validation.Valid;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import static cn.iocoder.yudao.framework.common.pojo.CommonResult.success;
import static cn.iocoder.yudao.framework.common.util.servlet.ServletUtils.getClientIP;

@RestController
@RequestMapping("/marketplace/order")
@Validated
public class MarketplaceOrderAppController {
    @Resource private MarketplaceOrderService service;

    @PostMapping("/preview")
    public CommonResult<AppMarketplaceOrderRespVO> preview(@Valid @RequestBody AppMarketplaceOrderReqVO req) {
        return success(service.preview(SecurityFrameworkUtils.getLoginUserId(), req));
    }
    @PostMapping("/create")
    public CommonResult<Long> create(@Valid @RequestBody AppMarketplaceOrderReqVO req) {
        return success(service.create(SecurityFrameworkUtils.getLoginUserId(), req));
    }
    @GetMapping("/get")
    public CommonResult<AppMarketplaceOrderRespVO> get(@RequestParam Long id) {
        return success(service.get(SecurityFrameworkUtils.getLoginUserId(), id));
    }
    @GetMapping("/page")
    public CommonResult<PageResult<AppMarketplaceOrderRespVO>> page(@Valid PageParam req) {
        return success(service.page(SecurityFrameworkUtils.getLoginUserId(), req));
    }
    @PutMapping("/cancel")
    public CommonResult<Boolean> cancel(@Valid @RequestBody AppMarketplaceOrderCancelReqVO req) {
        service.cancel(SecurityFrameworkUtils.getLoginUserId(), req);
        return success(true);
    }
    @PostMapping("/pay")
    public CommonResult<AppMarketplaceOrderPayRespVO> pay(@Valid @RequestBody AppMarketplaceOrderPayReqVO req) {
        return success(service.preparePayment(SecurityFrameworkUtils.getLoginUserId(), req.getOrderId(), getClientIP()));
    }
    @PostMapping("/update-paid")
    @PermitAll
    public CommonResult<Boolean> updatePaid(@Valid @RequestBody PayOrderNotifyReqDTO req) {
        service.updatePaid(req);
        return success(true);
    }
    @PutMapping("/merchant/receive")
    public CommonResult<Boolean> receive(@Valid @RequestBody AppMarketplaceMerchantOrderReceiveReqVO req) {
        service.receive(SecurityFrameworkUtils.getLoginUserId(), req);
        return success(true);
    }
}
