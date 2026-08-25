package cn.iocoder.yudao.module.inherit.service.inheritor;

import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.module.inherit.controller.admin.inheritor.vo.InheritorWorkPageReqVO;
import cn.iocoder.yudao.module.inherit.controller.admin.inheritor.vo.InheritorWorkSaveReqVO;
import cn.iocoder.yudao.module.inherit.dal.dataobject.inheritor.InheritorWorkDO;

import java.util.List;

/**
 * 传承人作品 Service 接口
 *
 * @author inherit
 */
public interface InheritorWorkService {

    /**
     * 创建传承人作品
     */
    Long createWork(InheritorWorkSaveReqVO createReqVO);

    /**
     * 更新传承人作品
     */
    void updateWork(InheritorWorkSaveReqVO updateReqVO);

    /**
     * 删除传承人作品
     */
    void deleteWork(Long id);

    /**
     * 获得传承人作品
     */
    InheritorWorkDO getWork(Long id);

    /**
     * 获得传承人作品分页
     */
    PageResult<InheritorWorkDO> getWorkPage(InheritorWorkPageReqVO pageReqVO);

    /**
     * 按传承人获得作品列表（C 端详情使用）
     */
    List<InheritorWorkDO> getWorkListByInheritorId(Long inheritorId);

}
