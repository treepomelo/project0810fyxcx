package cn.iocoder.yudao.module.inherit.service.inheritor;

import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.module.inherit.controller.admin.inheritor.vo.InheritorProjectRelationPageReqVO;
import cn.iocoder.yudao.module.inherit.controller.admin.inheritor.vo.InheritorProjectRelationSaveReqVO;
import cn.iocoder.yudao.module.inherit.dal.dataobject.inheritor.InheritorProjectRelationDO;

import java.util.List;

/**
 * 传承人-非遗项目 关系 Service 接口
 *
 * @author inherit
 */
public interface InheritorProjectRelationService {

    /**
     * 创建传承人-非遗项目 关系
     */
    Long createProjectRelation(InheritorProjectRelationSaveReqVO createReqVO);

    /**
     * 更新传承人-非遗项目 关系
     */
    void updateProjectRelation(InheritorProjectRelationSaveReqVO updateReqVO);

    /**
     * 删除传承人-非遗项目 关系
     */
    void deleteProjectRelation(Long id);

    /**
     * 获得传承人-非遗项目 关系
     */
    InheritorProjectRelationDO getProjectRelation(Long id);

    /**
     * 获得传承人-非遗项目 关系分页
     */
    PageResult<InheritorProjectRelationDO> getProjectRelationPage(InheritorProjectRelationPageReqVO pageReqVO);

    /**
     * 按传承人获得非遗项目关系列表（C 端详情使用）
     */
    List<InheritorProjectRelationDO> getProjectRelationListByInheritorId(Long inheritorId);

}
