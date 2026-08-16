package cn.iocoder.yudao.module.inherit.dal.dataobject.inheritor;

import cn.iocoder.yudao.framework.tenant.core.db.TenantBaseDO;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * 传承人-非遗项目 关系 DO
 *
 * 只保存关系 ID，不复制非遗项目主数据（name/category/level 等）。
 * 非遗门类筛选链路：Inheritor → inherit_inheritor_project_relation → HeritageProject → category
 * （HeritageProject 属未来非遗项目模块，本模块通过 projectId 弱关联，禁止跨模块 FK）。
 *
 * @author inherit
 */
@TableName("inherit_inheritor_project_relation")
@Data
@EqualsAndHashCode(callSuper = true)
public class InheritorProjectRelationDO extends TenantBaseDO {

    /**
     * 编号
     */
    private Long id;
    /**
     * 传承人编号
     */
    private Long inheritorId;
    /**
     * 非遗项目编号（HeritageProject 模块主键，弱关联）
     */
    private Long projectId;
    /**
     * 是否主打项目：true 是、false 否
     */
    private Boolean isPrimary;
    /**
     * 排序，越小越靠前
     */
    private Integer sort;

}
