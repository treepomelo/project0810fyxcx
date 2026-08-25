package cn.iocoder.yudao.module.marketplace.service.finance;

import cn.iocoder.yudao.module.marketplace.dal.dataobject.MarketplaceMerchantDO;
import cn.iocoder.yudao.module.marketplace.dal.dataobject.aftersale.MarketplaceAfterSaleDO;
import cn.iocoder.yudao.module.marketplace.dal.dataobject.finance.MarketplaceFinanceLedgerDO;
import cn.iocoder.yudao.module.marketplace.dal.dataobject.order.MarketplaceMerchantOrderDO;
import cn.iocoder.yudao.module.marketplace.dal.mysql.MarketplaceMerchantMapper;
import cn.iocoder.yudao.module.marketplace.dal.mysql.finance.MarketplaceFinanceLedgerMapper;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.test.util.ReflectionTestUtils;

import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class MarketplaceFinanceLedgerFoundationTest {

    @Mock private MarketplaceFinanceLedgerMapper ledgerMapper;
    @Mock private MarketplaceMerchantMapper merchantMapper;
    @InjectMocks private MarketplaceFinanceServiceImpl service;

    @BeforeEach
    void setUp() {
        ReflectionTestUtils.setField(service, "feeRate", 500L);
        lenient().when(merchantMapper.selectByIdForUpdate(anyLong())).thenReturn(new MarketplaceMerchantDO().setId(1L));
        lenient().when(ledgerMapper.sumAmount(anyLong(), isNull(), isNull(), isNull())).thenReturn(0L);
    }

    @Test
    void recordRefundWritesRefundAndServiceFeeAdjustment() {
        service.recordRefund(refund(1L, 2L, 20_00L));

        ArgumentCaptor<MarketplaceFinanceLedgerDO> rows = ArgumentCaptor.forClass(MarketplaceFinanceLedgerDO.class);
        verify(ledgerMapper, times(2)).insert(rows.capture());
        assertEquals(List.of("REFUND", "SERVICE_FEE"), rows.getAllValues().stream().map(MarketplaceFinanceLedgerDO::getBizType).toList());
        assertEquals(List.of(-20_00L, 100L), rows.getAllValues().stream().map(MarketplaceFinanceLedgerDO::getAmount).toList());
        assertEquals(List.of(2L, 2L), rows.getAllValues().stream().map(MarketplaceFinanceLedgerDO::getMerchantId).toList());
    }

    @Test
    void duplicateRefundDoesNotWriteAgain() {
        when(ledgerMapper.selectOne(any(), any(), any(), any(), any(), any())).thenReturn(new MarketplaceFinanceLedgerDO());
        service.recordRefund(refund(2L, 2L, 20_00L));
        verify(ledgerMapper, never()).insert(any(MarketplaceFinanceLedgerDO.class));
    }

    @Test
    void completedOrderWritesIncomeAndConfiguredServiceFee() {
        service.recordCompletedMerchantOrder(new MarketplaceMerchantOrderDO().setId(3L).setMerchantId(3L)
                .setShopId(30L).setStatus("COMPLETED").setPayAmount(10_000L));
        ArgumentCaptor<MarketplaceFinanceLedgerDO> rows = ArgumentCaptor.forClass(MarketplaceFinanceLedgerDO.class);
        verify(ledgerMapper, times(2)).insert(rows.capture());
        assertEquals(List.of("ORDER_INCOME", "SERVICE_FEE"), rows.getAllValues().stream().map(MarketplaceFinanceLedgerDO::getBizType).toList());
        assertEquals(List.of(10_000L, -500L), rows.getAllValues().stream().map(MarketplaceFinanceLedgerDO::getAmount).toList());
    }

    @Test
    void merchantsRemainIsolated() {
        service.recordRefund(refund(4L, 10L, 1_000L));
        service.recordRefund(refund(5L, 20L, 1_000L));
        verify(merchantMapper, times(2)).selectByIdForUpdate(10L);
        verify(merchantMapper, times(2)).selectByIdForUpdate(20L);
        verify(ledgerMapper, times(2)).sumAmount(10L, null, null, null);
        verify(ledgerMapper, times(2)).sumAmount(20L, null, null, null);
    }

    private MarketplaceAfterSaleDO refund(Long id, Long merchantId, Long amount) {
        return new MarketplaceAfterSaleDO().setId(id).setMerchantId(merchantId).setShopId(merchantId * 10)
                .setMerchantOrderId(id * 100).setOrderItemId(id * 1_000).setApplyAmount(amount).setStatus("REFUNDED");
    }
}
