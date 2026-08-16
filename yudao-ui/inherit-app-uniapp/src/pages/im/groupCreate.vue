<template>
  <view class="page">
    <view class="name-bar">
      <input class="name-input" v-model="groupName" placeholder="群名称" />
    </view>

    <view class="section-title">选择好友（{{ selected.length }} 人）</view>
    <view v-if="friends.length === 0" class="tip">暂无好友，请先添加好友</view>
    <view class="user-item" v-for="f in friends" :key="f.friendUserId" @click="toggle(f.friendUserId)">
      <image class="avatar" :src="f.avatar || defaultAvatar" mode="aspectFill" />
      <view class="info">
        <view class="name">{{ f.displayName || f.nickname }}</view>
        <view class="nick" v-if="f.displayName && f.nickname !== f.displayName">{{ f.nickname }}</view>
      </view>
      <view class="checkbox" :class="{ checked: selected.includes(f.friendUserId) }">
        {{ selected.includes(f.friendUserId) ? '✓' : '' }}
      </view>
    </view>

    <view class="footer">
      <view class="create-btn" :class="{ disabled: !canCreate }" @click="doCreate">创建群聊</view>
    </view>
  </view>
</template>

<script>
import { getContacts } from '../../utils/imStore.js'
import { createGroup } from '../../api/im.js'

export default {
  data() {
    return {
      groupName: '',
      friends: [],
      selected: [],
      defaultAvatar: 'https://qiniu-web-assets.dcloud.net.cn/unidoc/zh/uni.png',
    }
  },
  computed: {
    canCreate() {
      return this.groupName.trim().length > 0 && this.selected.length > 0
    },
  },
  onLoad() {
    const contacts = getContacts()
    this.friends = (contacts.friends || []).filter((f) => !f.blocked)
  },
  methods: {
    toggle(id) {
      const i = this.selected.indexOf(id)
      if (i >= 0) {
        this.selected.splice(i, 1)
      } else {
        this.selected.push(id)
      }
    },
    async doCreate() {
      if (!this.canCreate) {
        uni.showToast({ title: '请输入群名并选择成员', icon: 'none' })
        return
      }
      try {
        await createGroup({ name: this.groupName.trim(), memberUserIds: this.selected })
        uni.showToast({ title: '创建成功', icon: 'success' })
        setTimeout(() => uni.navigateBack(), 500)
      } catch (e) {
        uni.showToast({ title: (e && e.msg) || '创建失败', icon: 'none' })
      }
    },
  },
}
</script>

<style>
.page {
  padding: 20rpx 24rpx 140rpx;
  background: #f7f7f7;
  min-height: 100vh;
}

.name-bar {
  background: #fff;
  border-radius: 12rpx;
  padding: 8rpx 24rpx;
  margin-bottom: 20rpx;
}

.name-input {
  height: 84rpx;
  font-size: 30rpx;
}

.section-title {
  font-size: 26rpx;
  color: #999;
  margin: 10rpx 0 16rpx;
}

.user-item {
  display: flex;
  align-items: center;
  background: #fff;
  border-radius: 12rpx;
  padding: 20rpx;
  margin-bottom: 16rpx;
}

.avatar {
  width: 88rpx;
  height: 88rpx;
  border-radius: 10rpx;
  background: #eee;
  flex-shrink: 0;
}

.info {
  flex: 1;
  margin-left: 20rpx;
  overflow: hidden;
}

.name {
  font-size: 30rpx;
  color: #333;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.nick {
  font-size: 24rpx;
  color: #999;
  margin-top: 4rpx;
}

.checkbox {
  width: 44rpx;
  height: 44rpx;
  border-radius: 50%;
  border: 2rpx solid #ccc;
  text-align: center;
  line-height: 40rpx;
  font-size: 28rpx;
  color: #fff;
  flex-shrink: 0;
}

.checkbox.checked {
  background: #c8102e;
  border-color: #c8102e;
}

.footer {
  position: fixed;
  left: 0;
  right: 0;
  bottom: 0;
  padding: 16rpx 24rpx calc(16rpx + env(safe-area-inset-bottom));
  background: #fff;
}

.create-btn {
  height: 84rpx;
  line-height: 84rpx;
  background: #c8102e;
  color: #fff;
  text-align: center;
  border-radius: 12rpx;
  font-size: 32rpx;
}

.create-btn.disabled {
  opacity: 0.5;
}

.tip {
  text-align: center;
  color: #999;
  font-size: 28rpx;
  padding: 60rpx 0;
}
</style>
