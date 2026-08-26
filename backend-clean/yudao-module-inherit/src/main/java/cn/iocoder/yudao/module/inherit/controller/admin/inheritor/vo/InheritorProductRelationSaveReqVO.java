package cn.iocoder.yudao.module.inherit.controller.admin.inheritor.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
@Schema(description = "管理后台 - 传承人商品关系保存/更新 Request VO")
public class InheritorProductRelationSaveReqVO {
    private Long id;
    @NotNull(message = "传承人编号不能为空")
    private Long inheritorId;
    @NotNull(message = "商品 SPU 编号不能为空")
    private Long spuId;
    private Boolean isRepresentative = false;
    private Integer sort = 0;
    private Integer status = 1;
}