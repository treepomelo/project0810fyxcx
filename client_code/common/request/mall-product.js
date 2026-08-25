import { ruoyiRequest } from './ruoyi.js'

// 首页只读取已验收的公开 Mall Product 接口；不携带用户登录态。
export function getMallProductCategories() {
  return ruoyiRequest({ url: '/product/category/list', auth: false })
}

export function getMallProductPage(params = {}) {
  const data = {}
  if (params.pageNo !== undefined && params.pageNo !== null) data.pageNo = params.pageNo
  if (params.pageSize !== undefined && params.pageSize !== null) data.pageSize = params.pageSize
  if (params.categoryId !== undefined && params.categoryId !== null) data.categoryId = params.categoryId
  if (params.keyword) data.keyword = params.keyword
  return ruoyiRequest({ url: '/product/spu/page', data, auth: false })
}

export function getMallProductDetail(id) {
  return ruoyiRequest({
    url: '/product/spu/get-detail',
    data: { id },
    auth: false
  })
}
