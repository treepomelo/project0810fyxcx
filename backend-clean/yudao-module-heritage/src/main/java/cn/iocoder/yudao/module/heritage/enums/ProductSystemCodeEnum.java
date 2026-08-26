package cn.iocoder.yudao.module.heritage.enums;
public enum ProductSystemCodeEnum { CULTURAL_CREATIVE, HERITAGE_FOOD, HANDCRAFT_EXPERIENCE, WELLNESS_COMPANION, FOLK_PERFORMANCE;
 public static boolean isProduct(String code){return "CULTURAL_CREATIVE".equals(code)||"HERITAGE_FOOD".equals(code);} public static boolean isService(String code){return "HANDCRAFT_EXPERIENCE".equals(code)||"WELLNESS_COMPANION".equals(code)||"FOLK_PERFORMANCE".equals(code);} }
