package cn.iocoder.yudao.module.inherit.controller.app.inheritor;

import cn.hutool.core.collection.CollUtil;
import cn.iocoder.yudao.framework.common.pojo.CommonResult;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.common.util.object.BeanUtils;
import cn.iocoder.yudao.framework.ip.core.Area;
import cn.iocoder.yudao.framework.ip.core.utils.AreaUtils;
import cn.iocoder.yudao.framework.security.core.util.SecurityFrameworkUtils;
import cn.iocoder.yudao.module.inherit.controller.app.inheritor.vo.AppInheritorDetailRespVO;
import cn.iocoder.yudao.module.inherit.controller.app.inheritor.vo.AppInheritorContactRespVO;
import cn.iocoder.yudao.module.inherit.controller.app.inheritor.vo.AppInheritorPageReqVO;
import cn.iocoder.yudao.module.inherit.controller.app.inheritor.vo.AppInheritorProjectRelationRespVO;
import cn.iocoder.yudao.module.inherit.controller.app.inheritor.vo.AppInheritorProductRespVO;
import cn.iocoder.yudao.module.inherit.controller.app.inheritor.vo.AppInheritorServiceRespVO;
import cn.iocoder.yudao.module.inherit.controller.app.inheritor.vo.AppInheritorQualificationRespVO;
import cn.iocoder.yudao.module.inherit.controller.app.inheritor.vo.AppInheritorRespVO;
import cn.iocoder.yudao.module.inherit.controller.app.inheritor.vo.AppInheritorWorkRespVO;
import cn.iocoder.yudao.module.inherit.dal.dataobject.inheritor.InheritorDO;
import cn.iocoder.yudao.module.inherit.service.inheritor.InheritorFollowService;
import cn.iocoder.yudao.module.inherit.service.inheritor.InheritorProjectRelationService;
import cn.iocoder.yudao.module.inherit.service.inheritor.InheritorProductRelationService;
import cn.iocoder.yudao.module.inherit.service.inheritor.InheritorServiceRelationService;
import cn.iocoder.yudao.module.inherit.service.inheritor.InheritorQualificationService;
import cn.iocoder.yudao.module.inherit.service.inheritor.InheritorService;
import cn.iocoder.yudao.module.inherit.service.inheritor.InheritorWorkService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import jakarta.annotation.Resource;
import jakarta.annotation.security.PermitAll;
import jakarta.validation.Valid;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import static cn.iocoder.yudao.framework.common.pojo.CommonResult.success;

/**
 * 用户 App - 传承人 Controller
 *
 * 浏览接口全部 @PermitAll（不要求登录）；关注为独立接口（AppInheritorFollowController，要求登录）。
 * 详情采用【基础详情 + 关联数据接口】模式，避免巨型 SQL，保证传承人核心资料优先返回（异常隔离）。
 * 非遗产门类筛选链路：Inheritor → relation → HeritageProject → category（HeritageProject 模块就绪后接入）。
 *
 * @author inherit
 */
@Tag(name = "用户 App - 传承人")
@RestController
@RequestMapping("/inherit/inheritor")
@Validated
public class AppInheritorController {

    @Resource
    private InheritorService inheritorService;
    @Resource
    private InheritorFollowService followService;
    @Resource
    private InheritorQualificationService qualificationService;
    @Resource
    private InheritorWorkService workService;
    @Resource
    private InheritorProjectRelationService projectRelationService;
    @Resource
    private InheritorProductRelationService productRelationService;
    @Resource
    private InheritorServiceRelationService serviceRelationService;

    @GetMapping("/page")
    @Operation(summary = "获得传承人分页（关键词/地区/级别）")
    @PermitAll
    public CommonResult<PageResult<AppInheritorRespVO>> getInheritorPage(@Valid AppInheritorPageReqVO pageReqVO) {
        PageResult<InheritorDO> pageResult = inheritorService.getInheritorAppPage(pageReqVO);
        List<AppInheritorRespVO> list = new ArrayList<>();
        if (CollUtil.isNotEmpty(pageResult.getList())) {
            Map<Long, Long> followCountMap = followService.getFollowCountMap(
                    pageResult.getList().stream().map(InheritorDO::getId).collect(Collectors.toList()));
            for (InheritorDO inheritor : pageResult.getList()) {
                list.add(buildListVO(inheritor, followCountMap));
            }
        }
        return success(new PageResult<>(list, pageResult.getTotal()));
    }

