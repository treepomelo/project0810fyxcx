/**
 * IM 状态层（单例，跨页面共享）
 *
 * 负责：
 * 1. 好友 / 群组 / 好友申请
 * 2. 会话列表最后一条消息
 * 3. 未读消息
 * 4. 已读位置
 * 5. 文字 / 图片 / 语音消息发送
 * 6. WebSocket 实时消息
 * 7. WebSocket 自动重连
 * 8. 登录状态检查
 * 9. IM 数据刷新
 *
 * 页面只负责 UI：
 *
 * index.vue
 *   - 会话列表
 *   - 下拉刷新
 *
 * chat.vue
 *   - 聊天 UI
 *   - 录音
 *   - 图片选择
 *   - 语音播放
 *
 * 业务状态统一放这里。
 */

import {
  getFriendList,
  getGroupList,
  getFriendRequestList,

  pullPrivateMessageList,
  pullGroupMessageList,
  pullConversationReadList,

  sendPrivateMessage,
  sendGroupMessage,

  readPrivateMessages,
  readGroupMessages,

  ImContentType,
} from '../api/im'

import {
  getAdminToken,
  getAdminRefreshToken,
  getMyInfo,
  clearAdminToken,
  clearMyInfo,
} from './adminRequest'

import { buildWsUrl } from './base'

// ============================================================
// 事件系统
// ============================================================

const listeners = {}

/**
 * 订阅事件
 *
 * conversations
 * contacts
 * new-message
 * ws-status
 * auth-invalid
 * refreshing
 */
export function on(event, cb) {
  if (!listeners[event]) {
    listeners[event] = []
  }

  listeners[event].push(cb)
}

/**
 * 取消事件
 */
export function off(event, cb) {
  const arr = listeners[event]

  if (!arr) {
    return
  }

  const index = arr.indexOf(cb)

  if (index >= 0) {
    arr.splice(index, 1)
  }
}

/**
 * 派发事件
 */
function emit(event, payload) {
  const arr = listeners[event]

  if (!arr || !arr.length) {
    return
  }

  arr.slice().forEach((cb) => {
    try {
      cb(payload)
    } catch (e) {
      // 单个监听器报错不能影响其它监听器
    }
  })
}

// ============================================================
// IM 状态
// ============================================================

const state = {
  // 当前登录用户
  myInfo: null,

  // 好友
  friends: [],

  // 群组
  groups: [],

  // 好友申请
  friendRequests: [],

  // 已读位置
  // key = "1:userId" / "2:groupId"
  readMap: {},

  // 最后一条消息
  // key = "1:userId" / "2:groupId"
  lastMessageMap: {},

  // 未读
  unreadMap: {},

  // 会话列表
  conversations: [],

  // 私聊消息增量游标
  maxPrivateMessageId: 0,

  // 群聊消息增量游标
  maxGroupMessageId: 0,

  // 当前打开的聊天
  activeChatKey: null,

  // ----------------------------------------------------------
  // WebSocket
  // ----------------------------------------------------------

  /**
   * idle
   * connecting
   * connected
   * disconnected
   */
  wsStatus: 'idle',

  socketTask: null,

  // 心跳
  _heartbeat: null,

  // 自动重连
  _reconnectTimer: null,

  _reconnectAttempts: 0,

  // 初始化 Promise
  _initPromise: null,

  // 刷新 Promise
  _refreshPromise: null,

  // 是否主动断开
  _manualDisconnect: false,
}

// ============================================================
// 工具
// ============================================================

const keyOf = (type, targetId) => {
  return `${type}:${targetId}`
}

/**
 * 当前是否存在本地登录信息
 *
 * 注意：
 *
 * 这个函数只能判断：
 *
 * token + userInfo 是否存在。
 *
 * 不能完全代表 token 一定没有过期。
 */
export const hasLocalLogin = () => {
  return !!(
    getMyInfo() &&
    getAdminToken()
  )
}

/**
 * 保留原来的 API
 */
export const isLoggedIn = hasLocalLogin

/**
 * 当前用户 ID
 */
