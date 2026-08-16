package cn.iocoder.yudao.module.inherit.controller.admin.inheritor.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.time.LocalDateTime;

/**
 * 传承人作品 Response VO
 *
 * @author inherit
 */
@Schema(description = "管理后台 - 传承人作品 Response VO")
@Data
@EqualsAndHashCode(callSuper = true)
public class InheritorWorkRespVO extends InheritorWorkSaveReqVO {

    @Schema(description = "创建时间")
    private LocalDateTime createTime;

}
