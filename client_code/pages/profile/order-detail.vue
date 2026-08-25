<template>
  <view class="app-page order-detail-page">
    <page-header title="订单详情" />
    <view v-if="loading" class="empty-block">正在加载订单…</view>
    <view v-else-if="error" class="empty-block"><text>{{ error }}</text></view>
    <template v-else-if="order">
      <view class="section-card status-card">
        <text class="status-title">{{ statusText(order.status) }}</text>
        <text v-if="order.status === 'WAIT_PAY'" class="status-note">支付功能待接入</text>
      </view>
      <view class="section-card">
        <view class="section-title">收货信息</view>
        <text class="receiver">{{ order.receiverName }} {{ maskMobile(order.receiverMobile) }}</text>
        <text class="address">{{ order.receiverDetailAddress || '--' }}</text>
      </view>
      <view v-for="group in order.merchantOrders || []" :key="group.id" class="section-card">
        <view class="merchant-title">{{ group.merchantName || group.shopName || '商户' }}</view>
        <view v-for="item in group.items || []" :key="item.id" class="order-item">
          <image class="cover" :src="normalizeImage(item.picUrl)" mode="aspectFill" />
          <view class="item-main"><text class="name">{{ item.productName }}</text><text v-if="item.skuProperties" class="spec">{{ item.skuProperties }}</text><view class="item-bottom"><text>¥{{ formatPrice(item.price) }}</text><text>×{{ item.count }}</text></view></view>
        </view>
        <view v-if="group.logisticsCompanyName || group.trackingNo" class="logistics"><text>物流：{{ group.logisticsCompanyName || '--' }} {{ group.trackingNo || '--' }}</text><text v-if="group.shipTime">发货时间：{{ formatDateTime(group.shipTime) }}</text></view>
      </view>
      <view class="section-card amount-card">
        <view><text>商品金额</text><text>¥{{ formatPrice(order.goodsAmount) }}</text></view>
        <view><text>运费</text><text>{{ Number(order.deliveryAmount) === 0 ? '免运费' : `¥${formatPrice(order.deliveryAmount)}` }}</text></view>
        <view><text>优惠</text><text>{{ Number(order.discountAmount) === 0 ? '暂无优惠' : `-¥${formatPrice(order.discountAmount)}` }}</text></view>
        <view class="pay"><text>实付</text><text>¥{{ formatPrice(order.payAmount) }}</text></view>
      </view>
      <view class="section-card meta-card"><text>订单编号：{{ order.orderNo }}</text><text>创建时间：{{ formatDateTime(order.createTime) }}</text></view>
      <view v-if="order.status === 'WAIT_PAY'" class="action-bar"><button :loading="cancelling" class="cancel" @tap="cancelOrder">取消订单</button></view>
      <view v-else-if="order.status === 'WAIT_RECEIVE'" class="action-bar"><button :loading="receiving" class="receive" @tap="receiveOrder">确认收货</button></view>
    </template>
  </view>
</template>

<script>
import PageHeader from '@/components/page-header.vue'
import { cancelMarketplaceOrder, getMarketplaceOrder, receiveMarketplaceMerchantOrder } from '@/common/request/marketplace-order.js'
import { requireLogin } from '@/common/session.js'
import { formatDateTime, formatPrice, normalizeImage } from '@/common/utils.js'

const STATUS_TEXT = { WAIT_PAY: '待付款', PAID: '待发货', WAIT_SHIP: '待发货', SHIPPED: '待收货', WAIT_RECEIVE: '待收货', COMPLETED: '已完成', CANCELLED: '已取消' }

