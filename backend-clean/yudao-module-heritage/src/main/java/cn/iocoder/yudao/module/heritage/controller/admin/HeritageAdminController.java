package cn.iocoder.yudao.module.heritage.controller.admin;

import cn.iocoder.yudao.framework.common.pojo.CommonResult;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.module.heritage.dal.dataobject.CooperationApplicationDO;
import cn.iocoder.yudao.module.heritage.dal.dataobject.HeritageServiceDO;
import cn.iocoder.yudao.module.heritage.dal.dataobject.ProductSystemDO;
import cn.iocoder.yudao.module.heritage.dal.dataobject.ServiceBookingDO;
import cn.iocoder.yudao.module.heritage.dal.dataobject.ServiceScheduleDO;
import cn.iocoder.yudao.module.heritage.dal.mysql.CooperationApplicationMapper;
import cn.iocoder.yudao.module.heritage.dal.mysql.HeritageServiceMapper;
import cn.iocoder.yudao.module.heritage.dal.mysql.ProductSystemMapper;
import cn.iocoder.yudao.module.heritage.dal.mysql.ServiceBookingMapper;
import cn.iocoder.yudao.module.heritage.dal.mysql.ServiceScheduleMapper;
import cn.iocoder.yudao.module.heritage.service.HeritageEcosystemService;
import jakarta.annotation.Resource;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import java.util.List;
import static cn.iocoder.yudao.framework.common.pojo.CommonResult.success;

@RestController
@RequestMapping("/heritage")
public class HeritageAdminController {
    @Resource private ProductSystemMapper productSystemMapper;
    @Resource private HeritageServiceMapper serviceMapper;
    @Resource private ServiceScheduleMapper scheduleMapper;
    @Resource private ServiceBookingMapper bookingMapper;
    @Resource private CooperationApplicationMapper cooperationMapper;
    @Resource private HeritageEcosystemService heritageService;

    @GetMapping("/product-system/page")
    @PreAuthorize("@ss.hasPermission('heritage:product-system:query')")
    public CommonResult<List<ProductSystemDO>> productSystemPage() {
        return success(productSystemMapper.selectList(null));
    }

    @GetMapping("/service/page")
    @PreAuthorize("@ss.hasPermission('heritage:service:query')")
    public CommonResult<List<HeritageServiceDO>> servicePage() {
        return success(serviceMapper.selectList(null));
    }

    @GetMapping("/schedule/page")
    @PreAuthorize("@ss.hasPermission('heritage:schedule:query')")
    public CommonResult<List<ServiceScheduleDO>> schedulePage(@RequestParam Long serviceId) {
        return success(scheduleMapper.selectList(new com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper<ServiceScheduleDO>()
                .eq(ServiceScheduleDO::getServiceId, serviceId)));
    }

    @GetMapping("/booking/page")
    @PreAuthorize("@ss.hasPermission('heritage:booking:query')")
    public CommonResult<PageResult<?>> bookingPage(@RequestParam(defaultValue = "1") Integer pageNo,
                                                    @RequestParam(defaultValue = "10") Integer pageSize) {
        long offset = (long) (pageNo - 1) * pageSize;
        return success(new PageResult<>(bookingMapper.selectList(null), (long) bookingMapper.selectList(null).size()));
    }

    @PutMapping("/booking/{id}/status")
    @PreAuthorize("@ss.hasPermission('heritage:booking:update')")
    public CommonResult<Boolean> updateBookingStatus(@PathVariable Long id, @RequestParam Integer status) {
        heritageService.updateBookingStatus(id, status);
        return success(true);
    }

    @GetMapping("/cooperation/page")
    @PreAuthorize("@ss.hasPermission('heritage:cooperation:query')")
    public CommonResult<PageResult<?>> cooperationPage(@RequestParam(defaultValue = "1") Integer pageNo,
                                                        @RequestParam(defaultValue = "10") Integer pageSize) {
        long offset = (long) (pageNo - 1) * pageSize;
        return success(new PageResult<>(cooperationMapper.selectList(null), (long) cooperationMapper.selectList(null).size()));
    }

    @PutMapping("/cooperation/{id}/status")
    @PreAuthorize("@ss.hasPermission('heritage:cooperation:update')")
    public CommonResult<Boolean> updateCooperationStatus(@PathVariable Long id, @RequestParam Integer status) {
        heritageService.updateCooperationStatus(id, status);
        return success(true);
    }
}
