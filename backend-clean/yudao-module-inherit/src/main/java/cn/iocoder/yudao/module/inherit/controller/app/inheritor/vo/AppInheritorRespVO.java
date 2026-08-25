package cn.iocoder.yudao.module.inherit.controller.app.inheritor.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

/**
 * 用户 App - 传承人 Response VO（列表卡片）
 *
 * @author inherit
 */
@Schema(description = "用户 App - 传承人 Response VO")
@Data
public class AppInheritorRespVO {

    @Schema(description = "传承人编号", example = "1")
    private Long id;

    @Schema(description = "姓名", example = "张三")
    private String name;

    @Schema(description = "头像（真人照片）")
    private String avatar;

    @Schema(description = "封面图")
    private String cover;

    @Schema(description = "传承人级别/身份", example = "省级代表性传承人")
    private String level;

    @Schema(description = "省份编号", example = "110000")
    private Integer provinceCode;

    @Schema(description = "城市编号", example = "110100")
    private Integer cityCode;

    @Schema(description = "区县编号", example = "110101")
    private Integer districtCode;

    @Schema(description = "省份名称")
    private String provinceName;

    @Schema(description = "城市名称")
    private String cityName;

    @Schema(description = "区县名称")
    private String districtName;

    @Schema(description = "简介")
    private String introduction;

    @Schema(description = "擅长技艺", example = "景泰蓝,掐丝珐琅")
    private String specialty;

    @Schema(description = "关注数")
    private Long followCount;

}
