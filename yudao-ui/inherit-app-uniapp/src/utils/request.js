/**
 * 轻量请求封装：统一 tenant-id、Bearer token、CommonResult 解析
 * H5 走 vite 代理用相对路径；小程序/App 直连后端绝对地址（改 BASE_URL 即可）。
 * GET/DELETE 的参数序列化到 URL 查询串（后端 @RequestParam 读取），POST/PUT 走 body。
 */
import { BASE_URL } from './base'

function toQuery(data) {
  return Object.keys(data || {})
    .filter((k) => data[k] !== undefined && data[k] !== null)
    .map((k) => `${encodeURIComponent(k)}=${encodeURIComponent(data[k])}`)
    .join('&')
}

function buildUrl(url, method, data) {
  let full = BASE_URL + url
  if ((method === 'GET' || method === 'DELETE') && data) {
    const qs = toQuery(data)
    if (qs) {
      full += (full.includes('?') ? '&' : '?') + qs
    }
  }
  return full
}

function request(options) {
  return new Promise((resolve, reject) => {
    const token = uni.getStorageSync('memberToken')
    const method = options.method || 'GET'
    const isQueryMethod = method === 'GET' || method === 'DELETE'
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

export const get = (url, data) => request({ url, method: 'GET', data })
export const post = (url, data) => request({ url, method: 'POST', data })
export const del = (url, data) => request({ url, method: 'DELETE', data })