export function getMyUserId() {
  return (
    state.myInfo &&
    state.myInfo.id
  )
}

/**
 * 解析消息 content
 */
function parseContent(msg) {
  if (!msg) {
    return {}
  }

  try {
    return JSON.parse(msg.content)
  } catch (e) {
    return {
      content: msg.content,
    }
  }
}

/**
 * UUID
 */
function uuid() {
  return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(
    /[xy]/g,
    (c) => {
      const r =
        (Math.random() * 16) | 0

      const v =
        c === 'x'
          ? r
          : (r & 0x3) | 0x8

      return v.toString(16)
    }
  )
}

/**
 * 语音时长标准化
 *
 * 支持：
 *
 * 6
 * 6.2
 * 6000
 * "6000"
 *
 * 如果 > 1000，则认为是毫秒。
 */
function normalizeVoiceDuration(
  value
) {
  const n = Number(value || 0)

  if (
    !Number.isFinite(n) ||
    n <= 0
  ) {
    return 0
  }

  if (n > 1000) {
    return Math.max(
      1,
      Math.round(n / 1000)
    )
  }

  return Math.max(
    1,
    Math.round(n)
  )
}

/**
 * 判断一个错误是不是登录失效。
 *
 * 由于项目 adminRequest 的具体错误对象可能不同，
 * 这里尽量兼容常见结构。
 */
function isAuthError(error) {
  if (!error) {
    return false
  }

  const code = Number(
    error.code ??
      error.statusCode ??
      error.status ??
      error.data?.code ??
      error.response?.status ??
      error.response?.data?.code
  )

  if (
    code === 401 ||
    code === 403
  ) {
    return true
  }

  const message = String(
    error.msg ??
      error.message ??
      error.data?.msg ??
      error.response?.data?.msg ??
      ''
  ).toLowerCase()

  return (
    message.includes('token') ||
    message.includes('unauthorized') ||
    message.includes('未登录') ||
    message.includes('登录失效') ||
    message.includes('登录过期') ||
    message.includes('无权限')
  )
}

/**
 * 登录失效处理
 */
function handleAuthInvalid(error) {
  state.wsStatus =
    'disconnected'

  emit(
    'ws-status',
    'disconnected'
  )

  emit(
    'auth-invalid',
    error
  )

  return error
}

// ============================================================
// 初始化 / 登录
// ============================================================

/**
 * 检查本地登录状态
 *
 * 这里不伪造一个新的登录接口。
 *
 * 因为你当前 adminRequest 已经负责 token 管理，
 * 所以 IM Store 这里只做：
 *
 * 1. token 是否存在
 * 2. userInfo 是否存在
 *
 * 真正的 token 有效性，由第一次受保护 API 请求验证。
 */
export function checkLogin() {
  const token =
    getAdminToken()

  const myInfo =
    getMyInfo()

  if (!token || !myInfo) {
    return false
  }

  state.myInfo =
    myInfo

  return true
}

/**
 * 初始化 IM
 *
 * 页面进入 index.vue 后调用：
 *
 * await init()
 */
export async function init() {
  if (state._initPromise) {
    return state._initPromise
  }

  // 第一关：本地登录状态
  if (!checkLogin()) {
    handleAuthInvalid({
      code: 401,
      msg: '请先登录',
    })

    return false
  }

  state._initPromise =
    (async () => {
      try {
        await refreshContacts()

        await pullAllMessages()

        await pullReadPositions()

        rebuildConversations()

        connectWebSocket()

        return true
      } catch (error) {
        if (
          isAuthError(error)
        ) {
          handleAuthInvalid(
            error
          )

          return false
        }

        throw error
      }
    })().finally(() => {
      state._initPromise =
        null
    })

  return state._initPromise
}

// ============================================================
// 刷新
// ============================================================

/**
 * 刷新 IM 数据
 *
 * 给 index.vue 下拉刷新使用：
 *
 * await refresh()
 *
 * 注意：
 * 不清除 lastMessageMap，
 * 避免刷新过程中页面闪成空列表。
 */