    @GetMapping("/get")
    @Operation(summary = "获得传承人详情")
    @Parameter(name = "id", description = "传承人编号", required = true, example = "1024")
    @PermitAll
    public CommonResult<AppInheritorDetailRespVO> getInheritor(@RequestParam("id") Long id) {
        // 仅允许查看【已启用 + 已通过审核 + 展示中】的传承人；未审核/未展示/停用/已删除均视为不存在
        InheritorDO inheritor = inheritorService.validateInheritorPublicExists(id);
        AppInheritorDetailRespVO respVO = BeanUtils.toBean(inheritor, AppInheritorDetailRespVO.class);
        fillRegionNames(respVO);
        respVO.setFollowCount(followService.getFollowCount(id));
        // 登录用户视角判断是否已关注；未登录为 false
        Long userId = SecurityFrameworkUtils.getLoginUserId();
        respVO.setIsFollowed(userId != null && followService.isFollowed(userId, id));
        return success(respVO);
    }

    @GetMapping("/contact")
    @Operation(summary = "获取传承人联系电话")
    @Parameter(name = "id", description = "传承人编号", required = true, example = "1024")
    public CommonResult<AppInheritorContactRespVO> getContact(@RequestParam("id") Long id) {
        return success(inheritorService.getAppInheritorContact(id));
    }

    @GetMapping("/works")
    @Operation(summary = "获得传承人作品列表")
    @Parameter(name = "id", description = "传承人编号", required = true, example = "1024")
    @PermitAll
    public CommonResult<List<AppInheritorWorkRespVO>> getWorks(@RequestParam("id") Long inheritorId) {
        return success(BeanUtils.toBean(workService.getWorkListByInheritorId(inheritorId),
                AppInheritorWorkRespVO.class));
    }

    @GetMapping("/qualifications")
    @Operation(summary = "获得传承人荣誉/资质列表")
    @Parameter(name = "id", description = "传承人编号", required = true, example = "1024")
    @PermitAll
    public CommonResult<List<AppInheritorQualificationRespVO>> getQualifications(@RequestParam("id") Long inheritorId) {
        return success(BeanUtils.toBean(qualificationService.getQualificationListByInheritorId(inheritorId),
                AppInheritorQualificationRespVO.class));
    }

    @GetMapping("/projects")
    @Operation(summary = "获得传承人非遗项目关系列表")
    @Parameter(name = "id", description = "传承人编号", required = true, example = "1024")
    @PermitAll
    public CommonResult<List<AppInheritorProjectRelationRespVO>> getProjects(@RequestParam("id") Long inheritorId) {
        return success(BeanUtils.toBean(projectRelationService.getProjectRelationListByInheritorId(inheritorId),
                AppInheritorProjectRelationRespVO.class));
    }

    @GetMapping("/products")
    @Operation(summary = "获得传承人关联商品列表")
    @Parameter(name = "id", description = "传承人编号", required = true, example = "1024")
    @PermitAll
    public CommonResult<List<AppInheritorProductRespVO>> getProducts(@RequestParam("id") Long inheritorId) {
        return success(productRelationService.getPublicProducts(inheritorId));
    }

    @GetMapping("/services")
    @Operation(summary = "获得传承人关联服务列表")
    @Parameter(name = "id", description = "传承人编号", required = true, example = "1024")
    @PermitAll
    public CommonResult<List<AppInheritorServiceRespVO>> getServices(@RequestParam("id") Long inheritorId) {
        return success(serviceRelationService.getPublicServices(inheritorId));
    }
    /**
     * 构造列表卡片 VO：地区名称 + 关注数
     */
    private AppInheritorRespVO buildListVO(InheritorDO inheritor, Map<Long, Long> followCountMap) {
        AppInheritorRespVO respVO = BeanUtils.toBean(inheritor, AppInheritorRespVO.class);
        fillRegionNames(respVO);
        respVO.setFollowCount(followCountMap.getOrDefault(inheritor.getId(), 0L));
        return respVO;
    }

    private void fillRegionNames(AppInheritorRespVO respVO) {
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
