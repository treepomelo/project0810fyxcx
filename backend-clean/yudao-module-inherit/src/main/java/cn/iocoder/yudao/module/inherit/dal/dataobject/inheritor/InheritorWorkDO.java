package cn.iocoder.yudao.module.inherit.dal.dataobject.inheritor;

import cn.iocoder.yudao.framework.common.enums.CommonStatusEnum;
import cn.iocoder.yudao.framework.tenant.core.db.TenantBaseDO;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableName;
import com.baomidou.mybatisplus.extension.handlers.JacksonTypeHandler;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.util.List;

/**
 * 传承人作品 DO
 *
 * 作品图集 images 以 JSON 存储（数据库字段 json），封面/详情图复用底座文件上传。
 *
 * @author inherit
 */
@TableName(value = "inherit_inheritor_work", autoResultMap = true)
@Data
@EqualsAndHashCode(callSuper = true)
public class InheritorWorkDO extends TenantBaseDO {

    /**
     * 编号
     */
    private Long id;
    /**
     * 传承人编号
     */
    private Long inheritorId;
    /**
     * 作品名称
     */
    private String name;
    /**
     * 封面图 url
     */
    private String cover;
    /**
     * 作品图集（多图）url 列表
     */
    @TableField(typeHandler = JacksonTypeHandler.class)
    private List<String> images;
    /**
     * 作品描述
     */
    private String description;
    /**
     * 创作年份
     */
    private String year;
    /**
     * 材质
     */
    private String material;
    /**
     * 工艺/技法
     */
    private String technique;
    /**
     * 排序，越小越靠前
     */
    private Integer sort;
    /**
     * 状态：{@link CommonStatusEnum#ENABLE} 正常、{@link CommonStatusEnum#DISABLE} 停用
     */
    private Integer status;

}
