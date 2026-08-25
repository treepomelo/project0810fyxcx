package cn.iocoder.yudao.module.trade.api.cart;

import cn.iocoder.yudao.module.trade.api.cart.dto.CartItemRespDTO;
import cn.iocoder.yudao.module.trade.dal.dataobject.cart.CartDO;
import cn.iocoder.yudao.module.trade.service.cart.CartService;
import jakarta.annotation.Resource;
import org.springframework.stereotype.Service;

import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;

/** Cart-only module API. It delegates ownership checks to CartService. */
@Service
public class CartApiImpl implements CartApi {
    @Resource private CartService cartService;

    @Override
    public List<CartItemRespDTO> getCartItems(Long memberId, List<Long> cartItemIds) {
        Set<Long> ids = new LinkedHashSet<>(cartItemIds);
        return cartService.getCartList(memberId, ids).stream().map(this::convert).toList();
    }

    @Override
    public void deleteCartItems(Long memberId, List<Long> cartItemIds) {
        cartService.deleteCart(memberId, new LinkedHashSet<>(cartItemIds));
    }

    private CartItemRespDTO convert(CartDO cart) {
        return new CartItemRespDTO().setId(cart.getId()).setSpuId(cart.getSpuId()).setSkuId(cart.getSkuId())
                .setCount(cart.getCount()).setSelected(cart.getSelected());
    }
}
