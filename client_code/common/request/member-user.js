import { ruoyiRequest } from './ruoyi.js'

function normalizeMemberUser(user = {}) {
  return { ...user, phone: user.mobile || user.phone || '', gender: user.sex === undefined || user.sex === null ? (user.gender || 0) : user.sex }
}

export async function getMemberUserInfo() {
  return normalizeMemberUser(await ruoyiRequest({ url: '/member/user/get', requiresAuth: true }))
}

export async function updateMemberUserInfo(data = {}) {
  await ruoyiRequest({ url: '/member/user/update', method: 'PUT', data: { nickname: data.nickname, avatar: data.avatar, email: data.email, sex: data.sex === undefined || data.sex === null ? data.gender : data.sex }, requiresAuth: true })
  return getMemberUserInfo()
}
