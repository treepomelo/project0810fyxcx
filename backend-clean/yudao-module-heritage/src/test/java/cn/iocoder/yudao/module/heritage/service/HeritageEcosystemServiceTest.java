package cn.iocoder.yudao.module.heritage.service;

import cn.iocoder.yudao.framework.security.core.util.SecurityFrameworkUtils;
import cn.iocoder.yudao.framework.common.exception.ServiceException;
import cn.iocoder.yudao.module.heritage.enums.CooperationStatusEnum;
import cn.iocoder.yudao.module.heritage.enums.ErrorCodeConstants;
import cn.iocoder.yudao.module.heritage.controller.app.vo.ServiceBookingCreateReqVO;
import cn.iocoder.yudao.module.heritage.controller.app.vo.CooperationCreateReqVO;
import cn.iocoder.yudao.module.heritage.controller.admin.vo.ServiceScheduleUpdateReqVO;
import cn.iocoder.yudao.module.heritage.dal.dataobject.HeritageServiceDO;
import cn.iocoder.yudao.module.heritage.dal.dataobject.CooperationApplicationDO;
import cn.iocoder.yudao.module.heritage.dal.dataobject.ServiceBookingDO;
import cn.iocoder.yudao.module.heritage.dal.dataobject.ServiceScheduleDO;
import cn.iocoder.yudao.module.heritage.dal.mysql.*;
import cn.iocoder.yudao.module.heritage.enums.ServiceBookingStatusEnum;
import org.junit.jupiter.api.Test;
import org.mockito.MockedStatic;

import java.time.LocalDateTime;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

class HeritageEcosystemServiceTest {
    private final ProductSystemMapper systemMapper = mock(ProductSystemMapper.class);
    private final ProductSystemSpuMapper relationMapper = mock(ProductSystemSpuMapper.class);
    private final HeritageServiceMapper serviceMapper = mock(HeritageServiceMapper.class);
    private final ServiceScheduleMapper scheduleMapper = mock(ServiceScheduleMapper.class);
    private final ServiceBookingMapper bookingMapper = mock(ServiceBookingMapper.class);
    private final CooperationApplicationMapper cooperationMapper = mock(CooperationApplicationMapper.class);
    private final HeritageEcosystemService service = new HeritageEcosystemService(
            systemMapper, relationMapper, serviceMapper, scheduleMapper, bookingMapper, cooperationMapper);

    @Test
    void createBookingLocksScheduleAndWritesPendingBooking() {
        ServiceBookingCreateReqVO req = request(1L, 10L, 1);
        HeritageServiceDO heritageService = new HeritageServiceDO();
        heritageService.setId(1L);
        heritageService.setBookingEnabled(true);
        ServiceScheduleDO schedule = schedule(10L, 1L, 2, 0);
        when(serviceMapper.selectPublicById(1L)).thenReturn(heritageService);
        when(scheduleMapper.selectOneForUpdate(10L)).thenReturn(schedule);
        when(bookingMapper.selectActive(11L, 10L)).thenReturn(null);
        when(scheduleMapper.increaseIfAvailable(10L, 1)).thenReturn(1);
        doAnswer(invocation -> { invocation.<ServiceBookingDO>getArgument(0).setId(99L); return 1; })
                .when(bookingMapper).insert(any(ServiceBookingDO.class));

        try (MockedStatic<SecurityFrameworkUtils> login = mockStatic(SecurityFrameworkUtils.class)) {
            login.when(SecurityFrameworkUtils::getLoginUserId).thenReturn(11L);
            assertEquals(99L, service.createBooking(req));
        }
        verify(scheduleMapper).selectOneForUpdate(10L);
        verify(scheduleMapper).increaseIfAvailable(10L, 1);
        verify(bookingMapper).insert(argThat((ServiceBookingDO item) -> item.getUserId().equals(11L)
                && item.getStatus().equals(ServiceBookingStatusEnum.PENDING.value)));
    }

