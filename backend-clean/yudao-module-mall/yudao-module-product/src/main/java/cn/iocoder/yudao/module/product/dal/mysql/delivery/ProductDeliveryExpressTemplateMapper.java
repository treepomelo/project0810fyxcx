package cn.iocoder.yudao.module.product.dal.mysql.delivery;

import cn.iocoder.yudao.framework.mybatis.core.mapper.BaseMapperX;
import cn.iocoder.yudao.framework.mybatis.core.query.LambdaQueryWrapperX;
import cn.iocoder.yudao.module.product.dal.dataobject.delivery.ProductDeliveryExpressTemplateDO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface ProductDeliveryExpressTemplateMapper extends BaseMapperX<ProductDeliveryExpressTemplateDO> {

    default List<ProductDeliveryExpressTemplateDO> selectSimpleList() {
        return selectList(new LambdaQueryWrapperX<ProductDeliveryExpressTemplateDO>()
                .orderByAsc(ProductDeliveryExpressTemplateDO::getSort)
                .orderByAsc(ProductDeliveryExpressTemplateDO::getId));
    }

}