export async function refresh() {
  if (state._refreshPromise) {
    return state._refreshPromise
  }

  if (!checkLogin()) {
    handleAuthInvalid({
      code: 401,
      msg: '请先登录',
    })

    return false
  }

  emit(
    'refreshing',
    true
  )

  state._refreshPromise =
    (async () => {
      try {
        // 重新获取好友、群
        await refreshContacts()

        // 增量消息
        await pullAllMessages()

        // 已读位置
        await pullReadPositions()

        // 重新生成会话
        rebuildConversations()

        // 如果 WS 不存在，则重新连接
        if (
          !state.socketTask &&
          getAdminRefreshToken()
        ) {
          connectWebSocket()
        }

        return true
      } catch (error) {
        if (
          isAuthError(error)
        ) {
          handleAuthInvalid(
            error
          )

          return false
        }

        throw error
      } finally {
        emit(
          'refreshing',
          false
        )
      }
    })().finally(() => {
      state._refreshPromise =
        null
    })

  return state._refreshPromise
}

// ============================================================
// 联系人
// ============================================================

/**
 * 刷新好友 / 群 / 好友申请
 *
 * 这里非常重要：
 *
 * 原来：
 *
 * getFriendList().catch(() => [])
 *
 * 会把 401 直接吃掉。
 *
 * 现在：
 *
 * 登录失效继续抛出。
 */
export async function refreshContacts() {
  if (!checkLogin()) {
    throw {
      code: 401,
      msg: '请先登录',
    }
  }

  let friends
  let groups
  let requests

  try {
    ;[
      friends,
      groups,
      requests,
    ] = await Promise.all([
      getFriendList(),
      getGroupList(),
      getFriendRequestList(
        100
      ),
    ])
  } catch (error) {
    if (
      isAuthError(error)
    ) {
      handleAuthInvalid(
        error
      )
    }

    throw error
  }

  state.friends =
    friends || []

  state.groups =
    groups || []

  state.friendRequests =
    (requests || []).filter(
      (r) =>
        r.handleResult === 0
    )

  rebuildConversations()

  emit('contacts')

  return {
    friends:
      state.friends,

    groups:
      state.groups,

    friendRequests:
      state.friendRequests,
  }
}

// ============================================================
// 消息增量
// ============================================================

/**
 * 拉取消息
 */
async function pullAllMessages() {
  const size = 100

  // ----------------------------------------------------------
  // 私聊
  // ----------------------------------------------------------

  let privates

  try {
    privates =
      await pullPrivateMessageList(
        state.maxPrivateMessageId,
        size
      )
  } catch (error) {
    if (
      isAuthError(error)
    ) {
      handleAuthInvalid(
        error
      )
    }

    throw error
  }

  if (
    privates &&
    privates.length
  ) {
    privates.forEach(
      (message) => {
        updateLastMessage(
          1,
          message
        )
      }
    )

    const ids =
      privates
        .map((m) =>
          Number(m.id)
        )
        .filter(
          (id) =>
            Number.isFinite(id)
        )

    if (ids.length) {
      state.maxPrivateMessageId =
        Math.max(
          state.maxPrivateMessageId,
          ...ids
        )
    }
  }

  // ----------------------------------------------------------
  // 群聊
  // ----------------------------------------------------------

  let groups

  try {
    groups =
      await pullGroupMessageList(
        state.maxGroupMessageId,
        size
      )
  } catch (error) {
    if (
      isAuthError(error)
    ) {
      handleAuthInvalid(
        error
      )
    }

    throw error
  }

  if (
    groups &&
    groups.length
  ) {
    groups.forEach(
      (message) => {
        updateLastMessage(
          2,
          message
        )
      }
    )

    const ids =
      groups
        .map((m) =>
          Number(m.id)
        )
        .filter(
          (id) =>
            Number.isFinite(id)
        )

    if (ids.length) {
      state.maxGroupMessageId =
        Math.max(
          state.maxGroupMessageId,
          ...ids
        )
    }
  }
}