    @Test
    void duplicateBookingIsRejectedAfterLockedDuplicateCheck() {
        ServiceBookingCreateReqVO req = request(1L, 10L, 1);
        HeritageServiceDO heritageService = new HeritageServiceDO();
        heritageService.setBookingEnabled(true);
        when(serviceMapper.selectPublicById(1L)).thenReturn(heritageService);
        when(scheduleMapper.selectOneForUpdate(10L)).thenReturn(schedule(10L, 1L, 2, 0));
        when(bookingMapper.selectActive(11L, 10L)).thenReturn(new ServiceBookingDO());

        try (MockedStatic<SecurityFrameworkUtils> login = mockStatic(SecurityFrameworkUtils.class)) {
            login.when(SecurityFrameworkUtils::getLoginUserId).thenReturn(11L);
            assertThrows(RuntimeException.class, () -> service.createBooking(req));
        }
        verify(scheduleMapper, never()).increaseIfAvailable(anyLong(), anyInt());
        verify(bookingMapper, never()).insert(any(ServiceBookingDO.class));
    }

    @Test
    void cancelAndRejectReleaseCapacityOnlyOnce() {
        ServiceBookingDO booking = new ServiceBookingDO();
        booking.setId(99L); booking.setUserId(11L); booking.setScheduleId(10L);
        booking.setPeopleCount(1); booking.setStatus(ServiceBookingStatusEnum.PENDING.value);
        when(bookingMapper.selectForUpdate(99L)).thenReturn(booking);
        when(bookingMapper.cancel(99L, 11L, ServiceBookingStatusEnum.CANCELLED.value, "11")).thenReturn(1);
        when(scheduleMapper.decreaseIfAvailable(10L, 1, "11")).thenReturn(1);
        try (MockedStatic<SecurityFrameworkUtils> login = mockStatic(SecurityFrameworkUtils.class)) {
            login.when(SecurityFrameworkUtils::getLoginUserId).thenReturn(11L);
            service.cancelBooking(99L);
        }
        verify(scheduleMapper).decreaseIfAvailable(10L, 1, "11");

        ServiceBookingDO pending = new ServiceBookingDO();
        pending.setId(100L); pending.setUserId(11L); pending.setScheduleId(10L);
        pending.setPeopleCount(1); pending.setStatus(ServiceBookingStatusEnum.PENDING.value);
        when(bookingMapper.selectForUpdate(100L)).thenReturn(pending);
        when(scheduleMapper.decreaseIfAvailable(10L, 1, "11")).thenReturn(1);
        when(bookingMapper.updateStatus(100L, ServiceBookingStatusEnum.PENDING.value,
                ServiceBookingStatusEnum.REJECTED.value, "11")).thenReturn(1);
        try (MockedStatic<SecurityFrameworkUtils> login = mockStatic(SecurityFrameworkUtils.class)) {
            login.when(SecurityFrameworkUtils::getLoginUserId).thenReturn(11L);
            service.updateBookingStatus(100L, ServiceBookingStatusEnum.REJECTED.value);
        }
        verify(bookingMapper).updateStatus(100L, ServiceBookingStatusEnum.PENDING.value,
                ServiceBookingStatusEnum.REJECTED.value, "11");
    }

    @Test
    void confirmKeepsCapacityUnchanged() {
        ServiceBookingDO booking = booking(101L, 11L, ServiceBookingStatusEnum.PENDING.value);
        when(bookingMapper.selectForUpdate(101L)).thenReturn(booking);
        when(bookingMapper.updateStatus(101L, ServiceBookingStatusEnum.PENDING.value, ServiceBookingStatusEnum.CONFIRMED.value, "11")).thenReturn(1);
        try (MockedStatic<SecurityFrameworkUtils> login = mockStatic(SecurityFrameworkUtils.class)) {
            login.when(SecurityFrameworkUtils::getLoginUserId).thenReturn(11L);
            service.updateBookingStatus(101L, ServiceBookingStatusEnum.CONFIRMED.value);
        }
        verify(scheduleMapper, never()).decreaseIfAvailable(anyLong(), anyInt(), anyString());
        verify(bookingMapper).updateStatus(101L, 0, 1, "11");
    }

