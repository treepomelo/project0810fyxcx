package cn.iocoder.yudao.module.inherit.dal.dataobject.inheritor;

import cn.iocoder.yudao.framework.common.enums.CommonStatusEnum;
import cn.iocoder.yudao.framework.tenant.core.db.TenantBaseDO;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.time.LocalDateTime;

/**
 * 传承人 DO
 *
 * 业务主体：基础信息、真人照片、简介、地区、擅长技艺、荣誉/资质、作品、非遗项目关系、关注。
 * 地区仅存编号（provinceCode/cityCode/districtCode），名称由框架 AreaUtils 解析，不建冗余主数据。
 * 非遗项目、商品、服务均为跨域关系，只存 ID，不复制主数据（inherit_inheritor_project_relation）。
 *
 * @author inherit
 */
@TableName("inherit_inheritor")
@Data
@EqualsAndHashCode(callSuper = true)
public class InheritorDO extends TenantBaseDO {

    /**
     * 编号
     */
    private Long id;
    /**
     * 姓名
     */
    private String name;
    /**
     * 姓名拼音（小写、无空格，用于拼音搜索）
     */
    private String pinyin;
    /**
     * 头像（真人照片），文件上传后返回的 url
     */
    private String avatar;
    /**
     * 封面图
     */
    private String cover;
    /**
     * 性别：0 未知、1 男、2 女
     */
    private Integer gender;
    /**
     * 联系电话
     */
    private String phone;
    /**
     * 身份证号
     */
    private String idCard;
    /**
     * 传承人级别/身份（如：国家级/省级/市级/区县级代表性传承人）
     */
    private String level;
    /**
     * 省份编号，对应 /system/area 地区树的 id
     */
    private Integer provinceCode;
    /**
     * 城市编号
     */
    private Integer cityCode;
    /**
     * 区县编号
     */
    private Integer districtCode;
    /**
     * 简介（一句话）
     */
    private String introduction;
    /**
     * 详细介绍
     */
    private String profile;
    /**
     * 擅长技艺（多个技艺可用逗号分隔）
     */
    private String specialty;
    /**
     * 从业经历
     */
    private String experience;
    /**
     * 审核状态：{@link #AUDIT_STATUS_INIT} 待审核、{@link #AUDIT_STATUS_SUCCESS} 已通过、{@link #AUDIT_STATUS_FAIL} 未通过
     */
    private Integer auditStatus;
    /**
     * 审核备注
     */
    private String auditRemark;
    /**
     * 审核时间
     */
    private LocalDateTime auditTime;
    /**
     * 展示状态：0 不展示、1 展示
     */
    private Integer displayStatus;
    /**
     * 上架（展示）时间
     */
    private LocalDateTime publishedAt;
    /**
     * 是否首页推荐：0 否、1 是
     */
    private Integer isRecommend;
    /**
     * 首页推荐排序，越小越靠前
     */
    private Integer recommendSort;
    /**
     * 排序，越小越靠前
     */
    private Integer sort;
    /**
     * 状态：{@link CommonStatusEnum#ENABLE} 正常、{@link CommonStatusEnum#DISABLE} 停用
     */
    private Integer status;

    public static final Integer AUDIT_STATUS_INIT = 0;
    public static final Integer AUDIT_STATUS_SUCCESS = 1;
    public static final Integer AUDIT_STATUS_FAIL = 2;

}
