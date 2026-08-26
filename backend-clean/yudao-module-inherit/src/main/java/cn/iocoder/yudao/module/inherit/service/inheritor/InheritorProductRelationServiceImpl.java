package cn.iocoder.yudao.module.inherit.service.inheritor;

import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.common.util.object.BeanUtils;
import cn.iocoder.yudao.module.inherit.controller.admin.inheritor.vo.InheritorProductRelationPageReqVO;
import cn.iocoder.yudao.module.inherit.controller.admin.inheritor.vo.InheritorProductRelationSaveReqVO;
import cn.iocoder.yudao.module.inherit.controller.app.inheritor.vo.AppInheritorProductRespVO;
import cn.iocoder.yudao.module.inherit.dal.dataobject.inheritor.InheritorProductRelationDO;
import cn.iocoder.yudao.module.inherit.dal.mysql.inheritor.InheritorProductRelationMapper;
import cn.iocoder.yudao.module.product.api.spu.ProductSpuApi;
import cn.iocoder.yudao.module.product.api.spu.dto.ProductSpuRespDTO;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Service;
import static cn.iocoder.yudao.framework.security.core.util.SecurityFrameworkUtils.getLoginUserId;
import org.springframework.validation.annotation.Validated;
import jakarta.annotation.Resource;
import java.util.List;
import java.util.Objects;
import static cn.iocoder.yudao.framework.common.exception.util.ServiceExceptionUtil.exception;
import static cn.iocoder.yudao.module.inherit.enums.ErrorCodeConstants.*;

@Service
@Validated
public class InheritorProductRelationServiceImpl implements InheritorProductRelationService {
    @Resource private InheritorProductRelationMapper relationMapper;
    @Resource private InheritorService inheritorService;
    @Resource private ProductSpuApi productSpuApi;

    @Override
    public Long createProductRelation(InheritorProductRelationSaveReqVO req) {
        inheritorService.validateInheritorExists(req.getInheritorId());
        ProductSpuRespDTO spu = validateSpu(req.getSpuId());
        validateStatus(req.getStatus());
        InheritorProductRelationDO existing = relationMapper.selectAny(req.getInheritorId(), req.getSpuId());
        if (existing != null && !Boolean.TRUE.equals(existing.getDeleted())) throw exception(INHERITOR_PRODUCT_RELATION_DUPLICATE);
        Integer sort = req.getSort() == null ? 0 : req.getSort();
        Integer status = req.getStatus() == null ? 1 : req.getStatus();
        Boolean representative = Boolean.TRUE.equals(req.getIsRepresentative());
        if (existing != null) {
            if (relationMapper.revive(existing.getId(), representative, sort, status, String.valueOf(currentOperator())) != 1) throw exception(INHERITOR_PRODUCT_RELATION_DUPLICATE);
            return existing.getId();
        }
        InheritorProductRelationDO relation = BeanUtils.toBean(req, InheritorProductRelationDO.class);
        relation.setIsRepresentative(representative); relation.setSort(sort); relation.setStatus(status);
        try { relationMapper.insert(relation); } catch (DuplicateKeyException ex) { throw exception(INHERITOR_PRODUCT_RELATION_DUPLICATE); }
        return relation.getId();
    }

    @Override
    public void updateProductRelation(InheritorProductRelationSaveReqVO req) {
        InheritorProductRelationDO current = requireActive(req.getId());
        inheritorService.validateInheritorExists(req.getInheritorId());
        validateSpu(req.getSpuId());
        validateStatus(req.getStatus());
        InheritorProductRelationDO duplicate = relationMapper.selectAny(req.getInheritorId(), req.getSpuId());
        if (duplicate != null && !Objects.equals(duplicate.getId(), req.getId()) && !Boolean.TRUE.equals(duplicate.getDeleted())) throw exception(INHERITOR_PRODUCT_RELATION_DUPLICATE);
        if (relationMapper.updateRelation(req.getId(), req.getInheritorId(), req.getSpuId(), Boolean.TRUE.equals(req.getIsRepresentative()), req.getSort() == null ? current.getSort() : req.getSort(), req.getStatus() == null ? current.getStatus() : req.getStatus(), String.valueOf(currentOperator())) != 1) throw exception(INHERITOR_PRODUCT_RELATION_NOT_EXISTS);
    }

    @Override public void deleteProductRelation(Long id) { requireActive(id); if (relationMapper.deleteById(id) != 1) throw exception(INHERITOR_PRODUCT_RELATION_NOT_EXISTS); }
    @Override public InheritorProductRelationDO getProductRelation(Long id) { return relationMapper.selectById(id); }
    @Override public PageResult<InheritorProductRelationDO> getProductRelationPage(InheritorProductRelationPageReqVO req) { return relationMapper.selectPage(req); }
    @Override public void deleteByInheritorId(Long inheritorId) { relationMapper.deleteByInheritorId(inheritorId); }

    @Override
    public List<AppInheritorProductRespVO> getPublicProducts(Long inheritorId) {
        inheritorService.validateInheritorPublicExists(inheritorId);
        return relationMapper.selectActiveByInheritorId(inheritorId).stream().map(relation -> {
            ProductSpuRespDTO spu = productSpuApi.getSpu(relation.getSpuId());
            if (spu == null || !Objects.equals(spu.getStatus(), 1)) return null;
            AppInheritorProductRespVO vo = new AppInheritorProductRespVO();
            vo.setSpuId(spu.getId()); vo.setName(spu.getName()); vo.setPicUrl(spu.getPicUrl()); vo.setPrice(spu.getPrice()); vo.setMarketPrice(spu.getMarketPrice()); vo.setStock(spu.getStock()); vo.setIntroduction(null); vo.setIsRepresentative(relation.getIsRepresentative()); vo.setSort(relation.getSort());
            return vo;
        }).filter(Objects::nonNull).toList();
    }

    private ProductSpuRespDTO validateSpu(Long spuId) {
        List<ProductSpuRespDTO> list = productSpuApi.validateSpuList(List.of(spuId));
        return list.isEmpty() ? null : list.get(0);
    }
    private InheritorProductRelationDO requireActive(Long id) { InheritorProductRelationDO relation = relationMapper.selectById(id); if (relation == null) throw exception(INHERITOR_PRODUCT_RELATION_NOT_EXISTS); return relation; }
    private void validateStatus(Integer status) { if (status != null && status != 0 && status != 1) throw exception(INHERITOR_RELATION_STATUS_INVALID); }
    private Long currentOperator() { Long id = getLoginUserId(); return id == null ? 0L : id; }
}