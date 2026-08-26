package cn.iocoder.yudao.module.heritage.controller.app.vo;
import lombok.Data; import java.time.LocalDateTime;
@Data public class CooperationRespVO { private Long id; private String companyName; private String contactName; private String contactPhone; private String cooperationType; private String cooperationTypeName; private String requirement; private Integer status; private String statusName; private String adminRemark; private LocalDateTime createTime; private LocalDateTime processedTime; }
