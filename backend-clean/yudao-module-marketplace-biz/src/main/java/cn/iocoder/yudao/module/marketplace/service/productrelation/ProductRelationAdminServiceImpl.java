package cn.iocoder.yudao.module.marketplace.service.productrelation;

import cn.iocoder.yudao.framework.common.enums.CommonStatusEnum;
import cn.iocoder.yudao.module.marketplace.controller.admin.productrelation.vo.ProductRelationRespVO;
import cn.iocoder.yudao.module.marketplace.controller.admin.productrelation.vo.ProductRelationSaveReqVO;
import cn.iocoder.yudao.module.marketplace.dal.dataobject.MarketplaceMerchantDO;
import cn.iocoder.yudao.module.marketplace.dal.dataobject.MarketplaceProductRelationDO;
import cn.iocoder.yudao.module.marketplace.dal.dataobject.MarketplaceShopDO;
import cn.iocoder.yudao.module.marketplace.dal.mysql.MarketplaceMerchantMapper;
import cn.iocoder.yudao.module.marketplace.dal.mysql.MarketplaceProductRelationMapper;
import cn.iocoder.yudao.module.marketplace.dal.mysql.MarketplaceShopMapper;
import cn.iocoder.yudao.module.product.api.spu.ProductSpuApi;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import jakarta.annotation.Resource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.function.Function;
import java.util.stream.Collectors;

import static cn.iocoder.yudao.framework.common.exception.util.ServiceExceptionUtil.exception;
import static cn.iocoder.yudao.module.marketplace.enums.ErrorCodeConstants.MERCHANT_NOT_EXISTS;
import static cn.iocoder.yudao.module.marketplace.enums.ErrorCodeConstants.MERCHANT_WORKSPACE_RELATION_NOT_EXISTS;
import static cn.iocoder.yudao.module.marketplace.enums.ErrorCodeConstants.PRODUCT_NOT_SALEABLE;
import static cn.iocoder.yudao.module.marketplace.enums.ErrorCodeConstants.SHOP_NOT_EXISTS;

/**
 * Administrative ownership of a Mall SPU. Mall keeps product data; Marketplace owns only its operating relation.
 */
@Service
public class ProductRelationAdminServiceImpl implements ProductRelationAdminService {

    @Resource
    private MarketplaceProductRelationMapper productRelationMapper;
    @Resource
    private MarketplaceMerchantMapper merchantMapper;
    @Resource
    private MarketplaceShopMapper shopMapper;
    @Resource
    private ProductSpuApi productSpuApi;

    @Override
    public ProductRelationRespVO getBySpuId(Long spuId) {
        MarketplaceProductRelationDO relation = productRelationMapper.selectBySpuId(spuId);
        if (relation == null) {
            return null;
        }
        ProductRelationRespVO respVO = new ProductRelationRespVO();
        respVO.setSpuId(relation.getSpuId());
        respVO.setMerchantId(relation.getMerchantId());
        return respVO;
    }

    @Override
    public List<ProductRelationRespVO> getBySpuIds(List<Long> spuIds) {
        return buildRelations(spuIds, false);
    }

    @Override
    public List<ProductRelationRespVO> getEnabledBySpuIds(List<Long> spuIds) {
        return buildRelations(spuIds, true);
    }

    private List<ProductRelationRespVO> buildRelations(List<Long> spuIds, boolean enabledMerchantOnly) {
        if (spuIds == null || spuIds.isEmpty()) {
            return List.of();
        }
        List<MarketplaceProductRelationDO> relations = productRelationMapper.selectList(
                new LambdaQueryWrapper<MarketplaceProductRelationDO>()
                        .in(MarketplaceProductRelationDO::getSpuId, spuIds)
                        .eq(MarketplaceProductRelationDO::getStatus, CommonStatusEnum.ENABLE.getStatus()));
        if (relations.isEmpty()) {
            return List.of();
        }
        Set<Long> merchantIds = relations.stream().map(MarketplaceProductRelationDO::getMerchantId)
                .collect(Collectors.toSet());
        Map<Long, MarketplaceMerchantDO> merchantMap = merchantMapper.selectBatchIds(merchantIds).stream()
                .collect(Collectors.toMap(MarketplaceMerchantDO::getId, Function.identity()));
        return relations.stream().map(relation -> {
            ProductRelationRespVO respVO = new ProductRelationRespVO();
            respVO.setSpuId(relation.getSpuId());
            respVO.setMerchantId(relation.getMerchantId());
            MarketplaceMerchantDO merchant = merchantMap.get(relation.getMerchantId());
            if (enabledMerchantOnly && (merchant == null || !CommonStatusEnum.isEnable(merchant.getStatus()))) {
                return null;
            }
            respVO.setMerchantName(merchant != null ? merchant.getName() : null);
            return respVO;
        }).filter(java.util.Objects::nonNull).toList();
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void save(ProductRelationSaveReqVO reqVO) {
        validateSpu(reqVO.getSpuId());
        validateEnabledMerchant(reqVO.getMerchantId());
        MarketplaceShopDO shop = resolveSingleEnabledShop(reqVO.getMerchantId());

        MarketplaceProductRelationDO relation = productRelationMapper.selectBySpuId(reqVO.getSpuId());
        if (relation == null) {
            relation = new MarketplaceProductRelationDO()
                    .setSpuId(reqVO.getSpuId())
                    .setMerchantId(reqVO.getMerchantId())
                    .setShopId(shop.getId())
                    .setStatus(CommonStatusEnum.ENABLE.getStatus());
            productRelationMapper.insert(relation);
            return;
        }

        relation.setMerchantId(reqVO.getMerchantId())
                .setShopId(shop.getId())
                .setStatus(CommonStatusEnum.ENABLE.getStatus());
        productRelationMapper.updateById(relation);
    }

    private void validateSpu(Long spuId) {
        if (productSpuApi.getSpu(spuId) == null) {
            throw exception(PRODUCT_NOT_SALEABLE);
        }
    }

    private void validateEnabledMerchant(Long merchantId) {
        MarketplaceMerchantDO merchant = merchantMapper.selectById(merchantId);
        if (merchant == null || !CommonStatusEnum.isEnable(merchant.getStatus())) {
            throw exception(MERCHANT_NOT_EXISTS);
        }
    }

    private MarketplaceShopDO resolveSingleEnabledShop(Long merchantId) {
        List<MarketplaceShopDO> enabledShops = shopMapper.selectListByMerchantId(merchantId).stream()
                .filter(shop -> CommonStatusEnum.isEnable(shop.getStatus()))
                .toList();
        if (enabledShops.isEmpty()) {
            throw exception(SHOP_NOT_EXISTS);
        }
        if (enabledShops.size() != 1) {
            throw exception(MERCHANT_WORKSPACE_RELATION_NOT_EXISTS);
        }
        return enabledShops.get(0);
    }
}
