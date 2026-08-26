package cn.iocoder.yudao.module.inherit.controller.admin.inheritor.vo;

import cn.iocoder.yudao.framework.common.pojo.PageParam;
import lombok.Data;

@Data
public class InheritorProductRelationPageReqVO extends PageParam {
    private Long inheritorId;
    private Long spuId;
    private Integer status;
}