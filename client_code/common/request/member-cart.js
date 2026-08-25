import { ruoyiRequest } from './ruoyi.js'

export function getMemberCartList() {
  return ruoyiRequest({ url: '/trade/cart/list', requiresAuth: true })
}

export function getMemberCartCount() {
  return ruoyiRequest({ url: '/trade/cart/get-count', requiresAuth: true })
}

export function addMemberCartItem({ skuId, count }) {
  return ruoyiRequest({
    url: '/trade/cart/add',
    method: 'POST',
    data: { skuId, count },
    requiresAuth: true
  })
}

export function updateMemberCartCount({ id, count }) {
  return ruoyiRequest({
    url: '/trade/cart/update-count',
    method: 'PUT',
    data: { id, count },
    requiresAuth: true
  })
}

export function updateMemberCartSelected({ ids, selected }) {
  return ruoyiRequest({
    url: '/trade/cart/update-selected',
    method: 'PUT',
    data: { ids, selected },
    requiresAuth: true
  })
}

export function deleteMemberCartItems(ids) {
  return ruoyiRequest({
    url: `/trade/cart/delete?ids=${(Array.isArray(ids) ? ids : [ids]).map((id) => encodeURIComponent(id)).join(',')}`,
    method: 'DELETE',
    requiresAuth: true
  })
}
