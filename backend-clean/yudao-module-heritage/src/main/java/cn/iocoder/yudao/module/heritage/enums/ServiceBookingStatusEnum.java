package cn.iocoder.yudao.module.heritage.enums;
public enum ServiceBookingStatusEnum { PENDING(0,"待确认"), CONFIRMED(1,"已确认"), CANCELLED(2,"已取消"), REJECTED(3,"已拒绝"), COMPLETED(4,"已完成"); public final int value; public final String name; ServiceBookingStatusEnum(int value,String name){this.value=value;this.name=name;} }
