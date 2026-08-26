package cn.iocoder.yudao.module.inherit.controller.admin.inheritor;

import cn.iocoder.yudao.framework.common.pojo.CommonResult;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.common.util.object.BeanUtils;
import cn.iocoder.yudao.module.inherit.controller.admin.inheritor.vo.*;
import cn.iocoder.yudao.module.inherit.service.inheritor.InheritorServiceRelationService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;
import jakarta.annotation.Resource;
import jakarta.validation.Valid;
import static cn.iocoder.yudao.framework.common.pojo.CommonResult.success;

@Tag(name = "管理后台 - 传承人服务关系")
@RestController
@RequestMapping("/inherit/inheritor-service-relation")
@Validated
public class InheritorServiceRelationController {
    @Resource private InheritorServiceRelationService relationService;
    @PostMapping("/create") @Operation(summary = "创建传承人服务关系") @PreAuthorize("@ss.hasPermission('inherit:inheritor-service-relation:create')")
    public CommonResult<Long> create(@Valid @RequestBody InheritorServiceRelationSaveReqVO req) { return success(relationService.createServiceRelation(req)); }
    @PutMapping("/update") @Operation(summary = "更新传承人服务关系") @PreAuthorize("@ss.hasPermission('inherit:inheritor-service-relation:update')")
    public CommonResult<Boolean> update(@Valid @RequestBody InheritorServiceRelationSaveReqVO req) { relationService.updateServiceRelation(req); return success(true); }
    @DeleteMapping("/delete") @Operation(summary = "删除传承人服务关系") @PreAuthorize("@ss.hasPermission('inherit:inheritor-service-relation:delete')")
    public CommonResult<Boolean> delete(@RequestParam("id") Long id) { relationService.deleteServiceRelation(id); return success(true); }
    @GetMapping("/get") @Operation(summary = "获得传承人服务关系") @PreAuthorize("@ss.hasPermission('inherit:inheritor-service-relation:query')")
    public CommonResult<InheritorServiceRelationRespVO> get(@RequestParam("id") Long id) { return success(BeanUtils.toBean(relationService.getServiceRelation(id), InheritorServiceRelationRespVO.class)); }
    @GetMapping("/page") @Operation(summary = "获得传承人服务关系分页") @PreAuthorize("@ss.hasPermission('inherit:inheritor-service-relation:query')")
    public CommonResult<PageResult<InheritorServiceRelationRespVO>> page(@Valid InheritorServiceRelationPageReqVO req) { return success(BeanUtils.toBean(relationService.getServiceRelationPage(req), InheritorServiceRelationRespVO.class)); }
}