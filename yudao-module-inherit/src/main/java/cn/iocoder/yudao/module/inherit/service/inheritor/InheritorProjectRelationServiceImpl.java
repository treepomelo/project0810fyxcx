package cn.iocoder.yudao.module.inherit.service.inheritor;

import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.common.util.object.BeanUtils;
import cn.iocoder.yudao.module.inherit.controller.admin.inheritor.vo.InheritorProjectRelationPageReqVO;
import cn.iocoder.yudao.module.inherit.controller.admin.inheritor.vo.InheritorProjectRelationSaveReqVO;
import cn.iocoder.yudao.module.inherit.dal.dataobject.inheritor.InheritorProjectRelationDO;
import cn.iocoder.yudao.module.inherit.dal.mysql.inheritor.InheritorProjectRelationMapper;
import org.springframework.stereotype.Service;
import org.springframework.validation.annotation.Validated;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

import static cn.iocoder.yudao.framework.common.exception.util.ServiceExceptionUtil.exception;
import static cn.iocoder.yudao.module.inherit.enums.ErrorCodeConstants.INHERITOR_PROJECT_RELATION_DUPLICATE;
import static cn.iocoder.yudao.module.inherit.enums.ErrorCodeConstants.INHERITOR_PROJECT_RELATION_NOT_EXISTS;

/**
 * 传承人-非遗项目 关系 Service 实现类
 *
 * @author inherit
 */
@Service
@Validated
public class InheritorProjectRelationServiceImpl implements InheritorProjectRelationService {

    @Resource
    private InheritorProjectRelationMapper projectRelationMapper;
    @Resource
    private InheritorService inheritorService;

    @Override
    public Long createProjectRelation(InheritorProjectRelationSaveReqVO createReqVO) {
        // 校验传承人存在
        inheritorService.validateInheritorExists(createReqVO.getInheritorId());
        // 校验关系未重复（inheritor_id + project_id 唯一）
        validateProjectRelationExists(null, createReqVO.getInheritorId(), createReqVO.getProjectId());
        // 插入
        InheritorProjectRelationDO relation = BeanUtils.toBean(createReqVO, InheritorProjectRelationDO.class);
        projectRelationMapper.insert(relation);
        return relation.getId();
    }

    @Override
    public void updateProjectRelation(InheritorProjectRelationSaveReqVO updateReqVO) {
        // 校验存在
        validateProjectRelationExistsById(updateReqVO.getId());
        // 校验关系未重复（排除自身）
        validateProjectRelationExists(updateReqVO.getId(), updateReqVO.getInheritorId(), updateReqVO.getProjectId());
        // 更新
        InheritorProjectRelationDO updateObj = BeanUtils.toBean(updateReqVO, InheritorProjectRelationDO.class);
        projectRelationMapper.updateById(updateObj);
    }

    @Override
    public void deleteProjectRelation(Long id) {
        // 校验存在
        validateProjectRelationExistsById(id);
        // 删除
        projectRelationMapper.deleteById(id);
    }

    @Override
    public InheritorProjectRelationDO getProjectRelation(Long id) {
        return projectRelationMapper.selectById(id);
    }

    @Override
    public PageResult<InheritorProjectRelationDO> getProjectRelationPage(InheritorProjectRelationPageReqVO pageReqVO) {
        return projectRelationMapper.selectPage(pageReqVO);
    }

    @Override
    public List<InheritorProjectRelationDO> getProjectRelationListByInheritorId(Long inheritorId) {
        // 父传承人公开可见（已启用+已通过审核+展示中）才返回项目关系；不可见时返回空列表，避免子数据泄露
        if (inheritorService.getPublicInheritor(inheritorId) == null) {
            return new ArrayList<>();
        }
        return projectRelationMapper.selectListByInheritorId(inheritorId);
    }

    /**
     * 校验关系是否重复；excludeId 用于更新场景排除自身
     */
    private void validateProjectRelationExists(Long excludeId, Long inheritorId, Long projectId) {
        InheritorProjectRelationDO relation = projectRelationMapper.selectByInheritorIdAndProjectId(inheritorId, projectId);
        if (relation != null && !Objects.equals(relation.getId(), excludeId)) {
            throw exception(INHERITOR_PROJECT_RELATION_DUPLICATE);
        }
    }

    private void validateProjectRelationExistsById(Long id) {
        if (projectRelationMapper.selectById(id) == null) {
            throw exception(INHERITOR_PROJECT_RELATION_NOT_EXISTS);
        }
    }

}