export default {
  components: { PageHeader },
  data() { return { id: null, order: null, loading: false, error: '', cancelling: false, receiving: false } },
  onLoad(query) { this.id = Number(query.id) },
  onShow() { if (requireLogin() && this.id > 0) this.loadOrder() },
  methods: {
    formatDateTime, formatPrice, normalizeImage,
    statusText(status) { return STATUS_TEXT[status] || status || '--' },
    maskMobile(value) { const text = String(value || ''); return text.length >= 7 ? `${text.slice(0, 3)}****${text.slice(-4)}` : text },
    async loadOrder() {
      this.loading = true; this.error = ''
      try { this.order = await getMarketplaceOrder(this.id) } catch (error) { this.error = error.msg || '订单加载失败' } finally { this.loading = false }
    },
    cancelOrder() {
      uni.showModal({ title: '取消订单', content: '确定取消该待付款订单吗？', success: async (res) => {
        if (!res.confirm || this.cancelling) return
        this.cancelling = true
        try { await cancelMarketplaceOrder({ id: this.id, reason: 'MEMBER_CANCEL' }); uni.showToast({ title: '订单已取消', icon: 'success' }); this.loadOrder() } catch (error) { uni.showToast({ title: error.msg || '取消失败', icon: 'none' }) } finally { this.cancelling = false }
      } })
    },
    receiveOrder() {
      const groups = Array.isArray(this.order && this.order.merchantOrders) ? this.order.merchantOrders : []
      if (groups.length !== 1 || !groups[0].id) { uni.showToast({ title: '当前订单暂不支持合并确认收货', icon: 'none' }); return }
      uni.showModal({ title: '确认收货', content: '确认已收到商品吗？', success: async (res) => {
        if (!res.confirm || this.receiving) return
        this.receiving = true
        try { await receiveMarketplaceMerchantOrder({ merchantOrderId: groups[0].id }); uni.showToast({ title: '已确认收货', icon: 'success' }); this.loadOrder() } catch (error) { uni.showToast({ title: error.msg || '确认收货失败', icon: 'none' }) } finally { this.receiving = false }
      } })
    }
  }
}
</script>

<style lang="scss" scoped>
.order-detail-page { min-height: 100vh; padding-bottom: 42rpx; background: $ichip-color-page; }.section-card { margin: 20rpx 28rpx; padding: 26rpx; border: 1rpx solid $ichip-color-line; border-radius: 20rpx; background: $ichip-color-surface; }.status-card { display:flex; flex-direction:column; gap:10rpx; }.status-title { color:$ichip-color-ink; font-size:36rpx; font-weight:600; }.status-note,.spec,.meta-card,.logistics { color:$ichip-color-muted; font-size:23rpx; }.section-title,.merchant-title { display:block; color:$ichip-color-ink; font-size:29rpx; font-weight:600; }.receiver,.address { display:block; margin-top:15rpx; color:$ichip-color-ink; font-size:26rpx; }.address { color:$ichip-color-muted; line-height:1.55; }.order-item { display:flex; gap:18rpx; padding:22rpx 0 4rpx; }.cover { width:150rpx; height:150rpx; flex:none; border-radius:16rpx; background:#e3eee5; }.item-main { display:flex; flex:1; min-width:0; flex-direction:column; }.name { color:$ichip-color-ink; font-size:27rpx; line-height:1.4; }.spec { margin-top:8rpx; }.item-bottom,.amount-card>view { display:flex; justify-content:space-between; gap:20rpx; }.item-bottom { margin-top:auto; color:#a5523d; font-size:27rpx; }.logistics { display:flex; flex-direction:column; gap:7rpx; margin-top:16rpx; line-height:1.5; }.amount-card>view { margin-top:16rpx; color:$ichip-color-muted; font-size:25rpx; }.amount-card>view:first-child { margin-top:0; }.amount-card .pay { color:$ichip-color-ink; font-size:30rpx; font-weight:600; }.amount-card .pay text:last-child { color:#a5523d; }.meta-card { display:flex; flex-direction:column; gap:12rpx; line-height:1.5; }.action-bar { margin:28rpx; }.cancel { border:1rpx solid #c7a093; background:$ichip-color-surface; color:#a5523d; font-size:27rpx; }.receive { background:$ichip-color-nav-active; color:#fff; font-size:27rpx; }.empty-block { padding:120rpx 40rpx; color:$ichip-color-muted; text-align:center; }
</style>
