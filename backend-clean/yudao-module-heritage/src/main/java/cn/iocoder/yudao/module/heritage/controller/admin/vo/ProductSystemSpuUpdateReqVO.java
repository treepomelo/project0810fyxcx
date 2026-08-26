package cn.iocoder.yudao.module.heritage.controller.admin.vo;

import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class ProductSystemSpuUpdateReqVO {
    @NotNull
    private Long id;
    private Integer sort;
    private Integer status;
}