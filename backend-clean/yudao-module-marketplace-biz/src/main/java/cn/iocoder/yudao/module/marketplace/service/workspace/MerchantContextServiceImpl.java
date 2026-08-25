package cn.iocoder.yudao.module.marketplace.service.workspace;

import cn.iocoder.yudao.framework.common.enums.CommonStatusEnum;
import cn.iocoder.yudao.framework.security.core.util.SecurityFrameworkUtils;
import cn.iocoder.yudao.module.marketplace.dal.dataobject.MarketplaceMerchantInheritorDO;
import cn.iocoder.yudao.module.marketplace.dal.dataobject.MarketplaceShopDO;
import cn.iocoder.yudao.module.marketplace.dal.mysql.MarketplaceMerchantInheritorMapper;
import cn.iocoder.yudao.module.marketplace.dal.mysql.MarketplaceShopMapper;
import jakarta.annotation.Resource;
import org.springframework.stereotype.Service;

import java.util.List;

import static cn.iocoder.yudao.framework.common.exception.util.ServiceExceptionUtil.exception;
import static cn.iocoder.yudao.module.marketplace.enums.ErrorCodeConstants.MERCHANT_WORKSPACE_ACCESS_DENIED;
import static cn.iocoder.yudao.module.marketplace.enums.ErrorCodeConstants.MERCHANT_WORKSPACE_RELATION_NOT_EXISTS;

/** Marketplace-owned merchant workspace boundary. */
@Service
public class MerchantContextServiceImpl implements MerchantContextService {

    @Resource
    private InheritorIdentityAdapter inheritorIdentityAdapter;
    @Resource
    private MarketplaceMerchantInheritorMapper relationMapper;
    @Resource
    private MarketplaceShopMapper shopMapper;

    @Override
    public Long getCurrentMerchantId() {
        Long memberId = SecurityFrameworkUtils.getLoginUserId();
        Long inheritorId = inheritorIdentityAdapter.getInheritorIdByMemberId(memberId);
        List<Long> merchantIds = relationMapper.selectListByInheritorId(inheritorId).stream()
                .filter(relation -> CommonStatusEnum.ENABLE.getStatus().equals(relation.getStatus()))
                .map(MarketplaceMerchantInheritorDO::getMerchantId)
                .distinct()
                .toList();
        return requireExactlyOne(merchantIds);
    }

    @Override
    public Long getCurrentShopId() {
        Long merchantId = getCurrentMerchantId();
        List<Long> shopIds = shopMapper.selectListByMerchantId(merchantId).stream()
                .filter(shop -> CommonStatusEnum.ENABLE.getStatus().equals(shop.getStatus()))
                .map(MarketplaceShopDO::getId)
                .distinct()
                .toList();
        return requireExactlyOne(shopIds);
    }

    @Override
    public void checkMerchantAccess(Long merchantId) {
        if (!getCurrentMerchantId().equals(merchantId)) {
            throw exception(MERCHANT_WORKSPACE_ACCESS_DENIED);
        }
    }

    @Override
    public void checkShopAccess(Long shopId) {
        MarketplaceShopDO shop = shopMapper.selectById(shopId);
        if (shop == null) {
            throw exception(MERCHANT_WORKSPACE_ACCESS_DENIED);
        }
        checkMerchantAccess(shop.getMerchantId());
    }

    private Long requireExactlyOne(List<Long> ids) {
        if (ids.size() != 1) {
            throw exception(MERCHANT_WORKSPACE_RELATION_NOT_EXISTS);
        }
        return ids.get(0);
    }
}
