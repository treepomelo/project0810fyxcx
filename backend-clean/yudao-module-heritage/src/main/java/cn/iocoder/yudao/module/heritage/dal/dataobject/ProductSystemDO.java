package cn.iocoder.yudao.module.heritage.dal.dataobject;
import cn.iocoder.yudao.framework.tenant.core.db.TenantBaseDO; import com.baomidou.mybatisplus.annotation.TableName; import lombok.Data; import lombok.EqualsAndHashCode;
@TableName("heritage_product_system") @Data @EqualsAndHashCode(callSuper=true) public class ProductSystemDO extends TenantBaseDO { private Long id; private String code; private String name; private String description; private String iconUrl; private String coverUrl; private Integer sort; private Integer status; }
