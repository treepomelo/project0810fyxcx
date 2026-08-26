package cn.iocoder.yudao.module.heritage.dal.dataobject;
import cn.iocoder.yudao.framework.tenant.core.db.TenantBaseDO; import com.baomidou.mybatisplus.annotation.TableName; import lombok.Data; import lombok.EqualsAndHashCode;
@TableName("heritage_service_booking") @Data @EqualsAndHashCode(callSuper=true) public class ServiceBookingDO extends TenantBaseDO { private Long id; private Long userId; private Long serviceId; private Long scheduleId; private String contactName; private String contactPhone; private Integer peopleCount; private String remark; private Integer status; }
