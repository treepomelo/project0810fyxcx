package cn.iocoder.yudao.module.marketplace.controller.admin.productrelation;

import cn.iocoder.yudao.framework.common.pojo.CommonResult;
import cn.iocoder.yudao.module.marketplace.controller.admin.productrelation.vo.ProductRelationRespVO;
import cn.iocoder.yudao.module.marketplace.controller.admin.productrelation.vo.ProductRelationSaveReqVO;
import cn.iocoder.yudao.module.marketplace.service.productrelation.ProductRelationAdminService;
import jakarta.annotation.Resource;
import jakarta.validation.Valid;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

import static cn.iocoder.yudao.framework.common.pojo.CommonResult.success;

@RestController
@RequestMapping("/marketplace/product-relation")
@Validated
public class MarketplaceProductRelationAdminController {

    @Resource
    private ProductRelationAdminService productRelationAdminService;

    @GetMapping("/get-by-spu")
    @PreAuthorize("@ss.hasPermission('marketplace:merchant:query')")
    public CommonResult<ProductRelationRespVO> getBySpu(@RequestParam Long spuId) {
        return success(productRelationAdminService.getBySpuId(spuId));
    }

    @GetMapping("/list-by-spu-ids")
    @PreAuthorize("@ss.hasPermission('marketplace:merchant:query')")
    public CommonResult<List<ProductRelationRespVO>> listBySpuIds(@RequestParam List<Long> spuIds) {
        return success(productRelationAdminService.getBySpuIds(spuIds));
    }

    @PutMapping("/save")
    @PreAuthorize("@ss.hasPermission('marketplace:merchant:update')")
    public CommonResult<Boolean> save(@Valid @RequestBody ProductRelationSaveReqVO reqVO) {
        productRelationAdminService.save(reqVO);
        return success(true);
    }
}
