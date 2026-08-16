package cn.iocoder.yudao.module.inherit.controller.app.inheritor.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * 用户 App - 传承人详情 Response VO
 *
 * 详情页：基本信息（含隐私字段控制）+ 荣誉/资质 + 作品 + 非遗项目 + 关注，均通过独立接口加载，
 * 避免巨型 SQL，且保证传承人核心资料优先展示（异常隔离）。
 *
 * @author inherit
 */
@Schema(description = "用户 App - 传承人详情 Response VO")
@Data
@EqualsAndHashCode(callSuper = true)
public class AppInheritorDetailRespVO extends AppInheritorRespVO {

    @Schema(description = "性别：0 未知、1 男、2 女", example = "1")
    private Integer gender;

    @Schema(description = "详细介绍")
    private String profile;

    @Schema(description = "从业经历")
    private String experience;

    @Schema(description = "是否已关注（登录用户视角；未登录为 false）", example = "true")
    private Boolean isFollowed;

}