/**
 * 拉取已读位置
 */
async function pullReadPositions() {
  let list

  try {
    list =
      await pullConversationReadList(
        200
      )
  } catch (error) {
    if (
      isAuthError(error)
    ) {
      handleAuthInvalid(
        error
      )
    }

    throw error
  }

  state.readMap = {}

  ;(list || []).forEach(
    (r) => {
      if (
        r.conversationType ===
          1 ||
        r.conversationType ===
          2
      ) {
        state.readMap[
          keyOf(
            r.conversationType,
            r.targetId
          )
        ] = r.messageId
      }
    }
  )
}

// ============================================================
// 最后一条消息
// ============================================================

/**
 * 更新最后一条消息
 */
function updateLastMessage(
  type,
  msg
) {
  if (!msg) {
    return
  }

  const myId =
    state.myInfo &&
    state.myInfo.id

  const targetId =
    type === 1
      ? (
          msg.senderId ===
          myId
            ? msg.receiverId
            : msg.senderId
        )
      : msg.groupId

  if (!targetId) {
    return
  }

  const key = keyOf(
    type,
    targetId
  )

  if (
    !state.lastMessageMap[
      key
    ] ||
    Number(
      state.lastMessageMap[
        key
      ].id
    ) <
      Number(msg.id)
  ) {
    state.lastMessageMap[
      key
    ] = msg
  }

  return key
}

/**
 * 群事件
 */
function groupEventText(
  type
) {
  const map = {
    1501: '创建了群聊',
    1502: '群信息已更新',
    1504: '有人退出了群聊',
    1508: '有新成员加入群聊',
    1509: '有新成员加入群聊',
    1510: '有人退出了群聊',
    1511: '群聊已解散',
    1516: '群成员昵称已更新',
    1517: '设置了群管理员',
    1518: '移除了群管理员',
    1519: '群主已转让',
    1520: '群名已更新',
    1530: '群成员设置已更新',
  }

  return (
    map[type] ||
    '[群通知]'
  )
}

/**
 * 会话列表最后一条消息摘要
 *
 * TEXT
 *   -> 最后一条文字
 *
 * IMAGE
 *   -> [图片]
 *
 * VOICE
 *   -> [语音] 6″
 *
 * VIDEO
 *   -> [视频]
 *
 * FILE
 *   -> [文件]
 */
function renderLastContent(
  msg
) {
  if (!msg) {
    return ''
  }

  const type =
    msg.type

  const content =
    parseContent(msg)

  const myId =
    state.myInfo &&
    state.myInfo.id

  const mine =
    msg.senderId === myId

  const prefix =
    mine
      ? '我: '
      : ''

  switch (type) {
    // --------------------------------------------------------
    // 文字
    // --------------------------------------------------------

    case ImContentType.TEXT:
      return (
        prefix +
        (
          content.content ||
          ''
        )
      )

    // --------------------------------------------------------
    // 图片
    // --------------------------------------------------------

    case ImContentType.IMAGE:
      return (
        prefix +
        '[图片]'
      )

    // --------------------------------------------------------
    // 语音
    // --------------------------------------------------------

    case ImContentType.VOICE: {
      const duration =
        normalizeVoiceDuration(
          content.duration ||
            content.durationMs ||
            content.length
        )

      if (duration) {
        return (
          prefix +
          `[语音] ${duration}″`
        )
      }

      return (
        prefix +
        '[语音]'
      )
    }

    // --------------------------------------------------------
    // 视频
    // --------------------------------------------------------

    case ImContentType.VIDEO:
      return (
        prefix +
        '[视频]'
      )

    // --------------------------------------------------------
    // 文件
    // --------------------------------------------------------

    case ImContentType.FILE:
      return (
        prefix +
        '[文件]'
      )

    // --------------------------------------------------------
    // 撤回
    // --------------------------------------------------------

    case ImContentType.RECALL:
      return '撤回了一条消息'

    default:
      break
  }

  // 群系统消息
  if (
    type >= 1501 &&
    type <= 1533
  ) {
    return groupEventText(
      type
    )
  }

  // 好友系统消息
  if (
    type >= 1201 &&
    type <= 1210
  ) {
    return '好友通知'
  }

  return (
    prefix +
    '[消息]'
  )
}

