<template>
  <view class="page">
    <view class="search-bar">
      <input class="search-input" v-model="keyword" placeholder="搜索用户昵称" confirm-type="search" @confirm="doSearch" />
      <view class="search-btn" @click="doSearch">搜索</view>
    </view>

    <view v-if="searched && results.length === 0" class="tip">未找到匹配的用户</view>

    <view class="user-item" v-for="u in results" :key="u.id">
      <image class="avatar" :src="u.avatar || defaultAvatar" mode="aspectFill" />
      <view class="info">
        <view class="name">{{ u.nickname }}</view>
        <view class="dept" v-if="u.deptName">{{ u.deptName }}</view>
      </view>
      <view class="add-btn" :class="{ self: u.id === myId }" @click="apply(u)">
        {{ u.id === myId ? '自己' : (appliedMap[u.id] ? '已申请' : '加好友') }}
      </view>
    </view>
  </view>
</template>

<script>
import { searchUserByNickname, applyFriendRequest } from '../../api/im.js'
import { getMyUserId } from '../../utils/imStore.js'

export default {
  data() {
    return {
      keyword: '',
      results: [],
      searched: false,
      myId: null,
      appliedMap: {},
      defaultAvatar: 'https://qiniu-web-assets.dcloud.net.cn/unidoc/zh/uni.png',
    }
  },
  onLoad() {
    this.myId = getMyUserId()
  },
  methods: {
    async doSearch() {
      if (!this.keyword.trim()) return
      try {
        const list = await searchUserByNickname(this.keyword.trim())
        this.results = list || []
        this.searched = true
      } catch (e) {
        uni.showToast({ title: (e && e.msg) || '搜索失败', icon: 'none' })
      }
    },
    apply(u) {
      if (u.id === this.myId) return
      if (this.appliedMap[u.id]) return
      uni.showModal({
        title: '添加好友',
        content: `向「${u.nickname}」发送好友申请`,
        editable: true,
        placeholderText: '填写申请理由（选填）',
        success: async (res) => {
          if (!res.confirm) return
          try {
            await applyFriendRequest({
              toUserId: u.id,
              applyContent: res.content || '',
              addSource: 1,
            })
            this.$set(this.appliedMap, u.id, true)
            uni.showToast({ title: '申请已发送', icon: 'success' })
          } catch (e) {
            uni.showToast({ title: (e && e.msg) || '申请失败', icon: 'none' })
          }
        },
      })
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

.search-bar {
  display: flex;
  align-items: center;
  margin-bottom: 20rpx;
}

.search-input {
  flex: 1;
  height: 72rpx;
  background: #fff;
  border-radius: 36rpx;
  padding: 0 28rpx;
  font-size: 28rpx;
}

.search-btn {
  margin-left: 16rpx;
  padding: 0 30rpx;
  height: 72rpx;
  line-height: 72rpx;
  background: #c8102e;
  color: #fff;
  border-radius: 36rpx;
  font-size: 28rpx;
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

.dept {
  font-size: 24rpx;
  color: #999;
  margin-top: 4rpx;
}

.add-btn {
  padding: 0 26rpx;
  height: 60rpx;
  line-height: 60rpx;
  background: #c8102e;
  color: #fff;
  border-radius: 30rpx;
  font-size: 26rpx;
}

.add-btn.self {
  background: #eee;
  color: #999;
}

.tip {
  text-align: center;
  color: #999;
  font-size: 28rpx;
  padding: 80rpx 0;
}
</style>
