package cn.iocoder.yudao.module.inherit.service.inheritor;

import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.module.inherit.controller.admin.inheritor.vo.InheritorProductRelationPageReqVO;
import cn.iocoder.yudao.module.inherit.controller.admin.inheritor.vo.InheritorProductRelationSaveReqVO;
import cn.iocoder.yudao.module.inherit.dal.dataobject.inheritor.InheritorProductRelationDO;
import cn.iocoder.yudao.module.inherit.controller.app.inheritor.vo.AppInheritorProductRespVO;
import java.util.List;

public interface InheritorProductRelationService {
    Long createProductRelation(InheritorProductRelationSaveReqVO req);
    void updateProductRelation(InheritorProductRelationSaveReqVO req);
    void deleteProductRelation(Long id);
    InheritorProductRelationDO getProductRelation(Long id);
    PageResult<InheritorProductRelationDO> getProductRelationPage(InheritorProductRelationPageReqVO req);
    List<AppInheritorProductRespVO> getPublicProducts(Long inheritorId);
    void deleteByInheritorId(Long inheritorId);
}