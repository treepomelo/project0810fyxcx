/**
 * IM 接口封装（/admin-api 前缀，后台账号）。
 * 路径与 Yudao 后台 IM 控制器一一对应。
 */
import { adminGet, adminPost, adminPut, adminDelete, getAdminToken } from '../utils/adminRequest'
import { BASE_URL } from '../utils/base'

/** 消息类型常量（与后端 ImContentTypeEnum 对齐） */
export const ImContentType = {
  TEXT: 101,
  IMAGE: 102,
  VOICE: 103,
  VIDEO: 104,
  FILE: 105,
  RECALL: 2101,
  RECEIPT: 2200,
  READ: 2201,
}

/** 会话类型 */
export const ImConversationType = { PRIVATE: 1, GROUP: 2 }

// ---------- 私聊 ----------
export const sendPrivateMessage = (data) => adminPost('/im/message/private/send', data)

export const pullPrivateMessageList = (minId, size) =>
  adminGet('/im/message/private/pull', { minId, size })

export const getPrivateMessageList = (receiverId, maxId, limit) =>
  adminGet('/im/message/private/list', { receiverId, maxId, limit })

export const readPrivateMessages = (receiverId, messageId) =>
  adminPut('/im/message/private/read', { receiverId, messageId })

export const recallPrivateMessage = (id) =>
  adminDelete('/im/message/private/recall', { id })

// ---------- 群聊 ----------
export const sendGroupMessage = (data) =>
  adminPost('/im/message/group/send', data)

export const pullGroupMessageList = (minId, size) =>
  adminGet('/im/message/group/pull', { minId, size })

export const getGroupMessageList = (groupId, maxId, limit) =>
  adminGet('/im/message/group/list', { groupId, maxId, limit })

export const readGroupMessages = (groupId, messageId) =>
  adminPut('/im/message/group/read', { groupId, messageId })

export const recallGroupMessage = (id) =>
  adminDelete('/im/message/group/recall', { id })

// ---------- 会话已读位置 ----------
export const pullConversationReadList = (limit, lastId, lastUpdateTime) =>
  adminGet('/im/conversation-read/pull', {
    limit,
    lastId,
    lastUpdateTime,
  })

// ---------- 好友 ----------
export const getFriendList = () =>
  adminGet('/im/friend/list')

export const deleteFriend = (friendUserId, clear) =>
  adminDelete('/im/friend/delete', { friendUserId, clear })

// ---------- 好友申请 ----------
export const applyFriendRequest = (data) =>
  adminPost('/im/friend-request/apply', data)

export const agreeFriendRequest = (id) =>
  adminPut('/im/friend-request/agree', { id })

export const refuseFriendRequest = (id, handleContent) =>
  adminPut('/im/friend-request/refuse', { id, handleContent })

export const getFriendRequestList = (limit, maxId) =>
  adminGet('/im/friend-request/list', { limit, maxId })

// ---------- 群组 ----------
export const getGroupList = () =>
  adminGet('/im/group/list')

export const getGroup = (id) =>
  adminGet('/im/group/get', { id })

export const createGroup = (data) =>
  adminPost('/im/group/create', data)

export const quitGroup = (groupId) =>
  adminDelete('/im/group/quit', { groupId })

export const dissolveGroup = (id) =>
  adminDelete('/im/group/dissolve', { id })

export const getGroupMemberList = (groupId) =>
  adminGet('/im/group-member/list', { groupId })

export const inviteGroupMember = (groupId, memberUserIds) =>
  adminPost('/im/group/invite', {
    groupId,
    memberUserIds,
  })

// ---------- 群申请 ----------
export const applyJoinGroup = (groupId, applyContent) =>
  adminPost('/im/group-request/apply', {
    groupId,
    applyContent,
  })

// ---------- 用户搜索 ----------
export const searchUserByNickname = (nickname) =>
  adminGet('/system/user/list-by-nickname', { nickname })

// ---------- 文件上传 ----------

/**
 * 通用文件上传。
 *
 * 当前项目后端文件上传接口：
 * /admin-api/infra/file/upload
 *
 * 返回 body.data。
 */
export function uploadFile(filePath) {
  return new Promise((resolve, reject) => {
    if (!filePath) {
      reject({ code: -1, msg: '文件路径为空' })
      return
    }

    uni.uploadFile({
      url: BASE_URL + '/admin-api/infra/file/upload',
      filePath,
      name: 'file',
      header: {
        'tenant-id': '1',
        Authorization: 'Bearer ' + getAdminToken(),
      },
      success: (res) => {
        try {
          const body = JSON.parse(res.data)

          if (body && body.code === 0) {
            resolve(body.data)
          } else {
            reject(body || {
              code: -1,
              msg: '上传失败',
            })
          }
        } catch (e) {
          reject({
            code: -1,
            msg: '上传响应解析失败',
          })
        }
      },
      fail: (err) => {
        reject({
          code: -1,
          msg: (err && err.errMsg) || '上传失败',
        })
      },
    })
  })
}

/**
 * 上传图片。
 *
 * 保留原有 API，避免影响现有图片消息。
 */
export function uploadImage(filePath) {
  return uploadFile(filePath)
}

/**
 * 上传语音。
 *
 * 当前语音消息和图片消息使用同一个文件上传接口。
 *
 * @param {String} filePath 微信小程序录音临时文件路径
 * @returns {Promise<String|Object>} 后端返回的文件 URL / 文件信息
 */
export function uploadVoice(filePath) {
  return uploadFile(filePath)
}