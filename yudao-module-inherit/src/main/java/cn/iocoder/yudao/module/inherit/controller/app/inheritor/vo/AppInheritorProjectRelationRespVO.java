package cn.iocoder.yudao.module.inherit.controller.app.inheritor.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

/**
 * 用户 App - 传承人-非遗项目 关系 Response VO
 *
 * 只返回关系信息与 projectId，非遗项目名称/门类等主数据由 HeritageProject 模块（未来）提供。
 *
 * @author inherit
 */
@Schema(description = "用户 App - 传承人-非遗项目 关系 Response VO")
@Data
public class AppInheritorProjectRelationRespVO {

    @Schema(description = "编号")
    private Long id;

    @Schema(description = "非遗项目编号", example = "1")
    private Long projectId;

    @Schema(description = "是否主打项目", example = "true")
    private Boolean isPrimary;

    @Schema(description = "排序")
    private Integer sort;

}
