package cn.iocoder.yudao.module.product.dal.dataobject.delivery;

import cn.iocoder.yudao.framework.mybatis.core.dataobject.BaseDO;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

/**
 * Product form read model for the existing express-delivery template table.
 *
 * <p>This is intentionally read-only. Trade remains cart-only; this model only
 * supplies valid delivery-template choices required by Mall SPU validation.</p>
 */
@TableName("trade_delivery_express_template")
@Data
public class ProductDeliveryExpressTemplateDO extends BaseDO {

    @TableId
    private Long id;

    private String name;

    private Integer chargeMode;

    private Integer sort;

}
