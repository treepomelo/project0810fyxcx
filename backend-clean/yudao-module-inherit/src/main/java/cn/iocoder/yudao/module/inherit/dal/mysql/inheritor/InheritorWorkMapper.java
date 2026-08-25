package cn.iocoder.yudao.module.inherit.dal.mysql.inheritor;

import cn.iocoder.yudao.framework.common.enums.CommonStatusEnum;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.mybatis.core.mapper.BaseMapperX;
import cn.iocoder.yudao.framework.mybatis.core.query.LambdaQueryWrapperX;
import cn.iocoder.yudao.module.inherit.controller.admin.inheritor.vo.InheritorWorkPageReqVO;
import cn.iocoder.yudao.module.inherit.dal.dataobject.inheritor.InheritorWorkDO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

/**
 * 传承人作品 Mapper
 *
 * @author inherit
 */
@Mapper
public interface InheritorWorkMapper extends BaseMapperX<InheritorWorkDO> {

    default PageResult<InheritorWorkDO> selectPage(InheritorWorkPageReqVO reqVO) {
        return selectPage(reqVO, new LambdaQueryWrapperX<InheritorWorkDO>()
                .eqIfPresent(InheritorWorkDO::getInheritorId, reqVO.getInheritorId())
                .likeIfPresent(InheritorWorkDO::getName, reqVO.getName())
                .orderByAsc(InheritorWorkDO::getSort)
                .orderByDesc(InheritorWorkDO::getId));
    }

    /**
     * 按传承人查询（C 端详情使用），只返回状态正常（ENABLE）的作品
     */
    default List<InheritorWorkDO> selectListByInheritorId(Long inheritorId) {
        return selectList(new LambdaQueryWrapperX<InheritorWorkDO>()
                .eq(InheritorWorkDO::getInheritorId, inheritorId)
                .eq(InheritorWorkDO::getStatus, CommonStatusEnum.ENABLE.getStatus())
                .orderByAsc(InheritorWorkDO::getSort)
                .orderByDesc(InheritorWorkDO::getId));
    }

    /**
     * 传承人删除时，级联逻辑删除其作品
     */
    default void deleteByInheritorId(Long inheritorId) {
        delete(new LambdaQueryWrapperX<InheritorWorkDO>()
                .eq(InheritorWorkDO::getInheritorId, inheritorId));
    }

}
