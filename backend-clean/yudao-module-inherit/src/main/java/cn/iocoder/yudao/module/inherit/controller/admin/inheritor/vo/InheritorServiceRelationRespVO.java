package cn.iocoder.yudao.module.inherit.controller.admin.inheritor.vo;

import lombok.Data;
import lombok.EqualsAndHashCode;
import java.time.LocalDateTime;

@Data
@EqualsAndHashCode(callSuper = true)
public class InheritorServiceRelationRespVO extends InheritorServiceRelationSaveReqVO {
    private LocalDateTime createTime;
}