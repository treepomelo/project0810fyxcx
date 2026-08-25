<template>
  <view class="address-page">
    <page-header title="收货地址" />
    <view class="address-head">
      <text class="eyebrow">收货服务</text>
      <text class="title">我的收货地址</text>
      <text class="subtitle">管理您的收货信息</text>
    </view>
    <view v-if="loading" class="state"><text>正在加载地址...</text></view>
    <view v-else-if="!addresses.length" class="state">
      <text class="state-title">还没有收货地址</text>
      <text class="state-note">添加地址后即可继续结算</text>
    </view>
    <view v-else class="address-list">
      <view v-for="item in addresses" :key="item.id" class="address-card" :class="{ selected: selectedId === String(item.id) }" @tap="selectAddress(item)">
        <view class="address-row">
          <text class="name">{{ item.name }}</text>
          <text class="mobile">{{ maskMobile(item.mobile) }}</text>
          <text v-if="item.defaultStatus" class="tag">默认</text>
          <text v-if="selectMode && selectedId === String(item.id)" class="selected-mark">已选择</text>
        </view>
        <text class="detail">{{ item.areaName || '已选择地区' }} {{ item.detailAddress }}</text>
        <view class="card-actions">
          <text v-if="selectMode" class="choose">选择此地址</text>
          <text @tap.stop="editAddress(item)">编辑</text>
          <text class="danger" @tap.stop="removeAddress(item)">删除</text>
        </view>
      </view>
    </view>
    <button class="add-button" @tap="editAddress()">新增收货地址</button>
  </view>
</template>

<script>
import PageHeader from '@/components/page-header.vue'
import { getMemberAddressList, deleteMemberAddress } from '@/common/request/member-address.js'
import { isLoggedIn } from '@/common/session.js'

export default {
  components: { PageHeader },
  data() { return { addresses: [], loading: false, selectMode: false, selectedId: '' } },
  onLoad(options) {
    this.selectMode = options && String(options.select) === '1'
    this.selectedId = options && options.selectedId ? String(options.selectedId) : ''
    if (!isLoggedIn()) {
      const backUrl = this.selectMode ? '/pages/shop/order' : '/pages/address/list'
      uni.navigateTo({ url: `/pages/login/login?backUrl=${encodeURIComponent(backUrl)}` })
    }
  },
  onShow() { if (isLoggedIn()) this.loadAddresses() },
  methods: {
    maskMobile(mobile) { const text = String(mobile || ''); return text.length >= 7 ? `${text.slice(0, 3)}****${text.slice(-4)}` : text },
    async loadAddresses() {
      this.loading = true
      try { this.addresses = await getMemberAddressList() || [] } catch (error) { uni.showToast({ title: error.msg || '地址加载失败', icon: 'none' }) } finally { this.loading = false }
    },
    editAddress(item) { uni.navigateTo({ url: item ? `/pages/address/edit?id=${item.id}` : '/pages/address/edit' }) },
    selectAddress(item) {
      if (!this.selectMode) return
      this.selectedId = String(item.id)
      uni.setStorageSync('selectedCheckoutAddress', item)
      uni.navigateBack()
    },
    removeAddress(item) {
      uni.showModal({ title: '删除地址', content: '确定删除这个收货地址吗？', cancelText: '取消', confirmText: '确认删除', success: async (res) => {
        if (!res.confirm) return
        try { await deleteMemberAddress(item.id); await this.loadAddresses() } catch (error) { uni.showToast({ title: error.msg || '删除失败', icon: 'none' }) }
      } })
    }
  }
}
</script>

<style lang="scss" scoped>
.address-page { min-height: 100vh; padding-bottom: calc(160rpx + env(safe-area-inset-bottom)); background: $ichip-color-page; }
.address-head { padding: 18rpx 32rpx 28rpx; }.eyebrow { display: block; color: $ichip-color-nav-active; font-size: 20rpx; letter-spacing: 4rpx; }.title { display: block; margin-top: 12rpx; color: $ichip-color-ink; font-size: 44rpx; font-weight: 600; }.subtitle { display: block; margin-top: 10rpx; color: $ichip-color-muted; font-size: 24rpx; }
.state { margin: 0 24rpx; padding: 90rpx 24rpx; border: 1rpx solid $ichip-color-line; border-radius: 22rpx; background: $ichip-color-surface; color: $ichip-color-muted; text-align: center; font-size: 25rpx; }.state-title, .state-note { display: block; }.state-title { color: $ichip-color-ink; font-size: 29rpx; }.state-note { margin-top: 12rpx; color: $ichip-color-muted; font-size: 23rpx; }
.address-card { margin: 0 24rpx 18rpx; padding: 24rpx; border: 1rpx solid $ichip-color-line; border-radius: 20rpx; background: $ichip-color-surface; }.address-card.selected { border-color: $ichip-color-nav-active; }.address-row { display: flex; align-items: center; gap: 16rpx; }.name { color: $ichip-color-ink; font-size: 29rpx; }.mobile, .detail, .card-actions { color: $ichip-color-muted; font-size: 23rpx; }.detail { display: block; margin-top: 14rpx; line-height: 1.5; }.tag, .selected-mark { padding: 4rpx 10rpx; border-radius: 8rpx; background: #e3eee5; color: $ichip-color-nav-active; font-size: 20rpx; }.selected-mark { margin-left: auto; }.card-actions { display: flex; justify-content: flex-end; gap: 28rpx; margin-top: 22rpx; }.choose { margin-right: auto; color: $ichip-color-nav-active; }.danger { color: #a5523d; }
.add-button { position: fixed; left: 24rpx; right: 24rpx; bottom: calc(24rpx + env(safe-area-inset-bottom)); border-radius: 18rpx; background: $ichip-color-nav-active; color: #fff; font-size: 27rpx; line-height: 82rpx; }
</style>
