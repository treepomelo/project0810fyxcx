package cn.iocoder.yudao.module.marketplace.controller.app.productrelation.vo;

/**
 * Public operating-merchant information for one Mall SPU.
 */
public class AppMarketplaceProductRelationRespVO {

    private Long spuId;
    private Long merchantId;
    private String merchantName;

    public Long getSpuId() {
        return spuId;
    }

    public AppMarketplaceProductRelationRespVO setSpuId(Long spuId) {
        this.spuId = spuId;
        return this;
    }

    public Long getMerchantId() {
        return merchantId;
    }

    public AppMarketplaceProductRelationRespVO setMerchantId(Long merchantId) {
        this.merchantId = merchantId;
        return this;
    }

    public String getMerchantName() {
        return merchantName;
    }

    public AppMarketplaceProductRelationRespVO setMerchantName(String merchantName) {
        this.merchantName = merchantName;
        return this;
    }
}
