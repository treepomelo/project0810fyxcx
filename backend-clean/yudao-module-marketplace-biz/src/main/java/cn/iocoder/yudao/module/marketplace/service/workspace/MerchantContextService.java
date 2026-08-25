package cn.iocoder.yudao.module.marketplace.service.workspace;

/**
 * Resolves the current merchant workspace from the authenticated Member identity.
 * This is not an Admin, Tenant, or Merchant-login context.
 */
public interface MerchantContextService {

    Long getCurrentMerchantId();

    Long getCurrentShopId();

    void checkMerchantAccess(Long merchantId);

    void checkShopAccess(Long shopId);
}
