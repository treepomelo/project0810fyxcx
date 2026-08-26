package cn.iocoder.yudao.module.inherit.controller.app.inheritor.vo;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class AppInheritorServiceRespVO {
    private Long serviceId;
    private String systemCode;
    private String systemName;
    private String title;
    private String coverUrl;
    private String summary;
    private Integer price;
    private String city;
    private String location;
    private Boolean bookingEnabled;
    private Boolean isRepresentative;
    private Integer sort;
    private LocalDateTime nearestStartTime;
}