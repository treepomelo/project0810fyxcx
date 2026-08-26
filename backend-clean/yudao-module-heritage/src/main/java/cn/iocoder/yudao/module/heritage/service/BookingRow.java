package cn.iocoder.yudao.module.heritage.service;
import lombok.Data; import java.time.LocalDateTime;
@Data public class BookingRow { private Long bookingId; private Integer status; private Integer peopleCount; private String contactName; private String contactPhone; private Long serviceId; private String serviceTitle; private String coverUrl; private String systemCode; private String systemName; private Long scheduleId; private LocalDateTime startTime; private LocalDateTime endTime; private String location; private LocalDateTime createTime; }
