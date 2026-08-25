package cn.iocoder.yudao.module.inherit.service.inheritor;

import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.module.inherit.controller.admin.inheritor.vo.InheritorQualificationPageReqVO;
import cn.iocoder.yudao.module.inherit.controller.admin.inheritor.vo.InheritorQualificationSaveReqVO;
import cn.iocoder.yudao.module.inherit.dal.dataobject.inheritor.InheritorQualificationDO;

import java.util.List;

/**
 * 传承人荣誉/资质 Service 接口
 *
 * @author inherit
 */
public interface InheritorQualificationService {

    /**
     * 创建传承人荣誉/资质
     */
    Long createQualification(InheritorQualificationSaveReqVO createReqVO);

    /**
     * 更新传承人荣誉/资质
     */
    void updateQualification(InheritorQualificationSaveReqVO updateReqVO);

    /**
     * 删除传承人荣誉/资质
     */
    void deleteQualification(Long id);

    /**
     * 获得传承人荣誉/资质
     */
    InheritorQualificationDO getQualification(Long id);

    /**
     * 获得传承人荣誉/资质分页
     */
    PageResult<InheritorQualificationDO> getQualificationPage(InheritorQualificationPageReqVO pageReqVO);

    /**
     * 按传承人获得荣誉/资质列表（C 端详情使用）
     */
    List<InheritorQualificationDO> getQualificationListByInheritorId(Long inheritorId);

}
