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

export async function getLegacyMarketplaceOrderPage(params = {}) {
  const page = await getMarketplaceOrderPage(params)
  const statusMap = { WAIT_PAY: 0, PAID: 1, WAIT_SHIP: 1, SHIPPED: 2, WAIT_RECEIVE: 2, COMPLETED: 3, CANCELLED: 4 }
  const list = Array.isArray(page && page.list) ? page.list.map((order) => {
    const merchant = Array.isArray(order.merchantOrders) ? order.merchantOrders[0] : null
    const items = merchant && Array.isArray(merchant.items) ? merchant.items.map((item) => ({ ...item, quantity: item.count })) : []
    return { ...order, status: statusMap[order.status] === undefined ? order.status : statusMap[order.status], items, merchantOrderId: merchant && merchant.id, address: order.receiverDetailAddress, totalPrice: order.payAmount }
  }) : []
  return { ...(page || {}), list }
}