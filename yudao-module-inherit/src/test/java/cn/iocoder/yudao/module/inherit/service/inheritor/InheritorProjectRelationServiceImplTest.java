package cn.iocoder.yudao.module.inherit.service.inheritor;

import cn.iocoder.yudao.framework.common.enums.CommonStatusEnum;
import cn.iocoder.yudao.framework.test.core.ut.BaseDbUnitTest;
import cn.iocoder.yudao.module.inherit.dal.dataobject.inheritor.InheritorDO;
import cn.iocoder.yudao.module.inherit.dal.dataobject.inheritor.InheritorProjectRelationDO;
import cn.iocoder.yudao.module.inherit.dal.mysql.inheritor.InheritorMapper;
import cn.iocoder.yudao.module.inherit.dal.mysql.inheritor.InheritorProjectRelationMapper;
import org.junit.jupiter.api.Test;
import org.springframework.context.annotation.Import;

import javax.annotation.Resource;
import java.util.List;

import static cn.iocoder.yudao.framework.test.core.util.RandomUtils.randomPojo;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

/**
 * {@link InheritorProjectRelationServiceImpl} 的单元测试类
 *
 * 覆盖 P1 修复用例：
 *   8. 父传承人不可见 → projects 不返回任何数据（空列表）
 */
@Import({InheritorProjectRelationServiceImpl.class, InheritorServiceImpl.class})
public class InheritorProjectRelationServiceImplTest extends BaseDbUnitTest {

    @Resource
    private InheritorProjectRelationServiceImpl projectRelationService;

    @Resource
    private InheritorMapper inheritorMapper;

    @Resource
    private InheritorProjectRelationMapper projectRelationMapper;

    @Test
    public void testGetProjectRelationListByInheritorId_success() {
        // 准备：公开传承人 + 1 条项目关系
        InheritorDO inheritor = randomPojo(InheritorDO.class, o -> {
            o.setStatus(CommonStatusEnum.ENABLE.getStatus());
            o.setAuditStatus(InheritorDO.AUDIT_STATUS_SUCCESS);
            o.setDisplayStatus(1);
        });
        inheritorMapper.insert(inheritor);
        InheritorProjectRelationDO relation = randomPojo(InheritorProjectRelationDO.class, o -> {
            o.setInheritorId(inheritor.getId());
        });
        projectRelationMapper.insert(relation);

        // 调用
        List<InheritorProjectRelationDO> list = projectRelationService.getProjectRelationListByInheritorId(inheritor.getId());
        // 断言：返回关系列表
        assertEquals(1, list.size());
        assertEquals(relation.getId(), list.get(0).getId());
    }

    @Test
    public void testGetProjectRelationListByInheritorId_parentNotPublic_returnEmpty() {
        // 准备：已停用（App 不可见）的传承人，且有项目关系
        InheritorDO inheritor = randomPojo(InheritorDO.class, o -> {
            o.setStatus(CommonStatusEnum.DISABLE.getStatus());
            o.setAuditStatus(InheritorDO.AUDIT_STATUS_SUCCESS);
            o.setDisplayStatus(1);
        });
        inheritorMapper.insert(inheritor);
        projectRelationMapper.insert(randomPojo(InheritorProjectRelationDO.class, o -> {
            o.setInheritorId(inheritor.getId());
        }));

        // 调用并断言：父传承人不可见 → 返回空列表，不泄露子数据
        assertTrue(projectRelationService.getProjectRelationListByInheritorId(inheritor.getId()).isEmpty());
    }

}
