package cn.iocoder.yudao.module.product.service.delivery;

import cn.iocoder.yudao.module.product.dal.dataobject.delivery.ProductDeliveryExpressTemplateDO;
import cn.iocoder.yudao.module.product.dal.mysql.delivery.ProductDeliveryExpressTemplateMapper;
import org.springframework.stereotype.Service;

import jakarta.annotation.Resource;
import java.util.List;

@Service
public class ProductDeliveryExpressTemplateServiceImpl implements ProductDeliveryExpressTemplateService {

    @Resource
    private ProductDeliveryExpressTemplateMapper deliveryExpressTemplateMapper;

    @Override
    public List<ProductDeliveryExpressTemplateDO> getSimpleTemplateList() {
        return deliveryExpressTemplateMapper.selectSimpleList();
    }

}
