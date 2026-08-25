import { ruoyiRequest } from './ruoyi.js'

export function previewMarketplaceOrder(data) {
  return ruoyiRequest({ url: '/marketplace/order/preview', method: 'POST', data, requiresAuth: true })
}

export function createMarketplaceOrder(data) {
  return ruoyiRequest({ url: '/marketplace/order/create', method: 'POST', data, requiresAuth: true })
}

export function getMarketplaceOrder(id) {
  return ruoyiRequest({ url: '/marketplace/order/get', method: 'GET', data: { id }, requiresAuth: true })
}

export function getMarketplaceOrderPage(params) {
  return ruoyiRequest({ url: '/marketplace/order/page', method: 'GET', data: params, requiresAuth: true })
}

export function cancelMarketplaceOrder(data) {
  return ruoyiRequest({ url: '/marketplace/order/cancel', method: 'PUT', data, requiresAuth: true })
}

export function receiveMarketplaceMerchantOrder(data) {
  return ruoyiRequest({ url: '/marketplace/order/merchant/receive', method: 'PUT', data, requiresAuth: true })
}
