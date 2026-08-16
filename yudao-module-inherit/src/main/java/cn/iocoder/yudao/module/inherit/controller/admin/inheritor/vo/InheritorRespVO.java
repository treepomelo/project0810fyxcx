package cn.iocoder.yudao.module.inherit.controller.admin.inheritor.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.time.LocalDateTime;

/**
 * 传承人 Response VO
 *
 * @author inherit
 */
@Schema(description = "管理后台 - 传承人 Response VO")
@Data
@EqualsAndHashCode(callSuper = true)
public class InheritorRespVO extends InheritorSaveReqVO {

    @Schema(description = "审核状态：0 待审核、1 已通过、2 未通过", example = "1")
    private Integer auditStatus;

    @Schema(description = "审核备注")
    private String auditRemark;

    @Schema(description = "审核时间")
    private LocalDateTime auditTime;

    @Schema(description = "创建时间")
    private LocalDateTime createTime;

    @Schema(description = "省份名称")
    private String provinceName;

    @Schema(description = "城市名称")
    private String cityName;

    @Schema(description = "区县名称")
    private String districtName;

    @Schema(description = "关注数")
    private Long followCount;

}
