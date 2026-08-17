<template>
  <view class="page">
    <!-- ==================== 登录 ==================== -->
    <view v-if="!loggedIn" class="login-page">
      <view class="login-decoration decoration-one"></view>
      <view class="login-decoration decoration-two"></view>

      <view class="login-card">
        <view class="login-logo">
          <text class="logo-icon">聊</text>
        </view>

        <view class="login-title">消息中心</view>
        <view class="login-subtitle">登录后开始你的聊天</view>

        <view class="login-form">
          <view class="field">
            <text class="field-icon">⌁</text>
            <input
              v-model="username"
              class="login-input"
              placeholder="请输入账号"
              placeholder-class="input-placeholder"
            />
          </view>

          <view class="field">
            <text class="field-icon">●</text>
            <input
              v-model="password"
              class="login-input"
              placeholder="请输入密码"
              placeholder-class="input-placeholder"
              password
            />
          </view>

          <view class="login-btn" :class="{ disabled: loginLoading }" @click="doLogin">
            <text>{{ loginLoading ? '登录中...' : '登录' }}</text>
          </view>
        </view>

        <view class="login-hint">
          <text>IM 服务已连接后台消息系统</text>
        </view>
      </view>
    </view>

    <!-- ==================== 主页面 ==================== -->
    <template v-else>
      <!-- 顶部 -->
      <view class="top-area">
        <view class="top-title-row">
          <view>
            <view class="page-title">消息</view>
            <view class="page-subtitle">
              <text class="status-dot" :class="{ connected: wsConnected }"></text>
              <text>{{ wsConnected ? '消息服务正常' : '正在连接...' }}</text>
            </view>
          </view>

          <view class="top-actions">
            <view class="circle-action" @click="goFriendRequests">
              <text class="action-icon">＋</text>
              <view v-if="friendRequestCount > 0" class="action-badge">
                {{ friendRequestCount > 99 ? '99+' : friendRequestCount }}
              </view>
            </view>

            <view class="circle-action" @click="showMore">
              <text class="more-dot">•••</text>
            </view>
          </view>
        </view>

        <!-- Tab -->
        <view class="tabs">
          <view
            class="tab"
            :class="{ active: tab === 'conv' }"
            @click="tab = 'conv'"
          >
            <text>消息</text>
            <view v-if="totalUnread > 0" class="tab-badge">
              {{ totalUnread > 99 ? '99+' : totalUnread }}
            </view>
          </view>

          <view
            class="tab"
            :class="{ active: tab === 'contact' }"
            @click="tab = 'contact'"
          >
            <text>通讯录</text>
          </view>
        </view>
      </view>

      <!-- ==================== 消息列表 ==================== -->
      <scroll-view
        v-if="tab === 'conv'"
        class="content-scroll"
        scroll-y
        :show-scrollbar="false"
      >
        <view class="conversation-list">
          <!-- 空状态 -->
          <view v-if="conversations.length === 0" class="empty-state">
            <view class="empty-icon">
              <text>💬</text>
            </view>
            <view class="empty-title">还没有聊天</view>
            <view class="empty-text">去通讯录找一位朋友聊聊吧</view>
            <view class="empty-btn" @click="tab = 'contact'">查看通讯录</view>
          </view>

          <!-- 会话 -->
          <view
            v-for="c in conversations"
            :key="c.key"
            class="conversation-card"
            :class="{ unread: c.unread > 0 }"
            @click="openChat(c)"
          >
            <view class="avatar-wrap">
              <image
                class="conversation-avatar"
                :src="c.avatar || defaultAvatar"
                mode="aspectFill"
              />

              <view v-if="c.type === 2" class="group-mark">
                <text>群</text>
              </view>

              <view v-if="c.unread > 0" class="unread-dot">
                {{ c.unread > 99 ? '99+' : c.unread }}
              </view>
            </view>

            <view class="conversation-content">
              <view class="conversation-top">
                <text class="conversation-name">{{ c.name || '好友' }}</text>

                <text class="conversation-time">
                  {{ formatTime(c.lastSendTime) }}
                </text>
              </view>

              <view class="conversation-bottom">
                <text
                  class="conversation-preview"
                  :class="{ highlight: c.unread > 0 }"
                >
                  {{ getConversationPreview(c) }}
                </text>

                <text v-if="c.silent" class="silent-icon">⌁</text>
              </view>
            </view>

            <view class="conversation-arrow">
              <text>›</text>
            </view>
          </view>
        </view>

        <view class="bottom-space"></view>
      </scroll-view>

      <!-- ==================== 通讯录 ==================== -->
      <scroll-view
        v-else
        class="content-scroll"
        scroll-y
        :show-scrollbar="false"
      >
        <view class="contact-page">
          <!-- 新的朋友 -->
          <view class="contact-section">
            <view class="contact-card special-card" @click="goFriendRequests">
              <view class="special-icon friend-icon">
                <text>＋</text>
              </view>

              <view class="contact-main">
                <text class="contact-name">新的朋友</text>
                <text class="contact-desc">
                  添加新的聊天好友
                </text>
              </view>

              <view v-if="friendRequestCount > 0" class="contact-count">
                {{ friendRequestCount > 99 ? '99+' : friendRequestCount }}
              </view>

              <text class="contact-arrow">›</text>
            </view>
          </view>

          <!-- 我的群聊 -->
          <view class="section-title">
            <text>我的群聊</text>
            <text class="section-count">{{ groups.length }}</text>
          </view>

          <view class="contact-section">
            <view
              v-for="g in groups"
              :key="g.id"
              class="contact-card"
              @click="openChat({
                type: 2,
                targetId: g.id,
                name: g.name,
                avatar: g.avatar
              })"
            >
              <view class="avatar-wrap">
                <image
                  class="contact-avatar"
                  :src="g.avatar || defaultAvatar"
                  mode="aspectFill"
                />
                <view class="contact-group-mark">群</view>
              </view>

              <view class="contact-main">
                <text class="contact-name">{{ g.name || '群聊' }}</text>
                <text class="contact-desc">群聊</text>
              </view>

              <view
                class="contact-info-btn"
                @click.stop="goGroupInfo(g.id)"
              >
                <text>›</text>
              </view>
            </view>

            <view v-if="groups.length === 0" class="section-empty">
              <text>暂无群聊</text>
            </view>
          </view>

          <!-- 好友 -->
          <view class="section-title">
            <text>我的好友</text>
            <text class="section-count">{{ friends.length }}</text>
          </view>

          <view class="contact-section">
            <view
              v-for="f in friends"
              :key="f.friendUserId"
              class="contact-card"
              @click="openChat({
                type: 1,
                targetId: f.friendUserId,
                name: f.displayName || f.nickname,
                avatar: f.avatar
              })"
            >
              <image
                class="contact-avatar"
                :src="f.avatar || defaultAvatar"
                mode="aspectFill"
              />

              <view class="contact-main">
                <text class="contact-name">
                  {{ f.displayName || f.nickname || '好友' }}
                </text>

                <text
                  v-if="f.nickname && f.nickname !== f.displayName"
                  class="contact-desc"
                >
                  {{ f.nickname }}
                </text>
              </view>

              <text class="contact-arrow">›</text>
            </view>

            <view v-if="friends.length === 0" class="section-empty">
              <text>暂无好友，去添加一位新朋友吧</text>
            </view>
          </view>

          <!-- 群聊创建 -->
          <view class="create-group-btn" @click="goGroupCreate">
            <view class="create-group-icon">＋</view>
            <text>创建群聊</text>
          </view>
        </view>

        <view class="bottom-space"></view>
      </scroll-view>

      <!-- 底部 TabBar 不做固定导航，避免和项目原有 TabBar 冲突 -->
    </template>

    <!-- 更多菜单 -->
    <view v-if="moreVisible" class="mask" @click="moreVisible = false">
      <view class="more-menu" @click.stop>
        <view class="menu-item" @click="refreshPage">
          <text class="menu-icon">↻</text>
          <text>刷新消息</text>
        </view>

        <view class="menu-item" @click="doLogout">
          <text class="menu-icon">⇥</text>
          <text>退出登录</text>
        </view>
      </view>
    </view>
  </view>
