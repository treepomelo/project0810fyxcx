package cn.iocoder.yudao.module.inherit.service.inheritor;

import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.module.inherit.controller.admin.inheritor.vo.InheritorAuditReqVO;
import cn.iocoder.yudao.module.inherit.controller.admin.inheritor.vo.InheritorPageReqVO;
import cn.iocoder.yudao.module.inherit.controller.admin.inheritor.vo.InheritorSaveReqVO;
import cn.iocoder.yudao.module.inherit.controller.app.inheritor.vo.AppInheritorPageReqVO;
import cn.iocoder.yudao.module.inherit.dal.dataobject.inheritor.InheritorDO;

import java.util.Collection;
import java.util.List;

/**
 * 传承人 Service 接口
 *
 * @author inherit
 */
public interface InheritorService {

    /**
     * 创建传承人
     */
    Long createInheritor(InheritorSaveReqVO createReqVO);

    /**
     * 更新传承人
     */
    void updateInheritor(InheritorSaveReqVO updateReqVO);

    /**
     * 删除传承人（级联逻辑删除作品/资质/项目关系/关注）
     */
    void deleteInheritor(Long id);

    /**
     * 获得传承人
     */
    InheritorDO getInheritor(Long id);

    /**
     * 获得传承人分页（管理后台）
     */
    PageResult<InheritorDO> getInheritorPage(InheritorPageReqVO pageReqVO);

    /**
     * 审核传承人
     */
    void updateAudit(InheritorAuditReqVO auditReqVO);

    /**
     * 获得传承人分页（用户 App，仅展示已启用+已通过审核+展示中）
     */
    PageResult<InheritorDO> getInheritorAppPage(AppInheritorPageReqVO pageReqVO);

    /**
     * 批量获得传承人（用于“我的关注”等场景）
     */
    List<InheritorDO> getInheritorList(Collection<Long> ids);

    /**
     * 校验传承人是否存在，不存在则抛出异常
     */
    InheritorDO validateInheritorExists(Long id);

    /**
     * 获得公开可见的传承人（已启用 + 已通过审核 + 展示中），不可见返回 null
     *
     * 仅用于用户 App 的公开浏览/详情链路；管理后台不受影响。
     */
    InheritorDO getPublicInheritor(Long id);

    /**
     * 校验传承人公开可见（已启用 + 已通过审核 + 展示中），不可见则抛出异常
     *
     * 仅用于用户 App 的公开详情；管理后台不受影响。
     */
    InheritorDO validateInheritorPublicExists(Long id);

}
