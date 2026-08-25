package cn.iocoder.yudao.module.inherit.dal.mysql.inheritor;

import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.common.pojo.PageParam;
import cn.iocoder.yudao.framework.mybatis.core.mapper.BaseMapperX;
import cn.iocoder.yudao.framework.mybatis.core.query.LambdaQueryWrapperX;
import cn.iocoder.yudao.module.inherit.dal.dataobject.inheritor.InheritorFollowDO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Update;

import java.util.List;

/**
 * 传承人关注 Mapper
 *
 * 用户（member_user.id）关注传承人，user_id + inheritor_id 唯一（数据库唯一索引兜底）。
 *
 * @author inherit
 */
@Mapper
public interface InheritorFollowMapper extends BaseMapperX<InheritorFollowDO> {

    /**
     * 查询关注关系（用于防重复、判断是否已关注）
     */
    default InheritorFollowDO selectByUserIdAndInheritorId(Long userId, Long inheritorId) {
        return selectOne(InheritorFollowDO::getUserId, userId, InheritorFollowDO::getInheritorId, inheritorId);
    }

    /**
     * 查询某用户关注的分页（用于“我的关注”）
     */
    default PageResult<InheritorFollowDO> selectPageByUserId(PageParam pageParam, Long userId) {
        return selectPage(pageParam, new LambdaQueryWrapperX<InheritorFollowDO>()
                .eq(InheritorFollowDO::getUserId, userId)
                .orderByDesc(InheritorFollowDO::getId));
    }

    /**
     * 查询某传承人的关注数
     */
    default Long selectCountByInheritorId(Long inheritorId) {
        return selectCount(InheritorFollowDO::getInheritorId, inheritorId);
    }

    /**
     * 批量查询一批传承人的关注数（列表页避免 N+1）
     */
    default List<InheritorFollowDO> selectListByInheritorIds(List<Long> inheritorIds) {
        return selectList(InheritorFollowDO::getInheritorId, inheritorIds);
    }

    /**
     * 取消关注
     */
    default void deleteByUserIdAndInheritorId(Long userId, Long inheritorId) {
        delete(new LambdaQueryWrapperX<InheritorFollowDO>()
                .eq(InheritorFollowDO::getUserId, userId)
                .eq(InheritorFollowDO::getInheritorId, inheritorId));
    }

    /**
     * 恢复逻辑删除的旧关注（取消后再关注的唯一键冲突解法），返回恢复条数
     */
    @Update("UPDATE inherit_inheritor_follow SET deleted = 0, update_time = NOW() "
            + "WHERE user_id = #{userId} AND inheritor_id = #{inheritorId} AND deleted = 1")
    int reviveByUserIdAndInheritorId(@Param("userId") Long userId, @Param("inheritorId") Long inheritorId);

    /**
     * 传承人删除时，级联逻辑删除其关注
     */
    default void deleteByInheritorId(Long inheritorId) {
        delete(new LambdaQueryWrapperX<InheritorFollowDO>()
                .eq(InheritorFollowDO::getInheritorId, inheritorId));
    }

}
