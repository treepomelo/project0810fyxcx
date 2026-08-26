package cn.iocoder.yudao.module.inherit.service.inheritor;

import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.module.heritage.dal.dataobject.HeritageServiceDO;
import cn.iocoder.yudao.module.heritage.dal.dataobject.ProductSystemDO;
import cn.iocoder.yudao.module.heritage.dal.mysql.HeritageServiceMapper;
import cn.iocoder.yudao.module.heritage.dal.mysql.ProductSystemMapper;
import cn.iocoder.yudao.framework.common.util.object.BeanUtils;
import cn.iocoder.yudao.module.inherit.controller.admin.inheritor.vo.InheritorServiceRelationPageReqVO;
import cn.iocoder.yudao.module.inherit.controller.admin.inheritor.vo.InheritorServiceRelationSaveReqVO;
import cn.iocoder.yudao.module.inherit.controller.app.inheritor.vo.AppInheritorServiceRespVO;
import cn.iocoder.yudao.module.inherit.dal.dataobject.inheritor.InheritorServiceRelationDO;
import cn.iocoder.yudao.module.inherit.dal.mysql.inheritor.InheritorServiceRelationMapper;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Service;
import org.springframework.validation.annotation.Validated;
import jakarta.annotation.Resource;
import java.util.List;
import java.util.Objects;
import static cn.iocoder.yudao.framework.common.exception.util.ServiceExceptionUtil.exception;
import static cn.iocoder.yudao.module.inherit.enums.ErrorCodeConstants.*;
import static cn.iocoder.yudao.framework.security.core.util.SecurityFrameworkUtils.getLoginUserId;

@Service
@Validated
public class InheritorServiceRelationServiceImpl implements InheritorServiceRelationService {
    @Resource private InheritorServiceRelationMapper relationMapper;
    @Resource private InheritorService inheritorService;
    @Resource private HeritageServiceMapper heritageServiceMapper;
    @Resource private ProductSystemMapper productSystemMapper;

    @Override
    public Long createServiceRelation(InheritorServiceRelationSaveReqVO req) {
        inheritorService.validateInheritorExists(req.getInheritorId());
        validateService(req.getServiceId());
        validateStatus(req.getStatus());
        InheritorServiceRelationDO existing = relationMapper.selectAny(req.getInheritorId(), req.getServiceId());
        if (existing != null && !Boolean.TRUE.equals(existing.getDeleted())) throw exception(INHERITOR_SERVICE_RELATION_DUPLICATE);
        Integer sort = req.getSort() == null ? 0 : req.getSort(); Integer status = req.getStatus() == null ? 1 : req.getStatus(); Boolean representative = Boolean.TRUE.equals(req.getIsRepresentative());
        if (existing != null) {
            if (relationMapper.revive(existing.getId(), representative, sort, status, operator()) != 1) throw exception(INHERITOR_SERVICE_RELATION_DUPLICATE);
            return existing.getId();
        }
        InheritorServiceRelationDO relation = BeanUtils.toBean(req, InheritorServiceRelationDO.class);
        relation.setIsRepresentative(representative); relation.setSort(sort); relation.setStatus(status);
        try { relationMapper.insert(relation); } catch (DuplicateKeyException ex) { throw exception(INHERITOR_SERVICE_RELATION_DUPLICATE); }
        return relation.getId();
    }

    @Override
    public void updateServiceRelation(InheritorServiceRelationSaveReqVO req) {
        InheritorServiceRelationDO current = requireActive(req.getId());
        inheritorService.validateInheritorExists(req.getInheritorId()); validateService(req.getServiceId()); validateStatus(req.getStatus());
        InheritorServiceRelationDO duplicate = relationMapper.selectAny(req.getInheritorId(), req.getServiceId());
        if (duplicate != null && !Objects.equals(duplicate.getId(), req.getId()) && !Boolean.TRUE.equals(duplicate.getDeleted())) throw exception(INHERITOR_SERVICE_RELATION_DUPLICATE);
        if (relationMapper.updateRelation(req.getId(), req.getInheritorId(), req.getServiceId(), Boolean.TRUE.equals(req.getIsRepresentative()), req.getSort() == null ? current.getSort() : req.getSort(), req.getStatus() == null ? current.getStatus() : req.getStatus(), operator()) != 1) throw exception(INHERITOR_SERVICE_RELATION_NOT_EXISTS);
    }

    @Override public void deleteServiceRelation(Long id) { requireActive(id); if (relationMapper.deleteById(id) != 1) throw exception(INHERITOR_SERVICE_RELATION_NOT_EXISTS); }
    @Override public InheritorServiceRelationDO getServiceRelation(Long id) { return relationMapper.selectById(id); }
    @Override public PageResult<InheritorServiceRelationDO> getServiceRelationPage(InheritorServiceRelationPageReqVO req) { return relationMapper.selectPage(req); }
    @Override public void deleteByInheritorId(Long inheritorId) { relationMapper.deleteByInheritorId(inheritorId); }

    @Override
    public List<AppInheritorServiceRespVO> getPublicServices(Long inheritorId) {
        inheritorService.validateInheritorPublicExists(inheritorId);
        return relationMapper.selectActiveByInheritorId(inheritorId).stream().map(relation -> {
            HeritageServiceDO service = heritageServiceMapper.selectPublicById(relation.getServiceId());
            if (service == null) return null;
            ProductSystemDO system = productSystemMapper.selectById(service.getProductSystemId());
            AppInheritorServiceRespVO vo = new AppInheritorServiceRespVO();
            vo.setServiceId(service.getId()); vo.setTitle(service.getTitle()); vo.setCoverUrl(service.getCoverUrl()); vo.setSummary(service.getSummary()); vo.setPrice(service.getPrice()); vo.setCity(service.getCity()); vo.setLocation(service.getLocation()); vo.setBookingEnabled(service.getBookingEnabled()); vo.setIsRepresentative(relation.getIsRepresentative()); vo.setSort(relation.getSort());
            if (system != null) { vo.setSystemCode(system.getCode()); vo.setSystemName(system.getName()); }
            return vo;
        }).filter(Objects::nonNull).toList();
    }

    private void validateService(Long serviceId) { HeritageServiceDO service = heritageServiceMapper.selectById(serviceId); if (service == null || !Objects.equals(service.getStatus(), 1)) throw exception(INHERITOR_SERVICE_NOT_EXISTS); }
    private InheritorServiceRelationDO requireActive(Long id) { InheritorServiceRelationDO relation = relationMapper.selectById(id); if (relation == null) throw exception(INHERITOR_SERVICE_RELATION_NOT_EXISTS); return relation; }
    private void validateStatus(Integer status) { if (status != null && status != 0 && status != 1) throw exception(INHERITOR_RELATION_STATUS_INVALID); }
    private String operator() { Long id = getLoginUserId(); return id == null ? "0" : String.valueOf(id); }
}