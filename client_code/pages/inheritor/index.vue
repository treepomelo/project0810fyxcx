<template>
  <view class="app-page inheritor-list-page">
    <view class="list-heading">
      <text class="list-title">非遗传承人</text>
      <text class="list-subtitle">认识守护传统技艺的人</text>
    </view>

    <!-- ===== [MAIN-INHERIT-MIGRATION START] ===== -->
    <view class="search-card">
      <input
        v-model.trim="keyword"
        class="search-input"
        placeholder="搜索姓名或擅长技艺"
        confirm-type="search"
        @confirm="submitSearch"
      />
      <text class="search-action" @tap="submitSearch">搜索</text>
    </view>

    <view v-if="loading && !list.length" class="state-wrap">
      <content-state type="loading" message="正在加载传承人…" />
    </view>
    <view v-else-if="error && !list.length" class="state-wrap">
      <content-state type="error" :message="error" :retrying="loading" @retry="loadFirstPage" />
    </view>
    <view v-else>
      <view v-if="list.length" class="inheritor-list">
        <view
          v-for="item in list"
          :key="item.id"
          class="inheritor-card"
          @tap="goDetail(item.id)"
        >
          <image class="inheritor-avatar" :src="normalizeImage(item.avatar || item.cover, '/static/img/logo.png')" mode="aspectFill" />
          <view class="inheritor-card__body">
            <view class="inheritor-card__title-row">
              <text class="inheritor-card__name">{{ item.name || '未命名传承人' }}</text>
              <text v-if="item.level" class="inheritor-card__level">{{ item.level }}</text>
            </view>
            <text v-if="regionText(item)" class="inheritor-card__region">{{ regionText(item) }}</text>
            <text v-if="item.specialty" class="inheritor-card__specialty">擅长：{{ item.specialty }}</text>
            <text v-if="item.introduction" class="inheritor-card__intro">{{ shortText(item.introduction, 54) }}</text>
            <text class="inheritor-card__follow">关注 {{ item.followCount || 0 }}</text>
          </view>
        </view>
      </view>
      <content-state v-else type="empty" message="暂无符合条件的传承人" />

      <view v-if="loading && list.length" class="list-loading">正在加载更多…</view>
      <view v-else-if="hasMore" class="list-more">上拉加载更多</view>
      <view v-else-if="list.length" class="list-more">没有更多了</view>
    </view>
    <!-- ===== [MAIN-INHERIT-MIGRATION END] ===== -->

    <bottom-nav current="inheritor" />
  </view>
</template>

<script>
import BottomNav from '@/components/bottom-nav.vue'
import ContentState from '@/components/content-state.vue'
import { getInheritorPage } from '@/common/request/api.js'
import { normalizeImage, shortText } from '@/common/utils.js'

// ===== [MAIN-INHERIT-MIGRATION START] =====
// 从 main 分支拼接传承人页面业务，Phase 1 仅完成功能接入。
export default {
  components: { BottomNav, ContentState },
  data() {
    return {
      keyword: '',
      list: [],
      pageNo: 1,
      pageSize: 10,
      total: 0,
      loading: false,
      error: ''
    }
  },
  computed: {
    hasMore() {
      return this.list.length < this.total
    }
  },
  onLoad() {
    this.loadFirstPage()
  },
  onPullDownRefresh() {
    this.loadFirstPage().finally(() => uni.stopPullDownRefresh())
  },
  onReachBottom() {
    this.loadNextPage()
  },
  methods: {
    normalizeImage,
    shortText,
    async loadFirstPage() {
      this.pageNo = 1
      await this.loadPage(true)
    },
    async loadNextPage() {
      if (this.loading || !this.hasMore) return
      this.pageNo += 1
      await this.loadPage(false)
    },
    async loadPage(reset) {
      this.loading = true
      if (reset) this.error = ''
      try {
        const result = await getInheritorPage({
          pageNo: this.pageNo,
          pageSize: this.pageSize,
          keyword: this.keyword || undefined
        })
        const rows = result && Array.isArray(result.list) ? result.list : []
        this.total = Number(result && result.total) || 0
        this.list = reset ? rows : this.list.concat(rows)
      } catch (requestError) {
        if (reset) this.list = []
        this.error = this.getErrorMessage(requestError, '传承人加载失败，请稍后重试')
      } finally {
        this.loading = false
      }
    },
    submitSearch() {
      this.loadFirstPage()
    },
    goDetail(id) {
      if (!id) return
      uni.navigateTo({ url: `/pages/inheritor/detail?id=${id}` })
    },
    regionText(item) {
      return [item.provinceName, item.cityName, item.districtName].filter(Boolean).join(' ')
    },
    getErrorMessage(error, fallback) {
      return (error && (error.message || error.msg)) || fallback
    }
  }
}
// ===== [MAIN-INHERIT-MIGRATION END] =====
</script>

