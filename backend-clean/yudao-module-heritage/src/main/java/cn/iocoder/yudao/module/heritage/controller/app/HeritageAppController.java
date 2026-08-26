package cn.iocoder.yudao.module.heritage.controller.app;

import cn.iocoder.yudao.framework.common.pojo.CommonResult;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.module.heritage.controller.app.vo.*;
import cn.iocoder.yudao.module.heritage.service.HeritageEcosystemService;
import jakarta.annotation.Resource;
import jakarta.annotation.security.PermitAll;
import jakarta.validation.Valid;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.util.List;

import static cn.iocoder.yudao.framework.common.pojo.CommonResult.success;

@RestController
@RequestMapping("/heritage")
@Validated
public class HeritageAppController {
    @Resource
    private HeritageEcosystemService service;

    @GetMapping("/product-system/list")
    @PermitAll
    public CommonResult<List<ProductSystemRespVO>> listSystems() { return success(service.listSystems()); }

    @GetMapping("/product-system/item-page")
    @PermitAll
    public CommonResult<PageResult<ProductSystemItemRespVO>> itemPage(@RequestParam String code,
                                                                       @RequestParam(defaultValue = "1") Integer pageNo,
                                                                       @RequestParam(defaultValue = "10") Integer pageSize,
                                                                       @RequestParam(required = false) String keyword) {
        return success(service.itemPage(code, pageNo, pageSize, keyword));
    }

    @GetMapping("/service/get")
    @PermitAll
    public CommonResult<ServiceRespVO> getService(@RequestParam Long id) { return success(service.getService(id)); }

    @GetMapping("/service/schedule-list")
    @PermitAll
    public CommonResult<List<ServiceScheduleRespVO>> schedules(@RequestParam Long serviceId) { return success(service.schedules(serviceId)); }

    @PostMapping("/service-booking/create")
    public CommonResult<Long> createBooking(@RequestBody @Valid ServiceBookingCreateReqVO req) { return success(service.createBooking(req)); }

    @GetMapping("/service-booking/my-page")
    public CommonResult<PageResult<ServiceBookingRespVO>> myBookings(@RequestParam(defaultValue = "1") Integer pageNo,
                                                                      @RequestParam(defaultValue = "10") Integer pageSize) {
        return success(service.myBookings(pageNo, pageSize));
    }

    @PutMapping("/service-booking/cancel")
    public CommonResult<Boolean> cancelBooking(@RequestParam Long id) { service.cancelBooking(id); return success(true); }

    @GetMapping("/cooperation/type-list")
    @PermitAll
    public CommonResult<List<CooperationTypeRespVO>> cooperationTypes() { return success(service.cooperationTypes()); }

    @PostMapping("/cooperation/application/create")
    public CommonResult<Long> createCooperation(@RequestBody @Valid CooperationCreateReqVO req) { return success(service.createCooperation(req)); }

    @GetMapping("/cooperation/application/my-page")
    public CommonResult<PageResult<CooperationRespVO>> myCooperations(@RequestParam(defaultValue = "1") Integer pageNo,
                                                                        @RequestParam(defaultValue = "10") Integer pageSize) {
        return success(service.myCooperations(pageNo, pageSize));
    }
}
