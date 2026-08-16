<template>
  <view class="page">
    <!-- 未登录：后台账号登录 -->
    <view v-if="!loggedIn" class="login-wrap">
      <view class="login-title">IM 测试入口</view>
      <input class="login-input" v-model="username" placeholder="后台账号（如 admin）" />
      <input class="login-input" v-model="password" placeholder="密码" password />
      <view class="login-btn" @click="doLogin">登录</view>
      <view class="login-hint">演示账号：admin / admin123</view>
    </view>

    <!-- 已登录 -->
    <template v-else>
      <!-- 顶部 -->
      <view class="header">
        <view class="header-title">
          消息
          <text class="ws-dot" :class="{ on: wsConnected }"></text>
        </view>
        <view class="header-actions">
          <text class="header-btn" @click="goFriendRequests">
            新的朋友
            <text class="req-badge" v-if="friendRequestCount > 0">{{ friendRequestCount > 99 ? '99+' : friendRequestCount }}</text>
          </text>
          <text class="header-btn" @click="goGroupCreate">创建群聊</text>
          <text class="header-btn" @click="doLogout">退出</text>
        </view>
      </view>

      <!-- 会话 / 通讯录 Tab -->
      <view class="tabs">
        <view class="tab" :class="{ active: tab === 'conv' }" @click="tab = 'conv'">会话</view>
        <view class="tab" :class="{ active: tab === 'contact' }" @click="tab = 'contact'">通讯录</view>
      </view>

      <!-- 会话列表 -->
      <view v-if="tab === 'conv'">
        <view v-if="conversations.length === 0" class="tip">暂无会话，去「通讯录」找人聊吧</view>
        <view class="conv-item" v-for="c in conversations" :key="c.key" @click="openChat(c)">
          <image class="avatar" :src="c.avatar || defaultAvatar" mode="aspectFill" />
          <view class="conv-info">
            <view class="conv-row">
              <text class="conv-name">{{ c.name }}</text>
              <text class="conv-time">{{ formatTime(c.lastSendTime) }}</text>
            </view>
            <view class="conv-row">
              <text class="conv-last">{{ c.lastContent || '开始聊天吧' }}</text>
              <text class="conv-badge" v-if="c.unread > 0">{{ c.unread > 99 ? '99+' : c.unread }}</text>
            </view>
          </view>
        </view>
      </view>

      <!-- 通讯录 -->
      <view v-else>
        <view class="contact-group">
          <view class="contact-group-title">我的群聊（{{ groups.length }}）</view>
          <view class="conv-item" v-for="g in groups" :key="g.id" @click="openChat({ type: 2, targetId: g.id, name: g.name, avatar: g.avatar })">
            <image class="avatar" :src="g.avatar || defaultAvatar" mode="aspectFill" />
            <view class="conv-info">
              <view class="conv-row"><text class="conv-name">{{ g.name }}</text></view>
              <view class="conv-row"><text class="conv-last">群聊</text></view>
            </view>
            <text class="arrow" @click.stop="goGroupInfo(g.id)">›</text>
          </view>
        </view>
        <view class="contact-group">
          <view class="contact-group-title">我的好友（{{ friends.length }}）</view>
          <view class="conv-item" v-for="f in friends" :key="f.friendUserId" @click="openChat({ type: 1, targetId: f.friendUserId, name: f.displayName || f.nickname, avatar: f.avatar })">
            <image class="avatar" :src="f.avatar || defaultAvatar" mode="aspectFill" />
            <view class="conv-info">
              <view class="conv-row"><text class="conv-name">{{ f.displayName || f.nickname }}</text></view>
              <view class="conv-row"><text class="conv-last">{{ f.nickname && f.nickname !== f.displayName ? '昵称：' + f.nickname : ' ' }}</text></view>
            </view>
          </view>
          <view v-if="friends.length === 0" class="tip-mini">暂无好友，去「新的朋友」添加吧</view>
        </view>
      </view>
    </template>
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
      tab: 'conv',
      conversations: [],
      friends: [],
      groups: [],
      friendRequestCount: 0,
      wsConnected: false,
      defaultAvatar: 'https://qiniu-web-assets.dcloud.net.cn/unidoc/zh/uni.png',
      _handlers: [],
    }
  },
  onLoad() {
    this.loggedIn = isLoggedIn()
    if (this.loggedIn) {
      this._initData()
      init()
    }
  },
  onShow() {
    // 从其他页面返回时刷新
    if (this.loggedIn) {
      this.refresh()
    }
  },
  onUnload() {
    this._handlers.forEach(([e, cb]) => off(e, cb))
    this._handlers = []
  },
  methods: {
    _subscribe(event, cb) {
      on(event, cb)
      this._handlers.push([event, cb])
    },
    _initData() {
      this._subscribe('conversations', () => this.refresh())
      this._subscribe('contacts', () => this.refresh())
      this._subscribe('ws-status', (v) => (this.wsConnected = v))
      this.refresh()
    },
    refresh() {
      this.conversations = getConversations()
      const contacts = getContacts()
      this.friends = contacts.friends || []
      this.groups = contacts.groups || []
      const myId = getMyUserId()
      this.friendRequestCount = (getFriendRequests() || []).filter((r) => r.toUserId === myId).length
      this.wsConnected = getWsConnected()
    },
    async doLogin() {
      if (!this.username || !this.password) {
        uni.showToast({ title: '请输入账号密码', icon: 'none' })
        return
      }
      try {
        uni.showLoading({ title: '登录中' })
        await adminLogin(this.username, this.password)
        uni.hideLoading()
        this.loggedIn = true
        this._initData()
        init()
        uni.showToast({ title: '登录成功', icon: 'success' })
      } catch (e) {
        uni.hideLoading()
        uni.showToast({ title: (e && e.msg) || '登录失败', icon: 'none' })
      }
    },
    openChat(c) {
      uni.navigateTo({
        url: `/pages/im/chat?type=${c.type}&targetId=${c.targetId}&name=${encodeURIComponent(c.name || '')}&avatar=${encodeURIComponent(c.avatar || '')}`,
      })
    },
    goFriendRequests() {
      uni.navigateTo({ url: '/pages/im/friendRequests' })
    },
    goGroupCreate() {
      uni.navigateTo({ url: '/pages/im/groupCreate' })
    },
    goGroupInfo(id) {
      uni.navigateTo({ url: '/pages/im/groupInfo?groupId=' + id })
    },
    doLogout() {
      uni.showModal({
        title: '提示',
        content: '确定退出 IM 登录吗？',
        success: (res) => {
          if (res.confirm) {
            logout()
            this.loggedIn = false
            this.conversations = []
            this.friends = []
            this.groups = []
            this.friendRequestCount = 0
          }
        },
      })
    },
    formatTime(ts) {
      if (!ts) return ''
      const d = new Date(ts)
      if (isNaN(d.getTime())) return ''
      const now = new Date()
      const pad = (n) => (n < 10 ? '0' + n : '' + n)
      if (d.toDateString() === now.toDateString()) {
        return `${pad(d.getHours())}:${pad(d.getMinutes())}`
      }
      return `${pad(d.getMonth() + 1)}-${pad(d.getDate())}`
    },
  },
}
</script>

