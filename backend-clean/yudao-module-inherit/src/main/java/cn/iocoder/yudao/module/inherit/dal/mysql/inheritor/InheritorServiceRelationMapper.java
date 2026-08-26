package cn.iocoder.yudao.module.inherit.dal.mysql.inheritor;

import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.mybatis.core.mapper.BaseMapperX;
import cn.iocoder.yudao.framework.mybatis.core.query.LambdaQueryWrapperX;
import cn.iocoder.yudao.module.inherit.controller.admin.inheritor.vo.InheritorServiceRelationPageReqVO;
import cn.iocoder.yudao.module.inherit.dal.dataobject.inheritor.InheritorServiceRelationDO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;
import java.util.List;

@Mapper
public interface InheritorServiceRelationMapper extends BaseMapperX<InheritorServiceRelationDO> {
    default PageResult<InheritorServiceRelationDO> selectPage(InheritorServiceRelationPageReqVO req) {
        return selectPage(req, new LambdaQueryWrapperX<InheritorServiceRelationDO>()
                .eqIfPresent(InheritorServiceRelationDO::getInheritorId, req.getInheritorId())
                .eqIfPresent(InheritorServiceRelationDO::getServiceId, req.getServiceId())
                .eqIfPresent(InheritorServiceRelationDO::getStatus, req.getStatus())
                .orderByAsc(InheritorServiceRelationDO::getSort)
                .orderByDesc(InheritorServiceRelationDO::getId));
    }

    @Select("SELECT * FROM inherit_inheritor_service_relation WHERE inheritor_id=#{inheritorId} AND service_id=#{serviceId} LIMIT 1")
    InheritorServiceRelationDO selectAny(@Param("inheritorId") Long inheritorId, @Param("serviceId") Long serviceId);

    @Update("UPDATE inherit_inheritor_service_relation SET is_representative=#{representative},sort=#{sort},status=#{status},deleted=0,updater=#{updater},update_time=NOW() WHERE id=#{id}")
    int revive(@Param("id") Long id, @Param("representative") Boolean representative, @Param("sort") Integer sort,
               @Param("status") Integer status, @Param("updater") String updater);

    @Update("UPDATE inherit_inheritor_service_relation SET inheritor_id=#{inheritorId},service_id=#{serviceId},is_representative=#{representative},sort=#{sort},status=#{status},updater=#{updater},update_time=NOW() WHERE id=#{id} AND deleted=0")
    int updateRelation(@Param("id") Long id, @Param("inheritorId") Long inheritorId, @Param("serviceId") Long serviceId,
                       @Param("representative") Boolean representative, @Param("sort") Integer sort,
                       @Param("status") Integer status, @Param("updater") String updater);

    default void deleteByInheritorId(Long inheritorId) {
        delete(new LambdaQueryWrapperX<InheritorServiceRelationDO>().eq(InheritorServiceRelationDO::getInheritorId, inheritorId));
    }

    default List<InheritorServiceRelationDO> selectActiveByInheritorId(Long inheritorId) {
        return selectList(new LambdaQueryWrapperX<InheritorServiceRelationDO>()
                .eq(InheritorServiceRelationDO::getInheritorId, inheritorId)
                .eq(InheritorServiceRelationDO::getStatus, 1)
                .orderByAsc(InheritorServiceRelationDO::getSort)
                .orderByDesc(InheritorServiceRelationDO::getId));
    }
}