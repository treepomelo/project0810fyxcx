package cn.iocoder.yudao.module.inherit.controller.admin.inheritor.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import jakarta.validation.constraints.NotNull;

/**
 * 传承人 审核 Request VO
 *
 * @author inherit
 */
@Schema(description = "管理后台 - 传承人 审核 Request VO")
@Data
public class InheritorAuditReqVO {

    @Schema(description = "传承人编号", requiredMode = Schema.RequiredMode.REQUIRED, example = "1")
    @NotNull(message = "传承人编号不能为空")
    private Long id;

    @Schema(description = "审核状态：0 待审核、1 已通过、2 未通过", requiredMode = Schema.RequiredMode.REQUIRED, example = "1")
    @NotNull(message = "审核状态不能为空")
    private Integer auditStatus;

    @Schema(description = "审核备注")
    private String auditRemark;

}
