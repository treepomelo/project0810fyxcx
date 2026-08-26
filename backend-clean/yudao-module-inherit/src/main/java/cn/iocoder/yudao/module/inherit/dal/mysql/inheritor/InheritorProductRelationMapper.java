package cn.iocoder.yudao.module.inherit.dal.mysql.inheritor;

import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.mybatis.core.mapper.BaseMapperX;
import cn.iocoder.yudao.framework.mybatis.core.query.LambdaQueryWrapperX;
import cn.iocoder.yudao.module.inherit.controller.admin.inheritor.vo.InheritorProductRelationPageReqVO;
import cn.iocoder.yudao.module.inherit.dal.dataobject.inheritor.InheritorProductRelationDO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;
import java.util.List;

@Mapper
public interface InheritorProductRelationMapper extends BaseMapperX<InheritorProductRelationDO> {
    default PageResult<InheritorProductRelationDO> selectPage(InheritorProductRelationPageReqVO req) {
        return selectPage(req, new LambdaQueryWrapperX<InheritorProductRelationDO>()
                .eqIfPresent(InheritorProductRelationDO::getInheritorId, req.getInheritorId())
                .eqIfPresent(InheritorProductRelationDO::getSpuId, req.getSpuId())
                .eqIfPresent(InheritorProductRelationDO::getStatus, req.getStatus())
                .orderByAsc(InheritorProductRelationDO::getSort)
                .orderByDesc(InheritorProductRelationDO::getId));
    }

    @Select("SELECT * FROM inherit_inheritor_product_relation WHERE inheritor_id=#{inheritorId} AND spu_id=#{spuId} LIMIT 1")
    InheritorProductRelationDO selectAny(@Param("inheritorId") Long inheritorId, @Param("spuId") Long spuId);

    @Update("UPDATE inherit_inheritor_product_relation SET is_representative=#{representative},sort=#{sort},status=#{status},deleted=0,updater=#{updater},update_time=NOW() WHERE id=#{id}")
    int revive(@Param("id") Long id, @Param("representative") Boolean representative, @Param("sort") Integer sort,
               @Param("status") Integer status, @Param("updater") String updater);

    @Update("UPDATE inherit_inheritor_product_relation SET inheritor_id=#{inheritorId},spu_id=#{spuId},is_representative=#{representative},sort=#{sort},status=#{status},updater=#{updater},update_time=NOW() WHERE id=#{id} AND deleted=0")
    int updateRelation(@Param("id") Long id, @Param("inheritorId") Long inheritorId, @Param("spuId") Long spuId,
                       @Param("representative") Boolean representative, @Param("sort") Integer sort,
                       @Param("status") Integer status, @Param("updater") String updater);

    default void deleteByInheritorId(Long inheritorId) {
        delete(new LambdaQueryWrapperX<InheritorProductRelationDO>().eq(InheritorProductRelationDO::getInheritorId, inheritorId));
    }

    default List<InheritorProductRelationDO> selectActiveByInheritorId(Long inheritorId) {
        return selectList(new LambdaQueryWrapperX<InheritorProductRelationDO>()
                .eq(InheritorProductRelationDO::getInheritorId, inheritorId)
                .eq(InheritorProductRelationDO::getStatus, 1)
                .orderByAsc(InheritorProductRelationDO::getSort)
                .orderByDesc(InheritorProductRelationDO::getId));
    }
}