</template>

<script>
import {
  isLoggedIn,
  init,
  getConversations,
  getContacts,
  getFriendRequests,
  getMyUserId,
  getWsConnected,
  logout,
  on,
  off,
} from '../../utils/imStore.js'

import { adminLogin } from '../../utils/adminRequest.js'

export default {
  data() {
    return {
      loggedIn: false,

      username: 'admin',
      password: 'admin123',
      loginLoading: false,

      tab: 'conv',

      conversations: [],
      friends: [],
      groups: [],

      friendRequestCount: 0,
      wsConnected: false,

      moreVisible: false,

      defaultAvatar:
        'https://qiniu-web-assets.dcloud.net.cn/unidoc/zh/uni.png',

      _handlers: [],
    }
  },

  computed: {
    totalUnread() {
      return this.conversations.reduce((total, item) => {
        return total + Number(item.unread || 0)
      }, 0)
    },
  },

  onLoad() {
    this.loggedIn = isLoggedIn()

    if (this.loggedIn) {
      this._initData()
      init()
    }
  },

  onShow() {
    if (this.loggedIn) {
      this.refresh()
    }
  },

  onUnload() {
    this._handlers.forEach(([event, callback]) => {
      off(event, callback)
    })

    this._handlers = []
  },

  methods: {
    _subscribe(event, callback) {
      on(event, callback)
      this._handlers.push([event, callback])
    },

    _initData() {
      if (this._handlers.length === 0) {
        this._subscribe('conversations', () => {
          this.refresh()
        })

        this._subscribe('contacts', () => {
          this.refresh()
        })

        this._subscribe('ws-status', (value) => {
          this.wsConnected = !!value
        })
      }

      this.refresh()
    },

    refresh() {
      this.conversations = getConversations() || {}

      if (!Array.isArray(this.conversations)) {
        this.conversations = []
      }

      const contacts = getContacts() || {}

      this.friends = contacts.friends || []
      this.groups = contacts.groups || []

      const myId = getMyUserId()

      this.friendRequestCount = (getFriendRequests() || []).filter(
        (item) => item.toUserId === myId,
      ).length

      this.wsConnected = getWsConnected()
    },

    async doLogin() {
      if (this.loginLoading) return

      if (!this.username || !this.password) {
        uni.showToast({
          title: '请输入账号密码',
          icon: 'none',
        })
        return
      }

      this.loginLoading = true

      try {
        await adminLogin(this.username, this.password)

        this.loggedIn = true

        this._initData()

        await init()

        uni.showToast({
          title: '登录成功',
          icon: 'success',
        })
      } catch (e) {
        uni.showToast({
          title: (e && e.msg) || '登录失败',
          icon: 'none',
        })
      } finally {
        this.loginLoading = false
      }
    },

    openChat(conversation) {
      uni.navigateTo({
        url:
          `/pages/im/chat` +
          `?type=${conversation.type}` +
          `&targetId=${conversation.targetId}` +
          `&name=${encodeURIComponent(conversation.name || '')}` +
          `&avatar=${encodeURIComponent(conversation.avatar || '')}`,
      })
    },

    goFriendRequests() {
      this.moreVisible = false

      uni.navigateTo({
        url: '/pages/im/friendRequests',
      })
    },

    goGroupCreate() {
      this.moreVisible = false

      uni.navigateTo({
        url: '/pages/im/groupCreate',
      })
    },

    goGroupInfo(id) {
      uni.navigateTo({
        url: '/pages/im/groupInfo?groupId=' + id,
      })
    },

    showMore() {
      this.moreVisible = true
    },

    refreshPage() {
      this.moreVisible = false
      this.refresh()

      uni.showToast({
        title: '已刷新',
        icon: 'none',
      })
    },

    doLogout() {
      this.moreVisible = false

      uni.showModal({
        title: '退出登录',
        content: '确定退出当前 IM 账号吗？',
        confirmText: '退出',
        cancelText: '取消',
        success: (res) => {
          if (!res.confirm) return

          logout()

          this.loggedIn = false
          this.conversations = []
          this.friends = []
          this.groups = []
          this.friendRequestCount = 0
          this.wsConnected = false
        },
      })
    },

    getConversationPreview(conversation) {
      const text = conversation.lastContent || ''

      if (!text) {
        return conversation.type === 2
          ? '开始群聊吧'
          : '开始聊天吧'
      }

      // 对现有 imStore 的 "[语音]" 做进一步 UI 优化
      if (text.indexOf('[语音]') >= 0) {
        return text.replace('[语音]', '语音消息')
      }

      if (text.indexOf('[图片]') >= 0) {
        return text.replace('[图片]', '图片')
      }

      if (text.indexOf('[视频]') >= 0) {
        return text.replace('[视频]', '视频')
      }

      return text
    },

    formatTime(ts) {
      if (!ts) return ''

      let d = new Date(ts)

      if (isNaN(d.getTime())) {
        // 兼容部分后端时间格式
        d = new Date(String(ts).replace(/-/g, '/'))
      }

      if (isNaN(d.getTime())) {
        return ''
      }

      const now = new Date()

      const pad = (n) => {
        return n < 10 ? '0' + n : '' + n
      }

      const sameDay =
        d.getFullYear() === now.getFullYear() &&
        d.getMonth() === now.getMonth() &&
        d.getDate() === now.getDate()

      if (sameDay) {
        return `${pad(d.getHours())}:${pad(d.getMinutes())}`
      }

      const yesterday = new Date(now)
      yesterday.setDate(now.getDate() - 1)

      const isYesterday =
        d.getFullYear() === yesterday.getFullYear() &&
        d.getMonth() === yesterday.getMonth() &&
        d.getDate() === yesterday.getDate()

      if (isYesterday) {
        return '昨天'
      }

      if (d.getFullYear() === now.getFullYear()) {
        return `${pad(d.getMonth() + 1)}-${pad(d.getDate())}`
      }

      return `${d.getFullYear()}-${pad(d.getMonth() + 1)}-${pad(
        d.getDate(),
      )}`
    },
  },
}
</script>