<style>
.page {
  background: #f7f7f7;
  min-height: 100vh;
}

/* 登录 */
.login-wrap {
  padding: 120rpx 60rpx;
}
.login-title {
  font-size: 40rpx;
  font-weight: bold;
  text-align: center;
  margin-bottom: 60rpx;
}
.login-input {
  height: 80rpx;
  border: 1rpx solid #ddd;
  border-radius: 12rpx;
  padding: 0 24rpx;
  margin-bottom: 24rpx;
  font-size: 30rpx;
  background: #fff;
}
.login-btn {
  height: 84rpx;
  line-height: 84rpx;
  background: #c8102e;
  color: #fff;
  text-align: center;
  border-radius: 12rpx;
  font-size: 32rpx;
  margin-top: 20rpx;
}
.login-hint {
  margin-top: 24rpx;
  text-align: center;
  font-size: 24rpx;
  color: #999;
}

/* 顶部 */
.header {
  background: #fff;
  padding: 20rpx 24rpx 16rpx;
}
.header-title {
  font-size: 36rpx;
  font-weight: bold;
  color: #333;
}
.ws-dot {
  display: inline-block;
  width: 14rpx;
  height: 14rpx;
  border-radius: 50%;
  background: #ddd;
  margin-left: 12rpx;
  vertical-align: middle;
}
.ws-dot.on {
  background: #07c160;
}
.header-actions {
  margin-top: 12rpx;
  display: flex;
}
.header-btn {
  position: relative;
  font-size: 26rpx;
  color: #576b95;
  margin-right: 32rpx;
}
.req-badge {
  position: absolute;
  top: -14rpx;
  right: -20rpx;
  min-width: 30rpx;
  height: 30rpx;
  line-height: 30rpx;
  padding: 0 6rpx;
  background: #fa5151;
  color: #fff;
  border-radius: 15rpx;
  font-size: 20rpx;
  text-align: center;
}

/* tabs */
.tabs {
  display: flex;
  background: #fff;
  border-bottom: 1rpx solid #eee;
}
.tab {
  flex: 1;
  text-align: center;
  font-size: 30rpx;
  color: #666;
  padding: 18rpx 0;
  position: relative;
}
.tab.active {
  color: #c8102e;
  font-weight: bold;
}
.tab.active::after {
  content: '';
  position: absolute;
  left: 50%;
  bottom: 0;
  transform: translateX(-50%);
  width: 60rpx;
  height: 6rpx;
  background: #c8102e;
  border-radius: 3rpx;
}

/* 会话 / 联系人 */
.conv-item {
  display: flex;
  align-items: center;
  background: #fff;
  padding: 20rpx 24rpx;
  border-bottom: 1rpx solid #f5f5f5;
}
.avatar {
  width: 88rpx;
  height: 88rpx;
  border-radius: 10rpx;
  background: #eee;
  flex-shrink: 0;
}
.conv-info {
  flex: 1;
  margin-left: 20rpx;
  overflow: hidden;
}
.conv-row {
  display: flex;
  align-items: center;
}
.conv-name {
  flex: 1;
  font-size: 30rpx;
  color: #333;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}
.conv-time {
  font-size: 22rpx;
  color: #bbb;
  margin-left: 12rpx;
}
.conv-last {
  flex: 1;
  font-size: 26rpx;
  color: #999;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}
.conv-badge {
  min-width: 32rpx;
  height: 32rpx;
  line-height: 32rpx;
  padding: 0 8rpx;
  background: #fa5151;
  color: #fff;
  border-radius: 16rpx;
  font-size: 22rpx;
  text-align: center;
  margin-left: 12rpx;
}
.contact-group {
  background: #fff;
  margin-top: 16rpx;
}
.contact-group-title {
  font-size: 26rpx;
  color: #999;
  padding: 16rpx 24rpx;
  border-bottom: 1rpx solid #f5f5f5;
  background: #fafafa;
}
.arrow {
  font-size: 40rpx;
  color: #ccc;
  padding: 0 10rpx;
}
.tip {
  text-align: center;
  color: #999;
  font-size: 28rpx;
  padding: 100rpx 0;
}
.tip-mini {
  text-align: center;
  color: #999;
  font-size: 26rpx;
  padding: 40rpx 0;
}
</style>
