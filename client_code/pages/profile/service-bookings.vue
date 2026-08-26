<template>
  <view class="app-page">
    <view v-for="item in list" :key="item.bookingId" class="booking-row">
      <text class="title">{{ item.serviceTitle || item.serviceName }}</text>
      <text>{{ item.systemName || item.systemCode }} · {{ item.location || '场次信息' }}</text>
      <text>{{ item.startTime }} - {{ item.endTime }}</text>
      <text>{{ item.peopleCount }} 人 · {{ item.contactName }} · {{ item.contactPhone }}</text>
      <text class="status">{{ status(item.status) }}</text>
      <button v-if="[0,1].includes(Number(item.status))" size="mini" @click="cancel(item.bookingId)">取消</button>
    </view>
    <text v-if="!list.length">暂无服务预约</text>
  </view>
</template>
<script>
import { getMyHeritageBookings, cancelHeritageBooking } from '@/common/request/heritage-ecosystem.js'
export default {
  data: () => ({ list: [] }),
  onShow() { this.load() },
  methods: {
    async load() { try { const page = await getMyHeritageBookings({ pageNo: 1, pageSize: 50 }); this.list = page && Array.isArray(page.list) ? page.list : [] } catch (e) { this.list = [] } },
    status(v) { return ({ 0: '待确认', 1: '已确认', 2: '已取消', 3: '已拒绝', 4: '已完成' })[Number(v)] || '处理中' },
    async cancel(id) { try { await cancelHeritageBooking(id); await this.load(); uni.showToast({ title: '已取消', icon: 'success' }) } catch (e) { uni.showToast({ title: e.msg || '取消失败', icon: 'none' }) } }
  }
}
</script>
<style scoped>.app-page{padding:24rpx;background:#f7f2eb;min-height:100vh}.booking-row{padding:24rpx;background:#fff;margin-bottom:16rpx;border-radius:16rpx;display:flex;flex-direction:column;gap:10rpx}.title{font-size:30rpx;font-weight:700}.status{color:#a6472d}</style>