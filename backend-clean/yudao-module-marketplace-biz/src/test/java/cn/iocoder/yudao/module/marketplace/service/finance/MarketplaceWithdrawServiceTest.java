package cn.iocoder.yudao.module.marketplace.service.finance;

import cn.iocoder.yudao.framework.common.exception.ServiceException;
import cn.iocoder.yudao.module.marketplace.controller.admin.finance.vo.MarketplaceWithdrawApplyReqVO;
import cn.iocoder.yudao.module.marketplace.dal.dataobject.MarketplaceMerchantDO;
import cn.iocoder.yudao.module.marketplace.dal.dataobject.finance.MarketplaceFinanceLedgerDO;
import cn.iocoder.yudao.module.marketplace.dal.dataobject.finance.MarketplaceWithdrawDO;
import cn.iocoder.yudao.module.marketplace.dal.mysql.MarketplaceMerchantMapper;
import cn.iocoder.yudao.module.marketplace.dal.mysql.finance.MarketplaceFinanceLedgerMapper;
import cn.iocoder.yudao.module.marketplace.dal.mysql.finance.MarketplaceWithdrawMapper;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class MarketplaceWithdrawServiceTest {

    @Mock private MarketplaceMerchantMapper merchantMapper;
    @Mock private MarketplaceFinanceLedgerMapper ledgerMapper;
    @Mock private MarketplaceWithdrawMapper withdrawMapper;
    @InjectMocks private MarketplaceFinanceServiceImpl service;

    @BeforeEach
    void setUp() {
        lenient().when(merchantMapper.selectByIdForUpdate(anyLong()))
                .thenAnswer(invocation -> new MarketplaceMerchantDO().setId(invocation.getArgument(0)));
        lenient().when(ledgerMapper.sumAmount(anyLong(), any(), any(), any())).thenReturn(10_000L);
        lenient().when(withdrawMapper.sumPendingAmount(anyLong())).thenReturn(0L);
        lenient().when(ledgerMapper.selectOne(any(), any(), any(), any(), any(), any())).thenReturn(null);
        lenient().doAnswer(invocation -> {
            MarketplaceWithdrawDO row = invocation.getArgument(0);
            row.setId(101L);
            return 1;
        }).when(withdrawMapper).insert(any(MarketplaceWithdrawDO.class));
    }

    @Test
    void availableBalanceSubtractsPendingAndApprovedReservations() {
        when(withdrawMapper.sumPendingAmount(1L)).thenReturn(2_000L);

        assertEquals(8_000L, service.summary(1L).getAvailableBalance());
    }

    @Test
    void applyCreatesApplyingWithdrawWithinAvailableBalance() {
        Long id = service.applyWithdraw(apply(1L, 6_000L));

        ArgumentCaptor<MarketplaceWithdrawDO> rows = ArgumentCaptor.forClass(MarketplaceWithdrawDO.class);
        verify(withdrawMapper).insert(rows.capture());
        assertEquals(101L, id);
        assertEquals(1L, rows.getValue().getMerchantId());
        assertEquals(6_000L, rows.getValue().getAmount());
        assertEquals("APPLYING", rows.getValue().getStatus());
    }

    @Test
    void overWithdrawIsRejectedAndConcurrentSecondApplySeesReservation() {
        when(withdrawMapper.sumPendingAmount(1L)).thenReturn(0L, 6_000L);

        service.applyWithdraw(apply(1L, 6_000L));
        assertThrows(ServiceException.class, () -> service.applyWithdraw(apply(1L, 6_000L)));
        verify(withdrawMapper, times(1)).insert(any(MarketplaceWithdrawDO.class));
        verify(merchantMapper, times(2)).selectByIdForUpdate(1L);
    }

    @Test
    void rejectReleasesReservationWithoutLedger() {
        when(withdrawMapper.reject(eq(101L), eq(9L), anyString(), any())).thenReturn(1);

        service.rejectWithdraw(101L, 9L, "manual review rejected");

        verify(withdrawMapper).reject(eq(101L), eq(9L), eq("manual review rejected"), any());
        verify(ledgerMapper, never()).insert(any(MarketplaceFinanceLedgerDO.class));
    }

    @Test
    void completeWritesWithdrawLedgerOnceAndRejectsDuplicateComplete() {
        MarketplaceWithdrawDO withdraw = new MarketplaceWithdrawDO().setId(101L).setMerchantId(1L)
                .setAmount(6_000L).setStatus("APPROVED");
        when(withdrawMapper.selectById(101L)).thenReturn(withdraw);
        when(withdrawMapper.complete(eq(101L), any())).thenReturn(1, 0);

        service.completeWithdraw(101L);
        assertThrows(ServiceException.class, () -> service.completeWithdraw(101L));

        ArgumentCaptor<MarketplaceFinanceLedgerDO> rows = ArgumentCaptor.forClass(MarketplaceFinanceLedgerDO.class);
        verify(ledgerMapper, times(1)).insert(rows.capture());
        assertEquals("WITHDRAW", rows.getValue().getBizType());
        assertEquals(101L, rows.getValue().getBizId());
        assertEquals(-6_000L, rows.getValue().getAmount());
    }

    @Test
    void merchantQueriesAreIsolatedByMerchantId() {
        when(withdrawMapper.sumPendingAmount(1L)).thenReturn(1_000L);
        when(withdrawMapper.sumPendingAmount(2L)).thenReturn(3_000L);

        assertEquals(9_000L, service.summary(1L).getAvailableBalance());
        assertEquals(7_000L, service.summary(2L).getAvailableBalance());
        verify(withdrawMapper).sumPendingAmount(1L);
        verify(withdrawMapper).sumPendingAmount(2L);
        verify(ledgerMapper).sumAmount(1L, null, null, null);
        verify(ledgerMapper).sumAmount(2L, null, null, null);
    }

    private MarketplaceWithdrawApplyReqVO apply(Long merchantId, Long amount) {
        return new MarketplaceWithdrawApplyReqVO().setMerchantId(merchantId).setAmount(amount)
                .setPaymentMethod("MANUAL").setPaymentAccountSnapshot("test-only");
    }
}
