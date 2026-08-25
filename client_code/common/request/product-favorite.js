import { ruoyiRequest } from './ruoyi.js'

function toSpuId(data = {}) {
  const spuId = data.spuId === undefined ? data.targetId : data.spuId
  if (spuId === undefined || spuId === null || spuId === '') throw new Error('FAVORITE_SPUID_REQUIRED')
  return spuId
}

export async function getProductFavoriteStatus(data = {}) {
  const favorited = await ruoyiRequest({ url: '/product/favorite/exits', data: { spuId: toSpuId(data) }, requiresAuth: true })
  return { favorited: !!favorited }
}

export async function toggleProductFavorite(data = {}) {
  const spuId = toSpuId(data)
  const favorited = data.favorited === undefined ? !!data.isFavorite : !!data.favorited
  if (favorited) {
    await ruoyiRequest({ url: '/product/favorite/delete', method: 'DELETE', data: { spuId }, requiresAuth: true })
    return { favorited: false }
  }
  await ruoyiRequest({ url: '/product/favorite/create', method: 'POST', data: { spuId }, requiresAuth: true })
  return { favorited: true }
}

export async function getProductFavoritePage(params = {}) {
  const page = await ruoyiRequest({
    url: '/product/favorite/page',
    data: { pageNo: params.pageNo === undefined ? (params.page === undefined ? 1 : params.page) : params.pageNo, pageSize: params.pageSize === undefined ? (params.size === undefined ? 10 : params.pageSize) : params.pageSize },
    requiresAuth: true
  })
  return { ...(page || {}), list: Array.isArray(page && page.list) ? page.list.map((item) => ({ ...item, type: 'product', targetId: item.spuId, summary: item.spuName || '', cover: item.picUrl || '' })) : [] }
}
