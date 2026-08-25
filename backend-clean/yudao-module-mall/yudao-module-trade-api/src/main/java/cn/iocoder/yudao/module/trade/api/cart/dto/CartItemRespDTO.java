package cn.iocoder.yudao.module.trade.api.cart.dto;

import lombok.Data;
import lombok.experimental.Accessors;

@Data
@Accessors(chain = true)
public class CartItemRespDTO {
    private Long id;
    private Long spuId;
    private Long skuId;
    private Integer count;
    private Boolean selected;
}
