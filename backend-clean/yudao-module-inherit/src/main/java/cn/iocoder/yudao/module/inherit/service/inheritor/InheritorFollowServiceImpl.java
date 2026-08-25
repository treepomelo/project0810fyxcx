package cn.iocoder.yudao.module.inherit.service.inheritor;

import cn.hutool.core.collection.CollUtil;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.common.pojo.PageParam;
import cn.iocoder.yudao.module.inherit.dal.dataobject.inheritor.InheritorDO;
import cn.iocoder.yudao.module.inherit.dal.dataobject.inheritor.InheritorFollowDO;
import cn.iocoder.yudao.module.inherit.dal.mysql.inheritor.InheritorFollowMapper;
import org.springframework.stereotype.Service;
import org.springframework.validation.annotation.Validated;

import jakarta.annotation.Resource;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import static cn.iocoder.yudao.framework.common.exception.util.ServiceExceptionUtil.exception;
import static cn.iocoder.yudao.module.inherit.enums.ErrorCodeConstants.INHERITOR_FOLLOW_DUPLICATE;
import static cn.iocoder.yudao.module.inherit.enums.ErrorCodeConstants.INHERITOR_FOLLOW_NOT_EXISTS;

/**
 * 传承人关注 Service 实现类
 *
 * @author inherit
 */
@Service
@Validated
public class InheritorFollowServiceImpl implements InheritorFollowService {

    @Resource
    private InheritorFollowMapper followMapper;
    @Resource
    private InheritorService inheritorService;

    @Override
    public void createFollow(Long userId, Long inheritorId) {
        // 校验传承人存在
        inheritorService.validateInheritorExists(inheritorId);
        // 校验未重复关注
        if (followMapper.selectByUserIdAndInheritorId(userId, inheritorId) != null) {
            throw exception(INHERITOR_FOLLOW_DUPLICATE);
        }
        // 取消后再关注：唯一键 uk_user_inheritor 冲突，优先恢复逻辑删除的旧关注，否则新增
        if (followMapper.reviveByUserIdAndInheritorId(userId, inheritorId) == 0) {
            InheritorFollowDO follow = new InheritorFollowDO();
            follow.setUserId(userId);
            follow.setInheritorId(inheritorId);
            followMapper.insert(follow);
        }
    }

    @Override
    public void deleteFollow(Long userId, Long inheritorId) {
        // 校验已关注
        if (followMapper.selectByUserIdAndInheritorId(userId, inheritorId) == null) {
            throw exception(INHERITOR_FOLLOW_NOT_EXISTS);
        }
        // 删除
        followMapper.deleteByUserIdAndInheritorId(userId, inheritorId);
    }

    @Override
    public boolean isFollowed(Long userId, Long inheritorId) {
        return followMapper.selectByUserIdAndInheritorId(userId, inheritorId) != null;
    }

    @Override
    public Long getFollowCount(Long inheritorId) {
        return followMapper.selectCountByInheritorId(inheritorId);
    }

    @Override
    public Map<Long, Long> getFollowCountMap(Collection<Long> inheritorIds) {
        if (CollUtil.isEmpty(inheritorIds)) {
            return new HashMap<>();
        }
        return followMapper.selectListByInheritorIds(new ArrayList<>(inheritorIds)).stream()
                .collect(Collectors.groupingBy(InheritorFollowDO::getInheritorId, Collectors.counting()));
    }

    @Override
    public PageResult<InheritorDO> getFollowPage(Long userId, PageParam pageParam) {
        PageResult<InheritorFollowDO> followPage = followMapper.selectPageByUserId(pageParam, userId);
        if (CollUtil.isEmpty(followPage.getList())) {
            return new PageResult<>(new ArrayList<>(), followPage.getTotal());
        }
        // 按关注顺序加载传承人信息
        List<Long> inheritorIds = followPage.getList().stream()
                .map(InheritorFollowDO::getInheritorId).collect(Collectors.toList());
        Map<Long, InheritorDO> inheritorMap = inheritorService.getInheritorList(inheritorIds).stream()
                .collect(Collectors.toMap(InheritorDO::getId, o -> o, (a, b) -> a));
        List<InheritorDO> list = new ArrayList<>();
        for (Long inheritorId : inheritorIds) {
            if (inheritorMap.containsKey(inheritorId)) {
                list.add(inheritorMap.get(inheritorId));
            }
        }
        return new PageResult<>(list, followPage.getTotal());
    }

}
