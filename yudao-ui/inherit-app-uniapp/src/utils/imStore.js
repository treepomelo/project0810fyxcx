/**
 * IM 状态层（单例，跨页面共享）：
 * - 会话列表本地聚合：好友/群元数据 + 增量拉取消息摘要 + 已读位置 + WS 实时增量
 * - WebSocket 连接 / 心跳 / 自动重连，帧分发（type=im-notification）
 * - 轻量事件订阅：conversations / contacts / new-message / ws-status
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

// ---------- 事件 ----------
const listeners = {}

export function on(event, cb) {
  ;(listeners[event] = listeners[event] || []).push(cb)
}

export function off(event, cb) {
  const arr = listeners[event]

  if (arr) {
    const i = arr.indexOf(cb)

    if (i >= 0) {
      arr.splice(i, 1)
    }
  }
}

function emit(event, payload) {
  ;(listeners[event] || []).slice().forEach((cb) => {
    try {
      cb(payload)
    } catch (e) {}
  })
}

// ---------- 状态 ----------
const state = {
  myInfo: null,

  friends: [],
  groups: [],
  friendRequests: [],

  readMap: {},

  lastMessageMap: {},

  unreadMap: {},

  conversations: [],

  maxPrivateMessageId: 0,
  maxGroupMessageId: 0,

  activeChatKey: null,

  wsConnected: false,
  socketTask: null,

  _heartbeat: null,
  _reconnectTimer: null,
  _reconnectAttempts: 0,
  _initPromise: null,
}

const keyOf = (type, targetId) => `${type}:${targetId}`

export const isLoggedIn = () =>
  !!(getMyInfo() && getAdminToken())

// ---------- 消息内容解析 ----------

function parseContent(msg) {
  try {
    return JSON.parse(msg.content)
  } catch (e) {
    return {
      content: msg.content,
    }
  }
}

// ---------- UUID ----------

function uuid() {
  return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(
    /[xy]/g,
    (c) => {
      const r = (Math.random() * 16) | 0
      const v = c === 'x'
        ? r
        : (r & 0x3) | 0x8

      return v.toString(16)
    }
  )
}

// ---------- 初始化 / 联系人 / 增量拉取 ----------

export async function init() {
  if (state._initPromise) {
    return state._initPromise
  }

  state.myInfo = getMyInfo()

  state._initPromise = (async () => {
    await refreshContacts()
    await pullAllMessages()
    await pullReadPositions()

    rebuildConversations()

    connectWebSocket()
  })().finally(() => {
    state._initPromise = null
  })

  return state._initPromise
}

export async function refreshContacts() {
  const [friends, groups, requests] = await Promise.all([
    getFriendList().catch(() => []),
    getGroupList().catch(() => []),
    getFriendRequestList(100).catch(() => []),
  ])

  state.friends = friends || []
  state.groups = groups || []

  state.friendRequests = (requests || [])
    .filter((r) => r.handleResult === 0)

  rebuildConversations()

  emit('contacts')
}

async function pullAllMessages() {
  const size = 100

  const privates = await pullPrivateMessageList(
    state.maxPrivateMessageId,
    size
  ).catch(() => [])

  if (privates && privates.length) {
    privates.forEach((m) => {
      updateLastMessage(1, m)
    })

    state.maxPrivateMessageId = Math.max(
      state.maxPrivateMessageId,
      ...privates.map((m) => m.id)
    )
  }

  const groups = await pullGroupMessageList(
    state.maxGroupMessageId,
    size
  ).catch(() => [])

  if (groups && groups.length) {
    groups.forEach((m) => {
      updateLastMessage(2, m)
    })

    state.maxGroupMessageId = Math.max(
      state.maxGroupMessageId,
      ...groups.map((m) => m.id)
    )
  }
}

async function pullReadPositions() {
  const list = await pullConversationReadList(200).catch(() => [])

  state.readMap = {}

  ;(list || []).forEach((r) => {
    if (
      r.conversationType === 1 ||
      r.conversationType === 2
    ) {
      state.readMap[
        keyOf(r.conversationType, r.targetId)
      ] = r.messageId
    }
  })
}

function updateLastMessage(type, msg) {
  const myId = state.myInfo && state.myInfo.id

  const targetId =
    type === 1
      ? (
          msg.senderId === myId
            ? msg.receiverId
            : msg.senderId
        )
      : msg.groupId

  if (!targetId) {
    return
  }

  const key = keyOf(type, targetId)

  if (
    !state.lastMessageMap[key] ||
    state.lastMessageMap[key].id < msg.id
  ) {
    state.lastMessageMap[key] = msg
  }

  return key
}

// ---------- 会话列表聚合 ----------

function groupEventText(t, content) {
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

  return map[t] || '[群通知]'
}

function renderLastContent(msg) {
  const t = msg.type

  const content = parseContent(msg)

  const mine =
    msg.senderId ===
    (state.myInfo && state.myInfo.id)

  const prefix = mine ? '我: ' : ''

  switch (t) {
    case ImContentType.TEXT:
      return prefix + (content.content || '')

    case ImContentType.IMAGE:
      return prefix + '[图片]'

    case ImContentType.VOICE:
      return prefix + '[语音]'

    case ImContentType.VIDEO:
      return prefix + '[视频]'

    case ImContentType.FILE:
      return prefix + '[文件]'

    case ImContentType.RECALL:
      return '撤回了一条消息'

    default:
      break
  }

  if (t >= 1501 && t <= 1533) {
    return groupEventText(t, content)
  }

  if (t >= 1201 && t <= 1210) {
    return '好友通知'
  }

  return prefix + '[消息]'
}

function rebuildConversations() {
  const list = []

  ;(state.friends || []).forEach((f) => {
    const key = keyOf(1, f.friendUserId)

    const last = state.lastMessageMap[key]

    list.push({
      type: 1,
      targetId: f.friendUserId,
      key,
      name:
        f.displayName ||
        f.nickname ||
        '好友',
      avatar: f.avatar || '',
      lastContent:
        last
          ? renderLastContent(last)
          : '',
      lastSendTime:
        last
          ? last.sendTime
          : 0,
      unread:
        state.unreadMap[key] || 0,
      silent: f.silent,
    })
  })

  ;(state.groups || []).forEach((g) => {
    const key = keyOf(2, g.id)

    const last = state.lastMessageMap[key]

    list.push({
      type: 2,
      targetId: g.id,
      key,
      name: g.name || '群聊',
      avatar: g.avatar || '',
      lastContent:
        last
          ? renderLastContent(last)
          : '',
      lastSendTime:
        last
          ? last.sendTime
          : 0,
      unread:
        state.unreadMap[key] || 0,
      silent: g.silent,
    })
  })

  list.sort(
    (a, b) =>
      (b.lastSendTime || 0) -
      (a.lastSendTime || 0)
  )

  state.conversations = list

  emit('conversations')
}

// ---------- 新消息处理 ----------

export function handleNewMessage(type, msg) {
  const myId =
    state.myInfo &&
    state.myInfo.id

  const key = updateLastMessage(type, msg)

  if (!key) {
    return
  }

  // 群定向消息：不含我则丢弃
  if (
    type === 2 &&
    Array.isArray(msg.receiverUserIds) &&
    msg.receiverUserIds.length
  ) {
    if (
      !msg.receiverUserIds.includes(myId)
    ) {
      return
    }
  }

  // 未读计数
  if (msg.senderId !== myId) {
    const readId = state.readMap[key]

    if (
      !(readId && readId >= msg.id) &&
      key !== state.activeChatKey
    ) {
      state.unreadMap[key] =
        (state.unreadMap[key] || 0) + 1
    }
  }

  rebuildConversations()

  emit('new-message', {
    key,
    type,
    msg,
  })
}

// ---------- 发送文字 ----------

export async function sendText(
  type,
  targetId,
  text,
  atUserIds
) {
  const clientMessageId = uuid()

  const content = JSON.stringify({
    content: text,
  })

  let msg

  if (type === 1) {
    msg = await sendPrivateMessage({
      clientMessageId,
      receiverId: targetId,
      type: ImContentType.TEXT,
      content,
    })
  } else {
    msg = await sendGroupMessage({
      clientMessageId,
      groupId: targetId,
      type: ImContentType.TEXT,
      content,
      atUserIds: atUserIds || [],
    })
  }

  handleNewMessage(type, msg)

  return msg
}

// ---------- 发送图片 ----------

export async function sendImage(
  type,
  targetId,
  url,
  thumbnailUrl
) {
  const clientMessageId = uuid()

  const content = JSON.stringify({
    url,
    thumbnailUrl:
      thumbnailUrl || url,
  })

  let msg

  if (type === 1) {
    msg = await sendPrivateMessage({
      clientMessageId,
      receiverId: targetId,
      type: ImContentType.IMAGE,
      content,
    })
  } else {
    msg = await sendGroupMessage({
      clientMessageId,
      groupId: targetId,
      type: ImContentType.IMAGE,
      content,
    })
  }

  handleNewMessage(type, msg)

  return msg
}

// ---------- 发送语音 ----------

/**
 * 发送语音消息。
 *
 * content:
 * {
 *   url: 'https://xxx/audio.mp3',
 *   duration: 3
 * }
 *
 * duration 单位：秒。
 */
