package cn.iocoder.yudao.module.heritage.service;

import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.common.util.object.BeanUtils;
import cn.iocoder.yudao.module.heritage.controller.app.vo.*;
import cn.iocoder.yudao.module.heritage.dal.dataobject.*;
import cn.iocoder.yudao.module.heritage.dal.mysql.*;
import cn.iocoder.yudao.module.heritage.enums.*;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.List;
import java.util.Objects;

import static cn.iocoder.yudao.framework.common.exception.util.ServiceExceptionUtil.exception;
import static cn.iocoder.yudao.framework.security.core.util.SecurityFrameworkUtils.getLoginUserId;

@Service
public class HeritageEcosystemService {
    private final ProductSystemMapper systemMapper;
    private final ProductSystemSpuMapper relationMapper;
    private final HeritageServiceMapper serviceMapper;
    private final ServiceScheduleMapper scheduleMapper;
    private final ServiceBookingMapper bookingMapper;
    private final CooperationApplicationMapper cooperationMapper;

    public HeritageEcosystemService(ProductSystemMapper systemMapper, ProductSystemSpuMapper relationMapper,
                                    HeritageServiceMapper serviceMapper, ServiceScheduleMapper scheduleMapper,
                                    ServiceBookingMapper bookingMapper, CooperationApplicationMapper cooperationMapper) {
        this.systemMapper = systemMapper;
        this.relationMapper = relationMapper;
        this.serviceMapper = serviceMapper;
        this.scheduleMapper = scheduleMapper;
        this.bookingMapper = bookingMapper;
        this.cooperationMapper = cooperationMapper;
    }

    public List<ProductSystemRespVO> listSystems() {
        return systemMapper.selectEnabled().stream()
                .map(item -> BeanUtils.toBean(item, ProductSystemRespVO.class)).toList();
    }

    public PageResult<ProductSystemItemRespVO> itemPage(String code, int pageNo, int pageSize, String keyword) {
        ProductSystemDO system = systemMapper.selectByCode(code);
        if (system == null || system.getStatus() != 1) {
            throw exception(ErrorCodeConstants.PRODUCT_SYSTEM_NOT_EXISTS);
        }
        if (!ProductSystemCodeEnum.isProduct(code) && !ProductSystemCodeEnum.isService(code)) {
            throw exception(ErrorCodeConstants.PRODUCT_SYSTEM_TYPE_NOT_SUPPORTED);
        }
        long offset = (long) (pageNo - 1) * pageSize;
        long total;
        List<ProductItemRow> rows;
        if (ProductSystemCodeEnum.isProduct(code)) {
            boolean filtered = keyword != null && !keyword.isBlank();
            total = filtered ? relationMapper.countVisibleKeyword(system.getId(), keyword)
                    : relationMapper.countVisible(system.getId());
            rows = filtered ? relationMapper.selectVisibleKeyword(system.getId(), keyword, offset, pageSize)
                    : relationMapper.selectVisible(system.getId(), offset, pageSize);
        } else {
            total = serviceMapper.countPublic(code);
            rows = serviceMapper.selectPublic(code, keyword, offset, pageSize).stream().map(item -> {
                ProductItemRow row = new ProductItemRow();
                row.setTargetId(item.getId());
                row.setTitle(item.getTitle());
                row.setSummary(item.getSummary());
                row.setCoverUrl(item.getCoverUrl());
                row.setPrice(item.getPrice());
                return row;
            }).toList();
        }
        List<ProductSystemItemRespVO> list = rows.stream().map(row -> {
            ProductSystemItemRespVO vo = new ProductSystemItemRespVO();
            vo.setTargetType(ProductSystemCodeEnum.isProduct(code) ? "PRODUCT" : "SERVICE");
            vo.setTargetId(row.getTargetId());
            vo.setSystemCode(code);
            vo.setTitle(row.getTitle());
            vo.setSummary(row.getSummary());
            vo.setCoverUrl(row.getCoverUrl());
            vo.setPrice(row.getPrice());
            if (!ProductSystemCodeEnum.isProduct(code)) {
                HeritageServiceDO service = serviceMapper.selectPublicById(row.getTargetId());
                vo.setBookingEnabled(service != null && Boolean.TRUE.equals(service.getBookingEnabled()));
                vo.setLocation(service == null ? null : service.getLocation());
            }
            return vo;
        }).toList();
        return new PageResult<>(list, total);
    }

