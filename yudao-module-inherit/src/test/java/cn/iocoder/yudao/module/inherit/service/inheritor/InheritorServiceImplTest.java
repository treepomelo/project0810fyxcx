package cn.iocoder.yudao.module.inherit.service.inheritor;

import cn.iocoder.yudao.framework.common.enums.CommonStatusEnum;
import cn.iocoder.yudao.framework.test.core.ut.BaseDbUnitTest;
import cn.iocoder.yudao.module.inherit.dal.dataobject.inheritor.InheritorDO;
import cn.iocoder.yudao.module.inherit.dal.mysql.inheritor.InheritorMapper;
import org.junit.jupiter.api.Test;
import org.springframework.context.annotation.Import;

import javax.annotation.Resource;

import static cn.iocoder.yudao.framework.test.core.util.AssertUtils.assertServiceException;
import static cn.iocoder.yudao.framework.test.core.util.RandomUtils.randomPojo;
import static cn.iocoder.yudao.module.inherit.enums.ErrorCodeConstants.INHERITOR_NOT_EXISTS;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertNull;

/**
 * {@link InheritorServiceImpl} 的单元测试类
 *
 * 覆盖 P1 修复的核心：App 公开可见性过滤（已启用 + 已通过审核 + 展示中）。
 * 用例：
 *   1. 已审核 + 展示 + 启用 → App 详情可访问
 *   2. 未审核 → App 详情不可访问（抛「传承人不存在」）
 *   3. 已审核但未展示 → App 详情不可访问
 *   4. 已停用 → App 详情不可访问
 *   5. 已删除 → App 详情不可访问
 *   11. 管理后台校验（validateInheritorExists）不受公开过滤影响，仍可查看未审核/未展示/停用
 */
@Import(InheritorServiceImpl.class)
public class InheritorServiceImplTest extends BaseDbUnitTest {

    @Resource
    private InheritorServiceImpl inheritorService;

    @Resource
    private InheritorMapper inheritorMapper;

    /**
     * 构建一个公开可见（已启用 + 已通过审核 + 展示中）的传承人
     */
    private InheritorDO buildPublicInheritor() {
        return randomPojo(InheritorDO.class, o -> {
            o.setStatus(CommonStatusEnum.ENABLE.getStatus());
            o.setAuditStatus(InheritorDO.AUDIT_STATUS_SUCCESS);
            o.setDisplayStatus(1);
        });
    }

    @Test
    public void testGetPublicInheritor_success() {
        // 准备：公开可见的传承人
        InheritorDO inheritor = buildPublicInheritor();
        inheritorMapper.insert(inheritor);
        // 调用并断言：详情可访问
        assertNotNull(inheritorService.getPublicInheritor(inheritor.getId()));
        assertNotNull(inheritorService.validateInheritorPublicExists(inheritor.getId()));
    }

    @Test
    public void testValidateInheritorPublicExists_notAudit() {
        // 准备：未审核（AUDIT_STATUS_INIT）
        InheritorDO inheritor = randomPojo(InheritorDO.class, o -> {
            o.setStatus(CommonStatusEnum.ENABLE.getStatus());
            o.setAuditStatus(InheritorDO.AUDIT_STATUS_INIT);
            o.setDisplayStatus(1);
        });
        inheritorMapper.insert(inheritor);
        // 调用并断言：不可访问，抛出「传承人不存在」
        assertNull(inheritorService.getPublicInheritor(inheritor.getId()));
        assertServiceException(() -> inheritorService.validateInheritorPublicExists(inheritor.getId()), INHERITOR_NOT_EXISTS);
    }

    @Test
    public void testValidateInheritorPublicExists_notDisplay() {
        // 准备：已通过审核但未展示（displayStatus=0）
        InheritorDO inheritor = randomPojo(InheritorDO.class, o -> {
            o.setStatus(CommonStatusEnum.ENABLE.getStatus());
            o.setAuditStatus(InheritorDO.AUDIT_STATUS_SUCCESS);
            o.setDisplayStatus(0);
        });
        inheritorMapper.insert(inheritor);
        // 调用并断言：不可访问
        assertNull(inheritorService.getPublicInheritor(inheritor.getId()));
        assertServiceException(() -> inheritorService.validateInheritorPublicExists(inheritor.getId()), INHERITOR_NOT_EXISTS);
    }

    @Test
    public void testValidateInheritorPublicExists_disabled() {
        // 准备：已停用（status=DISABLE）
        InheritorDO inheritor = randomPojo(InheritorDO.class, o -> {
            o.setStatus(CommonStatusEnum.DISABLE.getStatus());
            o.setAuditStatus(InheritorDO.AUDIT_STATUS_SUCCESS);
            o.setDisplayStatus(1);
        });
        inheritorMapper.insert(inheritor);
        // 调用并断言：不可访问
        assertNull(inheritorService.getPublicInheritor(inheritor.getId()));
        assertServiceException(() -> inheritorService.validateInheritorPublicExists(inheritor.getId()), INHERITOR_NOT_EXISTS);
    }

    @Test
    public void testValidateInheritorPublicExists_deleted() {
        // 准备：先插入公开可见的传承人，再逻辑删除
        InheritorDO inheritor = buildPublicInheritor();
        inheritorMapper.insert(inheritor);
        inheritorMapper.deleteById(inheritor.getId());
        // 调用并断言：不可访问
        assertNull(inheritorService.getPublicInheritor(inheritor.getId()));
        assertServiceException(() -> inheritorService.validateInheritorPublicExists(inheritor.getId()), INHERITOR_NOT_EXISTS);
    }

    @Test
    public void testValidateInheritorExists_adminStillVisible() {
        // 管理后台：未审核、未展示、停用的传承人仍应可查看（公开过滤不影响管理后台）
        InheritorDO inheritor = randomPojo(InheritorDO.class, o -> {
            o.setStatus(CommonStatusEnum.DISABLE.getStatus());
            o.setAuditStatus(InheritorDO.AUDIT_STATUS_INIT);
            o.setDisplayStatus(0);
        });
        inheritorMapper.insert(inheritor);
        // 调用并断言：管理后台校验存在且可获取，不受公开过滤影响
        assertNotNull(inheritorService.validateInheritorExists(inheritor.getId()));
        assertNotNull(inheritorService.getInheritor(inheritor.getId()));
        // 对比：App 公开校验则不可访问
        assertNull(inheritorService.getPublicInheritor(inheritor.getId()));
    }

}
