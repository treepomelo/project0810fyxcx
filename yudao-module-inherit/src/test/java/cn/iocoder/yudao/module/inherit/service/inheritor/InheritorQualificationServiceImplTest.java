package cn.iocoder.yudao.module.inherit.service.inheritor;

import cn.iocoder.yudao.framework.common.enums.CommonStatusEnum;
import cn.iocoder.yudao.framework.test.core.ut.BaseDbUnitTest;
import cn.iocoder.yudao.module.inherit.dal.dataobject.inheritor.InheritorDO;
import cn.iocoder.yudao.module.inherit.dal.dataobject.inheritor.InheritorQualificationDO;
import cn.iocoder.yudao.module.inherit.dal.mysql.inheritor.InheritorMapper;
import cn.iocoder.yudao.module.inherit.dal.mysql.inheritor.InheritorQualificationMapper;
import org.junit.jupiter.api.Test;
import org.springframework.context.annotation.Import;

import javax.annotation.Resource;
import java.util.List;

import static cn.iocoder.yudao.framework.test.core.util.RandomUtils.randomPojo;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

/**
 * {@link InheritorQualificationServiceImpl} 的单元测试类
 *
 * 覆盖 P1 修复用例：
 *   7. 父传承人不可见 → qualifications 不返回任何数据（空列表）
 *   10. 子资质停用 → 不返回
 */
@Import({InheritorQualificationServiceImpl.class, InheritorServiceImpl.class})
public class InheritorQualificationServiceImplTest extends BaseDbUnitTest {

    @Resource
    private InheritorQualificationServiceImpl qualificationService;

    @Resource
    private InheritorMapper inheritorMapper;

    @Resource
    private InheritorQualificationMapper qualificationMapper;

    @Test
    public void testGetQualificationListByInheritorId_disabledFilteredOut() {
        // 准备：公开传承人
        InheritorDO inheritor = randomPojo(InheritorDO.class, o -> {
            o.setStatus(CommonStatusEnum.ENABLE.getStatus());
            o.setAuditStatus(InheritorDO.AUDIT_STATUS_SUCCESS);
            o.setDisplayStatus(1);
        });
        inheritorMapper.insert(inheritor);
        // 准备：1 个启用资质 + 1 个停用资质
        InheritorQualificationDO enableQualification = randomPojo(InheritorQualificationDO.class, o -> {
            o.setInheritorId(inheritor.getId());
            o.setStatus(CommonStatusEnum.ENABLE.getStatus());
        });
        InheritorQualificationDO disableQualification = randomPojo(InheritorQualificationDO.class, o -> {
            o.setInheritorId(inheritor.getId());
            o.setStatus(CommonStatusEnum.DISABLE.getStatus());
        });
        qualificationMapper.insert(enableQualification);
        qualificationMapper.insert(disableQualification);

        // 调用
        List<InheritorQualificationDO> list = qualificationService.getQualificationListByInheritorId(inheritor.getId());
        // 断言：只返回启用资质，停用资质被过滤
        assertEquals(1, list.size());
        assertEquals(enableQualification.getId(), list.get(0).getId());
    }

    @Test
    public void testGetQualificationListByInheritorId_parentNotPublic_returnEmpty() {
        // 准备：未展示（App 不可见）的传承人，且有子资质（启用）
        InheritorDO inheritor = randomPojo(InheritorDO.class, o -> {
            o.setStatus(CommonStatusEnum.ENABLE.getStatus());
            o.setAuditStatus(InheritorDO.AUDIT_STATUS_SUCCESS);
            o.setDisplayStatus(0);
        });
        inheritorMapper.insert(inheritor);
        qualificationMapper.insert(randomPojo(InheritorQualificationDO.class, o -> {
            o.setInheritorId(inheritor.getId());
            o.setStatus(CommonStatusEnum.ENABLE.getStatus());
        }));

        // 调用并断言：父传承人不可见 → 返回空列表，不泄露子数据
        assertTrue(qualificationService.getQualificationListByInheritorId(inheritor.getId()).isEmpty());
    }

}