    public ServiceRespVO getService(Long id) {
        HeritageServiceDO service = serviceMapper.selectPublicById(id);
        if (service == null) {
            throw exception(ErrorCodeConstants.SERVICE_NOT_PUBLIC);
        }
        ProductSystemDO system = systemMapper.selectById(service.getProductSystemId());
        ServiceRespVO vo = BeanUtils.toBean(service, ServiceRespVO.class);
        if (system != null) {
            vo.setSystemCode(system.getCode());
            vo.setSystemName(system.getName());
        }
        return vo;
    }

    public List<ServiceScheduleRespVO> schedules(Long serviceId) {
        getService(serviceId);
        return scheduleMapper.selectPublic(serviceId).stream().map(this::scheduleVO).toList();
    }

    private ServiceScheduleRespVO scheduleVO(ServiceScheduleDO schedule) {
        ServiceScheduleRespVO vo = BeanUtils.toBean(schedule, ServiceScheduleRespVO.class);
        if (schedule.getCapacity() == 0) {
            vo.setRemaining(null);
            vo.setAvailable(true);
        } else {
            int remaining = Math.max(0, schedule.getCapacity() - schedule.getBookedCount());
            vo.setRemaining(remaining);
            vo.setAvailable(remaining > 0);
        }
        return vo;
    }

    @Transactional
    public Long createBooking(ServiceBookingCreateReqVO req) {
        Long userId = login();
        HeritageServiceDO service = serviceMapper.selectPublicById(req.getServiceId());
        if (service == null || !Boolean.TRUE.equals(service.getBookingEnabled())) {
            throw exception(ErrorCodeConstants.SERVICE_NOT_PUBLIC);
        }
        // Lock the schedule before duplicate/capacity checks. This serializes requests for one schedule.
        ServiceScheduleDO schedule = scheduleMapper.selectOneForUpdate(req.getScheduleId());
        if (schedule == null || !Objects.equals(schedule.getServiceId(), req.getServiceId())
                || schedule.getStatus() != 1 || schedule.getEndTime().isBefore(LocalDateTime.now())) {
            throw exception(ErrorCodeConstants.SCHEDULE_NOT_AVAILABLE);
        }
        if (bookingMapper.selectActive(userId, req.getScheduleId()) != null) {
            throw exception(ErrorCodeConstants.BOOKING_DUPLICATE);
        }
        if (scheduleMapper.increaseIfAvailable(req.getScheduleId(), req.getPeopleCount()) != 1) {
            throw exception(ErrorCodeConstants.BOOKING_CAPACITY_NOT_ENOUGH);
        }
        ServiceBookingDO booking = BeanUtils.toBean(req, ServiceBookingDO.class);
        booking.setUserId(userId);
        booking.setStatus(ServiceBookingStatusEnum.PENDING.value);
        bookingMapper.insert(booking);
        return booking.getId();
    }

    public PageResult<ServiceBookingRespVO> myBookings(int pageNo, int pageSize) {
        Long userId = login();
        long total = bookingMapper.countMy(userId);
        return new PageResult<>(bookingMapper.selectMy(userId, (long) (pageNo - 1) * pageSize, pageSize)
                .stream().map(this::bookingVO).toList(), total);
    }

    private ServiceBookingRespVO bookingVO(BookingRow row) {
        ServiceBookingRespVO vo = BeanUtils.toBean(row, ServiceBookingRespVO.class);
        vo.setStatusName(Arrays.stream(ServiceBookingStatusEnum.values())
                .filter(item -> item.value == row.getStatus()).map(item -> item.name).findFirst().orElse("未知"));
        return vo;
    }

    @Transactional
    public void cancelBooking(Long id) {
        Long userId = login();
        ServiceBookingDO booking = bookingMapper.selectForUpdate(id);
        if (booking == null || !Objects.equals(booking.getUserId(), userId)) {
            throw exception(ErrorCodeConstants.BOOKING_NOT_EXISTS);
        }
        if (booking.getStatus() != ServiceBookingStatusEnum.PENDING.value
                && booking.getStatus() != ServiceBookingStatusEnum.CONFIRMED.value) {
            throw exception(ErrorCodeConstants.BOOKING_NOT_ALLOWED);
        }
        if (bookingMapper.cancel(id, userId, ServiceBookingStatusEnum.CANCELLED.value, String.valueOf(userId)) != 1) {
            throw exception(ErrorCodeConstants.BOOKING_NOT_ALLOWED);
        }
        if (scheduleMapper.decreaseIfAvailable(booking.getScheduleId(), booking.getPeopleCount(), String.valueOf(userId)) != 1) {
            throw exception(ErrorCodeConstants.BOOKING_NOT_ALLOWED);
        }
    }

