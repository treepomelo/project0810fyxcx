package cn.iocoder.yudao.module.inherit.controller.admin.inheritor.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.time.LocalDateTime;

/**
 * 传承人荣誉/资质 Response VO
 *
 * @author inherit
 */
@Schema(description = "管理后台 - 传承人荣誉/资质 Response VO")
@Data
@EqualsAndHashCode(callSuper = true)
public class InheritorQualificationRespVO extends InheritorQualificationSaveReqVO {

    @Schema(description = "创建时间")
    private LocalDateTime createTime;

}
