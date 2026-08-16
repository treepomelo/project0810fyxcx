<template>
  <view class="chat-page">
    <!-- 消息列表 -->
    <scroll-view class="msg-scroll" scroll-y :scroll-into-view="scrollIntoId" :scroll-with-animation="true">
      <view class="msg-list">
        <view v-if="loadingHistory" class="load-more" @click="loadMore">加载中...</view>
        <view v-else-if="historyEnded" class="load-more">没有更多消息了</view>
        <view v-else class="load-more" @click="loadMore">加载更早消息</view>

        <view v-for="m in messages" :id="'msg-' + m.id" :key="m.id" class="msg-wrap">
          <!-- 系统提示 -->
          <view v-if="isTip(m)" class="msg-tip">{{ renderTip(m) }}</view>
          <!-- 气泡 -->
          <view v-else class="msg-row" :class="{ mine: m._mine }">
            <image class="msg-avatar" :src="m._avatar || defaultAvatar" mode="aspectFill" />
            <view class="msg-body">
              <view class="msg-name" v-if="!m._mine && isGroup && m._senderName">{{ m._senderName }}</view>
              <view class="bubble" :class="{ mine: m._mine }" @longpress="onLongPress(m)">
                <image v-if="m._kind === 'image'" class="bubble-img" :src="m._imageUrl" mode="aspectFill" @click="preview(m._imageUrl)" />
                <text v-else>{{ m._kind === 'text' ? m._text : renderTip(m) }}</text>
              </view>
            </view>
          </view>
        </view>
      </view>
    </scroll-view>

    <!-- 输入栏 -->
    <view class="input-bar">
      <view class="tool-btn" @click="chooseImage">图片</view>
      <input class="input" v-model="draft" confirm-type="send" placeholder="输入消息" @confirm="sendDraft" />
      <view class="send-btn" @click="sendDraft">发送</view>
    </view>
  </view>
</template>

<script>
import {
  setActiveChat,
  clearActiveChat,
  markRead,
  sendText,
  sendImage,
  getMyUserId,
  getLastMessage,
  on,
  off,
} from '../../utils/imStore.js'
import { getMyInfo } from '../../utils/adminRequest.js'
import {
  getPrivateMessageList,
  getGroupMessageList,
  getGroupMemberList,
  recallPrivateMessage,
  recallGroupMessage,
  uploadImage,
  ImContentType,
} from '../../api/im.js'

const keyOf = (type, targetId) => `${type}:${targetId}`

