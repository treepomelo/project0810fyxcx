package cn.iocoder.yudao.module.inherit.service.inheritor;

import cn.iocoder.yudao.framework.common.exception.ServiceException;
import cn.iocoder.yudao.framework.common.pojo.PageParam;
import cn.iocoder.yudao.module.inherit.dal.dataobject.inheritor.InheritorDO;
import cn.iocoder.yudao.module.inherit.dal.dataobject.inheritor.InheritorFollowDO;
import cn.iocoder.yudao.module.inherit.dal.mysql.inheritor.InheritorFollowMapper;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import java.util.List;
import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class InheritorFollowServiceTest {
    @Mock private InheritorFollowMapper followMapper;
    @Mock private InheritorService inheritorService;
    @InjectMocks private InheritorFollowServiceImpl service;

    @Test void createFollow_publicInheritorInsertsRelation() {
        when(followMapper.selectByUserIdAndInheritorId(7L, 1L)).thenReturn(null);
        when(followMapper.reviveByUserIdAndInheritorId(7L, 1L)).thenReturn(0);
        service.createFollow(7L, 1L);
        verify(inheritorService).validateInheritorPublicExists(1L);
        verify(followMapper).insert(any(InheritorFollowDO.class));
    }
    @Test void createFollow_hiddenInheritorRejected() {
        doThrow(new ServiceException(100, "not public")).when(inheritorService).validateInheritorPublicExists(2L);
        assertThrows(ServiceException.class, () -> service.createFollow(7L, 2L));
        verifyNoInteractions(followMapper);
    }
    @Test void createFollow_duplicateRejected() {
        when(followMapper.selectByUserIdAndInheritorId(7L, 1L)).thenReturn(new InheritorFollowDO());
        assertThrows(ServiceException.class, () -> service.createFollow(7L, 1L));
        verify(followMapper, never()).insert(any(InheritorFollowDO.class));
    }
    @Test void createFollow_afterLogicalDeleteRevives() {
        when(followMapper.selectByUserIdAndInheritorId(7L, 1L)).thenReturn(null);
        when(followMapper.reviveByUserIdAndInheritorId(7L, 1L)).thenReturn(1);
        service.createFollow(7L, 1L);
        verify(followMapper, never()).insert(any(InheritorFollowDO.class));
        verify(followMapper).reviveByUserIdAndInheritorId(7L, 1L);
    }
    @Test void deleteFollow_existingRelationDeletes() {
        when(followMapper.selectByUserIdAndInheritorId(7L, 1L)).thenReturn(new InheritorFollowDO());
        service.deleteFollow(7L, 1L);
        verify(followMapper).deleteByUserIdAndInheritorId(7L, 1L);
    }
    @Test void deleteFollow_missingRelationRejected() {
        when(followMapper.selectByUserIdAndInheritorId(7L, 1L)).thenReturn(null);
        assertThrows(ServiceException.class, () -> service.deleteFollow(7L, 1L));
        verify(followMapper, never()).deleteByUserIdAndInheritorId(any(), any());
    }
    @Test void getFollowPage_filtersHiddenInheritorsAndKeepsTotal() {
        InheritorFollowDO visibleFollow = new InheritorFollowDO(); visibleFollow.setInheritorId(1L);
        InheritorFollowDO hiddenFollow = new InheritorFollowDO(); hiddenFollow.setInheritorId(2L);
        when(followMapper.selectList(any())).thenReturn(List.of(visibleFollow, hiddenFollow));
        InheritorDO visible = new InheritorDO(); visible.setId(1L);
        when(inheritorService.getPublicInheritor(1L)).thenReturn(visible);
        when(inheritorService.getPublicInheritor(2L)).thenReturn(null);
        PageParam page = new PageParam(); page.setPageNo(1); page.setPageSize(10);
        var result = service.getFollowPage(7L, page);
        assertEquals(List.of(visible), result.getList());
        assertEquals(1L, result.getTotal());
    }
}