    @Test
    void completeKeepsCapacityUnchanged() {
        ServiceBookingDO booking = booking(102L, 11L, ServiceBookingStatusEnum.CONFIRMED.value);
        when(bookingMapper.selectForUpdate(102L)).thenReturn(booking);
        when(bookingMapper.updateStatus(102L, ServiceBookingStatusEnum.CONFIRMED.value, ServiceBookingStatusEnum.COMPLETED.value, "11")).thenReturn(1);
        try (MockedStatic<SecurityFrameworkUtils> login = mockStatic(SecurityFrameworkUtils.class)) {
            login.when(SecurityFrameworkUtils::getLoginUserId).thenReturn(11L);
            service.updateBookingStatus(102L, ServiceBookingStatusEnum.COMPLETED.value);
        }
        verify(scheduleMapper, never()).decreaseIfAvailable(anyLong(), anyInt(), anyString());
        verify(bookingMapper).updateStatus(102L, 1, 4, "11");
    }

    @Test
    void doubleCancelIsBlockedAndReleasesOnce() {
        ServiceBookingDO booking = booking(103L, 11L, ServiceBookingStatusEnum.PENDING.value);
        when(bookingMapper.selectForUpdate(103L)).thenReturn(booking);
        when(bookingMapper.cancel(103L, 11L, ServiceBookingStatusEnum.CANCELLED.value, "11"))
                .thenAnswer(invocation -> { booking.setStatus(ServiceBookingStatusEnum.CANCELLED.value); return 1; });
        when(scheduleMapper.decreaseIfAvailable(10L, 1, "11")).thenReturn(1);
        try (MockedStatic<SecurityFrameworkUtils> login = mockStatic(SecurityFrameworkUtils.class)) {
            login.when(SecurityFrameworkUtils::getLoginUserId).thenReturn(11L);
            service.cancelBooking(103L);
            assertThrows(RuntimeException.class, () -> service.cancelBooking(103L));
        }
        verify(scheduleMapper, times(1)).decreaseIfAvailable(10L, 1, "11");
    }

    @Test
    void wrongUserCannotCancelBooking() {
        ServiceBookingDO booking = booking(104L, 12L, ServiceBookingStatusEnum.PENDING.value);
        when(bookingMapper.selectForUpdate(104L)).thenReturn(booking);
        try (MockedStatic<SecurityFrameworkUtils> login = mockStatic(SecurityFrameworkUtils.class)) {
            login.when(SecurityFrameworkUtils::getLoginUserId).thenReturn(11L);
            assertThrows(RuntimeException.class, () -> service.cancelBooking(104L));
        }
        verify(bookingMapper, never()).cancel(anyLong(), anyLong(), anyInt(), anyString());
        verify(scheduleMapper, never()).decreaseIfAvailable(anyLong(), anyInt(), anyString());
    }

    @Test
    void cooperationCreateStartsPending() {
        CooperationCreateReqVO req = new CooperationCreateReqVO();
        req.setCompanyName("E2E"); req.setContactName("A"); req.setContactPhone("19900000001");
        req.setCooperationType("CULTURAL_TOURISM"); req.setRequirement("need");
        doAnswer(invocation -> { invocation.<cn.iocoder.yudao.module.heritage.dal.dataobject.CooperationApplicationDO>getArgument(0).setId(201L); return 1; })
                .when(cooperationMapper).insert(any(cn.iocoder.yudao.module.heritage.dal.dataobject.CooperationApplicationDO.class));
        try (MockedStatic<SecurityFrameworkUtils> login = mockStatic(SecurityFrameworkUtils.class)) {
            login.when(SecurityFrameworkUtils::getLoginUserId).thenReturn(11L);
            assertEquals(201L, service.createCooperation(req));
        }
        verify(cooperationMapper).insert(argThat((cn.iocoder.yudao.module.heritage.dal.dataobject.CooperationApplicationDO item) ->
                item.getUserId().equals(11L) && item.getStatus().equals(0)));
    }

    @Test
    void invalidCooperationTypeIsRejected() {
        CooperationCreateReqVO req = new CooperationCreateReqVO();
        req.setCompanyName("E2E"); req.setContactName("A"); req.setContactPhone("19900000001");
        req.setCooperationType("INVALID"); req.setRequirement("need");
        try (MockedStatic<SecurityFrameworkUtils> login = mockStatic(SecurityFrameworkUtils.class)) {
            login.when(SecurityFrameworkUtils::getLoginUserId).thenReturn(11L);
            assertThrows(RuntimeException.class, () -> service.createCooperation(req));
        }
        verify(cooperationMapper, never()).insert(any(cn.iocoder.yudao.module.heritage.dal.dataobject.CooperationApplicationDO.class));
    }

