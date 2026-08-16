package cn.iocoder.yudao.module.inherit.controller.app.inheritor;

import cn.hutool.core.collection.CollUtil;
import cn.iocoder.yudao.framework.common.pojo.CommonResult;
import cn.iocoder.yudao.framework.common.pojo.PageParam;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.common.util.object.BeanUtils;
import cn.iocoder.yudao.framework.ip.core.Area;
import cn.iocoder.yudao.framework.ip.core.utils.AreaUtils;
import cn.iocoder.yudao.framework.security.core.util.SecurityFrameworkUtils;
import cn.iocoder.yudao.module.inherit.controller.app.inheritor.vo.AppInheritorFollowReqVO;
import cn.iocoder.yudao.module.inherit.controller.app.inheritor.vo.AppInheritorFollowRespVO;
import cn.iocoder.yudao.module.inherit.controller.app.inheritor.vo.AppInheritorRespVO;
import cn.iocoder.yudao.module.inherit.dal.dataobject.inheritor.InheritorDO;
import cn.iocoder.yudao.module.inherit.service.inheritor.InheritorFollowService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import javax.validation.Valid;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import static cn.iocoder.yudao.framework.common.pojo.CommonResult.success;

/**
 * 用户 App - 传承人关注 Controller
 *
 * 全部要求登录（无 @PermitAll），当前用户取 {@link SecurityFrameworkUtils#getLoginUserId()}，
 * 用户身份复用底座 member_user 体系，不新建用户/账号体系。
 *
 * @author inherit
 */
@Tag(name = "用户 App - 传承人关注")
@RestController
@RequestMapping("/inherit/inheritor-follow")
@Validated
public class AppInheritorFollowController {

    @Resource
    private InheritorFollowService followService;

    @PostMapping("/create")
    @Operation(summary = "关注传承人")
    public CommonResult<Boolean> createFollow(@Valid @RequestBody AppInheritorFollowReqVO reqVO) {
        followService.createFollow(getLoginUserId(), reqVO.getInheritorId());
        return success(true);
    }

    @DeleteMapping("/delete")
    @Operation(summary = "取消关注传承人")
    @Parameter(name = "inheritorId", description = "传承人编号", required = true, example = "1024")
    public CommonResult<Boolean> deleteFollow(@RequestParam("inheritorId") Long inheritorId) {
        followService.deleteFollow(getLoginUserId(), inheritorId);
        return success(true);
    }

    @GetMapping("/get")
    @Operation(summary = "获得关注状态（是否已关注 + 关注数）")
    @Parameter(name = "inheritorId", description = "传承人编号", required = true, example = "1024")
    public CommonResult<AppInheritorFollowRespVO> getFollow(@RequestParam("inheritorId") Long inheritorId) {
        Long userId = getLoginUserId();
        AppInheritorFollowRespVO respVO = new AppInheritorFollowRespVO();
        respVO.setIsFollowed(followService.isFollowed(userId, inheritorId));
        respVO.setFollowCount(followService.getFollowCount(inheritorId));
        return success(respVO);
    }

    @GetMapping("/page")
    @Operation(summary = "获得我的关注传承人分页")
    public CommonResult<PageResult<AppInheritorRespVO>> getFollowPage(@Valid PageParam pageParam) {
        PageResult<InheritorDO> pageResult = followService.getFollowPage(getLoginUserId(), pageParam);
        List<AppInheritorRespVO> list = new ArrayList<>();
        if (CollUtil.isNotEmpty(pageResult.getList())) {
            Map<Long, Long> followCountMap = followService.getFollowCountMap(
                    pageResult.getList().stream().map(InheritorDO::getId).collect(Collectors.toList()));
            for (InheritorDO inheritor : pageResult.getList()) {
                AppInheritorRespVO respVO = BeanUtils.toBean(inheritor, AppInheritorRespVO.class);
                fillRegionNames(respVO);
                respVO.setFollowCount(followCountMap.getOrDefault(inheritor.getId(), 0L));
                list.add(respVO);
            }
        }
        return success(new PageResult<>(list, pageResult.getTotal()));
    }

    private Long getLoginUserId() {
        return SecurityFrameworkUtils.getLoginUserId();
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
