package cn.iocoder.yudao.module.heritage.controller.admin;

import cn.iocoder.yudao.framework.common.pojo.CommonResult;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.module.heritage.controller.admin.vo.*;
import cn.iocoder.yudao.module.heritage.dal.dataobject.*;
import cn.iocoder.yudao.module.heritage.dal.mysql.*;
import cn.iocoder.yudao.module.heritage.service.HeritageEcosystemService;
import jakarta.annotation.Resource;
import jakarta.validation.Valid;
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

    @GetMapping("/product-system/list")
    @PreAuthorize("@ss.hasPermission('heritage:product-system:query')")
    public CommonResult<List<ProductSystemDO>> productSystemList() {
        return success(productSystemMapper.selectEnabled());
    }

    @GetMapping("/service/page")
    @PreAuthorize("@ss.hasPermission('heritage:service:query')")
    public CommonResult<List<HeritageServiceDO>> servicePage() {
        return success(serviceMapper.selectList(null));
    }

    @PutMapping("/service/status")
    @PreAuthorize("@ss.hasPermission('heritage:service:update')")
    public CommonResult<Boolean> updateServiceStatus(@RequestParam Long id, @RequestParam Integer status) {
        heritageService.updateServiceStatus(id, status);
        return success(true);
    }

    @DeleteMapping("/service/delete")
    @PreAuthorize("@ss.hasPermission('heritage:service:delete')")
    public CommonResult<Boolean> deleteService(@RequestParam Long id) {
        heritageService.deleteService(id);
        return success(true);
    }

    @GetMapping("/schedule/page")
    @PreAuthorize("@ss.hasPermission('heritage:schedule:query')")
    public CommonResult<List<ServiceScheduleDO>> schedulePage(@RequestParam Long serviceId) {
        return success(heritageService.adminSchedules(serviceId));
    }

    @GetMapping("/service-schedule/list")
    @PreAuthorize("@ss.hasPermission('heritage:schedule:query')")
    public CommonResult<List<ServiceScheduleDO>> scheduleList(@RequestParam Long serviceId) {
        return success(heritageService.adminSchedules(serviceId));
    }

    @PostMapping("/service-schedule/create")
    @PreAuthorize("@ss.hasPermission('heritage:schedule:create')")
    public CommonResult<Long> createSchedule(@RequestBody @Valid ServiceScheduleCreateReqVO req) {
        return success(heritageService.createSchedule(req));
    }

    @PutMapping("/service-schedule/update")
    @PreAuthorize("@ss.hasPermission('heritage:schedule:update')")
    public CommonResult<Boolean> updateSchedule(@RequestBody @Valid ServiceScheduleUpdateReqVO req) {
        heritageService.updateSchedule(req);
        return success(true);
    }

    @DeleteMapping("/service-schedule/delete")
    @PreAuthorize("@ss.hasPermission('heritage:schedule:delete')")
    public CommonResult<Boolean> deleteSchedule(@RequestParam Long id) {
        heritageService.deleteSchedule(id);
        return success(true);
    }

    @GetMapping("/booking/page")
    @PreAuthorize("@ss.hasPermission('heritage:booking:query')")
    public CommonResult<PageResult<?>> bookingPage(@RequestParam(defaultValue = "1") Integer pageNo,
                                                    @RequestParam(defaultValue = "10") Integer pageSize) {
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
        return success(new PageResult<>(cooperationMapper.selectList(null), (long) cooperationMapper.selectList(null).size()));
    }

    @PutMapping("/cooperation/{id}/status")
    @PreAuthorize("@ss.hasPermission('heritage:cooperation:update')")
    public CommonResult<Boolean> updateCooperationStatus(@PathVariable Long id, @RequestParam Integer status) {
        heritageService.updateCooperationStatus(id, status);
        return success(true);
    }

    @GetMapping("/product-system-spu/page")
    @PreAuthorize("@ss.hasPermission('heritage:product-system-spu:query')")
    public CommonResult<PageResult<ProductSystemSpuRespVO>> relationPage(@Valid ProductSystemSpuPageReqVO req) {
        return success(heritageService.relationPage(req));
    }

    @PostMapping("/product-system-spu/create")
    @PreAuthorize("@ss.hasPermission('heritage:product-system-spu:create')")
    public CommonResult<Long> createRelation(@RequestBody @Valid ProductSystemSpuCreateReqVO req) {
        return success(heritageService.createRelation(req));
    }

    @PutMapping("/product-system-spu/update")
    @PreAuthorize("@ss.hasPermission('heritage:product-system-spu:update')")
    public CommonResult<Boolean> updateRelation(@RequestBody @Valid ProductSystemSpuUpdateReqVO req) {
        heritageService.updateRelation(req);
        return success(true);
    }

    @DeleteMapping("/product-system-spu/delete")
    @PreAuthorize("@ss.hasPermission('heritage:product-system-spu:delete')")
    public CommonResult<Boolean> deleteRelation(@RequestParam Long id) {
        heritageService.deleteRelation(id);
        return success(true);
    }
}