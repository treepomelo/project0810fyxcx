package cn.iocoder.yudao.module.inherit.controller.admin.inheritor.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import javax.validation.constraints.NotNull;

/**
 * 传承人-非遗项目 关系 保存/更新 Request VO
 *
 * @author inherit
 */
@Schema(description = "管理后台 - 传承人-非遗项目 关系 保存/更新 Request VO")
@Data
public class InheritorProjectRelationSaveReqVO {

    @Schema(description = "编号", example = "1")
    private Long id;

    @Schema(description = "传承人编号", requiredMode = Schema.RequiredMode.REQUIRED, example = "1")
    @NotNull(message = "传承人编号不能为空")
    private Long inheritorId;

    @Schema(description = "非遗项目编号", requiredMode = Schema.RequiredMode.REQUIRED, example = "1")
    @NotNull(message = "非遗项目编号不能为空")
    private Long projectId;

    @Schema(description = "是否主打项目", example = "true")
    private Boolean isPrimary;

    @Schema(description = "排序", example = "0")
    private Integer sort;

}
