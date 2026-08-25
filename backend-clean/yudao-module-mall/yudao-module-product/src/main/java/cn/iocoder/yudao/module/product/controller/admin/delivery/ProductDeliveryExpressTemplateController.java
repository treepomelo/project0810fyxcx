package cn.iocoder.yudao.module.product.controller.admin.delivery;

import cn.iocoder.yudao.framework.common.pojo.CommonResult;
import cn.iocoder.yudao.framework.common.util.object.BeanUtils;
import cn.iocoder.yudao.module.product.controller.admin.delivery.vo.ProductDeliveryExpressTemplateSimpleRespVO;
import cn.iocoder.yudao.module.product.dal.dataobject.delivery.ProductDeliveryExpressTemplateDO;
import cn.iocoder.yudao.module.product.service.delivery.ProductDeliveryExpressTemplateService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import jakarta.annotation.Resource;
import java.util.List;

import static cn.iocoder.yudao.framework.common.pojo.CommonResult.success;

/**
 * Supplies the existing Mall Product form's required delivery-template choices.
 * It deliberately exposes no delivery-template administration and no Trade order capability.
 */
@Tag(name = "管理后台 - 商品配送模板")
@RestController
@RequestMapping("/trade/delivery/express-template")
public class ProductDeliveryExpressTemplateController {

    @Resource
    private ProductDeliveryExpressTemplateService deliveryExpressTemplateService;

    @GetMapping("/list-all-simple")
    @Operation(summary = "获取快递运费模板精简信息列表")
    public CommonResult<List<ProductDeliveryExpressTemplateSimpleRespVO>> getSimpleTemplateList() {
        List<ProductDeliveryExpressTemplateDO> list = deliveryExpressTemplateService.getSimpleTemplateList();
        return success(BeanUtils.toBean(list, ProductDeliveryExpressTemplateSimpleRespVO.class));
    }

}
