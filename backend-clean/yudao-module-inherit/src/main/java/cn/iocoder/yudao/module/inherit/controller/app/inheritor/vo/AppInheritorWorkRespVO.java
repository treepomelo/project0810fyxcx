package cn.iocoder.yudao.module.inherit.controller.app.inheritor.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.util.List;

/**
 * 用户 App - 传承人作品 Response VO
 *
 * @author inherit
 */
@Schema(description = "用户 App - 传承人作品 Response VO")
@Data
public class AppInheritorWorkRespVO {

    @Schema(description = "编号")
    private Long id;

    @Schema(description = "作品名称", example = "掐丝珐琅花瓶")
    private String name;

    @Schema(description = "封面图 url")
    private String cover;

    @Schema(description = "作品图集 url 列表")
    private List<String> images;

    @Schema(description = "作品描述")
    private String description;

    @Schema(description = "创作年份", example = "2024")
    private String year;

    @Schema(description = "材质", example = "铜胎,珐琅")
    private String material;

    @Schema(description = "工艺/技法", example = "掐丝,点蓝")
    private String technique;

}
