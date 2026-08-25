package cn.iocoder.yudao.module.inherit.controller.admin.inheritor.vo;

import cn.iocoder.yudao.framework.common.pojo.PageParam;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * 传承人作品 分页 Request VO
 *
 * @author inherit
 */
@Schema(description = "管理后台 - 传承人作品 分页 Request VO")
@Data
@EqualsAndHashCode(callSuper = true)
public class InheritorWorkPageReqVO extends PageParam {

    @Schema(description = "传承人编号", example = "1")
    private Long inheritorId;

    @Schema(description = "作品名称", example = "掐丝珐琅花瓶")
    private String name;

}
