package cn.iocoder.yudao.module.heritage.enums;
public enum CooperationStatusEnum { PENDING(0,"待处理"), COMMUNICATING(1,"沟通中"), REACHED(2,"已达成"), REJECTED(3,"已拒绝"); public final int value; public final String name; CooperationStatusEnum(int value,String name){this.value=value;this.name=name;} }