// ============================================================
// 会话列表
// ============================================================

function rebuildConversations() {
  const list = []

  // ----------------------------------------------------------
  // 私聊
  // ----------------------------------------------------------

  ;(
    state.friends || []
  ).forEach((friend) => {
    const key = keyOf(
      1,
      friend.friendUserId
    )

    const last =
      state.lastMessageMap[
        key
      ]

    list.push({
      type: 1,

      targetId:
        friend.friendUserId,

      key,

      name:
        friend.displayName ||
        friend.nickname ||
        '好友',

      avatar:
        friend.avatar ||
        '',

      lastContent:
        last
          ? renderLastContent(
              last
            )
          : '',

      lastSendTime:
        last
          ? last.sendTime
          : 0,

      unread:
        state.unreadMap[
          key
        ] || 0,

      silent:
        friend.silent,
    })
  })

  // ----------------------------------------------------------
  // 群聊
  // ----------------------------------------------------------

  ;(
    state.groups || []
  ).forEach((group) => {
    const key = keyOf(
      2,
      group.id
    )

    const last =
      state.lastMessageMap[
        key
      ]

    list.push({
      type: 2,

      targetId:
        group.id,

      key,

      name:
        group.name ||
        '群聊',

      avatar:
        group.avatar ||
        '',

      lastContent:
        last
          ? renderLastContent(
              last
            )
          : '',

      lastSendTime:
        last
          ? last.sendTime
          : 0,

      unread:
        state.unreadMap[
          key
        ] || 0,

      silent:
        group.silent,
    })
  })

  // 最新消息在最前
  list.sort(
    (a, b) =>
      (
        b.lastSendTime ||
        0
      ) -
      (
        a.lastSendTime ||
        0
      )
  )

  state.conversations =
    list

  emit(
    'conversations',
    state.conversations
  )

  return list
}

// ============================================================
// 新消息
// ============================================================

/**
 * 统一处理：
 *
 * 1. WS 新消息
 * 2. 发送成功消息
 */
export function handleNewMessage(
  type,
  msg
) {
  if (!msg) {
    return
  }

  const myId =
    state.myInfo &&
    state.myInfo.id

  const key =
    updateLastMessage(
      type,
      msg
    )

  if (!key) {
    return
  }

  // ----------------------------------------------------------
  // 群定向消息
  // ----------------------------------------------------------

  if (
    type === 2 &&
    Array.isArray(
      msg.receiverUserIds
    ) &&
    msg.receiverUserIds.length
  ) {
    if (
      !msg.receiverUserIds.includes(
        myId
      )
    ) {
      return
    }
  }

  // ----------------------------------------------------------
  // 未读
  // ----------------------------------------------------------

  if (
    msg.senderId !== myId
  ) {
    const readId =
      state.readMap[key]

    const alreadyRead =
      readId &&
      Number(readId) >=
        Number(msg.id)

    const isCurrent =
      key ===
      state.activeChatKey

    if (
      !alreadyRead &&
      !isCurrent
    ) {
      state.unreadMap[key] =
        (
          state.unreadMap[
            key
          ] || 0
        ) + 1
    }
  }

  rebuildConversations()

  emit(
    'new-message',
    {
      key,
      type,
      msg,
    }
  )
}

// ============================================================
// 发送文字
// ============================================================

export async function sendText(
  type,
  targetId,
  text,
  atUserIds
) {
  if (!text) {
    return null
  }

  if (!checkLogin()) {
    handleAuthInvalid({
      code: 401,
      msg: '请先登录',
    })

    throw new Error(
      '请先登录'
    )
  }

  const clientMessageId =
    uuid()

  const content =
    JSON.stringify({
      content: text,
    })

  let msg

  try {
    if (type === 1) {
      msg =
        await sendPrivateMessage({
          clientMessageId,

          receiverId:
            targetId,

          type:
            ImContentType.TEXT,

          content,
        })
    } else {
      msg =
        await sendGroupMessage({
          clientMessageId,

          groupId:
            targetId,

          type:
            ImContentType.TEXT,

          content,

          atUserIds:
            atUserIds || [],
        })
    }
  } catch (error) {
    if (
      isAuthError(error)
    ) {
      handleAuthInvalid(
        error
      )
    }

    throw error
  }

  handleNewMessage(
    type,
    msg
  )

  return msg
}

