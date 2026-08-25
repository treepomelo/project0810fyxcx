package cn.iocoder.yudao.module.marketplace.controller.app.productrelation;

import cn.iocoder.yudao.framework.common.pojo.CommonResult;
import cn.iocoder.yudao.module.marketplace.controller.admin.productrelation.vo.ProductRelationRespVO;
import cn.iocoder.yudao.module.marketplace.controller.app.productrelation.vo.AppMarketplaceProductRelationRespVO;
import cn.iocoder.yudao.module.marketplace.service.productrelation.ProductRelationAdminService;
import jakarta.annotation.Resource;
import jakarta.annotation.security.PermitAll;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

import static cn.iocoder.yudao.framework.common.pojo.CommonResult.success;

/**
 * Public read-only Merchant aggregation for Mall product browse pages.
 */
@RestController
@RequestMapping("/marketplace/product-relation")
@Validated
public class MarketplaceProductRelationAppController {

    @Resource
    private ProductRelationAdminService productRelationService;

    @GetMapping("/get-by-spu")
    @PermitAll
    public CommonResult<AppMarketplaceProductRelationRespVO> getBySpu(@RequestParam Long spuId) {
        return success(productRelationService.getEnabledBySpuIds(List.of(spuId)).stream()
                .findFirst().map(this::convert).orElse(null));
    }

    @GetMapping("/list-by-spu-ids")
    @PermitAll
    public CommonResult<List<AppMarketplaceProductRelationRespVO>> listBySpuIds(@RequestParam List<Long> spuIds) {
        return success(productRelationService.getEnabledBySpuIds(spuIds).stream().map(this::convert).toList());
    }

    private AppMarketplaceProductRelationRespVO convert(ProductRelationRespVO relation) {
        return new AppMarketplaceProductRelationRespVO().setSpuId(relation.getSpuId())
                .setMerchantId(relation.getMerchantId()).setMerchantName(relation.getMerchantName());
    }
}
