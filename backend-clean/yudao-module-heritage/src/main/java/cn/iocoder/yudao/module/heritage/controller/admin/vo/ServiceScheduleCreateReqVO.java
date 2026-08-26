package cn.iocoder.yudao.module.heritage.controller.admin.vo;

import jakarta.validation.constraints.NotNull;
import lombok.Data;
import java.time.LocalDateTime;

@Data
public class ServiceScheduleCreateReqVO {
    @NotNull private Long serviceId;
    @NotNull private LocalDateTime startTime;
    @NotNull private LocalDateTime endTime;
    private String location;
    @NotNull private Integer capacity;
    private Integer status = 1;
}