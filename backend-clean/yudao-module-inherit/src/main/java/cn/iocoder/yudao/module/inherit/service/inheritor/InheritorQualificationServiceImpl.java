package cn.iocoder.yudao.module.inherit.service.inheritor;

import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.common.util.object.BeanUtils;
import cn.iocoder.yudao.module.inherit.controller.admin.inheritor.vo.InheritorQualificationPageReqVO;
import cn.iocoder.yudao.module.inherit.controller.admin.inheritor.vo.InheritorQualificationSaveReqVO;
import cn.iocoder.yudao.module.inherit.dal.dataobject.inheritor.InheritorQualificationDO;
import cn.iocoder.yudao.module.inherit.dal.mysql.inheritor.InheritorQualificationMapper;
import org.springframework.stereotype.Service;
import org.springframework.validation.annotation.Validated;

import jakarta.annotation.Resource;
import java.util.ArrayList;
import java.util.List;

import static cn.iocoder.yudao.framework.common.exception.util.ServiceExceptionUtil.exception;
import static cn.iocoder.yudao.module.inherit.enums.ErrorCodeConstants.INHERITOR_QUALIFICATION_NOT_EXISTS;

/**
 * 传承人荣誉/资质 Service 实现类
 *
 * @author inherit
 */
@Service
@Validated
public class InheritorQualificationServiceImpl implements InheritorQualificationService {

    @Resource
    private InheritorQualificationMapper qualificationMapper;
    @Resource
    private InheritorService inheritorService;

    @Override
    public Long createQualification(InheritorQualificationSaveReqVO createReqVO) {
        // 校验传承人存在
        inheritorService.validateInheritorExists(createReqVO.getInheritorId());
        // 插入
        InheritorQualificationDO qualification = BeanUtils.toBean(createReqVO, InheritorQualificationDO.class);
        qualificationMapper.insert(qualification);
        return qualification.getId();
    }

    @Override
    public void updateQualification(InheritorQualificationSaveReqVO updateReqVO) {
        // 校验存在
        validateQualificationExists(updateReqVO.getId());
        // 更新
        InheritorQualificationDO updateObj = BeanUtils.toBean(updateReqVO, InheritorQualificationDO.class);
        qualificationMapper.updateById(updateObj);
    }

    @Override
    public void deleteQualification(Long id) {
        // 校验存在
        validateQualificationExists(id);
        // 删除
        qualificationMapper.deleteById(id);
    }

    @Override
    public InheritorQualificationDO getQualification(Long id) {
        return qualificationMapper.selectById(id);
    }

    @Override
    public PageResult<InheritorQualificationDO> getQualificationPage(InheritorQualificationPageReqVO pageReqVO) {
        return qualificationMapper.selectPage(pageReqVO);
    }

    @Override
    public List<InheritorQualificationDO> getQualificationListByInheritorId(Long inheritorId) {
        // 父传承人公开可见（已启用+已通过审核+展示中）才返回荣誉/资质；不可见时返回空列表，避免子数据泄露
        if (inheritorService.getPublicInheritor(inheritorId) == null) {
            return new ArrayList<>();
        }
        return qualificationMapper.selectListByInheritorId(inheritorId);
    }

    private void validateQualificationExists(Long id) {
        if (qualificationMapper.selectById(id) == null) {
            throw exception(INHERITOR_QUALIFICATION_NOT_EXISTS);
        }
    }

}
