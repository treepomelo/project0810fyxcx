/**
 * 全局请求地址。
 * H5 走 vite 代理（相对路径）；小程序直连本机后端（微信开发者工具需勾选"不校验合法域名"）。
 */
// #ifdef H5
export const BASE_URL = ''
// #endif
// #ifndef H5
export const BASE_URL = 'http://127.0.0.1:48080'
// #endif

/** 后台 IM 的 WebSocket 地址（鉴权用后台 refreshToken） */
export function buildWsUrl() {
  return BASE_URL.replace(/^http/, 'ws')
}
