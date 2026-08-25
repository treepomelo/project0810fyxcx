const ACCESS_TOKEN_KEY = 'member_access_token'
const REFRESH_TOKEN_KEY = 'member_refresh_token'
const USER_INFO_KEY = 'member_info'
const LEGACY_TOKEN_KEY = 'token'

export function getAccessToken() {
  return uni.getStorageSync(ACCESS_TOKEN_KEY) || ''
}

export function setAccessToken(token) {
  uni.setStorageSync(ACCESS_TOKEN_KEY, token || '')
}

export function clearAccessToken() {
  uni.removeStorageSync(ACCESS_TOKEN_KEY)
}

export function getRefreshToken() {
  return uni.getStorageSync(REFRESH_TOKEN_KEY) || ''
}

export function setRefreshToken(token) {
  uni.setStorageSync(REFRESH_TOKEN_KEY, token || '')
}

export function clearRefreshToken() {
  uni.removeStorageSync(REFRESH_TOKEN_KEY)
}

export const getToken = getAccessToken
export const setToken = setAccessToken
export const clearToken = clearAccessToken

export function setAuthSession({ accessToken, refreshToken, memberInfo } = {}) {
  setAccessToken(accessToken)
  setRefreshToken(refreshToken)
  if (memberInfo) setUserInfo(memberInfo)
  uni.removeStorageSync(LEGACY_TOKEN_KEY)
}

export function getUserInfo() {
  return uni.getStorageSync(USER_INFO_KEY) || {}
}

export function setUserInfo(userInfo) {
  uni.setStorageSync(USER_INFO_KEY, userInfo || {})
}

export function clearUserInfo() {
  uni.removeStorageSync(USER_INFO_KEY)
}

export function clearAuth() {
  clearAccessToken()
  clearRefreshToken()
  clearUserInfo()
  uni.removeStorageSync(LEGACY_TOKEN_KEY)
}

export function isLoggedIn() {
  return !!getAccessToken()
}

export function ensureLogin() {
  if (isLoggedIn()) return true
  uni.showToast({
    title: '请先登录',
    icon: 'none'
  })
  setTimeout(() => {
    uni.navigateTo({
      url: '/pages/login/login'
    })
  }, 300)
  return false
}

export const requireLogin = ensureLogin
