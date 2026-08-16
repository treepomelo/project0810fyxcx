package cn.iocoder.yudao.module.inherit.dal.dataobject.inheritor;

import cn.iocoder.yudao.framework.common.enums.CommonStatusEnum;
import cn.iocoder.yudao.framework.tenant.core.db.TenantBaseDO;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.time.LocalDate;

/**
 * 传承人荣誉/资质 DO
 *
 * 用于：荣誉、资质、代表性传承人身份、获奖、证书。
 * 证书图片只存 url（复用底座文件上传），不存业务文件关系。
 *
 * @author inherit
 */
@TableName("inherit_inheritor_qualification")
@Data
@EqualsAndHashCode(callSuper = true)
public class InheritorQualificationDO extends TenantBaseDO {

    /**
     * 编号
     */
    private Long id;
    /**
     * 传承人编号
     */
    private Long inheritorId;
    /**
     * 类型：荣誉 / 资质 / 代表性传承人身份 / 获奖 / 证书
     */
    private String type;
    /**
     * 名称
     */
    private String name;
    /**
     * 级别
     */
    private String level;
    /**
     * 颁发机构
     */
    private String issuer;
    /**
     * 颁发日期
     */
    private LocalDate issueDate;
    /**
     * 证书编号
     */
    private String certificateNo;
    /**
     * 描述
     */
    private String description;
    /**
     * 证书/荣誉图片 url
     */
    private String imageUrl;
    /**
     * 排序，越小越靠前
     */
    private Integer sort;
    /**
     * 状态：{@link CommonStatusEnum#ENABLE} 正常、{@link CommonStatusEnum#DISABLE} 停用
     */
    private Integer status;

}