    @Test
    void pendingCompleteIsRejectedWithBusinessCodeAndUnchangedStatus() {
        ServiceBookingDO booking = booking(105L, 11L, ServiceBookingStatusEnum.PENDING.value);
        when(bookingMapper.selectForUpdate(105L)).thenReturn(booking);
        try (MockedStatic<SecurityFrameworkUtils> login = mockStatic(SecurityFrameworkUtils.class)) {
            login.when(SecurityFrameworkUtils::getLoginUserId).thenReturn(11L);
            ServiceException error = assertThrows(ServiceException.class,
                    () -> service.updateBookingStatus(105L, ServiceBookingStatusEnum.COMPLETED.value));
            assertEquals(ErrorCodeConstants.BOOKING_NOT_ALLOWED.getCode(), error.getCode());
        }
        assertEquals(ServiceBookingStatusEnum.PENDING.value, booking.getStatus());
        verify(bookingMapper, never()).updateStatus(anyLong(), anyInt(), anyInt(), anyString());
        verify(scheduleMapper, never()).decreaseIfAvailable(anyLong(), anyInt(), anyString());
    }

    @Test
    void completedCancelIsRejectedAndStatusRemainsCompleted() {
        ServiceBookingDO booking = booking(106L, 11L, ServiceBookingStatusEnum.COMPLETED.value);
        when(bookingMapper.selectForUpdate(106L)).thenReturn(booking);
        try (MockedStatic<SecurityFrameworkUtils> login = mockStatic(SecurityFrameworkUtils.class)) {
            login.when(SecurityFrameworkUtils::getLoginUserId).thenReturn(11L);
            ServiceException error = assertThrows(ServiceException.class, () -> service.cancelBooking(106L));
            assertEquals(ErrorCodeConstants.BOOKING_NOT_ALLOWED.getCode(), error.getCode());
        }
        assertEquals(ServiceBookingStatusEnum.COMPLETED.value, booking.getStatus());
        verify(scheduleMapper, never()).decreaseIfAvailable(anyLong(), anyInt(), anyString());
    }

    @Test
    void rejectedConfirmIsRejectedAndStatusRemainsRejected() {
        ServiceBookingDO booking = booking(107L, 11L, ServiceBookingStatusEnum.REJECTED.value);
        when(bookingMapper.selectForUpdate(107L)).thenReturn(booking);
        try (MockedStatic<SecurityFrameworkUtils> login = mockStatic(SecurityFrameworkUtils.class)) {
            login.when(SecurityFrameworkUtils::getLoginUserId).thenReturn(11L);
            ServiceException error = assertThrows(ServiceException.class,
                    () -> service.updateBookingStatus(107L, ServiceBookingStatusEnum.CONFIRMED.value));
            assertEquals(ErrorCodeConstants.BOOKING_NOT_ALLOWED.getCode(), error.getCode());
        }
        assertEquals(ServiceBookingStatusEnum.REJECTED.value, booking.getStatus());
    }

    @Test
    void cancelledConfirmIsRejectedAndStatusRemainsCancelled() {
        ServiceBookingDO booking = booking(108L, 11L, ServiceBookingStatusEnum.CANCELLED.value);
        when(bookingMapper.selectForUpdate(108L)).thenReturn(booking);
        try (MockedStatic<SecurityFrameworkUtils> login = mockStatic(SecurityFrameworkUtils.class)) {
            login.when(SecurityFrameworkUtils::getLoginUserId).thenReturn(11L);
            ServiceException error = assertThrows(ServiceException.class,
                    () -> service.updateBookingStatus(108L, ServiceBookingStatusEnum.CONFIRMED.value));
            assertEquals(ErrorCodeConstants.BOOKING_NOT_ALLOWED.getCode(), error.getCode());
        }
        assertEquals(ServiceBookingStatusEnum.CANCELLED.value, booking.getStatus());
    }

