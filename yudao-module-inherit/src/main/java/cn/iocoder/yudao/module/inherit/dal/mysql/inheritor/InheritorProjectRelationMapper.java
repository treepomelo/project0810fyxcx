package cn.iocoder.yudao.module.inherit.dal.mysql.inheritor;

import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.mybatis.core.mapper.BaseMapperX;
import cn.iocoder.yudao.framework.mybatis.core.query.LambdaQueryWrapperX;
import cn.iocoder.yudao.module.inherit.controller.admin.inheritor.vo.InheritorProjectRelationPageReqVO;
import cn.iocoder.yudao.module.inherit.dal.dataobject.inheritor.InheritorProjectRelationDO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

/**
 * 传承人-非遗项目 关系 Mapper
 *
 * 只保存关系，不跨模块 Mapper（非遗项目主数据属 HeritageProject 模块）。
 *
 * @author inherit
 */
@Mapper
public interface InheritorProjectRelationMapper extends BaseMapperX<InheritorProjectRelationDO> {

    default PageResult<InheritorProjectRelationDO> selectPage(InheritorProjectRelationPageReqVO reqVO) {
        return selectPage(reqVO, new LambdaQueryWrapperX<InheritorProjectRelationDO>()
                .eqIfPresent(InheritorProjectRelationDO::getInheritorId, reqVO.getInheritorId())
                .eqIfPresent(InheritorProjectRelationDO::getProjectId, reqVO.getProjectId())
                .orderByAsc(InheritorProjectRelationDO::getSort)
                .orderByDesc(InheritorProjectRelationDO::getId));
    }

    /**
     * 查询是否已存在关系（防止重复：inheritor_id + project_id）
     */
    default InheritorProjectRelationDO selectByInheritorIdAndProjectId(Long inheritorId, Long projectId) {
        return selectOne(InheritorProjectRelationDO::getInheritorId, inheritorId,
                InheritorProjectRelationDO::getProjectId, projectId);
    }

    /**
     * 按传承人查询（C 端详情使用）
     */
    default List<InheritorProjectRelationDO> selectListByInheritorId(Long inheritorId) {
        return selectList(new LambdaQueryWrapperX<InheritorProjectRelationDO>()
                .eq(InheritorProjectRelationDO::getInheritorId, inheritorId)
                .orderByAsc(InheritorProjectRelationDO::getSort)
                .orderByDesc(InheritorProjectRelationDO::getId));
    }

    /**
     * 传承人删除时，级联逻辑删除其项目关系
     */
    default void deleteByInheritorId(Long inheritorId) {
        delete(new LambdaQueryWrapperX<InheritorProjectRelationDO>()
                .eq(InheritorProjectRelationDO::getInheritorId, inheritorId));
    }

}