// ============================================================
// 发送图片
// ============================================================

export async function sendImage(
  type,
  targetId,
  url,
  thumbnailUrl
) {
  if (!url) {
    throw new Error(
      '图片地址不能为空'
    )
  }

  if (!checkLogin()) {
    handleAuthInvalid({
      code: 401,
      msg: '请先登录',
    })

    throw new Error(
      '请先登录'
    )
  }

  const clientMessageId =
    uuid()

  const content =
    JSON.stringify({
      url,

      thumbnailUrl:
        thumbnailUrl || url,
    })

  let msg

  try {
    if (type === 1) {
      msg =
        await sendPrivateMessage({
          clientMessageId,

          receiverId:
            targetId,

          type:
            ImContentType.IMAGE,

          content,
        })
    } else {
      msg =
        await sendGroupMessage({
          clientMessageId,

          groupId:
            targetId,

          type:
            ImContentType.IMAGE,

          content,
        })
    }
  } catch (error) {
    if (
      isAuthError(error)
    ) {
      handleAuthInvalid(
        error
      )
    }

    throw error
  }

  handleNewMessage(
    type,
    msg
  )

  return msg
}

// ============================================================
// 发送语音
// ============================================================

/**
 * 发送语音
 *
 * content：
 *
 * {
 *   url: "...",
 *   duration: 6
 * }
 *
 * 后端：
 *
 * type = 103
 */
export async function sendVoice(
  type,
  targetId,
  url,
  duration
) {
  if (!url) {
    throw new Error(
      '语音地址不能为空'
    )
  }

  if (!checkLogin()) {
    handleAuthInvalid({
      code: 401,
      msg: '请先登录',
    })

    throw new Error(
      '请先登录'
    )
  }

  const normalizedDuration =
    normalizeVoiceDuration(
      duration
    )

  const clientMessageId =
    uuid()

  const content =
    JSON.stringify({
      url,

      duration:
        normalizedDuration,
    })

  let msg

  try {
    if (type === 1) {
      msg =
        await sendPrivateMessage({
          clientMessageId,

          receiverId:
            targetId,

          type:
            ImContentType.VOICE,

          content,
        })
    } else {
      msg =
        await sendGroupMessage({
          clientMessageId,

          groupId:
            targetId,

          type:
            ImContentType.VOICE,

          content,
        })
    }
  } catch (error) {
    if (
      isAuthError(error)
    ) {
      handleAuthInvalid(
        error
      )
    }

    throw error
  }

  handleNewMessage(
    type,
    msg
  )

  return msg
}

// ============================================================
// 已读
// ============================================================

export function markRead(
  type,
  targetId,
  messageId
) {
  const key = keyOf(
    type,
    targetId
  )

  state.readMap[key] =
    Math.max(
      Number(
        state.readMap[key] || 0
      ),
      Number(
        messageId || 0
      )
    )

  state.unreadMap[key] = 0

  if (type === 1) {
    readPrivateMessages(
      targetId,
      messageId
    ).catch(() => {})
  } else {
    readGroupMessages(
      targetId,
      messageId
    ).catch(() => {})
  }

  rebuildConversations()
}

/**
 * 设置当前聊天
 */
export function setActiveChat(
  type,
  targetId
) {
  state.activeChatKey =
    keyOf(
      type,
      targetId
    )

  state.unreadMap[
    state.activeChatKey
  ] = 0

  rebuildConversations()
}

/**
 * 清除当前聊天
 */
export function clearActiveChat() {
  state.activeChatKey =
    null
}

