package cn.iocoder.yudao.module.inherit.controller.admin.inheritor.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import jakarta.validation.constraints.NotEmpty;
import java.time.LocalDateTime;

/**
 * 传承人 保存/更新 Request VO
 *
 * @author inherit
 */
@Schema(description = "管理后台 - 传承人 保存/更新 Request VO")
@Data
public class InheritorSaveReqVO {

    @Schema(description = "编号", example = "1")
    private Long id;

    @Schema(description = "姓名", requiredMode = Schema.RequiredMode.REQUIRED, example = "张三")
    @NotEmpty(message = "姓名不能为空")
    private String name;

    @Schema(description = "头像（真人照片）", example = "https://xxx.com/avatar.jpg")
    private String avatar;

    @Schema(description = "封面图")
    private String cover;

    @Schema(description = "性别：0 未知、1 男、2 女", example = "1")
    private Integer gender;

    @Schema(description = "联系电话")
    private String phone;

    @Schema(description = "身份证号")
    private String idCard;

    @Schema(description = "传承人级别/身份", example = "省级代表性传承人")
    private String level;

    @Schema(description = "省份编号", example = "110000")
    private Integer provinceCode;

    @Schema(description = "城市编号", example = "110100")
    private Integer cityCode;

    @Schema(description = "区县编号", example = "110101")
    private Integer districtCode;

    @Schema(description = "简介", example = "深耕传统技艺三十年的手艺人")
    private String introduction;

    @Schema(description = "详细介绍")
    private String profile;

    @Schema(description = "擅长技艺", example = "景泰蓝,掐丝珐琅")
    private String specialty;

    @Schema(description = "从业经历")
    private String experience;

    @Schema(description = "展示状态：0 不展示、1 展示", example = "1")
    private Integer displayStatus;

    @Schema(description = "是否首页推荐：0 否、1 是", example = "0")
    private Integer isRecommend;

    @Schema(description = "首页推荐排序", example = "0")
    private Integer recommendSort;

    @Schema(description = "排序", example = "0")
    private Integer sort;

    @Schema(description = "状态：0 正常、1 停用", example = "0")
    private Integer status;

    /** 展示时间（后台赋值，前端不传） */
    @Schema(hidden = true)
    private LocalDateTime publishedAt;

}