<style>
page {
  background: #f6f8fb;
}

.page {
  min-height: 100vh;
  background: #f6f8fb;
  color: #24344d;
}

/* ==================== 登录 ==================== */

.login-page {
  min-height: 100vh;
  position: relative;
  overflow: hidden;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 60rpx;
  box-sizing: border-box;
}

.login-decoration {
  position: absolute;
  border-radius: 50%;
  pointer-events: none;
}

.decoration-one {
  width: 500rpx;
  height: 500rpx;
  right: -230rpx;
  top: -180rpx;
  background: #e3efff;
}

.decoration-two {
  width: 360rpx;
  height: 360rpx;
  left: -180rpx;
  bottom: -100rpx;
  background: #e7f7f1;
}

.login-card {
  position: relative;
  z-index: 2;
  width: 100%;
  padding: 70rpx 48rpx 50rpx;
  box-sizing: border-box;
  background: rgba(255, 255, 255, 0.96);
  border-radius: 40rpx;
  box-shadow: 0 20rpx 70rpx rgba(56, 85, 120, 0.1);
}

.login-logo {
  width: 110rpx;
  height: 110rpx;
  margin: 0 auto 30rpx;
  border-radius: 34rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  background: #dfeeff;
}

.logo-icon {
  font-size: 48rpx;
  font-weight: 700;
  color: #4c91e8;
}