// ============================================================
// WebSocket
// ============================================================

/**
 * WebSocket 帧处理
 */
function handleFrame(data) {
  let frame

  try {
    frame =
      JSON.parse(data)
  } catch (e) {
    return
  }

  // pong
  if (
    frame === 'pong'
  ) {
    return
  }

  if (
    !frame ||
    frame.type !==
      'im-notification'
  ) {
    return
  }

  let content

  try {
    content =
      JSON.parse(
        frame.content
      )
  } catch (e) {
    return
  }

  const {
    conversationType,
    contentType,
    payload,
  } = content

  if (!payload) {
    return
  }

  payload.type =
    contentType

  if (
    conversationType === 1
  ) {
    handlePrivateFrame(
      payload
    )
  } else if (
    conversationType === 2
  ) {
    handleGroupFrame(
      payload
    )
  } else {
    handleOtherFrame(
      payload
    )
  }
}

/**
 * 私聊 WS
 */
function handlePrivateFrame(
  payload
) {
  const type =
    payload.type

  // 已读 / 回执
  if (
    type ===
      ImContentType.READ ||
    type ===
      ImContentType.RECEIPT
  ) {
    return
  }

  // 好友关系变化
  if (
    type >= 1201 &&
    type <= 1210
  ) {
    refreshContacts().catch(
      () => {}
    )

    return
  }

  handleNewMessage(
    1,
    payload
  )
}

/**
 * 群聊 WS
 */
function handleGroupFrame(
  payload
) {
  const type =
    payload.type

  // 已读 / 回执
  if (
    type ===
      ImContentType.READ ||
    type ===
      ImContentType.RECEIPT
  ) {
    return
  }

  // 群系统事件
  if (
    type >= 1501 &&
    type <= 1533
  ) {
    refreshContacts().catch(
      () => {}
    )

    handleNewMessage(
      2,
      payload
    )

    return
  }

  handleNewMessage(
    2,
    payload
  )
}

/**
 * 其它 IM 通知
 */
function handleOtherFrame() {
  getFriendRequestList(
    100
  )
    .then((list) => {
      state.friendRequests =
        (
          list || []
        ).filter(
          (r) =>
            r.handleResult ===
            0
        )

      emit(
        'contacts'
      )
    })
    .catch((error) => {
      if (
        isAuthError(error)
      ) {
        handleAuthInvalid(
          error
        )
      }
    })
}

/**
 * 建立 WebSocket
 */
export function connectWebSocket() {
  // 没登录，不连接
  if (!checkLogin()) {
    return false
  }

  // 已经连接 / 正在连接
  if (
    state.socketTask &&
    (
      state.wsStatus ===
        'connecting' ||
      state.wsStatus ===
        'connected'
    )
  ) {
    return true
  }

  const refreshToken =
    getAdminRefreshToken()

  if (!refreshToken) {
    state.wsStatus =
      'disconnected'

    emit(
      'ws-status',
      'disconnected'
    )

    return false
  }

  state._manualDisconnect =
    false

  state.wsStatus =
    'connecting'

  emit(
    'ws-status',
    'connecting'
  )

  const wsUrl =
    buildWsUrl() +
    '/infra/ws?token=' +
    encodeURIComponent(
      refreshToken
    )

  try {
    const task =
      uni.connectSocket({
        url: wsUrl,
      })

    state.socketTask =
      task

    // --------------------------------------------------------
    // 成功
    // --------------------------------------------------------

    task.onOpen(() => {
      state.wsStatus =
        'connected'

      state._reconnectAttempts =
        0

      startHeartbeat()

      emit(
        'ws-status',
        'connected'
      )
    })

    // --------------------------------------------------------
    // 收消息
    // --------------------------------------------------------

    task.onMessage((res) => {
      handleFrame(
        res.data
      )
    })

    // --------------------------------------------------------
    // 关闭
    // --------------------------------------------------------

    task.onClose(() => {
      state.socketTask =
        null

      state.wsStatus =
        'disconnected'

      stopHeartbeat()

      emit(
        'ws-status',
        'disconnected'
      )

      if (
        !state._manualDisconnect
      ) {
        scheduleReconnect()
      }
    })

    // --------------------------------------------------------
    // 错误
    // --------------------------------------------------------

    task.onError((error) => {
      state.wsStatus =
        'disconnected'

      stopHeartbeat()

      emit(
        'ws-status',
        'disconnected'
      )

      // onClose 一般会随后触发
      // 这里不重复 scheduleReconnect
    })

    return true
  } catch (error) {
    state.socketTask =
      null

    state.wsStatus =
      'disconnected'

    stopHeartbeat()

    emit(
      'ws-status',
      'disconnected'
    )

    if (
      !state._manualDisconnect
    ) {
      scheduleReconnect()
    }

    return false
  }
}

