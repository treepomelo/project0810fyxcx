package cn.iocoder.yudao.module.inherit.service.inheritor;

import cn.hutool.core.collection.CollUtil;
import cn.iocoder.yudao.framework.common.pojo.PageParam;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.mybatis.core.query.LambdaQueryWrapperX;
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

@Service
@Validated
public class InheritorFollowServiceImpl implements InheritorFollowService {
    @Resource private InheritorFollowMapper followMapper;
    @Resource private InheritorService inheritorService;

    @Override
    public void createFollow(Long userId, Long inheritorId) {
        inheritorService.validateInheritorPublicExists(inheritorId);
        if (followMapper.selectByUserIdAndInheritorId(userId, inheritorId) != null) throw exception(INHERITOR_FOLLOW_DUPLICATE);
        if (followMapper.reviveByUserIdAndInheritorId(userId, inheritorId) == 0) {
            InheritorFollowDO follow = new InheritorFollowDO();
            follow.setUserId(userId); follow.setInheritorId(inheritorId);
            followMapper.insert(follow);
        }
    }

    @Override
    public void deleteFollow(Long userId, Long inheritorId) {
        if (followMapper.selectByUserIdAndInheritorId(userId, inheritorId) == null) throw exception(INHERITOR_FOLLOW_NOT_EXISTS);
        followMapper.deleteByUserIdAndInheritorId(userId, inheritorId);
    }

    @Override public boolean isFollowed(Long userId, Long inheritorId) { return followMapper.selectByUserIdAndInheritorId(userId, inheritorId) != null; }
    @Override public Long getFollowCount(Long inheritorId) { return followMapper.selectCountByInheritorId(inheritorId); }
    @Override public Map<Long, Long> getFollowCountMap(Collection<Long> inheritorIds) {
        if (CollUtil.isEmpty(inheritorIds)) return new HashMap<>();
        return followMapper.selectListByInheritorIds(new ArrayList<>(inheritorIds)).stream().collect(Collectors.groupingBy(InheritorFollowDO::getInheritorId, Collectors.counting()));
    }

    @Override
    public PageResult<InheritorDO> getFollowPage(Long userId, PageParam pageParam) {
        List<InheritorFollowDO> follows = followMapper.selectList(new LambdaQueryWrapperX<InheritorFollowDO>()
                .eq(InheritorFollowDO::getUserId, userId).orderByDesc(InheritorFollowDO::getId));
        List<InheritorDO> visible = follows.stream().map(item -> inheritorService.getPublicInheritor(item.getInheritorId()))
                .filter(java.util.Objects::nonNull).toList();
        if (PageParam.PAGE_SIZE_NONE.equals(pageParam.getPageSize())) return new PageResult<>(visible, (long) visible.size());
        int from = Math.min((pageParam.getPageNo() - 1) * pageParam.getPageSize(), visible.size());
        int to = Math.min(from + pageParam.getPageSize(), visible.size());
        return new PageResult<>(visible.subList(from, to), (long) visible.size());
    }
}