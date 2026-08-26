package cn.iocoder.yudao.module.inherit.enums;

import cn.iocoder.yudao.framework.common.exception.ErrorCode;

/** inherit 模块错误码枚举。 */
public interface ErrorCodeConstants {
    ErrorCode INHERITOR_NOT_EXISTS = new ErrorCode(1_001_000_000, "传承人不存在");
    ErrorCode INHERITOR_QUALIFICATION_NOT_EXISTS = new ErrorCode(1_001_000_001, "传承人荣誉/资质不存在");
    ErrorCode INHERITOR_WORK_NOT_EXISTS = new ErrorCode(1_001_000_002, "传承人作品不存在");
    ErrorCode INHERITOR_PROJECT_RELATION_NOT_EXISTS = new ErrorCode(1_001_000_003, "传承人非遗项目关系不存在");
    ErrorCode INHERITOR_PROJECT_RELATION_DUPLICATE = new ErrorCode(1_001_000_004, "该非遗项目已关联该传承人，请勿重复关联");
    ErrorCode INHERITOR_FOLLOW_DUPLICATE = new ErrorCode(1_001_000_005, "已关注该传承人，请勿重复关注");
    ErrorCode INHERITOR_FOLLOW_NOT_EXISTS = new ErrorCode(1_001_000_006, "未关注该传承人");
    ErrorCode INHERITOR_PHONE_NOT_CONFIGURED = new ErrorCode(1_001_000_007, "传承人暂未配置联系电话");
    ErrorCode INHERITOR_AUDIT_STATUS_INVALID = new ErrorCode(1_001_000_008, "传承人审核状态无效");
    ErrorCode INHERITOR_GENDER_INVALID = new ErrorCode(1_001_000_009, "传承人性别无效");
    ErrorCode INHERITOR_DISPLAY_STATUS_INVALID = new ErrorCode(1_001_000_010, "传承人展示状态无效");
    ErrorCode INHERITOR_RECOMMEND_STATUS_INVALID = new ErrorCode(1_001_000_011, "传承人推荐状态无效");
    ErrorCode INHERITOR_STATUS_INVALID = new ErrorCode(1_001_000_012, "传承人状态无效");
    ErrorCode INHERITOR_RELATION_STATUS_INVALID = new ErrorCode(1_001_000_013, "传承人关系状态无效");
    ErrorCode INHERITOR_PRODUCT_RELATION_NOT_EXISTS = new ErrorCode(1_001_000_014, "传承人商品关系不存在");
    ErrorCode INHERITOR_PRODUCT_RELATION_DUPLICATE = new ErrorCode(1_001_000_015, "该商品已关联该传承人，请勿重复关联");
    ErrorCode INHERITOR_SERVICE_RELATION_NOT_EXISTS = new ErrorCode(1_001_000_016, "传承人服务关系不存在");
    ErrorCode INHERITOR_SERVICE_RELATION_DUPLICATE = new ErrorCode(1_001_000_017, "该服务已关联该传承人，请勿重复关联");
    ErrorCode INHERITOR_SERVICE_NOT_EXISTS = new ErrorCode(1_001_000_018, "非遗服务不存在或未上架");
    ErrorCode INHERITOR_PROJECT_NOT_EXISTS = new ErrorCode(1_001_000_019, "非遗项目不存在或未上架");
}