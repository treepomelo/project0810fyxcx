package cn.iocoder.yudao.module.heritage.controller.admin.vo;

import jakarta.validation.constraints.NotNull;
import lombok.Data;
import java.time.LocalDateTime;

@Data
public class ServiceScheduleUpdateReqVO {
    @NotNull private Long id;
    private LocalDateTime startTime;
    private LocalDateTime endTime;
    private String location;
    private Integer capacity;
    private Integer status;
}