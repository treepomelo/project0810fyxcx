package cn.iocoder.yudao.module.inherit.service.inheritor;

import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.common.pojo.PageParam;
import cn.iocoder.yudao.module.inherit.dal.dataobject.inheritor.InheritorDO;

import java.util.Collection;
import java.util.Map;

/**
 * 传承人关注 Service 接口
 *
 * user_id 复用底座用户体系（member_user.id），不新建用户/账号体系。
 *
 * @author inherit
 */
public interface InheritorFollowService {

    /**
     * 关注传承人
     *
     * @param userId      用户编号
     * @param inheritorId 传承人编号
     */
    void createFollow(Long userId, Long inheritorId);

    /**
     * 取消关注传承人
     *
     * @param userId      用户编号
     * @param inheritorId 传承人编号
     */
    void deleteFollow(Long userId, Long inheritorId);

    /**
     * 是否已关注
     *
     * @param userId      用户编号
     * @param inheritorId 传承人编号
     */
    boolean isFollowed(Long userId, Long inheritorId);

    /**
     * 获得传承人关注数
     *
     * @param inheritorId 传承人编号
     */
    Long getFollowCount(Long inheritorId);

    /**
     * 获得某用户的关注列表（分页，返回传承人信息）
     */
    PageResult<InheritorDO> getFollowPage(Long userId, PageParam pageParam);

    /**
     * 批量获得一批传承人的关注数（列表页避免 N+1）
     */
    Map<Long, Long> getFollowCountMap(Collection<Long> inheritorIds);

}
