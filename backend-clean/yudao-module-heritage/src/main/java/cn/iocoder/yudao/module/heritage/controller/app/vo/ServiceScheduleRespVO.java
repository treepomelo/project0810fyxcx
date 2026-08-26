package cn.iocoder.yudao.module.heritage.controller.app.vo;
import lombok.Data; import java.time.LocalDateTime;
@Data public class ServiceScheduleRespVO { private Long id; private LocalDateTime startTime; private LocalDateTime endTime; private String location; private Integer capacity; private Integer bookedCount; private Integer remaining; private Boolean available; }