    @Transactional
    public void updateBookingStatus(Long id, Integer targetStatus) {
        Long operatorId = login();
        ServiceBookingDO booking = bookingMapper.selectForUpdate(id);
        if (booking == null) {
            throw exception(ErrorCodeConstants.BOOKING_NOT_EXISTS);
        }
        int current = booking.getStatus();
        if (targetStatus == ServiceBookingStatusEnum.CONFIRMED.value
                && current == ServiceBookingStatusEnum.PENDING.value) {
            updateBookingStatusOrThrow(id, current, targetStatus, operatorId);
            return;
        }
        if (targetStatus == ServiceBookingStatusEnum.COMPLETED.value
                && current == ServiceBookingStatusEnum.CONFIRMED.value) {
            updateBookingStatusOrThrow(id, current, targetStatus, operatorId);
            return;
        }
        if (targetStatus == ServiceBookingStatusEnum.REJECTED.value
                && current == ServiceBookingStatusEnum.PENDING.value) {
            if (scheduleMapper.decreaseIfAvailable(booking.getScheduleId(), booking.getPeopleCount(), String.valueOf(operatorId)) != 1) {
                throw exception(ErrorCodeConstants.BOOKING_NOT_ALLOWED);
            }
            updateBookingStatusOrThrow(id, current, targetStatus, operatorId);
            return;
        }
        throw exception(ErrorCodeConstants.BOOKING_NOT_ALLOWED);
    }

    private void updateBookingStatusOrThrow(Long id, int current, int target, Long operatorId) {
        if (bookingMapper.updateStatus(id, current, target, String.valueOf(operatorId)) != 1) {
            throw exception(ErrorCodeConstants.BOOKING_NOT_ALLOWED);
        }
    }

    public List<CooperationTypeRespVO> cooperationTypes() {
        return Arrays.stream(CooperationTypeEnum.values())
                .map(item -> new CooperationTypeRespVO(item.name(), item.name)).toList();
    }

    @Transactional
    public Long createCooperation(CooperationCreateReqVO req) {
        Long userId = login();
        try {
            CooperationTypeEnum.valueOf(req.getCooperationType());
        } catch (Exception ignored) {
            throw exception(ErrorCodeConstants.COOPERATION_TYPE_NOT_SUPPORTED);
        }
        CooperationApplicationDO application = BeanUtils.toBean(req, CooperationApplicationDO.class);
        application.setUserId(userId);
        application.setStatus(CooperationStatusEnum.PENDING.value);
        cooperationMapper.insert(application);
        return application.getId();
    }

    public PageResult<CooperationRespVO> myCooperations(int pageNo, int pageSize) {
        Long userId = login();
        long total = cooperationMapper.countMy(userId);
        return new PageResult<>(cooperationMapper.selectMy(userId, (long) (pageNo - 1) * pageSize, pageSize)
                .stream().map(this::cooperationVO).toList(), total);
    }

    @Transactional
    public void updateCooperationStatus(Long id, Integer targetStatus) {
        Long operatorId = login();
        CooperationApplicationDO application = cooperationMapper.selectById(id);
        if (application == null || targetStatus == null
                || targetStatus == CooperationStatusEnum.PENDING.value
                || Arrays.stream(CooperationStatusEnum.values()).noneMatch(item -> item.value == targetStatus)) {
            throw exception(ErrorCodeConstants.COOPERATION_NOT_ALLOWED);
        }
        if (cooperationMapper.updateStatus(id, targetStatus, operatorId, String.valueOf(operatorId)) != 1) {
            throw exception(ErrorCodeConstants.COOPERATION_NOT_ALLOWED);
        }
    }
    private CooperationRespVO cooperationVO(CooperationRow row) {
        CooperationRespVO vo = BeanUtils.toBean(row, CooperationRespVO.class);
        try {
            vo.setCooperationTypeName(CooperationTypeEnum.valueOf(row.getCooperationType()).name);
        } catch (Exception ignored) {
            // Keep the code when old data contains an unknown type.
        }
        vo.setStatusName(Arrays.stream(CooperationStatusEnum.values())
                .filter(item -> item.value == row.getStatus()).map(item -> item.name).findFirst().orElse("未知"));
        return vo;
    }

    private Long login() {
        Long id = getLoginUserId();
        if (id == null) {
            throw exception(ErrorCodeConstants.LOGIN_REQUIRED);
        }
        return id;
    }
}
