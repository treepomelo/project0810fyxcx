import { ruoyiRequest } from './ruoyi.js'

const optional = (params = {}) => Object.fromEntries(Object.entries(params).filter(([, value]) => value !== undefined && value !== null && value !== ''))

export function getHeritageProductSystems() {
  return ruoyiRequest({ url: '/heritage/product-system/list', auth: false })
}
export function getHeritageSystemItems({ code, pageNo = 1, pageSize = 10, keyword } = {}) {
  return ruoyiRequest({ url: '/heritage/product-system/item-page', data: optional({ code, pageNo, pageSize, keyword }), auth: false })
}
export function getHeritageService(id) {
  return ruoyiRequest({ url: `/heritage/service/get?id=${encodeURIComponent(id)}`, auth: false })
}
export function getHeritageServiceSchedules(serviceId) {
  return ruoyiRequest({ url: `/heritage/service/schedule-list?serviceId=${encodeURIComponent(serviceId)}`, auth: false })
}
export function createHeritageBooking(data) {
  return ruoyiRequest({ url: '/heritage/service-booking/create', method: 'POST', data, requiresAuth: true })
}
export function getMyHeritageBookings(params = {}) {
  return ruoyiRequest({ url: '/heritage/service-booking/my-page', data: optional(params), requiresAuth: true })
}
export function cancelHeritageBooking(id) {
  return ruoyiRequest({ url: `/heritage/service-booking/cancel?id=${encodeURIComponent(id)}`, method: 'PUT', requiresAuth: true })
}
export function getHeritageCooperationTypes() {
  return ruoyiRequest({ url: '/heritage/cooperation/type-list', auth: false })
}
export function createHeritageCooperation(data) {
  return ruoyiRequest({ url: '/heritage/cooperation/application/create', method: 'POST', data, requiresAuth: true })
}
export function getMyHeritageCooperations(params = {}) {
  return ruoyiRequest({ url: '/heritage/cooperation/application/my-page', data: optional(params), requiresAuth: true })
}
