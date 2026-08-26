package cn.iocoder.yudao.module.heritage.controller.admin.vo;

import lombok.Data;

@Data
public class ProductSystemSpuPageReqVO {
    private Integer pageNo = 1;
    private Integer pageSize = 10;
    private String systemCode;
    private Long spuId;
    private Integer status;
}