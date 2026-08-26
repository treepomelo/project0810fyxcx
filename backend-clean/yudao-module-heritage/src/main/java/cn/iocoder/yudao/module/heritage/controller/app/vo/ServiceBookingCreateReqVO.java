package cn.iocoder.yudao.module.heritage.controller.app.vo;
import jakarta.validation.constraints.*; import lombok.Data;
@Data public class ServiceBookingCreateReqVO { @NotNull private Long serviceId; @NotNull private Long scheduleId; @NotBlank @Size(max=100) private String contactName; @NotBlank @Pattern(regexp="^[0-9]{11}$") private String contactPhone; @NotNull @Min(1) @Max(20) private Integer peopleCount; @Size(max=500) private String remark; }
