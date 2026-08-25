package cn.iocoder.yudao.module.marketplace.service.workspace;

import cn.iocoder.yudao.framework.common.exception.ServiceException;
import cn.iocoder.yudao.framework.security.core.LoginUser;
import cn.iocoder.yudao.module.marketplace.dal.dataobject.MarketplaceMerchantInheritorDO;
import cn.iocoder.yudao.module.marketplace.dal.dataobject.MarketplaceShopDO;
import cn.iocoder.yudao.module.marketplace.dal.mysql.MarketplaceMerchantInheritorMapper;
import cn.iocoder.yudao.module.marketplace.dal.mysql.MarketplaceShopMapper;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;

import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertDoesNotThrow;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class MerchantContextServiceImplTest {

    @Mock private InheritorIdentityAdapter inheritorIdentityAdapter;
    @Mock private MarketplaceMerchantInheritorMapper relationMapper;
    @Mock private MarketplaceShopMapper shopMapper;
    @InjectMocks private MerchantContextServiceImpl service;

    @BeforeEach
    void setUp() {
        SecurityContextHolder.getContext().setAuthentication(
                new UsernamePasswordAuthenticationToken(new LoginUser().setId(501L), null));
        lenient().when(inheritorIdentityAdapter.getInheritorIdByMemberId(501L)).thenReturn(701L);
        lenient().when(relationMapper.selectListByInheritorId(701L)).thenReturn(List.of(relation(1L, 0)));
        lenient().when(shopMapper.selectListByMerchantId(1L)).thenReturn(List.of(shop(11L, 1L, 0)));
    }

    @AfterEach
    void clearSecurityContext() {
        SecurityContextHolder.clearContext();
    }

    @Test
    void resolvesMerchantThroughInheritorRelation() {
        assertEquals(1L, service.getCurrentMerchantId());
        verify(relationMapper).selectListByInheritorId(701L);
    }

    @Test
    void resolvesOnlyEnabledShopForCurrentMerchant() {
        assertEquals(11L, service.getCurrentShopId());
    }

    @Test
    void merchantAccessRejectsAnotherMerchant() {
        assertDoesNotThrow(() -> service.checkMerchantAccess(1L));
        assertThrows(ServiceException.class, () -> service.checkMerchantAccess(2L));
    }

    @Test
    void shopAccessRequiresCurrentMerchantOwnership() {
        when(shopMapper.selectById(11L)).thenReturn(shop(11L, 1L, 0));
        when(shopMapper.selectById(12L)).thenReturn(shop(12L, 2L, 0));

        assertDoesNotThrow(() -> service.checkShopAccess(11L));
        assertThrows(ServiceException.class, () -> service.checkShopAccess(12L));
    }

    @Test
    void multipleEnabledShopsAreRejectedInsteadOfChoosingOne() {
        when(shopMapper.selectListByMerchantId(1L)).thenReturn(List.of(shop(11L, 1L, 0), shop(12L, 1L, 0)));

        assertThrows(ServiceException.class, () -> service.getCurrentShopId());
    }

    @Test
    void pendingAdapterNeverFabricatesMerchantIdentity() {
        assertThrows(ServiceException.class, () -> new PendingInheritorIdentityAdapter().getInheritorIdByMemberId(501L));
    }

    private MarketplaceMerchantInheritorDO relation(Long merchantId, Integer status) {
        return new MarketplaceMerchantInheritorDO().setMerchantId(merchantId).setInheritorId(701L).setStatus(status);
    }

    private MarketplaceShopDO shop(Long id, Long merchantId, Integer status) {
        return new MarketplaceShopDO().setId(id).setMerchantId(merchantId).setStatus(status);
    }
}
