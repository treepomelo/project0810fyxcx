<template>
  <view class="page">
    <view class="toolbar">
      <text class="toolbar-btn" @click="goAdd">搜索加好友</text>
    </view>

    <view v-if="loading" class="tip">加载中...</view>
    <view v-else-if="requests.length === 0" class="tip">暂无好友申请</view>

    <view class="req-item" v-for="r in requests" :key="r.id">
      <image class="avatar" :src="(isIncoming(r) ? r.fromAvatar : r.toAvatar) || defaultAvatar" mode="aspectFill" />
      <view class="info">
        <view class="name">
          {{ isIncoming(r) ? (r.fromNickname || '用户' + r.fromUserId) : (r.toNickname || '用户' + r.toUserId) }}
          <text class="tag" v-if="!isIncoming(r)">我发出的</text>
        </view>
        <view class="content" v-if="r.applyContent">申请理由：{{ r.applyContent }}</view>
        <view class="status" v-if="!isIncoming(r)">等待对方同意</view>
        <view class="status" v-else-if="r.handleResult === 2">已拒绝{{ r.handleContent ? '：' + r.handleContent : '' }}</view>
      </view>
      <view v-if="isIncoming(r) && r.handleResult === 0" class="actions">
        <view class="btn refuse" @click="refuse(r)">拒绝</view>
        <view class="btn agree" @click="agree(r)">同意</view>
      </view>
    </view>
  </view>
</template>

<script>
import { getFriendRequestList, agreeFriendRequest, refuseFriendRequest } from '../../api/im.js'
import { getMyUserId, refreshContacts } from '../../utils/imStore.js'

export default {
  data() {
    return {
      requests: [],
      loading: false,
      myId: null,
      defaultAvatar: 'https://qiniu-web-assets.dcloud.net.cn/unidoc/zh/uni.png',
    }
  },
  onLoad() {
    this.myId = getMyUserId()
    this.load()
  },
  onShow() {
    this.load()
  },
  methods: {
    isIncoming(r) {
      return r.toUserId === this.myId
    },
    async load() {
      this.loading = true
      try {
        const list = await getFriendRequestList(100)
        this.requests = (list || []).filter((r) => r.handleResult === 0 || this.isIncoming(r))
      } catch (e) {
        uni.showToast({ title: (e && e.msg) || '加载失败', icon: 'none' })
      } finally {
        this.loading = false
      }
    },
    async agree(r) {
      try {
        await agreeFriendRequest(r.id)
        uni.showToast({ title: '已添加好友', icon: 'success' })
        refreshContacts()
        this.load()
      } catch (e) {
        uni.showToast({ title: (e && e.msg) || '操作失败', icon: 'none' })
      }
    },
    refuse(r) {
      uni.showModal({
        title: '拒绝申请',
        content: `拒绝「${r.fromNickname || '对方'}」的好友申请？`,
        editable: true,
        placeholderText: '填写拒绝理由（选填）',
        success: async (res) => {
          if (!res.confirm) return
          try {
            await refuseFriendRequest(r.id, res.content || '')
            uni.showToast({ title: '已拒绝', icon: 'none' })
            this.load()
          } catch (e) {
            uni.showToast({ title: (e && e.msg) || '操作失败', icon: 'none' })
          }
        },
      })
    },
    goAdd() {
      uni.navigateTo({ url: '/pages/im/friendAdd' })
    },
  },
}
</script>

<style>
.page {
  padding: 20rpx 24rpx;
  background: #f7f7f7;
  min-height: 100vh;
}

.toolbar {
  margin-bottom: 20rpx;
}

.toolbar-btn {
  font-size: 28rpx;
  color: #576b95;
}

.req-item {
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
}

.tag {
  margin-left: 12rpx;
  font-size: 22rpx;
  color: #c8102e;
  border: 1rpx solid #c8102e;
  border-radius: 6rpx;
  padding: 0 8rpx;
}

.content {
  font-size: 24rpx;
  color: #999;
  margin-top: 4rpx;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.status {
  font-size: 24rpx;
  color: #999;
  margin-top: 4rpx;
}

.actions {
  display: flex;
  flex-shrink: 0;
}

.btn {
  margin-left: 16rpx;
  padding: 0 24rpx;
  height: 56rpx;
  line-height: 56rpx;
  border-radius: 28rpx;
  font-size: 26rpx;
}

.btn.agree {
  background: #c8102e;
  color: #fff;
}

.btn.refuse {
  background: #eee;
  color: #666;
}

.tip {
  text-align: center;
  color: #999;
  font-size: 28rpx;
  padding: 80rpx 0;
}
</style>
