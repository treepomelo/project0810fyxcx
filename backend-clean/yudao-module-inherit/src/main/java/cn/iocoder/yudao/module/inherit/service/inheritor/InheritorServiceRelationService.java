package cn.iocoder.yudao.module.inherit.service.inheritor;

import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.module.inherit.controller.admin.inheritor.vo.InheritorServiceRelationPageReqVO;
import cn.iocoder.yudao.module.inherit.controller.admin.inheritor.vo.InheritorServiceRelationSaveReqVO;
import cn.iocoder.yudao.module.inherit.controller.app.inheritor.vo.AppInheritorServiceRespVO;
import cn.iocoder.yudao.module.inherit.dal.dataobject.inheritor.InheritorServiceRelationDO;
import java.util.List;

public interface InheritorServiceRelationService {
    Long createServiceRelation(InheritorServiceRelationSaveReqVO req);
    void updateServiceRelation(InheritorServiceRelationSaveReqVO req);
    void deleteServiceRelation(Long id);
    InheritorServiceRelationDO getServiceRelation(Long id);
    PageResult<InheritorServiceRelationDO> getServiceRelationPage(InheritorServiceRelationPageReqVO req);
    List<AppInheritorServiceRespVO> getPublicServices(Long inheritorId);
    void deleteByInheritorId(Long inheritorId);
}