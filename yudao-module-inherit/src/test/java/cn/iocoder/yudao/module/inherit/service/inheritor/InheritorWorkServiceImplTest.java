package cn.iocoder.yudao.module.inherit.service.inheritor;

import cn.iocoder.yudao.framework.common.enums.CommonStatusEnum;
import cn.iocoder.yudao.framework.test.core.ut.BaseDbUnitTest;
import cn.iocoder.yudao.module.inherit.dal.dataobject.inheritor.InheritorDO;
import cn.iocoder.yudao.module.inherit.dal.dataobject.inheritor.InheritorWorkDO;
import cn.iocoder.yudao.module.inherit.dal.mysql.inheritor.InheritorMapper;
import cn.iocoder.yudao.module.inherit.dal.mysql.inheritor.InheritorWorkMapper;
import org.junit.jupiter.api.Test;
import org.springframework.context.annotation.Import;

import javax.annotation.Resource;
import java.util.List;

import static cn.iocoder.yudao.framework.test.core.util.RandomUtils.randomPojo;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

/**
 * {@link InheritorWorkServiceImpl} 的单元测试类
 *
 * 覆盖 P1 修复用例：
 *   6. 父传承人不可见 → works 不返回任何数据（空列表）
 *   9. 子作品停用 → 不返回
 */
@Import({InheritorWorkServiceImpl.class, InheritorServiceImpl.class})
public class InheritorWorkServiceImplTest extends BaseDbUnitTest {

    @Resource
    private InheritorWorkServiceImpl workService;

    @Resource
    private InheritorMapper inheritorMapper;

    @Resource
    private InheritorWorkMapper workMapper;

    @Test
    public void testGetWorkListByInheritorId_disabledFilteredOut() {
        // 准备：公开传承人
        InheritorDO inheritor = randomPojo(InheritorDO.class, o -> {
            o.setStatus(CommonStatusEnum.ENABLE.getStatus());
            o.setAuditStatus(InheritorDO.AUDIT_STATUS_SUCCESS);
            o.setDisplayStatus(1);
        });
        inheritorMapper.insert(inheritor);
        // 准备：1 个启用作品 + 1 个停用作品（year 置空，避免 H2 关键字列参与 insert）
        InheritorWorkDO enableWork = randomPojo(InheritorWorkDO.class, o -> {
            o.setInheritorId(inheritor.getId());
            o.setStatus(CommonStatusEnum.ENABLE.getStatus());
            o.setYear(null);
        });
        InheritorWorkDO disableWork = randomPojo(InheritorWorkDO.class, o -> {
            o.setInheritorId(inheritor.getId());
            o.setStatus(CommonStatusEnum.DISABLE.getStatus());
            o.setYear(null);
        });
        workMapper.insert(enableWork);
        workMapper.insert(disableWork);

        // 调用
        List<InheritorWorkDO> list = workService.getWorkListByInheritorId(inheritor.getId());
        // 断言：只返回启用作品，停用作品被过滤
        assertEquals(1, list.size());
        assertEquals(enableWork.getId(), list.get(0).getId());
    }

    @Test
    public void testGetWorkListByInheritorId_parentNotPublic_returnEmpty() {
        // 准备：未审核（App 不可见）的传承人，且有子作品（启用）
        InheritorDO inheritor = randomPojo(InheritorDO.class, o -> {
            o.setStatus(CommonStatusEnum.ENABLE.getStatus());
            o.setAuditStatus(InheritorDO.AUDIT_STATUS_INIT);
            o.setDisplayStatus(1);
        });
        inheritorMapper.insert(inheritor);
        workMapper.insert(randomPojo(InheritorWorkDO.class, o -> {
            o.setInheritorId(inheritor.getId());
            o.setStatus(CommonStatusEnum.ENABLE.getStatus());
            o.setYear(null);
        }));

        // 调用并断言：父传承人不可见 → 返回空列表，不泄露子数据
        assertTrue(workService.getWorkListByInheritorId(inheritor.getId()).isEmpty());
    }

}
