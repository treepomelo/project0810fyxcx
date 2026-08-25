package cn.iocoder.yudao.module.inherit.controller.admin.inheritor.vo;

import cn.iocoder.yudao.framework.common.pojo.PageParam;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * 传承人-非遗项目 关系 分页 Request VO
 *
 * @author inherit
 */
@Schema(description = "管理后台 - 传承人-非遗项目 关系 分页 Request VO")
@Data
@EqualsAndHashCode(callSuper = true)
public class InheritorProjectRelationPageReqVO extends PageParam {

    @Schema(description = "传承人编号", example = "1")
    private Long inheritorId;

    @Schema(description = "非遗项目编号", example = "1")
    private Long projectId;

}
