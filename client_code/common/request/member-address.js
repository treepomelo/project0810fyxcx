import { ruoyiRequest } from './ruoyi.js'

export function getMemberAddressList() {
  return ruoyiRequest({ url: '/member/address/list', requiresAuth: true })
}

export function getMemberAddress(id) {
  return ruoyiRequest({ url: `/member/address/get?id=${encodeURIComponent(id)}`, requiresAuth: true })
}

export function getDefaultMemberAddress() {
  return ruoyiRequest({ url: '/member/address/get-default', requiresAuth: true })
}

export function createMemberAddress(data) {
  return ruoyiRequest({ url: '/member/address/create', method: 'POST', data, requiresAuth: true })
}

export function updateMemberAddress(data) {
  return ruoyiRequest({ url: '/member/address/update', method: 'PUT', data, requiresAuth: true })
}

export function deleteMemberAddress(id) {
  return ruoyiRequest({ url: `/member/address/delete?id=${encodeURIComponent(id)}`, method: 'DELETE', requiresAuth: true })
}

export function getAreaTree() {
  return ruoyiRequest({ url: '/system/area/tree', auth: false })
}