export async function sendVoice(
  type,
  targetId,
  url,
  duration
) {
  const clientMessageId = uuid()

  const safeDuration = Math.max(
    0,
    Math.round(Number(duration) || 0)
  )

  const content = JSON.stringify({
    url,
    duration: safeDuration,
  })

  let msg

  if (type === 1) {
    msg = await sendPrivateMessage({
      clientMessageId,
      receiverId: targetId,
      type: ImContentType.VOICE,
      content,
    })
  } else {
    msg = await sendGroupMessage({
      clientMessageId,
      groupId: targetId,
      type: ImContentType.VOICE,
      content,
    })
  }

  handleNewMessage(type, msg)

  return msg
}

// ---------- 已读 ----------

export function markRead(
  type,
  targetId,
  messageId
) {
  const key = keyOf(type, targetId)

  state.readMap[key] =
    Math.max(
      state.readMap[key] || 0,
      messageId || 0
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

export function setActiveChat(
  type,
  targetId
) {
  state.activeChatKey =
    keyOf(type, targetId)

  state.unreadMap[
    state.activeChatKey
  ] = 0

  rebuildConversations()
}

export function clearActiveChat() {
  state.activeChatKey = null
}

// ---------- WebSocket ----------

function handleFrame(data) {
  let frame

  try {
    frame = JSON.parse(data)
  } catch (e) {
    return
  }

  if (frame === 'pong') {
    return
  }

  if (
    !frame ||
    frame.type !== 'im-notification'
  ) {
    return
  }

  let content

  try {
    content = JSON.parse(frame.content)
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

  payload.type = contentType

  if (conversationType === 1) {
    handlePrivateFrame(payload)
  } else if (conversationType === 2) {
    handleGroupFrame(payload)
  } else {
    handleOtherFrame(payload)
  }
}

function handlePrivateFrame(payload) {
  const t = payload.type

  if (
    t === ImContentType.READ ||
    t === ImContentType.RECEIPT
  ) {
    return
  }

  if (t >= 1201 && t <= 1210) {
    refreshContacts()
    return
  }

  handleNewMessage(1, payload)
}

function handleGroupFrame(payload) {
  const t = payload.type

  if (
    t === ImContentType.READ ||
    t === ImContentType.RECEIPT
  ) {
    return
  }

  if (t >= 1501 && t <= 1533) {
    refreshContacts()
    handleNewMessage(2, payload)
    return
  }

  handleNewMessage(2, payload)
}

function handleOtherFrame() {
  getFriendRequestList(100)
    .then((list) => {
      state.friendRequests =
        (list || []).filter(
          (r) => r.handleResult === 0
        )

      emit('contacts')
    })
    .catch(() => {})
}

export function connectWebSocket() {
  if (state.socketTask) {
    return
  }

  const refreshToken =
    getAdminRefreshToken()

  if (!refreshToken) {
    return
  }

  const wsUrl =
    buildWsUrl() +
    '/infra/ws?token=' +
    refreshToken

  try {
    const task = uni.connectSocket({
      url: wsUrl,
    })

    state.socketTask = task

    task.onOpen(() => {
      state.wsConnected = true
      state._reconnectAttempts = 0

      startHeartbeat()

      emit(
        'ws-status',
        true
      )
    })

    task.onMessage((res) => {
      handleFrame(res.data)
    })

    task.onClose(() => {
      state.wsConnected = false

      stopHeartbeat()

      emit(
        'ws-status',
        false
      )

      scheduleReconnect()
    })

    task.onError(() => {})
  } catch (e) {}
}

function startHeartbeat() {
  stopHeartbeat()

  state._heartbeat =
    setInterval(() => {
      if (
        state.socketTask &&
        state.wsConnected
      ) {
        try {
          state.socketTask.send({
            data: 'ping',
          })
        } catch (e) {}
      }
    }, 5000)
}

function stopHeartbeat() {
  if (state._heartbeat) {
    clearInterval(
      state._heartbeat
    )

    state._heartbeat = null
  }
}

function scheduleReconnect() {
  if (state._reconnectTimer) {
    return
  }

  const delay = Math.min(
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
      state._reconnectTimer = null
      state.socketTask = null

      connectWebSocket()
    }, delay)
}

export function disconnectWebSocket() {
  stopHeartbeat()

  if (state._reconnectTimer) {
    clearTimeout(
      state._reconnectTimer
    )

    state._reconnectTimer = null
  }

  if (state.socketTask) {
    try {
      state.socketTask.close({})
    } catch (e) {}

    state.socketTask = null
  }

  state.wsConnected = false
}

// ---------- 对外只读 ----------

export function getMyUserId() {
  return state.myInfo &&
    state.myInfo.id
}

export const getConversations =
  () => state.conversations

export const getContacts =
  () => ({
    friends: state.friends,
    groups: state.groups,
  })

export const getFriendRequests =
  () => state.friendRequests

export const getWsConnected =
  () => state.wsConnected

export const getLastMessage =
  (type, targetId) =>
    state.lastMessageMap[
      keyOf(type, targetId)
    ]

// ---------- 登出 ----------

export function logout() {
  disconnectWebSocket()

  clearAdminToken()
  clearMyInfo()

  state.myInfo = null

  state.friends = []
  state.groups = []
  state.friendRequests = []

  state.readMap = {}
  state.lastMessageMap = {}
  state.unreadMap = {}

  state.conversations = []

  state.maxPrivateMessageId = 0
  state.maxGroupMessageId = 0

  state.activeChatKey = null

  emit('conversations')
  emit('contacts')
}