/**
 * 心跳
 */
function startHeartbeat() {
  stopHeartbeat()

  state._heartbeat =
    setInterval(() => {
      if (
        state.socketTask &&
        state.wsStatus ===
          'connected'
      ) {
        try {
          state.socketTask.send({
            data: 'ping',
          })
        } catch (e) {}
      }
    }, 5000)
}

/**
 * 停止心跳
 */
function stopHeartbeat() {
  if (
    state._heartbeat
  ) {
    clearInterval(
      state._heartbeat
    )

    state._heartbeat =
      null
  }
}

/**
 * 自动重连
 */
function scheduleReconnect() {
  if (
    state._manualDisconnect
  ) {
    return
  }

  if (
    state._reconnectTimer
  ) {
    return
  }

  // 没登录，不重连
  if (
    !hasLocalLogin()
  ) {
    return
  }

  const delay =
    Math.min(
      1000 *
        Math.pow(
          2,
          state._reconnectAttempts
        ),
      30000
    )

  state._reconnectAttempts++

  state._reconnectTimer =
    setTimeout(() => {
      state._reconnectTimer =
        null

      state.socketTask =
        null

      if (
        !hasLocalLogin()
      ) {
        return
      }

      connectWebSocket()
    }, delay)
}

/**
 * 主动断开
 */
export function disconnectWebSocket() {
  state._manualDisconnect =
    true

  stopHeartbeat()

  if (
    state._reconnectTimer
  ) {
    clearTimeout(
      state._reconnectTimer
    )

    state._reconnectTimer =
      null
  }

  if (
    state.socketTask
  ) {
    try {
      state.socketTask.close({})
    } catch (e) {}

    state.socketTask =
      null
  }

  state.wsStatus =
    'idle'

  emit(
    'ws-status',
    'idle'
  )
}

// ============================================================
// 对外状态
// ============================================================

export function getWsStatus() {
  return state.wsStatus
}

/**
 * 保留旧 API。
 *
 * 以前：
 *
 * getWsConnected()
 *
 * 现在：
 *
 * connected === true
 */
export function getWsConnected() {
  return (
    state.wsStatus ===
    'connected'
  )
}

export function getConversations() {
  return state.conversations
}

export function getContacts() {
  return {
    friends:
      state.friends,

    groups:
      state.groups,
  }
}

export function getFriendRequests() {
  return state.friendRequests
}

export function getLastMessage(
  type,
  targetId
) {
  return (
    state.lastMessageMap[
      keyOf(
        type,
        targetId
      )
    ]
  )
}

// ============================================================
// 登出
// ============================================================

export function logout() {
  state._manualDisconnect =
    true

  disconnectWebSocket()

  clearAdminToken()

  clearMyInfo()

  state.myInfo =
    null

  state.friends = []

  state.groups = []

  state.friendRequests =
    []

  state.readMap = {}

  state.lastMessageMap =
    {}

  state.unreadMap = {}

  state.conversations =
    []

  state.maxPrivateMessageId =
    0

  state.maxGroupMessageId =
    0

  state.activeChatKey =
    null

  state.wsStatus =
    'idle'

  emit(
    'conversations',
    []
  )

  emit(
    'contacts'
  )

  emit(
    'ws-status',
    'idle'
  )
}