package cn.iocoder.yudao.module.inherit.controller.admin.inheritor.vo;

import cn.iocoder.yudao.framework.common.pojo.PageParam;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * 传承人 分页 Request VO
 *
 * @author inherit
 */
@Schema(description = "管理后台 - 传承人 分页 Request VO")
@Data
@EqualsAndHashCode(callSuper = true)
public class InheritorPageReqVO extends PageParam {

    @Schema(description = "姓名", example = "张三")
    private String name;

    @Schema(description = "传承人级别/身份", example = "省级代表性传承人")
    private String level;

    @Schema(description = "省份编号", example = "110000")
    private Integer provinceCode;

    @Schema(description = "城市编号", example = "110100")
    private Integer cityCode;

    @Schema(description = "区县编号", example = "110101")
    private Integer districtCode;

    @Schema(description = "状态：0 正常、1 停用", example = "0")
    private Integer status;

    @Schema(description = "审核状态：0 待审核、1 已通过、2 未通过", example = "1")
    private Integer auditStatus;

}
