<template>
  <view class="page">
    <!-- 搜索栏 -->
    <view class="search-bar">
      <input class="search-input" v-model="keyword" placeholder="搜索姓名 / 擅长技艺" confirm-type="search"
        @confirm="onSearch" />
      <view class="search-btn" @click="onSearch">搜索</view>
    </view>

    <view v-if="loading" class="tip">加载中...</view>
    <view v-else-if="list.length === 0" class="tip">暂无传承人数据</view>

    <!-- 传承人卡片 -->
    <view class="card" v-for="item in list" :key="item.id" @click="goDetail(item.id)">
      <image class="avatar" :src="item.avatar || defaultAvatar" mode="aspectFill" />
      <view class="info">
        <view class="name-row">
          <text class="name">{{ item.name }}</text>
          <text class="level" v-if="item.level">{{ item.level }}</text>
        </view>
        <view class="region">{{ item.provinceName || '' }} {{ item.cityName || '' }} {{ item.districtName || '' }}</view>
        <view class="specialty" v-if="item.specialty">擅长：{{ item.specialty }}</view>
        <view class="follow-count">♥ {{ item.followCount || 0 }} 关注</view>
      </view>
    </view>

    <view class="load-more" @click="loadMore">加载更多</view>
  </view>
</template>

<script>
import { get } from '../../utils/request.js'

export default {
  data() {
    return {
      keyword: '',
      list: [],
      pageNo: 1,
      pageSize: 10,
      total: 0,
      loading: false,
      defaultAvatar: 'https://qiniu-web-assets.dcloud.net.cn/unidoc/zh/uni.png',
    }
  },
  onLoad() {
    this.fetchList()
  },
  onPullDownRefresh() {
    this.pageNo = 1
    this.fetchList().finally(() => uni.stopPullDownRefresh())
  },
  methods: {
    async fetchList() {
      this.loading = true
      try {
        const params = { pageNo: this.pageNo, pageSize: this.pageSize }
        if (this.keyword) {
          params.keyword = this.keyword
        }
        const res = await get('/app-api/inherit/inheritor/page', params)
        this.total = res.total
        this.list = this.pageNo === 1 ? res.list : this.list.concat(res.list)
      } catch (e) {
        uni.showToast({ title: (e && e.msg) || '加载失败', icon: 'none' })
      } finally {
        this.loading = false
      }
    },
    onSearch() {
      this.pageNo = 1
      this.fetchList()
    },
    loadMore() {
      if (this.list.length < this.total) {
        this.pageNo += 1
        this.fetchList()
      } else {
        uni.showToast({ title: '没有更多了', icon: 'none' })
      }
    },
    goDetail(id) {
      uni.navigateTo({ url: '/pages/detail/index?id=' + id })
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

.card {
  display: flex;
  background: #fff;
  border-radius: 16rpx;
  padding: 20rpx;
  margin-bottom: 20rpx;
}

.avatar {
  width: 140rpx;
  height: 140rpx;
  border-radius: 12rpx;
  background: #eee;
  flex-shrink: 0;
}

.info {
  flex: 1;
  margin-left: 20rpx;
  overflow: hidden;
}

.name-row {
  display: flex;
  align-items: center;
}

.name {
  font-size: 32rpx;
  font-weight: bold;
  color: #333;
}

.level {
  margin-left: 12rpx;
  font-size: 22rpx;
  color: #c8102e;
  border: 1rpx solid #c8102e;
  border-radius: 6rpx;
  padding: 0 8rpx;
}

.region {
  margin-top: 6rpx;
  font-size: 24rpx;
  color: #999;
}

.specialty {
  margin-top: 6rpx;
  font-size: 26rpx;
  color: #555;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.follow-count {
  margin-top: 8rpx;
  font-size: 24rpx;
  color: #c8102e;
}

.tip {
  text-align: center;
  color: #999;
  font-size: 28rpx;
  padding: 80rpx 0;
}

.load-more {
  text-align: center;
  color: #666;
  font-size: 26rpx;
  padding: 20rpx 0 40rpx;
}
</style>
