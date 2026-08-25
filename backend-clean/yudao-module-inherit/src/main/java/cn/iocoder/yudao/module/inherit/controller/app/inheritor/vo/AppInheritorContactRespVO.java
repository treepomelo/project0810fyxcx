package cn.iocoder.yudao.module.inherit.controller.app.inheritor.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

/**
 * 用户 App - 传承人联系电话 Response VO
 *
 * @author inherit
 */
@Schema(description = "用户 App - 传承人联系电话 Response VO")
@Data
public class AppInheritorContactRespVO {

    @Schema(description = "联系电话")
    private String phone;

}
