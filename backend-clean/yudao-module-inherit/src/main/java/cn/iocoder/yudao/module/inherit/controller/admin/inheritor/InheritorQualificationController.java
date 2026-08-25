package cn.iocoder.yudao.module.inherit.controller.admin.inheritor;

import cn.iocoder.yudao.framework.common.pojo.CommonResult;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.common.util.object.BeanUtils;
import cn.iocoder.yudao.module.inherit.controller.admin.inheritor.vo.InheritorQualificationPageReqVO;
import cn.iocoder.yudao.module.inherit.controller.admin.inheritor.vo.InheritorQualificationRespVO;
import cn.iocoder.yudao.module.inherit.controller.admin.inheritor.vo.InheritorQualificationSaveReqVO;
import cn.iocoder.yudao.module.inherit.dal.dataobject.inheritor.InheritorQualificationDO;
import cn.iocoder.yudao.module.inherit.service.inheritor.InheritorQualificationService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import jakarta.annotation.Resource;
import jakarta.validation.Valid;

import static cn.iocoder.yudao.framework.common.pojo.CommonResult.success;

/**
 * 管理后台 - 传承人荣誉/资质 Controller
 *
 * @author inherit
 */
@Tag(name = "管理后台 - 传承人荣誉/资质")
@RestController
@RequestMapping("/inherit/inheritor-qualification")
@Validated
public class InheritorQualificationController {

    @Resource
    private InheritorQualificationService qualificationService;

    @PostMapping("/create")
    @Operation(summary = "创建传承人荣誉/资质")
    @PreAuthorize("@ss.hasPermission('inherit:inheritor-qualification:create')")
    public CommonResult<Long> createQualification(@Valid @RequestBody InheritorQualificationSaveReqVO createReqVO) {
        return success(qualificationService.createQualification(createReqVO));
    }

    @PutMapping("/update")
    @Operation(summary = "更新传承人荣誉/资质")
    @PreAuthorize("@ss.hasPermission('inherit:inheritor-qualification:update')")
    public CommonResult<Boolean> updateQualification(@Valid @RequestBody InheritorQualificationSaveReqVO updateReqVO) {
        qualificationService.updateQualification(updateReqVO);
        return success(true);
    }

    @DeleteMapping("/delete")
    @Operation(summary = "删除传承人荣誉/资质")
    @Parameter(name = "id", description = "编号", required = true)
    @PreAuthorize("@ss.hasPermission('inherit:inheritor-qualification:delete')")
    public CommonResult<Boolean> deleteQualification(@RequestParam("id") Long id) {
        qualificationService.deleteQualification(id);
        return success(true);
    }

    @GetMapping("/get")
    @Operation(summary = "获得传承人荣誉/资质")
    @Parameter(name = "id", description = "编号", required = true, example = "1024")
    @PreAuthorize("@ss.hasPermission('inherit:inheritor-qualification:query')")
    public CommonResult<InheritorQualificationRespVO> getQualification(@RequestParam("id") Long id) {
        InheritorQualificationDO qualification = qualificationService.getQualification(id);
        return success(BeanUtils.toBean(qualification, InheritorQualificationRespVO.class));
    }

    @GetMapping("/page")
    @Operation(summary = "获得传承人荣誉/资质分页")
    @PreAuthorize("@ss.hasPermission('inherit:inheritor-qualification:query')")
    public CommonResult<PageResult<InheritorQualificationRespVO>> getQualificationPage(
            @Valid InheritorQualificationPageReqVO pageReqVO) {
        PageResult<InheritorQualificationDO> pageResult = qualificationService.getQualificationPage(pageReqVO);
        return success(BeanUtils.toBean(pageResult, InheritorQualificationRespVO.class));
    }

}
