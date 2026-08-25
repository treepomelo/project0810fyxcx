<template>
  <view class="app-page orders-page">
    <page-header title="我的订单" />
    <view class="section-card">
      <view class="filter-row"><view v-for="item in filters" :key="item.value" class="filter" :class="{ active: status === item.value }" @tap="switchStatus(item.value)">{{ item.label }}</view></view>
      <view v-if="loading" class="empty-block">正在加载订单…</view>
      <view v-else-if="filteredOrders.length">
        <view v-for="order in filteredOrders" :key="order.id" class="order-card" @tap="openDetail(order.id)">
          <view class="order-head"><text>{{ order.orderNo }}</text><text class="status">{{ statusText(order.status) }}</text></view>
          <view v-for="group in order.merchantOrders || []" :key="group.id" class="merchant-group">
            <text class="merchant">{{ group.merchantName || group.shopName || '商户' }}</text>
            <view v-for="item in group.items || []" :key="item.id" class="item"><image :src="normalizeImage(item.picUrl)" mode="aspectFill" /><view><text>{{ item.productName }}</text><text v-if="item.skuProperties" class="spec">{{ item.skuProperties }}</text><text class="price">¥{{ formatPrice(item.price) }} ×{{ item.count }}</text></view></view>
          </view>
          <view class="order-foot"><text>{{ formatDateTime(order.createTime) }}</text><text>实付 ¥{{ formatPrice(order.payAmount) }}</text></view>
        </view>
      </view>
      <view v-else class="empty-block"><text>暂无订单，去商城看看吧</text><button class="shop-button" @tap="goToShop">前往商城</button></view>
    </view>
  </view>
</template>

<script>
import PageHeader from '@/components/page-header.vue'
import { getMarketplaceOrderPage } from '@/common/request/marketplace-order.js'
import { requireLogin } from '@/common/session.js'
import { formatDateTime, formatPrice, normalizeImage } from '@/common/utils.js'

const STATUS_TEXT = { WAIT_PAY: '待付款', PAID: '待发货', WAIT_SHIP: '待发货', SHIPPED: '待收货', WAIT_RECEIVE: '待收货', COMPLETED: '已完成', CANCELLED: '已取消' }

export default {
  components: { PageHeader },
  data() { return { loading: false, status: 'ALL', orders: [], filters: [{ label: '全部', value: 'ALL' }, { label: '待付款', value: 'WAIT_PAY' }, { label: '待发货', value: 'WAIT_SHIP' }, { label: '待收货', value: 'WAIT_RECEIVE' }, { label: '已完成', value: 'COMPLETED' }, { label: '已取消', value: 'CANCELLED' }] } },
  computed: { filteredOrders() { return this.status === 'ALL' ? this.orders : this.orders.filter((order) => order.status === this.status) } },
  onShow() { if (requireLogin()) this.loadOrders() },
  onPullDownRefresh() { this.loadOrders(true) },
  methods: {
    formatDateTime, formatPrice, normalizeImage,
    statusText(status) { return STATUS_TEXT[status] || status || '--' },
    async loadOrders(fromRefresh) { this.loading = true; try { const page = await getMarketplaceOrderPage({ pageNo: 1, pageSize: 50 }); this.orders = Array.isArray(page && page.list) ? page.list : [] } catch (error) { this.orders = []; uni.showToast({ title: error.msg || '订单加载失败', icon: 'none' }) } finally { this.loading = false; if (fromRefresh) uni.stopPullDownRefresh() } },
    switchStatus(status) { this.status = status },
    openDetail(id) { if (id) uni.navigateTo({ url: `/pages/profile/order-detail?id=${id}` }) },
    goToShop() { uni.switchTab({ url: '/pages/shop/list' }) }
  }
}
</script>

<style lang="scss" scoped>
.orders-page { min-height:100vh; padding:20rpx 28rpx 42rpx; background:$ichip-color-page; }.section-card { padding:22rpx; border:1rpx solid $ichip-color-line; border-radius:20rpx; background:$ichip-color-surface; }.filter-row { display:flex; flex-wrap:wrap; gap:12rpx; }.filter { padding:10rpx 18rpx; border-radius:999rpx; background:#f2ede4; color:$ichip-color-muted; font-size:23rpx; }.filter.active { background:$ichip-color-nav-active; color:#fff; }.order-card { padding:25rpx 0; border-top:1rpx solid $ichip-color-line; }.order-card:first-of-type { margin-top:14rpx; }.order-head,.order-foot { display:flex; justify-content:space-between; gap:16rpx; color:$ichip-color-muted; font-size:23rpx; }.status { color:#a5523d; }.merchant { display:block; margin-top:18rpx; color:$ichip-color-ink; font-size:27rpx; font-weight:500; }.item { display:flex; gap:14rpx; padding-top:16rpx; }.item image { width:108rpx; height:108rpx; border-radius:13rpx; background:#e3eee5; }.item view { display:flex; flex:1; flex-direction:column; gap:7rpx; color:$ichip-color-ink; font-size:25rpx; }.spec { color:$ichip-color-muted; font-size:22rpx; }.price { color:#a5523d; font-size:23rpx; }.order-foot { margin-top:18rpx; }.order-foot text:last-child { color:$ichip-color-ink; }.empty-block { padding:110rpx 20rpx; color:$ichip-color-muted; text-align:center; }.shop-button { width:220rpx; margin:24rpx auto 0; border-radius:14rpx; background:$ichip-color-nav-active; color:#fff; font-size:24rpx; }
</style>
