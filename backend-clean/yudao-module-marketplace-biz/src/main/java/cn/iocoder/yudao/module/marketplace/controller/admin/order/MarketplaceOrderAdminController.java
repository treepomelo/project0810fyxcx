package cn.iocoder.yudao.module.marketplace.controller.admin.order;

import cn.iocoder.yudao.framework.common.pojo.CommonResult;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.module.marketplace.controller.admin.order.vo.MarketplaceOrderPageReqVO;
import cn.iocoder.yudao.module.marketplace.controller.admin.order.vo.MarketplaceMerchantOrderShipReqVO;
import cn.iocoder.yudao.module.marketplace.controller.app.order.vo.AppMarketplaceOrderRespVO;
import cn.iocoder.yudao.module.marketplace.service.order.MarketplaceOrderService;
import jakarta.annotation.Resource;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import jakarta.validation.Valid;

import static cn.iocoder.yudao.framework.common.pojo.CommonResult.success;

@RestController
@RequestMapping("/marketplace/order")
@Validated
public class MarketplaceOrderAdminController {
    @Resource private MarketplaceOrderService service;

    @GetMapping("/get")
    @PreAuthorize("@ss.hasPermission('marketplace:order:query')")
    public CommonResult<AppMarketplaceOrderRespVO> get(@RequestParam Long id) {
        return success(service.adminGet(id));
    }
    @GetMapping("/page")
    @PreAuthorize("@ss.hasPermission('marketplace:order:query')")
    public CommonResult<PageResult<AppMarketplaceOrderRespVO>> page(@Validated MarketplaceOrderPageReqVO req) {
        return success(service.adminPage(req.getMemberId(), req));
    }
    @PutMapping("/merchant/ship")
    @PreAuthorize("@ss.hasPermission('marketplace:order:update')")
    public CommonResult<Boolean> ship(@Valid @RequestBody MarketplaceMerchantOrderShipReqVO req) {
        service.ship(req.getMerchantOrderId(), req);
        return success(true);
    }
    @PutMapping("/dev-pay")
    @PreAuthorize("@ss.hasPermission('marketplace:order:update')")
    public CommonResult<Boolean> devPay(@RequestParam Long orderId) {
        service.devPay(orderId);
        return success(true);
    }
}
