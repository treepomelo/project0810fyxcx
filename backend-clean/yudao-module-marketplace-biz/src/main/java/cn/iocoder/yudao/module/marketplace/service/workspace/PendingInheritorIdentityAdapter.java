package cn.iocoder.yudao.module.marketplace.service.workspace;

import org.springframework.context.annotation.Primary;
import org.springframework.stereotype.Component;

import static cn.iocoder.yudao.framework.common.exception.util.ServiceExceptionUtil.exception;
import static cn.iocoder.yudao.module.marketplace.enums.ErrorCodeConstants.INHERITOR_API_INTEGRATION_PENDING;

/** Safe default until yudao-module-inheritor-api is available. */
@Component
@Primary
public class PendingInheritorIdentityAdapter implements InheritorIdentityAdapter {

    @Override
    public Long getInheritorIdByMemberId(Long memberId) {
        throw exception(INHERITOR_API_INTEGRATION_PENDING);
    }
}
