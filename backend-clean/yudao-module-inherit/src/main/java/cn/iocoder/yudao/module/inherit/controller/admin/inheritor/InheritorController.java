package cn.iocoder.yudao.module.inherit.controller.admin.inheritor;

import cn.hutool.core.collection.CollUtil;
import cn.iocoder.yudao.framework.common.pojo.CommonResult;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.common.util.object.BeanUtils;
import cn.iocoder.yudao.framework.ip.core.Area;
import cn.iocoder.yudao.framework.ip.core.utils.AreaUtils;
import cn.iocoder.yudao.module.inherit.controller.admin.inheritor.vo.InheritorAuditReqVO;
import cn.iocoder.yudao.module.inherit.controller.admin.inheritor.vo.InheritorPageReqVO;
import cn.iocoder.yudao.module.inherit.controller.admin.inheritor.vo.InheritorRespVO;
import cn.iocoder.yudao.module.inherit.controller.admin.inheritor.vo.InheritorSaveReqVO;
import cn.iocoder.yudao.module.inherit.dal.dataobject.inheritor.InheritorDO;
import cn.iocoder.yudao.module.inherit.service.inheritor.InheritorFollowService;
import cn.iocoder.yudao.module.inherit.service.inheritor.InheritorService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import jakarta.annotation.Resource;
import jakarta.validation.Valid;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import static cn.iocoder.yudao.framework.common.pojo.CommonResult.success;

/**
 * 管理后台 - 传承人 Controller
 *
 * 权限接入现有 RBAC：inherit:inheritor:create/update/delete/query/audit
 *
 * @author inherit
 */
@Tag(name = "管理后台 - 传承人")
@RestController
@RequestMapping("/inherit/inheritor")
@Validated
public class InheritorController {

    @Resource
    private InheritorService inheritorService;
    @Resource
    private InheritorFollowService followService;

    @PostMapping("/create")
    @Operation(summary = "创建传承人")
    @PreAuthorize("@ss.hasPermission('inherit:inheritor:create')")
    public CommonResult<Long> createInheritor(@Valid @RequestBody InheritorSaveReqVO createReqVO) {
        return success(inheritorService.createInheritor(createReqVO));
    }

    @PutMapping("/update")
    @Operation(summary = "更新传承人")
    @PreAuthorize("@ss.hasPermission('inherit:inheritor:update')")
    public CommonResult<Boolean> updateInheritor(@Valid @RequestBody InheritorSaveReqVO updateReqVO) {
        inheritorService.updateInheritor(updateReqVO);
        return success(true);
    }

    @PutMapping("/update-audit")
    @Operation(summary = "审核传承人")
    @PreAuthorize("@ss.hasPermission('inherit:inheritor:audit')")
    public CommonResult<Boolean> updateInheritorAudit(@Valid @RequestBody InheritorAuditReqVO auditReqVO) {
        inheritorService.updateAudit(auditReqVO);
        return success(true);
    }

    @DeleteMapping("/delete")
    @Operation(summary = "删除传承人")
    @Parameter(name = "id", description = "编号", required = true)
    @PreAuthorize("@ss.hasPermission('inherit:inheritor:delete')")
    public CommonResult<Boolean> deleteInheritor(@RequestParam("id") Long id) {
        inheritorService.deleteInheritor(id);
        return success(true);
    }

    @GetMapping("/get")
    @Operation(summary = "获得传承人")
    @Parameter(name = "id", description = "编号", required = true, example = "1024")
    @PreAuthorize("@ss.hasPermission('inherit:inheritor:query')")
    public CommonResult<InheritorRespVO> getInheritor(@RequestParam("id") Long id) {
        InheritorDO inheritor = inheritorService.getInheritor(id);
        InheritorRespVO respVO = BeanUtils.toBean(inheritor, InheritorRespVO.class);
        fillRespVO(respVO);
        return success(respVO);
    }

    @GetMapping("/page")
    @Operation(summary = "获得传承人分页")
    @PreAuthorize("@ss.hasPermission('inherit:inheritor:query')")
    public CommonResult<PageResult<InheritorRespVO>> getInheritorPage(@Valid InheritorPageReqVO pageReqVO) {
        PageResult<InheritorDO> pageResult = inheritorService.getInheritorPage(pageReqVO);
        List<InheritorRespVO> list = new ArrayList<>();
        if (CollUtil.isNotEmpty(pageResult.getList())) {
            Map<Long, Long> followCountMap = followService.getFollowCountMap(
                    pageResult.getList().stream().map(InheritorDO::getId).collect(Collectors.toList()));
            for (InheritorDO inheritor : pageResult.getList()) {
                InheritorRespVO respVO = BeanUtils.toBean(inheritor, InheritorRespVO.class);
                respVO.setFollowCount(followCountMap.getOrDefault(inheritor.getId(), 0L));
                fillRegionNames(respVO);
                list.add(respVO);
            }
        }
        return success(new PageResult<>(list, pageResult.getTotal()));
    }

    /**
     * 填充地区名称与关注数
     */
    private void fillRespVO(InheritorRespVO respVO) {
        if (respVO == null) {
            return;
        }
        fillRegionNames(respVO);
        if (respVO.getId() != null) {
            respVO.setFollowCount(followService.getFollowCount(respVO.getId()));
        }
    }

    /**
     * 解析地区编号为名称（复用框架地区数据，不建行政区划表）
     */
    private void fillRegionNames(InheritorRespVO respVO) {
        respVO.setProvinceName(formatAreaName(respVO.getProvinceCode()));
        respVO.setCityName(formatAreaName(respVO.getCityCode()));
        respVO.setDistrictName(formatAreaName(respVO.getDistrictCode()));
    }

    private String formatAreaName(Integer code) {
        if (code == null) {
            return null;
        }
        Area area = AreaUtils.getArea(code);
        return area == null ? null : area.getName();
    }

}
