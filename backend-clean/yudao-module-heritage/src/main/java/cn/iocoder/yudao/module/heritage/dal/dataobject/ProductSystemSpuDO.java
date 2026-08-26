package cn.iocoder.yudao.module.heritage.dal.dataobject;
import cn.iocoder.yudao.framework.tenant.core.db.TenantBaseDO; import com.baomidou.mybatisplus.annotation.TableName; import lombok.Data; import lombok.EqualsAndHashCode;
@TableName("heritage_product_system_spu") @Data @EqualsAndHashCode(callSuper=true) public class ProductSystemSpuDO extends TenantBaseDO { private Long id; private Long productSystemId; private Long spuId; private Integer sort; private Integer status; }
