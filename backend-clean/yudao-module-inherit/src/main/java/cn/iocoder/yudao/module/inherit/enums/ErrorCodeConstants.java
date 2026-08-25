package cn.iocoder.yudao.module.inherit.enums;

import cn.iocoder.yudao.framework.common.exception.ErrorCode;

/**
 * inherit 模块错误码枚举
 *
 * 各域独立错误码段：传承人 1-001-000-000 ~ 1-001-000-099
 *
 * @author inherit
 */
public interface ErrorCodeConstants {

    // ========== 传承人 1-001-000-000 ==========
    ErrorCode INHERITOR_NOT_EXISTS = new ErrorCode(1_001_000_000, "传承人不存在");
    ErrorCode INHERITOR_QUALIFICATION_NOT_EXISTS = new ErrorCode(1_001_000_001, "传承人荣誉/资质不存在");
    ErrorCode INHERITOR_WORK_NOT_EXISTS = new ErrorCode(1_001_000_002, "传承人作品不存在");
    ErrorCode INHERITOR_PROJECT_RELATION_NOT_EXISTS = new ErrorCode(1_001_000_003, "传承人非遗项目关系不存在");
    ErrorCode INHERITOR_PROJECT_RELATION_DUPLICATE = new ErrorCode(1_001_000_004, "该非遗项目已关联该传承人，请勿重复关联");
    ErrorCode INHERITOR_FOLLOW_DUPLICATE = new ErrorCode(1_001_000_005, "已关注该传承人，请勿重复关注");
    ErrorCode INHERITOR_FOLLOW_NOT_EXISTS = new ErrorCode(1_001_000_006, "未关注该传承人");
    ErrorCode INHERITOR_PHONE_NOT_CONFIGURED = new ErrorCode(1_001_000_007, "传承人暂未配置联系电话");

}