export default {
  data() {
    return {
      type: 1,
      targetId: null,
      name: '',
      avatar: '',
      messages: [],
      draft: '',
      scrollIntoId: '',
      loadingHistory: false,
      historyEnded: false,
      myId: null,
      myAvatar: '',
      memberMap: {}, // group: userId -> { nickname, avatar }
      defaultAvatar: 'https://qiniu-web-assets.dcloud.net.cn/unidoc/zh/uni.png',
      _handlers: [],
    }
  },
  computed: {
    isGroup() {
      return this.type === 2
    },
    chatKey() {
      return keyOf(this.type, this.targetId)
    },
  },
  onLoad(options) {
    this.type = Number(options.type)
    this.targetId = Number(options.targetId)
    this.name = decodeURIComponent(options.name || '')
    this.avatar = decodeURIComponent(options.avatar || '')
    this.myId = getMyUserId()
    const me = getMyInfo()
    this.myAvatar = (me && me.avatar) || ''
    uni.setNavigationBarTitle({ title: this.name || (this.type === 1 ? '好友' : '群聊') })
    setActiveChat(this.type, this.targetId)

    this._subscribe('new-message', ({ key, msg }) => {
      if (key === this.chatKey) this.appendMessage(msg)
    })

    if (this.isGroup) {
      this.fetchMembers()
    }
    this.fetchHistory()
    // 拉历史后标记已读
    this.maybeMarkRead()
  },
  onUnload() {
    this._handlers.forEach(([e, cb]) => off(e, cb))
    this._handlers = []
    clearActiveChat()
  },
  methods: {
    _subscribe(event, cb) {
      on(event, cb)
      this._handlers.push([event, cb])
    },
    parse(msg) {
      let parsed = {}
      try {
        parsed = JSON.parse(msg.content || '{}')
      } catch (e) {}
      return parsed
    },
    async fetchMembers() {
      try {
        const list = await getGroupMemberList(this.targetId)
        const map = {}
        ;(list || []).forEach((m) => {
          if (m.userId != null) {
            map[m.userId] = { nickname: m.nickname, avatar: m.avatar }
          }
        })
        this.memberMap = map
        this.refreshSenders()
      } catch (e) {}
    },
    async fetchHistory() {
      if (this.loadingHistory) return
      this.loadingHistory = true
      try {
        const maxId = this.messages.length ? this.messages[0].id : undefined
        let list
        if (this.isGroup) {
          list = await getGroupMessageList(this.targetId, maxId, 30)
        } else {
          list = await getPrivateMessageList(this.targetId, maxId, 30)
        }
        const arr = (list || []).sort((a, b) => a.id - b.id)
        if (arr.length < 30) this.historyEnded = true
        // 去掉与现有消息重复的（WebSocket 实时增量可能已带上）
        const existIds = {}
        this.messages.forEach((m) => (existIds[m.id] = true))
        const newOnes = arr.filter((m) => !existIds[m.id])
        this.messages = newOnes.concat(this.messages)
        this.refreshSenders()
        if (!maxId) {
          this.scrollToBottom()
        }
      } catch (e) {
        uni.showToast({ title: (e && e.msg) || '加载失败', icon: 'none' })
      } finally {
        this.loadingHistory = false
      }
    },
    loadMore() {
      this.fetchHistory()
    },
    maybeMarkRead() {
      const last = getLastMessage(this.type, this.targetId)
      const maxId = last ? last.id : this.maxMessageId()
      if (maxId) {
        markRead(this.type, this.targetId, maxId)
      }
    },
    maxMessageId() {
      let max = 0
      this.messages.forEach((m) => {
        if (m.id && m.id > max) max = m.id
      })
      return max
    },
    appendMessage(msg) {
      // 去重：WebSocket 推送可能和发送回执重复
      if (this.messages.some((m) => m.id === msg.id)) {
        return
      }
      this.messages.push(msg)
      this.refreshSenders()
      this.scrollToBottom()
      this.maybeMarkRead()
    },
    refreshSenders() {
      this.messages.forEach((m) => {
        m._mine = m.senderId === this.myId
        const c = this.parse(m)
        if (m.type === ImContentType.IMAGE) {
          m._kind = 'image'
          m._imageUrl = c.thumbnailUrl || c.url
        } else if (m.type === ImContentType.TEXT) {
          m._kind = 'text'
          m._text = c.content
        } else {
          m._kind = 'other'
        }
        // 头像
        if (m._mine) {
          m._avatar = this.myAvatar
        } else if (this.isGroup) {
          m._avatar = this.memberMap[m.senderId] ? this.memberMap[m.senderId].avatar : ''
        } else {
          m._avatar = this.avatar
        }
        // 群聊发送人昵称
        if (this.memberMap[m.senderId]) {
          m._senderName = this.memberMap[m.senderId].nickname
        }
      })
    },
    scrollToBottom() {
      setTimeout(() => {
        const last = this.messages[this.messages.length - 1]
        this.scrollIntoId = last ? 'msg-' + last.id : ''
      }, 50)
    },
    isTip(m) {
      const t = m.type
      return (
        t === ImContentType.RECALL ||
        (t >= 1501 && t <= 1533) ||
        (t >= 1201 && t <= 1210)
      )
    },
    renderTip(m) {
      if (m.type === ImContentType.RECALL) {
        return m._mine ? '你撤回了一条消息' : '对方撤回了一条消息'
      }
      const typeMap = {
        [ImContentType.VOICE]: '[语音]',
        [ImContentType.VIDEO]: '[视频]',
        [ImContentType.FILE]: '[文件]',
        [ImContentType.MERGE]: '[聊天记录]',
        [ImContentType.CARD]: '[名片]',
        [ImContentType.FACE]: '[表情]',
      }
      if (typeMap[m.type]) return typeMap[m.type]
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
      return map[m.type] || '系统通知'
    },
    async sendDraft() {
      const text = this.draft.trim()
      if (!text) return
      this.draft = ''
      try {
        await sendText(this.type, this.targetId, text)
      } catch (e) {
        uni.showToast({ title: (e && e.msg) || '发送失败', icon: 'none' })
      }
    },
    chooseImage() {
      uni.chooseImage({
        count: 1,
        success: async (res) => {
          const filePath = res.tempFilePaths[0]
          uni.showLoading({ title: '上传中' })
          try {
            const url = await uploadImage(filePath)
            uni.hideLoading()
            await sendImage(this.type, this.targetId, url)
          } catch (e) {
            uni.hideLoading()
            uni.showToast({ title: (e && e.msg) || '上传失败', icon: 'none' })
          }
        },
      })
    },
    preview(url) {
      uni.previewImage({ urls: [url] })
    },
    onLongPress(m) {
      // 仅本人可撤回
      if (!m._mine || this.isTip(m)) return
      uni.showModal({
        title: '撤回消息',
        content: '确定撤回这条消息吗？',
        success: async (res) => {
          if (!res.confirm) return
          try {
            if (this.isGroup) {
              await recallGroupMessage(m.id)
            } else {
              await recallPrivateMessage(m.id)
            }
            // 本地将该消息标记为撤回
            this.messages.forEach((x) => {
              if (x.id === m.id) {
                x.type = ImContentType.RECALL
                x._type = ImContentType.RECALL
              }
            })
          } catch (e) {
            uni.showToast({ title: (e && e.msg) || '撤回失败', icon: 'none' })
          }
        },
      })
    },
  },
}
</script>