.login-title {
  text-align: center;
  font-size: 42rpx;
  font-weight: 700;
  color: #253650;
}

.login-subtitle {
  margin-top: 12rpx;
  text-align: center;
  color: #9aa8ba;
  font-size: 26rpx;
}

.login-form {
  margin-top: 60rpx;
}

.field {
  height: 92rpx;
  display: flex;
  align-items: center;
  margin-bottom: 24rpx;
  padding: 0 28rpx;
  box-sizing: border-box;
  border-radius: 26rpx;
  background: #f6f8fb;
}

.field-icon {
  width: 40rpx;
  color: #8aa9cc;
  font-size: 28rpx;
}

.login-input {
  flex: 1;
  height: 92rpx;
  padding-left: 12rpx;
  font-size: 28rpx;
  color: #27384e;
}

.input-placeholder {
  color: #b6c0cc;
}

.login-btn {
  height: 92rpx;
  line-height: 92rpx;
  margin-top: 34rpx;
  border-radius: 28rpx;
  text-align: center;
  color: #fff;
  font-size: 30rpx;
  font-weight: 600;
  background: #5c9ce9;
  box-shadow: 0 12rpx 30rpx rgba(92, 156, 233, 0.24);
}

.login-btn.disabled {
  opacity: 0.65;
}

