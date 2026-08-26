package cn.iocoder.yudao.module.inherit.controller.app.inheritor.vo;

import cn.iocoder.yudao.framework.common.pojo.PageParam;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * 用户 App - 传承人 分页 Request VO
 *
 * @author inherit
 */
@Schema(description = "用户 App - 传承人 分页 Request VO")
@Data
@EqualsAndHashCode(callSuper = true)
public class AppInheritorPageReqVO extends PageParam {

    @Schema(description = "关键词（姓名/擅长技艺），模糊搜索", example = "张三")
    private String keyword;

    @Schema(description = "省份编号", example = "110000")
    private Integer provinceCode;

    @Schema(description = "城市编号", example = "110100")
    private Integer cityCode;

    @Schema(description = "区县编号", example = "110101")
    private Integer districtCode;

    @Schema(description = "传承人级别/身份", example = "省级代表性传承人")
    private String level;
    @Schema(description = "非遗门类编号（复用 heritage_category）", example = "1")
    private Long heritageCategoryId;

}
