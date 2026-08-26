package cn.iocoder.yudao.module.inherit.dal.dataobject.inheritor;

import cn.iocoder.yudao.framework.tenant.core.db.TenantBaseDO;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;

@TableName("inherit_inheritor_product_relation")
@Data
@EqualsAndHashCode(callSuper = true)
public class InheritorProductRelationDO extends TenantBaseDO {
    private Long id;
    private Long inheritorId;
    private Long spuId;
    private Boolean isRepresentative;
    private Integer sort;
    private Integer status;
}