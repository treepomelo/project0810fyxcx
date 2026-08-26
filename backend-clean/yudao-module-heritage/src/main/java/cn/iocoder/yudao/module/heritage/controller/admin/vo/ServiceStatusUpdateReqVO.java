package cn.iocoder.yudao.module.heritage.controller.admin.vo;

import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class ServiceStatusUpdateReqVO {
    @NotNull private Long id;
    @NotNull private Integer status;
}