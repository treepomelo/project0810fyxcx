package cn.iocoder.yudao.module.inherit.controller.app.inheritor.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import javax.validation.constraints.NotNull;

/**
 * 用户 App - 关注传承人 Request VO
 *
 * @author inherit
 */
@Schema(description = "用户 App - 关注传承人 Request VO")
@Data
public class AppInheritorFollowReqVO {

    @Schema(description = "传承人编号", requiredMode = Schema.RequiredMode.REQUIRED, example = "1")
    @NotNull(message = "传承人编号不能为空")
    private Long inheritorId;

}
