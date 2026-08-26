package cn.iocoder.yudao.module.inherit.service.inheritor;

import cn.hutool.core.collection.CollUtil;
import cn.iocoder.yudao.framework.common.enums.CommonStatusEnum;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.common.util.object.BeanUtils;
import cn.iocoder.yudao.module.inherit.controller.admin.inheritor.vo.InheritorAuditReqVO;
import cn.iocoder.yudao.module.inherit.controller.admin.inheritor.vo.InheritorPageReqVO;
import cn.iocoder.yudao.module.inherit.controller.admin.inheritor.vo.InheritorSaveReqVO;
import cn.iocoder.yudao.module.inherit.controller.app.inheritor.vo.AppInheritorPageReqVO;
import cn.iocoder.yudao.module.inherit.controller.app.inheritor.vo.AppInheritorContactRespVO;
import cn.iocoder.yudao.module.inherit.dal.dataobject.inheritor.InheritorDO;
import cn.iocoder.yudao.module.inherit.dal.mysql.inheritor.InheritorFollowMapper;
import cn.iocoder.yudao.module.inherit.dal.mysql.inheritor.InheritorMapper;
import cn.iocoder.yudao.module.inherit.dal.mysql.inheritor.InheritorProjectRelationMapper;
import cn.iocoder.yudao.module.inherit.dal.mysql.inheritor.InheritorProductRelationMapper;
import cn.iocoder.yudao.module.inherit.dal.mysql.inheritor.InheritorServiceRelationMapper;
import cn.iocoder.yudao.module.inherit.dal.mysql.inheritor.InheritorQualificationMapper;
import cn.iocoder.yudao.module.inherit.dal.mysql.inheritor.InheritorWorkMapper;
import cn.iocoder.yudao.module.inherit.util.PinyinUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.annotation.Validated;

import jakarta.annotation.Resource;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.Objects;

import static cn.iocoder.yudao.framework.common.exception.util.ServiceExceptionUtil.exception;
import static cn.iocoder.yudao.module.inherit.enums.ErrorCodeConstants.INHERITOR_NOT_EXISTS;
import static cn.iocoder.yudao.module.inherit.enums.ErrorCodeConstants.INHERITOR_PHONE_NOT_CONFIGURED;

/**
 * 传承人 Service 实现类
 *
 * @author inherit
 */
@Service
@Validated
public class InheritorServiceImpl implements InheritorService {

    @Resource
    private InheritorMapper inheritorMapper;
    @Resource
    private InheritorQualificationMapper qualificationMapper;
    @Resource
    private InheritorWorkMapper workMapper;
    @Resource
    private InheritorProjectRelationMapper projectRelationMapper;
    @Resource
    private InheritorFollowMapper followMapper;
    @Resource
    private InheritorProductRelationMapper productRelationMapper;
    @Resource
    private InheritorServiceRelationMapper serviceRelationMapper;

    @Override
    public Long createInheritor(InheritorSaveReqVO createReqVO) {
        validateStateValues(createReqVO.getGender(), createReqVO.getDisplayStatus(), createReqVO.getIsRecommend(), createReqVO.getStatus(), null);
        InheritorDO inheritor = BeanUtils.toBean(createReqVO, InheritorDO.class);
        if (inheritor.getAuditStatus() == null) {
            inheritor.setAuditStatus(InheritorDO.AUDIT_STATUS_INIT);
        }
        if (inheritor.getDisplayStatus() == null) {
            inheritor.setDisplayStatus(0);
        }
        if (inheritor.getIsRecommend() == null) {
            inheritor.setIsRecommend(0);
        }
        if (inheritor.getStatus() == null) {
            inheritor.setStatus(CommonStatusEnum.ENABLE.getStatus());
        }
        // 计算姓名拼音，用于拼音搜索
        inheritor.setPinyin(PinyinUtils.toPinyin(inheritor.getName()));
        inheritorMapper.insert(inheritor);
        return inheritor.getId();
    }

