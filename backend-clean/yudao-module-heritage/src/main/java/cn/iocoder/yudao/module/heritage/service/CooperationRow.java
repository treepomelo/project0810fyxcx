package cn.iocoder.yudao.module.heritage.service;
import lombok.Data; import java.time.LocalDateTime;
@Data public class CooperationRow { private Long id; private String companyName; private String contactName; private String contactPhone; private String cooperationType; private String requirement; private Integer status; private String adminRemark; private LocalDateTime createTime; private LocalDateTime processedTime; }
