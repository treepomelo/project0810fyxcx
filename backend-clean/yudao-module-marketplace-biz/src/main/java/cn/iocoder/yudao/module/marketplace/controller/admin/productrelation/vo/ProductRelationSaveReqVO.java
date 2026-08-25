package cn.iocoder.yudao.module.marketplace.controller.admin.productrelation.vo;

import jakarta.validation.constraints.NotNull;

public class ProductRelationSaveReqVO {

    @NotNull(message = "SPU 编号不能为空")
    private Long spuId;

    @NotNull(message = "商户编号不能为空")
    private Long merchantId;

    public Long getSpuId() {
        return spuId;
    }

    public void setSpuId(Long spuId) {
        this.spuId = spuId;
    }

    public Long getMerchantId() {
        return merchantId;
    }

    public void setMerchantId(Long merchantId) {
        this.merchantId = merchantId;
    }
}
