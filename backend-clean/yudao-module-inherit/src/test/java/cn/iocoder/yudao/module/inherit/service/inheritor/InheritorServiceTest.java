package cn.iocoder.yudao.module.inherit.service.inheritor;

import cn.iocoder.yudao.framework.common.exception.ServiceException;
import cn.iocoder.yudao.module.inherit.controller.admin.inheritor.vo.InheritorAuditReqVO;
import cn.iocoder.yudao.module.inherit.controller.admin.inheritor.vo.InheritorSaveReqVO;
import cn.iocoder.yudao.module.inherit.dal.dataobject.inheritor.InheritorDO;
import cn.iocoder.yudao.module.inherit.dal.mysql.inheritor.*;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class InheritorServiceTest {
    @Mock private InheritorMapper inheritorMapper;
    @Mock private InheritorQualificationMapper qualificationMapper;
    @Mock private InheritorWorkMapper workMapper;
    @Mock private InheritorProjectRelationMapper projectRelationMapper;
    @Mock private InheritorFollowMapper followMapper;
    @Mock private InheritorProductRelationMapper productRelationMapper;
    @Mock private InheritorServiceRelationMapper serviceRelationMapper;
    @InjectMocks private InheritorServiceImpl service;

    @Test void deleteInheritor_cascadesAllRelations() {
        when(inheritorMapper.selectById(1L)).thenReturn(new InheritorDO());
        service.deleteInheritor(1L);
        verify(inheritorMapper).deleteById(1L);
        verify(workMapper).deleteByInheritorId(1L);
        verify(qualificationMapper).deleteByInheritorId(1L);
        verify(projectRelationMapper).deleteByInheritorId(1L);
        verify(productRelationMapper).deleteByInheritorId(1L);
        verify(serviceRelationMapper).deleteByInheritorId(1L);
        verify(followMapper).deleteByInheritorId(1L);
    }
    @Test void createInheritor_invalidGenderRejected() {
        InheritorSaveReqVO req = new InheritorSaveReqVO(); req.setName("测试"); req.setGender(9);
        assertThrows(ServiceException.class, () -> service.createInheritor(req)); verifyNoInteractions(inheritorMapper);
    }
    @Test void updateAudit_negativeStatusRejected() {
        InheritorAuditReqVO req = new InheritorAuditReqVO(); req.setId(1L); req.setAuditStatus(-1);
        assertThrows(ServiceException.class, () -> service.updateAudit(req));
    }
    @Test void updateAudit_outOfRangeStatusRejected() {
        InheritorAuditReqVO req = new InheritorAuditReqVO(); req.setId(1L); req.setAuditStatus(999);
        assertThrows(ServiceException.class, () -> service.updateAudit(req));
    }
    @Test void publicValidation_hiddenInheritorRejected() {
        when(inheritorMapper.selectPublicInheritor(3L)).thenReturn(null);
        assertThrows(ServiceException.class, () -> service.validateInheritorPublicExists(3L));
    }
    @Test void contact_returnsOnlyPhone() {
        InheritorDO inheritor = new InheritorDO(); inheritor.setPhone("13800000000");
        when(inheritorMapper.selectPublicInheritor(1L)).thenReturn(inheritor);
        assertEquals("13800000000", service.getAppInheritorContact(1L).getPhone());
    }
}