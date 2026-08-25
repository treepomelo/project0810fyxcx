package cn.iocoder.yudao.module.product.controller.admin.delivery.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Schema(description = "管理后台 - 快递运费模板精简信息 Response VO")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class ProductDeliveryExpressTemplateSimpleRespVO {

    @Schema(description = "模板编号", requiredMode = Schema.RequiredMode.REQUIRED, example = "1024")
    private Long id;

    @Schema(description = "模板名称", requiredMode = Schema.RequiredMode.REQUIRED, example = "全国包邮")
    private String name;

}
