package cn.iocoder.yudao.module.inherit.controller.app.inheritor.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

/**
 * 用户 App - 关注状态 Response VO
 *
 * @author inherit
 */
@Schema(description = "用户 App - 关注状态 Response VO")
@Data
public class AppInheritorFollowRespVO {

    @Schema(description = "是否已关注", example = "true")
    private Boolean isFollowed;

    @Schema(description = "关注数", example = "100")
    private Long followCount;

}
