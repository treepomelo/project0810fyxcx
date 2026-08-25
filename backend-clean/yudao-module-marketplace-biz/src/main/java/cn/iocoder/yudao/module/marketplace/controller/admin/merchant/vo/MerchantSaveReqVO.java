package cn.iocoder.yudao.module.marketplace.controller.admin.merchant.vo;

import cn.iocoder.yudao.framework.common.enums.CommonStatusEnum;
import cn.iocoder.yudao.framework.common.validation.InEnum;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class MerchantSaveReqVO {
    private Long id;
    @NotBlank private String merchantNo;
    @NotBlank private String name;
    private String shortName;
    @NotNull private Integer type;
    @NotNull @InEnum(CommonStatusEnum.class) private Integer status;
    private String contactName;
    private String contactMobile;
    private String logo;
    private String description;
    /** Platform-admin creation defaults this to CommonStatusEnum.ENABLE. */
    @InEnum(CommonStatusEnum.class) private Integer auditStatus;
}
