package cn.iocoder.yudao.module.inherit.service.inheritor;

import cn.iocoder.yudao.framework.common.exception.ServiceException;
import cn.iocoder.yudao.module.heritage.dal.dataobject.HeritageServiceDO;
import cn.iocoder.yudao.module.heritage.dal.mysql.HeritageServiceMapper;
import cn.iocoder.yudao.module.heritage.dal.mysql.ProductSystemMapper;
import cn.iocoder.yudao.module.inherit.controller.admin.inheritor.vo.*;
import cn.iocoder.yudao.module.inherit.dal.dataobject.inheritor.*;
import cn.iocoder.yudao.module.inherit.dal.mysql.inheritor.*;
import cn.iocoder.yudao.module.product.api.spu.ProductSpuApi;
import cn.iocoder.yudao.module.product.api.spu.dto.ProductSpuRespDTO;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.test.util.ReflectionTestUtils;
import java.util.List;
import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class InheritorRelationServiceTest {
    @Mock private InheritorProductRelationMapper productMapper;
    @Mock private ProductSpuApi productSpuApi;
    @Mock private InheritorService inheritorService;
    @InjectMocks private InheritorProductRelationServiceImpl productService;
    @Mock private InheritorServiceRelationMapper serviceMapper;
    @Mock private HeritageServiceMapper heritageServiceMapper;
    @Mock private ProductSystemMapper productSystemMapper;
    @InjectMocks private InheritorServiceRelationServiceImpl relationService;
    @BeforeEach void init() {
        ReflectionTestUtils.setField(productService, "relationMapper", productMapper);
        ReflectionTestUtils.setField(productService, "productSpuApi", productSpuApi);
        ReflectionTestUtils.setField(productService, "inheritorService", inheritorService);
        ReflectionTestUtils.setField(relationService, "relationMapper", serviceMapper);
        ReflectionTestUtils.setField(relationService, "heritageServiceMapper", heritageServiceMapper);
        ReflectionTestUtils.setField(relationService, "productSystemMapper", productSystemMapper);
        ReflectionTestUtils.setField(relationService, "inheritorService", inheritorService);
    }
    private InheritorProductRelationSaveReqVO productReq() { InheritorProductRelationSaveReqVO req = new InheritorProductRelationSaveReqVO(); req.setInheritorId(1L); req.setSpuId(10L); return req; }
    private ProductSpuRespDTO spu() { ProductSpuRespDTO dto = new ProductSpuRespDTO(); dto.setId(10L); dto.setStatus(1); return dto; }
    @Test void productCreate_valid() {
        when(productSpuApi.validateSpuList(List.of(10L))).thenReturn(List.of(spu())); when(productMapper.selectAny(1L, 10L)).thenReturn(null);
        productService.createProductRelation(productReq()); verify(productMapper).insert(any(InheritorProductRelationDO.class));
    }
    @Test void productCreate_duplicateRejected() {
        when(productSpuApi.validateSpuList(List.of(10L))).thenReturn(List.of(spu())); InheritorProductRelationDO existing = new InheritorProductRelationDO(); existing.setDeleted(false); when(productMapper.selectAny(1L, 10L)).thenReturn(existing);
        assertThrows(ServiceException.class, () -> productService.createProductRelation(productReq()));
    }
    @Test void productCreate_deletedRelationRevived() {
        when(productSpuApi.validateSpuList(List.of(10L))).thenReturn(List.of(spu())); InheritorProductRelationDO existing = new InheritorProductRelationDO(); existing.setId(5L); existing.setDeleted(true); when(productMapper.selectAny(1L, 10L)).thenReturn(existing); when(productMapper.revive(eq(5L), anyBoolean(), anyInt(), anyInt(), anyString())).thenReturn(1);
        assertEquals(5L, productService.createProductRelation(productReq()));
    }
    @Test void productCreate_invalidInheritorRejected() {
        doThrow(new ServiceException(100, "missing inheritor")).when(inheritorService).validateInheritorExists(1L); assertThrows(ServiceException.class, () -> productService.createProductRelation(productReq())); verifyNoInteractions(productSpuApi);
    }
    @Test void productCreate_invalidSpuRejected() {
        doThrow(new ServiceException(100, "missing spu")).when(productSpuApi).validateSpuList(List.of(10L)); assertThrows(ServiceException.class, () -> productService.createProductRelation(productReq()));
    }
    @Test void productDelete_deletesRelation() {
        InheritorProductRelationDO existing = new InheritorProductRelationDO(); existing.setId(5L); when(productMapper.selectById(5L)).thenReturn(existing); when(productMapper.deleteById(5L)).thenReturn(1);
        productService.deleteProductRelation(5L); verify(productMapper).deleteById(5L);
    }
    private InheritorServiceRelationSaveReqVO serviceReq() { InheritorServiceRelationSaveReqVO req = new InheritorServiceRelationSaveReqVO(); req.setInheritorId(1L); req.setServiceId(20L); return req; }
    private HeritageServiceDO heritageService() { HeritageServiceDO dto = new HeritageServiceDO(); dto.setId(20L); dto.setStatus(1); return dto; }
    @Test void serviceCreate_valid() {
        when(heritageServiceMapper.selectById(20L)).thenReturn(heritageService()); when(serviceMapper.selectAny(1L, 20L)).thenReturn(null);
        relationService.createServiceRelation(serviceReq()); verify(serviceMapper).insert(any(InheritorServiceRelationDO.class));
    }
    @Test void serviceCreate_duplicateRejected() {
        when(heritageServiceMapper.selectById(20L)).thenReturn(heritageService()); InheritorServiceRelationDO existing = new InheritorServiceRelationDO(); existing.setDeleted(false); when(serviceMapper.selectAny(1L, 20L)).thenReturn(existing);
        assertThrows(ServiceException.class, () -> relationService.createServiceRelation(serviceReq()));
    }
    @Test void serviceCreate_deletedRelationRevived() {
        when(heritageServiceMapper.selectById(20L)).thenReturn(heritageService()); InheritorServiceRelationDO existing = new InheritorServiceRelationDO(); existing.setId(6L); existing.setDeleted(true); when(serviceMapper.selectAny(1L, 20L)).thenReturn(existing); when(serviceMapper.revive(eq(6L), anyBoolean(), anyInt(), anyInt(), anyString())).thenReturn(1);
        assertEquals(6L, relationService.createServiceRelation(serviceReq()));
    }
    @Test void serviceCreate_invalidInheritorRejected() {
        doThrow(new ServiceException(100, "missing inheritor")).when(inheritorService).validateInheritorExists(1L); assertThrows(ServiceException.class, () -> relationService.createServiceRelation(serviceReq())); verifyNoInteractions(heritageServiceMapper);
    }
    @Test void serviceCreate_invalidServiceRejected() {
        when(heritageServiceMapper.selectById(20L)).thenReturn(null); assertThrows(ServiceException.class, () -> relationService.createServiceRelation(serviceReq()));
    }
    @Test void serviceDelete_deletesRelation() {
        InheritorServiceRelationDO existing = new InheritorServiceRelationDO(); existing.setId(6L); when(serviceMapper.selectById(6L)).thenReturn(existing); when(serviceMapper.deleteById(6L)).thenReturn(1);
        relationService.deleteServiceRelation(6L); verify(serviceMapper).deleteById(6L);
    }
}