<style lang="scss" scoped>
/* ===== [MAIN-INHERIT-MIGRATION START] ===== */
/* Phase 1: 传承人真实列表拼接，后续统一视觉优化。 */
.inheritor-list-page {
  min-height: 100vh;
  padding: 32rpx 24rpx 156rpx;
  background: #f5f0e7;
}

.list-heading {
  padding: 8rpx 4rpx 24rpx;
}

.list-title {
  display: block;
  color: #34251f;
  font-size: 44rpx;
  font-weight: 700;
}

.list-subtitle {
  display: block;
  margin-top: 8rpx;
  color: #8a7466;
  font-size: 25rpx;
}

.search-card {
  display: flex;
  align-items: center;
  padding: 10rpx 16rpx 10rpx 24rpx;
  border-radius: 22rpx;
  background: #fffaf5;
  box-shadow: 0 8rpx 24rpx rgba(83, 53, 37, 0.06);
}

.search-input {
  flex: 1;
  height: 72rpx;
  color: #34251f;
  font-size: 27rpx;
}

.search-action {
  padding: 18rpx 22rpx;
  border-radius: 18rpx;
  background: #64796e;
  color: #fff;
  font-size: 25rpx;
}

.inheritor-list {
  margin-top: 24rpx;
}

.inheritor-card {
  display: flex;
  margin-bottom: 18rpx;
  padding: 20rpx;
  border-radius: 22rpx;
  background: #fffaf5;
  box-shadow: 0 8rpx 24rpx rgba(83, 53, 37, 0.05);
}

.inheritor-avatar {
  width: 164rpx;
  height: 164rpx;
  flex-shrink: 0;
  border-radius: 18rpx;
  background: #eee2d6;
}

.inheritor-card__body {
  min-width: 0;
  flex: 1;
  margin-left: 20rpx;
}

.inheritor-card__title-row {
  display: flex;
  align-items: center;
}

.inheritor-card__name {
  overflow: hidden;
  color: #34251f;
  font-size: 32rpx;
  font-weight: 700;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.inheritor-card__level {
  max-width: 210rpx;
  margin-left: 12rpx;
  padding: 5rpx 10rpx;
  overflow: hidden;
  border: 1rpx solid rgba(166, 71, 45, 0.35);
  border-radius: 10rpx;
  color: #a6472d;
  font-size: 20rpx;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.inheritor-card__region,
.inheritor-card__specialty,
.inheritor-card__intro,
.inheritor-card__follow {
  display: block;
  margin-top: 10rpx;
  overflow: hidden;
  color: #806e62;
  font-size: 24rpx;
  line-height: 1.5;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.inheritor-card__intro {
  color: #9a877a;
}

.inheritor-card__follow {
  color: #64796e;
}

.state-wrap {
  margin-top: 20rpx;
  border-radius: 22rpx;
  background: #fffaf5;
}

.list-loading,
.list-more {
  padding: 24rpx 0;
  text-align: center;
  color: #9a877a;
  font-size: 24rpx;
}
/* ===== [MAIN-INHERIT-MIGRATION END] ===== */
</style>