package cn.iocoder.yudao.module.heritage.controller.admin.vo;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class ProductSystemSpuRespVO {
    private Long id;
    private Long systemId;
    private String systemCode;
    private String systemName;
    private Long spuId;
    private String spuName;
    private String spuPicUrl;
    private Integer spuPrice;
    private Integer sort;
    private Integer status;
    private LocalDateTime createTime;
}