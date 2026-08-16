package cn.iocoder.yudao.module.inherit.controller.admin.inheritor;

import cn.iocoder.yudao.framework.common.pojo.CommonResult;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.common.util.object.BeanUtils;
import cn.iocoder.yudao.module.inherit.controller.admin.inheritor.vo.InheritorProjectRelationPageReqVO;
import cn.iocoder.yudao.module.inherit.controller.admin.inheritor.vo.InheritorProjectRelationRespVO;
import cn.iocoder.yudao.module.inherit.controller.admin.inheritor.vo.InheritorProjectRelationSaveReqVO;
import cn.iocoder.yudao.module.inherit.dal.dataobject.inheritor.InheritorProjectRelationDO;
import cn.iocoder.yudao.module.inherit.service.inheritor.InheritorProjectRelationService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import javax.validation.Valid;

import static cn.iocoder.yudao.framework.common.pojo.CommonResult.success;

/**
 * 管理后台 - 传承人-非遗项目 关系 Controller
 *
 * 只管理关系（inheritorId + projectId），非遗项目主数据属 HeritageProject 模块（未来）。
 *
 * @author inherit
 */
@Tag(name = "管理后台 - 传承人-非遗项目 关系")
@RestController
@RequestMapping("/inherit/inheritor-project-relation")
@Validated
public class InheritorProjectRelationController {

    @Resource
    private InheritorProjectRelationService projectRelationService;

    @PostMapping("/create")
    @Operation(summary = "创建传承人-非遗项目 关系")
    @PreAuthorize("@ss.hasPermission('inherit:inheritor-project-relation:create')")
    public CommonResult<Long> createProjectRelation(@Valid @RequestBody InheritorProjectRelationSaveReqVO createReqVO) {
        return success(projectRelationService.createProjectRelation(createReqVO));
    }

    @PutMapping("/update")
    @Operation(summary = "更新传承人-非遗项目 关系")
    @PreAuthorize("@ss.hasPermission('inherit:inheritor-project-relation:update')")
    public CommonResult<Boolean> updateProjectRelation(@Valid @RequestBody InheritorProjectRelationSaveReqVO updateReqVO) {
        projectRelationService.updateProjectRelation(updateReqVO);
        return success(true);
    }

    @DeleteMapping("/delete")
    @Operation(summary = "删除传承人-非遗项目 关系")
    @Parameter(name = "id", description = "编号", required = true)
    @PreAuthorize("@ss.hasPermission('inherit:inheritor-project-relation:delete')")
    public CommonResult<Boolean> deleteProjectRelation(@RequestParam("id") Long id) {
        projectRelationService.deleteProjectRelation(id);
        return success(true);
    }

    @GetMapping("/get")
    @Operation(summary = "获得传承人-非遗项目 关系")
    @Parameter(name = "id", description = "编号", required = true, example = "1024")
    @PreAuthorize("@ss.hasPermission('inherit:inheritor-project-relation:query')")
    public CommonResult<InheritorProjectRelationRespVO> getProjectRelation(@RequestParam("id") Long id) {
        InheritorProjectRelationDO relation = projectRelationService.getProjectRelation(id);
        return success(BeanUtils.toBean(relation, InheritorProjectRelationRespVO.class));
    }

    @GetMapping("/page")
    @Operation(summary = "获得传承人-非遗项目 关系分页")
    @PreAuthorize("@ss.hasPermission('inherit:inheritor-project-relation:query')")
    public CommonResult<PageResult<InheritorProjectRelationRespVO>> getProjectRelationPage(
            @Valid InheritorProjectRelationPageReqVO pageReqVO) {
        PageResult<InheritorProjectRelationDO> pageResult = projectRelationService.getProjectRelationPage(pageReqVO);
        return success(BeanUtils.toBean(pageResult, InheritorProjectRelationRespVO.class));
    }

}
