import { isSuccessCode } from './response.js'
import config from '@/common/config.js'
import {
  clearAuth,
  getAccessToken,
  getRefreshToken,
  setAccessToken,
  setRefreshToken
} from '@/common/session.js'

let refreshPromise = null

function send(options, token = getAccessToken()) {
  return new Promise((resolve, reject) => {
    uni.request({
      url: `${config.ruoyiBaseUrl}${options.url}`,
      method: options.method || 'GET',
      data: options.data || {},
      timeout: options.timeout || 15000,
      header: {
        'Content-Type': 'application/json',
        ...(token ? { Authorization: `Bearer ${token}` } : {}),
        ...(options.header || {})
      },
      success: (response) => {
        const payload = response.data || {}
        if (isSuccessCode(payload.code)) {
          resolve(payload.data)
          return
        }
        reject({ ...payload, httpStatus: response.statusCode })
      },
      fail: reject
    })
  })
}

function refreshAccessToken() {
  const refreshToken = getRefreshToken()
  if (!refreshToken) return Promise.reject(new Error('NO_REFRESH_TOKEN'))
  if (!refreshPromise) {
    refreshPromise = send({
      url: `/member/auth/refresh-token?refreshToken=${encodeURIComponent(refreshToken)}`,
      method: 'POST'
    }, '').then((data) => {
      setAccessToken(data.accessToken)
      setRefreshToken(data.refreshToken)
      return data.accessToken
    }).finally(() => {
      refreshPromise = null
    })
  }
  return refreshPromise
}

export function ruoyiRequest(options = {}) {
  const isPublic = options.auth === false
  const hadAccessToken = !!getAccessToken()
  return send(options, isPublic ? '' : getAccessToken()).catch((error) => {
    const unauthorized = error && (error.httpStatus === 401 || error.code === 401)
    if (unauthorized && isPublic) {
      if (hadAccessToken && !options._publicRetried) {
        clearAuth()
        return send({ ...options, _publicRetried: true }, '')
      }
      throw error
    }
    if (unauthorized && options.requiresAuth && !options._retried) {
      return refreshAccessToken()
        .then(() => ruoyiRequest({ ...options, _retried: true }))
        .catch((refreshError) => {
          clearAuth()
          throw refreshError
        })
    }
    if (unauthorized) clearAuth()
    throw error
  })
}

export default ruoyiRequest
