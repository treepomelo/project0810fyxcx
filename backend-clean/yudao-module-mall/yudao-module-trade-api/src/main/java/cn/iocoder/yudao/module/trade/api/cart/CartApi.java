package cn.iocoder.yudao.module.trade.api.cart;

import cn.iocoder.yudao.module.trade.api.cart.dto.CartItemRespDTO;

import java.util.List;

/** Cross-module Cart-only contract for transaction preparation. */
public interface CartApi {
    List<CartItemRespDTO> getCartItems(Long memberId, List<Long> cartItemIds);
    void deleteCartItems(Long memberId, List<Long> cartItemIds);
}
