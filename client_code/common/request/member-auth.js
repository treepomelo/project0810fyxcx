import { ruoyiRequest } from './ruoyi.js'

export function weixinMiniAppLogin(data) {
  return ruoyiRequest({
    url: '/member/auth/weixin-mini-app-login',
    method: 'POST',
    data
  })
}

export function memberPasswordLogin(data) {
  return ruoyiRequest({
    url: '/member/auth/login',
    method: 'POST',
    data
  })
}

export function sendMemberSmsCode(data) {
  return ruoyiRequest({
    url: '/member/auth/send-sms-code',
    method: 'POST',
    data,
    auth: false
  })
}

export function memberSmsLogin(data) {
  return ruoyiRequest({
    url: '/member/auth/sms-login',
    method: 'POST',
    data,
    auth: false
  })
}

export function getCurrentMember() {
  return ruoyiRequest({
    url: '/member/user/get',
    requiresAuth: true
  })
}

export function memberLogout() {
  return ruoyiRequest({
    url: '/member/auth/logout',
    method: 'POST',
    requiresAuth: true
  })
}
