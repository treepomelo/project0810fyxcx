package cn.iocoder.yudao.module.inherit.controller.admin.inheritor;

import cn.iocoder.yudao.framework.common.pojo.CommonResult;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.common.util.object.BeanUtils;
import cn.iocoder.yudao.module.inherit.controller.admin.inheritor.vo.*;
import cn.iocoder.yudao.module.inherit.dal.dataobject.inheritor.InheritorProductRelationDO;
import cn.iocoder.yudao.module.inherit.service.inheritor.InheritorProductRelationService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;
import jakarta.annotation.Resource;
import jakarta.validation.Valid;
import static cn.iocoder.yudao.framework.common.pojo.CommonResult.success;

@Tag(name = "管理后台 - 传承人商品关系")
@RestController
@RequestMapping("/inherit/inheritor-product-relation")
@Validated
public class InheritorProductRelationController {
    @Resource private InheritorProductRelationService relationService;
    @PostMapping("/create") @Operation(summary = "创建传承人商品关系") @PreAuthorize("@ss.hasPermission('inherit:inheritor-product-relation:create')")
    public CommonResult<Long> create(@Valid @RequestBody InheritorProductRelationSaveReqVO req) { return success(relationService.createProductRelation(req)); }
    @PutMapping("/update") @Operation(summary = "更新传承人商品关系") @PreAuthorize("@ss.hasPermission('inherit:inheritor-product-relation:update')")
    public CommonResult<Boolean> update(@Valid @RequestBody InheritorProductRelationSaveReqVO req) { relationService.updateProductRelation(req); return success(true); }
    @DeleteMapping("/delete") @Operation(summary = "删除传承人商品关系") @PreAuthorize("@ss.hasPermission('inherit:inheritor-product-relation:delete')")
    public CommonResult<Boolean> delete(@RequestParam("id") Long id) { relationService.deleteProductRelation(id); return success(true); }
    @GetMapping("/get") @Operation(summary = "获得传承人商品关系") @PreAuthorize("@ss.hasPermission('inherit:inheritor-product-relation:query')")
    public CommonResult<InheritorProductRelationRespVO> get(@RequestParam("id") Long id) { return success(BeanUtils.toBean(relationService.getProductRelation(id), InheritorProductRelationRespVO.class)); }
    @GetMapping("/page") @Operation(summary = "获得传承人商品关系分页") @PreAuthorize("@ss.hasPermission('inherit:inheritor-product-relation:query')")
    public CommonResult<PageResult<InheritorProductRelationRespVO>> page(@Valid InheritorProductRelationPageReqVO req) { return success(BeanUtils.toBean(relationService.getProductRelationPage(req), InheritorProductRelationRespVO.class)); }
}