.login-hint {
  margin-top: 36rpx;
  text-align: center;
  font-size: 22rpx;
  color: #b1bdca;
}

/* ==================== 顶部 ==================== */

.top-area {
  background: #fff;
  padding: 24rpx 30rpx 0;
  box-sizing: border-box;
  border-bottom: 1rpx solid #edf1f5;
}

.top-title-row {
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.page-title {
  font-size: 40rpx;
  font-weight: 700;
  line-height: 54rpx;
  color: #26364d;
}

.page-subtitle {
  margin-top: 4rpx;
  display: flex;
  align-items: center;
  color: #a3afbe;
  font-size: 21rpx;
}

.status-dot {
  width: 12rpx;
  height: 12rpx;
  margin-right: 8rpx;
  border-radius: 50%;
  background: #d3d9e0;
}

.status-dot.connected {
  background: #64c79a;
}

.top-actions {
  display: flex;
  align-items: center;
  gap: 16rpx;
}

.circle-action {
  position: relative;
  width: 72rpx;
  height: 72rpx;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  background: #f5f8fc;
}

.action-icon {
  font-size: 42rpx;
  color: #5e86b1;
  font-weight: 300;
}

.more-dot {
  font-size: 28rpx;
  letter-spacing: 4rpx;
  color: #718298;
}

.action-badge {
  position: absolute;
  right: -6rpx;
  top: -8rpx;
  min-width: 30rpx;
  height: 30rpx;
  padding: 0 6rpx;
  line-height: 30rpx;
  border-radius: 15rpx;
  box-sizing: border-box;
  text-align: center;
  color: #fff;
  background: #f05d65;
  font-size: 18rpx;
  border: 3rpx solid #fff;
}

/* ==================== Tab ==================== */

.tabs {
  display: flex;
  margin-top: 26rpx;
  height: 78rpx;
}

.tab {
  position: relative;
  display: flex;
  align-items: center;
  justify-content: center;
  width: 120rpx;
  margin-right: 40rpx;
  color: #8795a7;
  font-size: 29rpx;
}

.tab.active {
  color: #397fca;
  font-weight: 600;
}

.tab.active::after {
  content: '';
  position: absolute;
  left: 50%;
  bottom: 0;
  width: 46rpx;
  height: 6rpx;
  border-radius: 3rpx;
  transform: translateX(-50%);
  background: #4c91e8;
}

.tab-badge {
  min-width: 26rpx;
  height: 26rpx;
  padding: 0 6rpx;
  margin-left: 8rpx;
  line-height: 26rpx;
  border-radius: 13rpx;
  color: #fff;
  background: #f05d65;
  font-size: 16rpx;
  text-align: center;
}

/* ==================== 内容 ==================== */

.content-scroll {
  height: calc(100vh - 190rpx);
  box-sizing: border-box;
}

.conversation-list {
  padding: 20rpx 24rpx 0;
  box-sizing: border-box;
}

/* ==================== 会话卡片 ==================== */

.conversation-card {
  position: relative;
  display: flex;
  align-items: center;
  margin-bottom: 18rpx;
  padding: 24rpx 20rpx;
  box-sizing: border-box;
  border-radius: 26rpx;
  background: #fff;
  box-shadow: 0 5rpx 24rpx rgba(65, 91, 120, 0.055);
}

.conversation-card:active {
  opacity: 0.72;
  transform: scale(0.99);
}

.conversation-card.unread {
  box-shadow: 0 7rpx 26rpx rgba(76, 145, 232, 0.08);
}

.avatar-wrap {
  position: relative;
  flex-shrink: 0;
}

.conversation-avatar {
  width: 92rpx;
  height: 92rpx;
  display: block;
  border-radius: 50%;
  background: #edf1f5;
}

.group-mark {
  position: absolute;
  right: -3rpx;
  bottom: -3rpx;
  width: 30rpx;
  height: 30rpx;
  line-height: 30rpx;
  border-radius: 10rpx;
  color: #fff;
  background: #83a9ce;
  text-align: center;
  font-size: 16rpx;
  border: 3rpx solid #fff;
}

.unread-dot {
  position: absolute;
  right: -8rpx;
  top: -8rpx;
  min-width: 30rpx;
  height: 30rpx;
  padding: 0 7rpx;
  line-height: 30rpx;
  border-radius: 15rpx;
  box-sizing: border-box;
  color: #fff;
  background: #ef5b64;
  font-size: 17rpx;
  text-align: center;
  border: 3rpx solid #fff;
}

.conversation-content {
  flex: 1;
  min-width: 0;
  margin-left: 22rpx;
}

.conversation-top {
  display: flex;
  align-items: center;
}

.conversation-name {
  flex: 1;
  min-width: 0;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  color: #2d3c51;
  font-size: 30rpx;
  font-weight: 600;
}

.conversation-time {
  flex-shrink: 0;
  margin-left: 14rpx;
  color: #aeb8c5;
  font-size: 21rpx;
}

.conversation-bottom {
  display: flex;
  align-items: center;
  margin-top: 12rpx;
}

.conversation-preview {
  flex: 1;
  min-width: 0;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  color: #9aa6b5;
  font-size: 25rpx;
}

.conversation-preview.highlight {
  color: #65758a;
}

.silent-icon {
  margin-left: 12rpx;
  color: #b5c0cc;
  font-size: 22rpx;
}

.conversation-arrow {
  width: 24rpx;
  margin-left: 6rpx;
  color: #c8d0d9;
  font-size: 34rpx;
}

/* ==================== 空状态 ==================== */

.empty-state {
  padding-top: 170rpx;
  text-align: center;
}

.empty-icon {
  width: 130rpx;
  height: 130rpx;
  margin: 0 auto;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 42rpx;
  background: #e9f2fc;
  font-size: 54rpx;
}

.empty-title {
  margin-top: 28rpx;
  color: #52647a;
  font-size: 30rpx;
  font-weight: 600;
}

.empty-text {
  margin-top: 10rpx;
  color: #aab5c1;
  font-size: 24rpx;
}

.empty-btn {
  display: inline-block;
  margin-top: 34rpx;
  padding: 18rpx 34rpx;
  border-radius: 30rpx;
  color: #fff;
  background: #5b99e3;
  font-size: 25rpx;
}

/* ==================== 通讯录 ==================== */

.contact-page {
  padding: 20rpx 24rpx 0;
}

.contact-section {
  margin-bottom: 28rpx;
}

.contact-card {
  display: flex;
  align-items: center;
  min-height: 108rpx;
  padding: 16rpx 20rpx;
  margin-bottom: 14rpx;
  box-sizing: border-box;
  border-radius: 24rpx;
  background: #fff;
  box-shadow: 0 5rpx 24rpx rgba(65, 91, 120, 0.05);
}

.special-card {
  min-height: 116rpx;
}

.special-icon {
  width: 82rpx;
  height: 82rpx;
  border-radius: 28rpx;
  display: flex;
  align-items: center;
  justify-content: center;
}

.friend-icon {
  background: #e4f2ff;
  color: #4c94e8;
  font-size: 42rpx;
}

.contact-avatar {
  width: 82rpx;
  height: 82rpx;
  border-radius: 50%;
  background: #edf1f5;
  flex-shrink: 0;
}

.contact-group-mark {
  position: absolute;
  right: -4rpx;
  bottom: -2rpx;
  width: 28rpx;
  height: 28rpx;
  line-height: 28rpx;
  border-radius: 9rpx;
  color: #fff;
  background: #86a8ca;
  text-align: center;
  font-size: 15rpx;
  border: 3rpx solid #fff;
}

.contact-main {
  flex: 1;
  min-width: 0;
  margin-left: 20rpx;
}

.contact-name {
  display: block;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  color: #34445a;
  font-size: 29rpx;
  font-weight: 600;
}

.contact-desc {
  display: block;
  margin-top: 7rpx;
  color: #a4afbd;
  font-size: 23rpx;
}

.contact-count {
  min-width: 30rpx;
  height: 30rpx;
  padding: 0 7rpx;
  line-height: 30rpx;
  margin-right: 10rpx;
  border-radius: 15rpx;
  color: #fff;
  background: #ef5c64;
  font-size: 17rpx;
  text-align: center;
}

.contact-arrow {
  margin-left: 12rpx;
  color: #c3ccd6;
  font-size: 34rpx;
}

.contact-info-btn {
  width: 58rpx;
  height: 58rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 20rpx;
  background: #f4f7fa;
  color: #8b9bad;
  font-size: 32rpx;
}

.section-title {
  display: flex;
  align-items: center;
  padding: 0 10rpx 14rpx;
  color: #8491a2;
  font-size: 24rpx;
}

.section-count {
  margin-left: 8rpx;
  color: #b4bec9;
}

.section-empty {
  padding: 35rpx 0;
  text-align: center;
  color: #adb8c4;
  font-size: 24rpx;
}

.create-group-btn {
  height: 92rpx;
  margin: 8rpx 0 40rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 28rpx;
  color: #568bc1;
  background: #eaf3fc;
  font-size: 27rpx;
}

.create-group-icon {
  width: 42rpx;
  height: 42rpx;
  line-height: 40rpx;
  margin-right: 10rpx;
  border-radius: 50%;
  background: #d7eafa;
  text-align: center;
  font-size: 32rpx;
}

.bottom-space {
  height: 50rpx;
}

/* ==================== 更多菜单 ==================== */

.mask {
  position: fixed;
  z-index: 99;
  left: 0;
  top: 0;
  right: 0;
  bottom: 0;
  background: rgba(30, 43, 60, 0.12);
}

.more-menu {
  position: absolute;
  right: 28rpx;
  top: 118rpx;
  width: 250rpx;
  padding: 12rpx;
  border-radius: 22rpx;
  background: #fff;
  box-shadow: 0 15rpx 60rpx rgba(45, 67, 92, 0.18);
}

.menu-item {
  display: flex;
  align-items: center;
  height: 82rpx;
  padding: 0 20rpx;
  box-sizing: border-box;
  border-radius: 16rpx;
  color: #52647a;
  font-size: 27rpx;
}

.menu-item:active {
  background: #f5f8fb;
}

.menu-icon {
  width: 42rpx;
  margin-right: 10rpx;
  color: #6b9cd0;
  font-size: 30rpx;
}
</style>