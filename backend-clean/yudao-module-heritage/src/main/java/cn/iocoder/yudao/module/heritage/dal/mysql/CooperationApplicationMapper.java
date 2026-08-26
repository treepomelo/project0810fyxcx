package cn.iocoder.yudao.module.heritage.dal.mysql;

import cn.iocoder.yudao.framework.mybatis.core.mapper.BaseMapperX;
import cn.iocoder.yudao.module.heritage.dal.dataobject.CooperationApplicationDO;
import cn.iocoder.yudao.module.heritage.service.CooperationRow;
import org.apache.ibatis.annotations.*;
import java.util.List;

@Mapper
public interface CooperationApplicationMapper extends BaseMapperX<CooperationApplicationDO> {
    @Select("SELECT * FROM heritage_cooperation_application WHERE id=#{id} AND deleted=0 LIMIT 1 FOR UPDATE")
    CooperationApplicationDO selectForUpdate(Long id);
    @Select("SELECT id,company_name AS companyName,contact_name AS contactName,contact_phone AS contactPhone,cooperation_type AS cooperationType,requirement,status,admin_remark AS adminRemark,create_time AS createTime,processed_time AS processedTime FROM heritage_cooperation_application WHERE user_id=#{userId} AND deleted=0 ORDER BY create_time DESC LIMIT #{offset},#{limit}")
    List<CooperationRow> selectMy(Long userId, long offset, int limit);
    @Select("SELECT COUNT(1) FROM heritage_cooperation_application WHERE user_id=#{userId} AND deleted=0")
    long countMy(Long userId);
    @Update("UPDATE heritage_cooperation_application SET status=#{status},processed_by=#{processedBy},processed_time=NOW(),updater=#{updater},update_time=NOW() WHERE id=#{id} AND deleted=0")
    int updateStatus(Long id, int status, Long processedBy, String updater);
}