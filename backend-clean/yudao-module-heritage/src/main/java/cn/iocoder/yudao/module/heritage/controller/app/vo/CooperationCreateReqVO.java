package cn.iocoder.yudao.module.heritage.controller.app.vo;
import jakarta.validation.constraints.*; import lombok.Data;
@Data public class CooperationCreateReqVO { @NotBlank @Size(max=200) private String companyName; @NotBlank @Size(max=100) private String contactName; @NotBlank @Pattern(regexp="^[0-9]{11}$") private String contactPhone; @NotBlank private String cooperationType; @NotBlank @Size(max=1000) private String requirement; }
