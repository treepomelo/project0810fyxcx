<template>
  <view class="app-page">
    <button @click="apply">提交合作申请</button>
    <view v-for="item in list" :key="item.id" class="row">
      <view><text class="company">{{ item.companyName }}</text><text class="meta">{{ item.cooperationTypeName || item.cooperationType }}</text></view>
      <text class="status">{{ status(item) }}</text>
    </view>
    <text v-if="!list.length">暂无合作申请</text>
  </view>
</template>
<script>
import { getMyHeritageCooperations } from '@/common/request/heritage-ecosystem.js'
export default {
  data: () => ({ list: [] }),
  onShow() { this.load() },
  methods: {
    async load() { try { const page = await getMyHeritageCooperations({ pageNo: 1, pageSize: 50 }); this.list = page && Array.isArray(page.list) ? page.list : [] } catch (e) { this.list = [] } },
    status(item) { return item.statusName || ({ 0: '待处理', 1: '沟通中', 2: '已达成', 3: '已拒绝' })[Number(item.status)] || '处理中' },
    apply() { uni.navigateTo({ url: '/pages/cooperation/apply' }) }
  }
}
</script>
<style scoped>.app-page{padding:24rpx;background:#f7f2eb;min-height:100vh}.row{padding:24rpx;background:#fff;margin-top:16rpx;border-radius:16rpx;display:flex;justify-content:space-between;align-items:center}.company,.meta{display:block}.meta{margin-top:8rpx;color:#8a7166;font-size:22rpx}.status{color:#a6472d}</style>