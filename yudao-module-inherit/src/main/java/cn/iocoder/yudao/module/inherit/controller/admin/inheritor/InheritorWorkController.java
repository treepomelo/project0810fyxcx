package cn.iocoder.yudao.module.inherit.controller.admin.inheritor;

import cn.iocoder.yudao.framework.common.pojo.CommonResult;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.common.util.object.BeanUtils;
import cn.iocoder.yudao.module.inherit.controller.admin.inheritor.vo.InheritorWorkPageReqVO;
import cn.iocoder.yudao.module.inherit.controller.admin.inheritor.vo.InheritorWorkRespVO;
import cn.iocoder.yudao.module.inherit.controller.admin.inheritor.vo.InheritorWorkSaveReqVO;
import cn.iocoder.yudao.module.inherit.dal.dataobject.inheritor.InheritorWorkDO;
import cn.iocoder.yudao.module.inherit.service.inheritor.InheritorWorkService;
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
 * 管理后台 - 传承人作品 Controller
 *
 * @author inherit
 */
@Tag(name = "管理后台 - 传承人作品")
@RestController
@RequestMapping("/inherit/inheritor-work")
@Validated
public class InheritorWorkController {

    @Resource
    private InheritorWorkService workService;

    @PostMapping("/create")
    @Operation(summary = "创建传承人作品")
    @PreAuthorize("@ss.hasPermission('inherit:inheritor-work:create')")
    public CommonResult<Long> createWork(@Valid @RequestBody InheritorWorkSaveReqVO createReqVO) {
        return success(workService.createWork(createReqVO));
    }

    @PutMapping("/update")
    @Operation(summary = "更新传承人作品")
    @PreAuthorize("@ss.hasPermission('inherit:inheritor-work:update')")
    public CommonResult<Boolean> updateWork(@Valid @RequestBody InheritorWorkSaveReqVO updateReqVO) {
        workService.updateWork(updateReqVO);
        return success(true);
    }

    @DeleteMapping("/delete")
    @Operation(summary = "删除传承人作品")
    @Parameter(name = "id", description = "编号", required = true)
    @PreAuthorize("@ss.hasPermission('inherit:inheritor-work:delete')")
    public CommonResult<Boolean> deleteWork(@RequestParam("id") Long id) {
        workService.deleteWork(id);
        return success(true);
    }

    @GetMapping("/get")
    @Operation(summary = "获得传承人作品")
    @Parameter(name = "id", description = "编号", required = true, example = "1024")
    @PreAuthorize("@ss.hasPermission('inherit:inheritor-work:query')")
    public CommonResult<InheritorWorkRespVO> getWork(@RequestParam("id") Long id) {
        InheritorWorkDO work = workService.getWork(id);
        return success(BeanUtils.toBean(work, InheritorWorkRespVO.class));
    }

    @GetMapping("/page")
    @Operation(summary = "获得传承人作品分页")
    @PreAuthorize("@ss.hasPermission('inherit:inheritor-work:query')")
    public CommonResult<PageResult<InheritorWorkRespVO>> getWorkPage(@Valid InheritorWorkPageReqVO pageReqVO) {
        PageResult<InheritorWorkDO> pageResult = workService.getWorkPage(pageReqVO);
        return success(BeanUtils.toBean(pageResult, InheritorWorkRespVO.class));
    }

}
