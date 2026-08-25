package cn.iocoder.yudao.module.marketplace.service.merchant;

import cn.iocoder.yudao.module.marketplace.dal.dataobject.MarketplaceMerchantDO;
import cn.iocoder.yudao.module.marketplace.dal.dataobject.MarketplaceShopDO;
import cn.iocoder.yudao.module.marketplace.dal.mysql.MarketplaceMerchantMapper;
import cn.iocoder.yudao.module.marketplace.dal.mysql.MarketplaceShopMapper;
import cn.iocoder.yudao.module.marketplace.controller.admin.merchant.vo.MerchantSaveReqVO;
import cn.iocoder.yudao.framework.common.enums.CommonStatusEnum;
import jakarta.annotation.Resource;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.springframework.stereotype.Component;
import org.springframework.transaction.support.TransactionTemplate;

import java.util.List;

/** Phase-1 internal lifecycle for the 1 Merchant : 1 Shop rule. */
@Aspect
@Component
public class MarketplaceMerchantShopLifecycleAspect {

    @Resource private TransactionTemplate transactionTemplate;
    @Resource private MarketplaceMerchantMapper merchantMapper;
    @Resource private MarketplaceShopMapper shopMapper;

    @Around("execution(* cn.iocoder.yudao.module.marketplace.service.MarketplaceService.createMerchant(..))")
    public Object createMerchantWithDefaultShop(ProceedingJoinPoint joinPoint) throws Throwable {
        return executeInTransaction(() -> {
            MerchantSaveReqVO reqVO = (MerchantSaveReqVO) joinPoint.getArgs()[0];
            if (reqVO.getAuditStatus() == null) {
                reqVO.setAuditStatus(CommonStatusEnum.ENABLE.getStatus());
            }
            Long merchantId = (Long) joinPoint.proceed();
            ensureDefaultShop(merchantMapper.selectById(merchantId));
            return merchantId;
        });
    }

    @Around("execution(* cn.iocoder.yudao.module.marketplace.service.MarketplaceService.updateMerchant(..)) && args(reqVO)")
    public Object preserveAuditStatusOnUpdate(ProceedingJoinPoint joinPoint, MerchantSaveReqVO reqVO) throws Throwable {
        if (reqVO.getAuditStatus() == null && reqVO.getId() != null) {
            reqVO.setAuditStatus(merchantMapper.selectById(reqVO.getId()).getAuditStatus());
        }
        return joinPoint.proceed();
    }

    @Around("execution(* cn.iocoder.yudao.module.marketplace.service.MarketplaceService.updateMerchantStatus(..)) && args(merchantId, status)")
    public Object syncShopStatus(ProceedingJoinPoint joinPoint, Long merchantId, Integer status) throws Throwable {
        return executeInTransaction(() -> {
            Object result = joinPoint.proceed();
            ensureDefaultShop(merchantMapper.selectById(merchantId));
            shopMapper.selectListByMerchantId(merchantId).forEach(shop -> {
                if (!status.equals(shop.getStatus())) {
                    shop.setStatus(status);
                    shopMapper.updateById(shop);
                }
            });
            return result;
        });
    }

    private void ensureDefaultShop(MarketplaceMerchantDO merchant) {
        List<MarketplaceShopDO> shops = shopMapper.selectListByMerchantId(merchant.getId());
        if (shops.isEmpty()) {
            shopMapper.insert(new MarketplaceShopDO().setMerchantId(merchant.getId())
                    .setShopNo("AUTO_MERCHANT_" + merchant.getId())
                    .setName(merchant.getName()).setStatus(merchant.getStatus()));
        }
    }

    private Object executeInTransaction(ThrowingSupplier supplier) throws Throwable {
        try {
            return transactionTemplate.execute(status -> {
                try {
                    return supplier.get();
                } catch (Throwable ex) {
                    status.setRollbackOnly();
                    throw new LifecycleException(ex);
                }
            });
        } catch (LifecycleException ex) {
            throw ex.getCause();
        }
    }

    @FunctionalInterface
    private interface ThrowingSupplier { Object get() throws Throwable; }

    private static final class LifecycleException extends RuntimeException {
        private LifecycleException(Throwable cause) { super(cause); }
    }
}
