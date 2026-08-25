package cn.iocoder.yudao.module.marketplace.service.productrelation;

import cn.iocoder.yudao.module.marketplace.controller.admin.productrelation.vo.ProductRelationRespVO;
import cn.iocoder.yudao.module.marketplace.controller.admin.productrelation.vo.ProductRelationSaveReqVO;

import java.util.List;

public interface ProductRelationAdminService {

    ProductRelationRespVO getBySpuId(Long spuId);

    List<ProductRelationRespVO> getBySpuIds(List<Long> spuIds);

    /**
     * Returns only relations whose merchant remains enabled and can therefore be
     * shown in public product content.
     */
    List<ProductRelationRespVO> getEnabledBySpuIds(List<Long> spuIds);

    void save(ProductRelationSaveReqVO reqVO);
}
