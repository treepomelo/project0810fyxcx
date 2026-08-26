package cn.iocoder.yudao.module.heritage.enums;

import cn.iocoder.yudao.framework.common.exception.ErrorCode;

public interface ErrorCodeConstants {
    ErrorCode PRODUCT_SYSTEM_NOT_EXISTS = new ErrorCode(1_002_000_000, "产品体系不存在");
    ErrorCode PRODUCT_SYSTEM_TYPE_NOT_SUPPORTED = new ErrorCode(1_002_000_001, "体系类型不支持");
    ErrorCode PRODUCT_NOT_EXISTS = new ErrorCode(1_002_000_002, "商品不存在");
    ErrorCode RELATION_EXISTS = new ErrorCode(1_002_000_003, "商品体系关系已存在");
    ErrorCode SERVICE_NOT_EXISTS = new ErrorCode(1_002_000_004, "服务不存在");
    ErrorCode SERVICE_NOT_PUBLIC = new ErrorCode(1_002_000_005, "服务未公开");
    ErrorCode SCHEDULE_NOT_EXISTS = new ErrorCode(1_002_000_006, "场次不存在");
    ErrorCode SCHEDULE_NOT_AVAILABLE = new ErrorCode(1_002_000_007, "场次不可预约");
    ErrorCode BOOKING_NOT_EXISTS = new ErrorCode(1_002_000_008, "预约不存在");
    ErrorCode BOOKING_DUPLICATE = new ErrorCode(1_002_000_009, "该场次已有有效预约");
    ErrorCode BOOKING_NOT_ALLOWED = new ErrorCode(1_002_000_010, "当前预约状态不允许此操作");
    ErrorCode BOOKING_CAPACITY_NOT_ENOUGH = new ErrorCode(1_002_000_011, "场次余量不足");
    ErrorCode COOPERATION_NOT_EXISTS = new ErrorCode(1_002_000_012, "合作申请不存在");
    ErrorCode COOPERATION_TYPE_NOT_SUPPORTED = new ErrorCode(1_002_000_013, "合作类型不支持");
    ErrorCode LOGIN_REQUIRED = new ErrorCode(1_002_000_014, "请先登录");
    ErrorCode COOPERATION_NOT_ALLOWED = new ErrorCode(1_002_000_015, "当前合作申请状态不允许此操作");
    ErrorCode RELATION_NOT_EXISTS = new ErrorCode(1_002_000_016, "商品体系关系不存在");
    ErrorCode STATUS_INVALID = new ErrorCode(1_002_000_017, "状态值无效");
    ErrorCode SCHEDULE_TIME_INVALID = new ErrorCode(1_002_000_018, "场次时间无效");
    ErrorCode SCHEDULE_CAPACITY_INVALID = new ErrorCode(1_002_000_019, "场次容量无效");
    ErrorCode SCHEDULE_HAS_ACTIVE_BOOKING = new ErrorCode(1_002_000_020, "场次存在有效预约，不能删除");
    ErrorCode SERVICE_HAS_ACTIVE_BOOKING = new ErrorCode(1_002_000_021, "服务存在有效预约，不能删除");
    ErrorCode SERVICE_HAS_SCHEDULE = new ErrorCode(1_002_000_022, "服务存在未删除场次，不能删除");
    ErrorCode SERVICE_STATUS_INVALID = new ErrorCode(1_002_000_023, "服务状态值无效");
}