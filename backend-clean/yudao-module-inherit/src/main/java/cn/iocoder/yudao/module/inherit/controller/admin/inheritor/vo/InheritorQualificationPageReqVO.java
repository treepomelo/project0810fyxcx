package cn.iocoder.yudao.module.inherit.controller.admin.inheritor.vo;

import cn.iocoder.yudao.framework.common.pojo.PageParam;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * 传承人荣誉/资质 分页 Request VO
 *
 * @author inherit
 */
@Schema(description = "管理后台 - 传承人荣誉/资质 分页 Request VO")
@Data
@EqualsAndHashCode(callSuper = true)
public class InheritorQualificationPageReqVO extends PageParam {

    @Schema(description = "传承人编号", example = "1")
    private Long inheritorId;

    @Schema(description = "类型", example = "荣誉")
    private String type;

    @Schema(description = "名称", example = "国家级工艺美术大师")
    private String name;

}
