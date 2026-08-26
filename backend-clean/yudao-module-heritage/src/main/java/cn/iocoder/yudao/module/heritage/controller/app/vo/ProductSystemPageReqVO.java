package cn.iocoder.yudao.module.heritage.controller.app.vo;
import cn.iocoder.yudao.framework.common.pojo.PageParam; import jakarta.validation.constraints.NotBlank; import lombok.Data;
@Data public class ProductSystemPageReqVO extends PageParam { @NotBlank private String code; private String keyword; }