    @Test
    void cooperationPendingToCommunicatingSucceeds() {
        CooperationApplicationDO application = new CooperationApplicationDO();
        application.setId(301L); application.setStatus(CooperationStatusEnum.PENDING.value);
        when(cooperationMapper.selectForUpdate(301L)).thenReturn(application);
        when(cooperationMapper.updateStatus(301L, CooperationStatusEnum.COMMUNICATING.value, 11L, "11")).thenAnswer(invocation -> {
            application.setStatus(CooperationStatusEnum.COMMUNICATING.value); return 1;
        });
        try (MockedStatic<SecurityFrameworkUtils> login = mockStatic(SecurityFrameworkUtils.class)) {
            login.when(SecurityFrameworkUtils::getLoginUserId).thenReturn(11L);
            service.updateCooperationStatus(301L, CooperationStatusEnum.COMMUNICATING.value);
        }
        assertEquals(CooperationStatusEnum.COMMUNICATING.value, application.getStatus());
    }

    @Test
    void cooperationAchievedIsTerminal() {
        CooperationApplicationDO application = new CooperationApplicationDO();
        application.setId(302L); application.setStatus(CooperationStatusEnum.REACHED.value);
        when(cooperationMapper.selectForUpdate(302L)).thenReturn(application);
        try (MockedStatic<SecurityFrameworkUtils> login = mockStatic(SecurityFrameworkUtils.class)) {
            login.when(SecurityFrameworkUtils::getLoginUserId).thenReturn(11L);
            ServiceException error = assertThrows(ServiceException.class,
                    () -> service.updateCooperationStatus(302L, CooperationStatusEnum.PENDING.value));
            assertEquals(ErrorCodeConstants.COOPERATION_NOT_ALLOWED.getCode(), error.getCode());
        }
        assertEquals(CooperationStatusEnum.REACHED.value, application.getStatus());
        verify(cooperationMapper, never()).updateStatus(anyLong(), anyInt(), anyLong(), anyString());
    }

    @Test
    void scheduleCapacityBelowBookedIsRejected() {
        ServiceScheduleDO schedule = schedule(401L, 1L, 6, 6);
        when(scheduleMapper.selectOneForUpdate(401L)).thenReturn(schedule);
        ServiceScheduleUpdateReqVO req = new ServiceScheduleUpdateReqVO();
        req.setId(401L); req.setCapacity(5);
        try (MockedStatic<SecurityFrameworkUtils> login = mockStatic(SecurityFrameworkUtils.class)) {
            login.when(SecurityFrameworkUtils::getLoginUserId).thenReturn(11L);
            ServiceException error = assertThrows(ServiceException.class, () -> service.updateSchedule(req));
            assertEquals(ErrorCodeConstants.SCHEDULE_CAPACITY_INVALID.getCode(), error.getCode());
        }
        assertEquals(6, schedule.getBookedCount());
        verify(scheduleMapper, never()).updateAdmin(anyLong(), any(), any(), anyString(), anyInt(), anyInt(), anyString());
    }
    private static ServiceBookingDO booking(Long id, Long userId, int status) {
        ServiceBookingDO booking = new ServiceBookingDO();
        booking.setId(id); booking.setUserId(userId); booking.setScheduleId(10L); booking.setPeopleCount(1); booking.setStatus(status);
        return booking;
    }
    private static ServiceBookingCreateReqVO request(Long serviceId, Long scheduleId, int people) {
        ServiceBookingCreateReqVO req = new ServiceBookingCreateReqVO();
        req.setServiceId(serviceId); req.setScheduleId(scheduleId); req.setPeopleCount(people);
        req.setContactName("E2E"); req.setContactPhone("19900000001");
        return req;
    }

    private static ServiceScheduleDO schedule(Long id, Long serviceId, int capacity, int booked) {
        ServiceScheduleDO schedule = new ServiceScheduleDO();
        schedule.setId(id); schedule.setServiceId(serviceId); schedule.setCapacity(capacity);
        schedule.setBookedCount(booked); schedule.setStatus(1);
        schedule.setStartTime(LocalDateTime.now().plusDays(1));
        schedule.setEndTime(LocalDateTime.now().plusDays(1).plusHours(2));
        return schedule;
    }
}
