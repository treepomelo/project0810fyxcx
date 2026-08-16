package cn.iocoder.yudao.module.inherit.controller.admin.inheritor.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import javax.validation.constraints.NotEmpty;
import javax.validation.constraints.NotNull;
import java.time.LocalDate;

/**
 * 传承人荣誉/资质 保存/更新 Request VO
 *
 * @author inherit
 */
@Schema(description = "管理后台 - 传承人荣誉/资质 保存/更新 Request VO")
@Data
public class InheritorQualificationSaveReqVO {

    @Schema(description = "编号", example = "1")
    private Long id;

    @Schema(description = "传承人编号", requiredMode = Schema.RequiredMode.REQUIRED, example = "1")
    @NotNull(message = "传承人编号不能为空")
    private Long inheritorId;

    @Schema(description = "类型：荣誉/资质/代表性传承人身份/获奖/证书", example = "荣誉")
    @NotEmpty(message = "类型不能为空")
    private String type;

    @Schema(description = "名称", example = "国家级工艺美术大师")
    @NotEmpty(message = "名称不能为空")
    private String name;

    @Schema(description = "级别")
    private String level;

    @Schema(description = "颁发机构")
    private String issuer;

    @Schema(description = "颁发日期")
    private LocalDate issueDate;

    @Schema(description = "证书编号")
    private String certificateNo;

    @Schema(description = "描述")
    private String description;

    @Schema(description = "证书/荣誉图片 url")
    private String imageUrl;

    @Schema(description = "排序", example = "0")
    private Integer sort;

    @Schema(description = "状态：0 正常、1 停用", example = "0")
    private Integer status;

}
