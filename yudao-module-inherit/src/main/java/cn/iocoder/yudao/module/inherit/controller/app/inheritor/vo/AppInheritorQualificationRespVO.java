package cn.iocoder.yudao.module.inherit.controller.app.inheritor.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.time.LocalDate;

/**
 * 用户 App - 传承人荣誉/资质 Response VO
 *
 * @author inherit
 */
@Schema(description = "用户 App - 传承人荣誉/资质 Response VO")
@Data
public class AppInheritorQualificationRespVO {

    @Schema(description = "编号")
    private Long id;

    @Schema(description = "类型：荣誉/资质/代表性传承人身份/获奖/证书", example = "荣誉")
    private String type;

    @Schema(description = "名称", example = "国家级工艺美术大师")
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

}