<style>
.chat-page {
  display: flex;
  flex-direction: column;
  height: 100vh;
  background: #f2f2f2;
}

.msg-scroll {
  flex: 1;
  overflow: hidden;
}

.msg-list {
  padding: 20rpx 24rpx 30rpx;
}

.load-more {
  text-align: center;
  color: #999;
  font-size: 24rpx;
  padding: 12rpx 0 24rpx;
}

.msg-wrap {
  margin-bottom: 20rpx;
}

.msg-tip {
  text-align: center;
  color: #999;
  font-size: 22rpx;
  padding: 8rpx 0;
}

.msg-row {
  display: flex;
  align-items: flex-start;
}

.msg-row.mine {
  flex-direction: row-reverse;
}

.msg-avatar {
  width: 72rpx;
  height: 72rpx;
  border-radius: 8rpx;
  background: #eee;
  flex-shrink: 0;
}

.msg-body {
  max-width: 62%;
  margin: 0 16rpx;
}

.msg-name {
  font-size: 22rpx;
  color: #999;
  margin-bottom: 4rpx;
}

.bubble {
  display: inline-block;
  padding: 16rpx 20rpx;
  background: #fff;
  border-radius: 12rpx;
  font-size: 30rpx;
  color: #333;
  line-height: 1.5;
  word-break: break-all;
}

.bubble.mine {
  background: #c8102e;
  color: #fff;
}

.bubble-img {
  width: 280rpx;
  height: 280rpx;
  border-radius: 10rpx;
  display: block;
}

.input-bar {
  display: flex;
  align-items: center;
  background: #fff;
  padding: 16rpx 20rpx;
  padding-bottom: calc(16rpx + env(safe-area-inset-bottom));
}

.tool-btn {
  padding: 0 20rpx;
  height: 72rpx;
  line-height: 72rpx;
  color: #576b95;
  font-size: 28rpx;
}

.input {
  flex: 1;
  height: 72rpx;
  background: #f2f2f2;
  border-radius: 36rpx;
  padding: 0 28rpx;
  font-size: 30rpx;
}

.send-btn {
  margin-left: 16rpx;
  padding: 0 28rpx;
  height: 72rpx;
  line-height: 72rpx;
  background: #c8102e;
  color: #fff;
  border-radius: 36rpx;
  font-size: 28rpx;
}
</style>
