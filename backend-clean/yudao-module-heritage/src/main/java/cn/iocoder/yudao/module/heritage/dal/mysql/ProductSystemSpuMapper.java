package cn.iocoder.yudao.module.heritage.dal.mysql;

import cn.iocoder.yudao.framework.mybatis.core.mapper.BaseMapperX;
import cn.iocoder.yudao.module.heritage.dal.dataobject.ProductSystemSpuDO;
import cn.iocoder.yudao.module.heritage.service.ProductItemRow;
import cn.iocoder.yudao.module.heritage.service.ProductSystemSpuAdminRow;
import org.apache.ibatis.annotations.*;
import java.util.List;

@Mapper
public interface ProductSystemSpuMapper extends BaseMapperX<ProductSystemSpuDO> {
    @Select("SELECT r.id AS relationId,r.spu_id AS targetId,p.name AS title,p.introduction AS summary,p.pic_url AS coverUrl,p.price AS price,r.sort AS sortOrder FROM heritage_product_system_spu r JOIN product_spu p ON p.id=r.spu_id AND p.deleted=0 AND p.status=1 WHERE r.product_system_id=#{systemId} AND r.status=1 AND r.deleted=0 ORDER BY r.sort ASC,r.id ASC LIMIT #{offset},#{limit}")
    List<ProductItemRow> selectVisible(Long systemId, long offset, int limit);
    @Select("SELECT COUNT(1) FROM heritage_product_system_spu r JOIN product_spu p ON p.id=r.spu_id AND p.deleted=0 AND p.status=1 WHERE r.product_system_id=#{systemId} AND r.status=1 AND r.deleted=0")
    long countVisible(Long systemId);
    @Select("SELECT r.id AS relationId,r.spu_id AS targetId,p.name AS title,p.introduction AS summary,p.pic_url AS coverUrl,p.price AS price,r.sort AS sortOrder FROM heritage_product_system_spu r JOIN product_spu p ON p.id=r.spu_id AND p.deleted=0 AND p.status=1 WHERE r.product_system_id=#{systemId} AND r.status=1 AND r.deleted=0 AND (p.name LIKE CONCAT('%',#{keyword},'%') OR p.introduction LIKE CONCAT('%',#{keyword},'%')) ORDER BY r.sort ASC,r.id ASC LIMIT #{offset},#{limit}")
    List<ProductItemRow> selectVisibleKeyword(Long systemId, String keyword, long offset, int limit);
    @Select("SELECT COUNT(1) FROM heritage_product_system_spu r JOIN product_spu p ON p.id=r.spu_id AND p.deleted=0 AND p.status=1 WHERE r.product_system_id=#{systemId} AND r.status=1 AND r.deleted=0 AND (p.name LIKE CONCAT('%',#{keyword},'%') OR p.introduction LIKE CONCAT('%',#{keyword},'%'))")
    long countVisibleKeyword(Long systemId, String keyword);
    @Select("SELECT COUNT(1) FROM product_spu WHERE id=#{spuId} AND deleted=0")
    int countSpu(Long spuId);
    @Select("SELECT * FROM heritage_product_system_spu WHERE product_system_id=#{systemId} AND spu_id=#{spuId} LIMIT 1")
    ProductSystemSpuDO selectAnyRelation(Long systemId, Long spuId);
    @Select("SELECT * FROM heritage_product_system_spu WHERE product_system_id=#{systemId} AND spu_id=#{spuId} AND deleted=0 LIMIT 1")
    ProductSystemSpuDO selectActiveRelation(Long systemId, Long spuId);
    @Update("UPDATE heritage_product_system_spu SET sort=#{sort},status=#{status},deleted=0,updater=#{updater},update_time=NOW() WHERE id=#{id}")
    int restoreRelation(Long id, Integer sort, Integer status, String updater);
    @Update("UPDATE heritage_product_system_spu SET sort=#{sort},status=#{status},updater=#{updater},update_time=NOW() WHERE id=#{id} AND deleted=0")
    int updateRelation(Long id, Integer sort, Integer status, String updater);
    @Select("<script>SELECT r.id,r.product_system_id AS systemId,ps.code AS systemCode,ps.name AS systemName,r.spu_id AS spuId,p.name AS spuName,p.pic_url AS spuPicUrl,p.price AS spuPrice,r.sort,r.status,r.create_time AS createTime FROM heritage_product_system_spu r JOIN heritage_product_system ps ON ps.id=r.product_system_id JOIN product_spu p ON p.id=r.spu_id WHERE r.deleted=0 <if test='systemCode != null and systemCode != \"\"'>AND ps.code=#{systemCode}</if> <if test='spuId != null'>AND r.spu_id=#{spuId}</if> <if test='status != null'>AND r.status=#{status}</if> ORDER BY r.sort ASC,r.id DESC LIMIT #{offset},#{limit}</script>")
    List<ProductSystemSpuAdminRow> selectAdminPage(String systemCode, Long spuId, Integer status, long offset, int limit);
    @Select("<script>SELECT COUNT(1) FROM heritage_product_system_spu r JOIN heritage_product_system ps ON ps.id=r.product_system_id WHERE r.deleted=0 <if test='systemCode != null and systemCode != \"\"'>AND ps.code=#{systemCode}</if> <if test='spuId != null'>AND r.spu_id=#{spuId}</if> <if test='status != null'>AND r.status=#{status}</if></script>")
    long countAdminPage(String systemCode, Long spuId, Integer status);
}