    @Override
    public void updateInheritor(InheritorSaveReqVO updateReqVO) {
        validateStateValues(updateReqVO.getGender(), updateReqVO.getDisplayStatus(), updateReqVO.getIsRecommend(), updateReqVO.getStatus(), null);
        // 校验存在
        validateInheritorExists(updateReqVO.getId());
        // 更新
        InheritorDO updateObj = BeanUtils.toBean(updateReqVO, InheritorDO.class);
        // 姓名变更时同步重新计算拼音
        if (updateObj.getName() != null) {
            updateObj.setPinyin(PinyinUtils.toPinyin(updateObj.getName()));
        }
        inheritorMapper.updateById(updateObj);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void deleteInheritor(Long id) {
        // 校验存在
        validateInheritorExists(id);
        // 逻辑删除传承人
        inheritorMapper.deleteById(id);
        // 级联逻辑删除：作品、资质、项目关系、关注（遵循项目逻辑删除规范，不做物理删除）
        workMapper.deleteByInheritorId(id);
        qualificationMapper.deleteByInheritorId(id);
        projectRelationMapper.deleteByInheritorId(id);
        followMapper.deleteByInheritorId(id);
        productRelationMapper.deleteByInheritorId(id);
        serviceRelationMapper.deleteByInheritorId(id);
    }

    @Override
    public InheritorDO getInheritor(Long id) {
        return inheritorMapper.selectById(id);
    }

    @Override
    public PageResult<InheritorDO> getInheritorPage(InheritorPageReqVO pageReqVO) {
        return inheritorMapper.selectPage(pageReqVO);
    }

    @Override
    public void updateAudit(InheritorAuditReqVO auditReqVO) {
        validateAuditStatus(auditReqVO.getAuditStatus());
        // 校验存在
        InheritorDO dbInheritor = validateInheritorExists(auditReqVO.getId());
        // 更新审核信息
        InheritorDO updateObj = new InheritorDO();
        updateObj.setId(auditReqVO.getId());
        updateObj.setAuditStatus(auditReqVO.getAuditStatus());
        updateObj.setAuditRemark(auditReqVO.getAuditRemark());
        updateObj.setAuditTime(LocalDateTime.now());
        // 审核通过且处于展示中时，记录上架时间
        if (Objects.equals(auditReqVO.getAuditStatus(), InheritorDO.AUDIT_STATUS_SUCCESS)
                && Objects.equals(dbInheritor.getDisplayStatus(), 1)) {
            updateObj.setPublishedAt(LocalDateTime.now());
        }
        inheritorMapper.updateById(updateObj);
    }

    @Override
    public PageResult<InheritorDO> getInheritorAppPage(AppInheritorPageReqVO pageReqVO) {
        return inheritorMapper.selectAppPage(pageReqVO);
    }

    @Override
    public List<InheritorDO> getInheritorList(Collection<Long> ids) {
        if (CollUtil.isEmpty(ids)) {
            return new ArrayList<>();
        }
        return inheritorMapper.selectBatchIds(ids);
    }

    @Override
    public InheritorDO validateInheritorExists(Long id) {
        InheritorDO inheritor = inheritorMapper.selectById(id);
        if (inheritor == null) {
            throw exception(INHERITOR_NOT_EXISTS);
        }
        return inheritor;
    }

    @Override
    public InheritorDO getPublicInheritor(Long id) {
        return inheritorMapper.selectPublicInheritor(id);
    }

    @Override
    public InheritorDO validateInheritorPublicExists(Long id) {
        InheritorDO inheritor = getPublicInheritor(id);
        if (inheritor == null) {
            throw exception(INHERITOR_NOT_EXISTS);
        }
        return inheritor;
    }

    private void validateAuditStatus(Integer value) {
        if (value == null || value < InheritorDO.AUDIT_STATUS_INIT || value > InheritorDO.AUDIT_STATUS_FAIL) {
            throw exception(cn.iocoder.yudao.module.inherit.enums.ErrorCodeConstants.INHERITOR_AUDIT_STATUS_INVALID);
        }
    }

    private void validateStateValues(Integer gender, Integer displayStatus, Integer isRecommend, Integer status, Integer auditStatus) {
        if (gender != null && (gender < 0 || gender > 2)) throw exception(cn.iocoder.yudao.module.inherit.enums.ErrorCodeConstants.INHERITOR_GENDER_INVALID);
        if (displayStatus != null && displayStatus != 0 && displayStatus != 1) throw exception(cn.iocoder.yudao.module.inherit.enums.ErrorCodeConstants.INHERITOR_DISPLAY_STATUS_INVALID);
        if (isRecommend != null && isRecommend != 0 && isRecommend != 1) throw exception(cn.iocoder.yudao.module.inherit.enums.ErrorCodeConstants.INHERITOR_RECOMMEND_STATUS_INVALID);
        if (status != null && status != 0 && status != 1) throw exception(cn.iocoder.yudao.module.inherit.enums.ErrorCodeConstants.INHERITOR_STATUS_INVALID);
        if (auditStatus != null) validateAuditStatus(auditStatus);
    }
    @Override
    public AppInheritorContactRespVO getAppInheritorContact(Long id) {
        InheritorDO inheritor = validateInheritorPublicExists(id);
        if (inheritor.getPhone() == null || inheritor.getPhone().trim().isEmpty()) {
            throw exception(INHERITOR_PHONE_NOT_CONFIGURED);
        }
        AppInheritorContactRespVO respVO = new AppInheritorContactRespVO();
        respVO.setPhone(inheritor.getPhone());
        return respVO;
    }

}
