package cn.iocoder.yudao.module.product.service.delivery;

import cn.iocoder.yudao.module.product.dal.dataobject.delivery.ProductDeliveryExpressTemplateDO;

import java.util.List;

/**
 * Read-only delivery-template lookup for the Mall Product form.
 */
public interface ProductDeliveryExpressTemplateService {

    List<ProductDeliveryExpressTemplateDO> getSimpleTemplateList();

}
