package cn.iocoder.yudao.module.inherit.controller.admin.inheritor.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import java.util.List;

/**
 * 传承人作品 保存/更新 Request VO
 *
 * @author inherit
 */
@Schema(description = "管理后台 - 传承人作品 保存/更新 Request VO")
@Data
public class InheritorWorkSaveReqVO {

    @Schema(description = "编号", example = "1")
    private Long id;

    @Schema(description = "传承人编号", requiredMode = Schema.RequiredMode.REQUIRED, example = "1")
    @NotNull(message = "传承人编号不能为空")
    private Long inheritorId;

    @Schema(description = "作品名称", requiredMode = Schema.RequiredMode.REQUIRED, example = "掐丝珐琅花瓶")
    @NotEmpty(message = "作品名称不能为空")
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

    @Schema(description = "排序", example = "0")
    private Integer sort;

    @Schema(description = "状态：0 正常、1 停用", example = "0")
    private Integer status;

}
