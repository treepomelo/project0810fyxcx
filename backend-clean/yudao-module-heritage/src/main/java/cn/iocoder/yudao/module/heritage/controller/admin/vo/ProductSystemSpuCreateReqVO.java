package cn.iocoder.yudao.module.heritage.controller.admin.vo;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class ProductSystemSpuCreateReqVO {
    @NotBlank
    private String systemCode;
    @NotNull
    private Long spuId;
    private Integer sort = 0;
    private Integer status = 1;
}