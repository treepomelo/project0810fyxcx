package cn.iocoder.yudao.module.inherit.controller.app.inheritor.vo;

import lombok.Data;

@Data
public class AppInheritorProductRespVO {
    private Long spuId;
    private String name;
    private String picUrl;
    private Integer price;
    private Integer marketPrice;
    private Integer stock;
    private Boolean isRepresentative;
    private Integer sort;
    private String introduction;
}