package cn.iocoder.yudao.module.inherit.dal.dataobject.inheritor;

import cn.iocoder.yudao.framework.tenant.core.db.TenantBaseDO;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;

@TableName("inherit_inheritor_service_relation")
@Data
@EqualsAndHashCode(callSuper = true)
public class InheritorServiceRelationDO extends TenantBaseDO {
    private Long id;
    private Long inheritorId;
    private Long serviceId;
    private Boolean isRepresentative;
    private Integer sort;
    private Integer status;
}