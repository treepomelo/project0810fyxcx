import { ruoyiRequest } from './ruoyi.js'

export function getMarketplaceProductRelation(spuId) {
  return ruoyiRequest({
    url: '/marketplace/product-relation/get-by-spu',
    data: { spuId },
    auth: false
  })
}

export function getMarketplaceProductRelations(spuIds = []) {
  const ids = Array.from(new Set(spuIds.map((id) => Number(id)).filter((id) => Number.isFinite(id) && id > 0)))
  if (!ids.length) return Promise.resolve([])
  return ruoyiRequest({
    url: '/marketplace/product-relation/list-by-spu-ids',
    data: { spuIds: ids.join(',') },
    auth: false
  })
}
