package cn.iocoder.yudao.module.inherit.service.inheritor;

import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.common.util.object.BeanUtils;
import cn.iocoder.yudao.module.inherit.controller.admin.inheritor.vo.InheritorWorkPageReqVO;
import cn.iocoder.yudao.module.inherit.controller.admin.inheritor.vo.InheritorWorkSaveReqVO;
import cn.iocoder.yudao.module.inherit.dal.dataobject.inheritor.InheritorWorkDO;
import cn.iocoder.yudao.module.inherit.dal.mysql.inheritor.InheritorWorkMapper;
import org.springframework.stereotype.Service;
import org.springframework.validation.annotation.Validated;

import jakarta.annotation.Resource;
import java.util.ArrayList;
import java.util.List;

import static cn.iocoder.yudao.framework.common.exception.util.ServiceExceptionUtil.exception;
import static cn.iocoder.yudao.module.inherit.enums.ErrorCodeConstants.INHERITOR_WORK_NOT_EXISTS;

/**
 * 传承人作品 Service 实现类
 *
 * @author inherit
 */
@Service
@Validated
public class InheritorWorkServiceImpl implements InheritorWorkService {

    @Resource
    private InheritorWorkMapper workMapper;
    @Resource
    private InheritorService inheritorService;

    @Override
    public Long createWork(InheritorWorkSaveReqVO createReqVO) {
        validateStatus(createReqVO.getStatus());
        // 校验传承人存在
        inheritorService.validateInheritorExists(createReqVO.getInheritorId());
        // 插入
        InheritorWorkDO work = BeanUtils.toBean(createReqVO, InheritorWorkDO.class);
        workMapper.insert(work);
        return work.getId();
    }

    @Override
    public void updateWork(InheritorWorkSaveReqVO updateReqVO) {
        validateStatus(updateReqVO.getStatus());
        inheritorService.validateInheritorExists(updateReqVO.getInheritorId());
        // 校验存在
        validateWorkExists(updateReqVO.getId());
        // 更新
        InheritorWorkDO updateObj = BeanUtils.toBean(updateReqVO, InheritorWorkDO.class);
        workMapper.updateById(updateObj);
    }

    @Override
    public void deleteWork(Long id) {
        // 校验存在
        validateWorkExists(id);
        // 删除
        workMapper.deleteById(id);
    }

    @Override
    public InheritorWorkDO getWork(Long id) {
        return workMapper.selectById(id);
    }

    @Override
    public PageResult<InheritorWorkDO> getWorkPage(InheritorWorkPageReqVO pageReqVO) {
        return workMapper.selectPage(pageReqVO);
    }

    @Override
    public List<InheritorWorkDO> getWorkListByInheritorId(Long inheritorId) {
        // 父传承人公开可见（已启用+已通过审核+展示中）才返回作品；不可见时返回空列表，避免子数据泄露
        if (inheritorService.getPublicInheritor(inheritorId) == null) {
            return new ArrayList<>();
        }
        return workMapper.selectListByInheritorId(inheritorId);
    }

    private void validateStatus(Integer status) {
        if (status != null && status != 0 && status != 1) throw exception(cn.iocoder.yudao.module.inherit.enums.ErrorCodeConstants.INHERITOR_STATUS_INVALID);
    }

    private void validateWorkExists(Long id) {
        if (workMapper.selectById(id) == null) {
            throw exception(INHERITOR_WORK_NOT_EXISTS);
        }
    }

}
