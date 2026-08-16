/**
 * 后台 IM 请求封装（/admin-api 前缀，独立于会员 token）。
 * 用于小程序里的 IM 测试：后台账号登录 → accessToken 调接口，refreshToken 连 WebSocket。
 */
import { BASE_URL } from './base'

const TOKEN_KEY = 'imAdminToken'
const REFRESH_KEY = 'imAdminRefreshToken'

export function getAdminToken() {
  return uni.getStorageSync(TOKEN_KEY) || ''
}
export function getAdminRefreshToken() {
  return uni.getStorageSync(REFRESH_KEY) || ''
}
export function setAdminToken(accessToken, refreshToken) {
  uni.setStorageSync(TOKEN_KEY, accessToken)
  uni.setStorageSync(REFRESH_KEY, refreshToken)
}
export function clearAdminToken() {
  uni.removeStorageSync(TOKEN_KEY)
  uni.removeStorageSync(REFRESH_KEY)
}

function toQuery(data) {
  return Object.keys(data || {})
    .filter((k) => data[k] !== undefined && data[k] !== null)
    .map((k) => `${encodeURIComponent(k)}=${encodeURIComponent(data[k])}`)
    .join('&')
}

function buildUrl(url, method, data) {
  // 后端接口统一挂在 /admin-api 前缀下（如 /admin-api/system/auth/login）
  const path = url.startsWith('/admin-api') ? url : '/admin-api' + url
  let full = BASE_URL + path
  // GET / DELETE / PUT：后端统一用 @RequestParam 取 query 参数（IM 的同意/拒绝/已读等 PUT 接口即是如此）
  const queryMethods = ['GET', 'DELETE', 'PUT']
  if (queryMethods.includes(method) && data) {
    const qs = toQuery(data)
    if (qs) {
      full += (full.includes('?') ? '&' : '?') + qs
    }
  }
  return full
}

export function adminRequest(options) {
  return new Promise((resolve, reject) => {
    const token = getAdminToken()
    const method = options.method || 'GET'
    const isQueryMethod = method === 'GET' || method === 'DELETE' || method === 'PUT'
    uni.request({
      url: buildUrl(options.url, method, options.data),
      method,
      data: isQueryMethod ? {} : (options.data || {}),
      header: {
        'tenant-id': '1',
        'Content-Type': 'application/json',
        ...(token ? { Authorization: 'Bearer ' + token } : {}),
        ...(options.header || {}),
      },
      success: (res) => {
        const body = res.data
        if (body && body.code === 0) {
          resolve(body.data)
        } else {
          reject(body || { code: -1, msg: '请求失败' })
        }
      },
      fail: () => reject({ code: -1, msg: '网络请求失败' }),
    })
  })
}

export const adminGet = (url, data) => adminRequest({ url, method: 'GET', data })
export const adminPost = (url, data) => adminRequest({ url, method: 'POST', data })
export const adminPut = (url, data) => adminRequest({ url, method: 'PUT', data })
export const adminDelete = (url, data) => adminRequest({ url, method: 'DELETE', data })

/**
 * 后台登录，返回 { accessToken, refreshToken, expiresTime, user }
 * user = { id, nickname, avatar, ... }（来自 get-permission-info 的 profile.user）
 */
export async function adminLogin(username, password) {
  const tokens = await adminPost('/system/auth/login', { username, password })
  // 先存 token，再拉个人信息（拉取接口需要带鉴权头）
  setAdminToken(tokens.accessToken, tokens.refreshToken)
  const info = await adminGet('/system/auth/get-permission-info')
  const user = (info && info.user) || {}
  uni.setStorageSync('imMyInfo', user)
  return { tokens, user }
}

export function getMyInfo() {
  return uni.getStorageSync('imMyInfo') || null
}
export function setMyInfo(user) {
  uni.setStorageSync('imMyInfo', user)
}
export function clearMyInfo() {
  uni.removeStorageSync('imMyInfo')
}
