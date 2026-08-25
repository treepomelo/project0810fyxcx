<template>
  <view class="order-page">
    <page-header title="确认订单" />
    <view class="order-head">
      <text class="title">确认订单</text>
      <text class="subtitle">请确认收货信息与商品信息</text>
    </view>

    <view class="section-card address-card" @tap="chooseAddress">
      <view class="section-title"><text>收货地址</text><text class="chevron">›</text></view>
      <view v-if="selectedAddress" class="address-content">
        <view class="address-line"><text class="address-name">{{ selectedAddress.name }}</text><text class="address-mobile">{{ maskMobile(selectedAddress.mobile) }}</text><text v-if="selectedAddress.defaultStatus" class="default-tag">默认</text></view>
        <text class="address-detail">{{ selectedAddress.areaName || '已选择地区' }} {{ selectedAddress.detailAddress }}</text>
      </view>
      <view v-else class="empty-address">
        <text class="empty-title">请先添加收货地址</text>
        <text class="empty-note">选择地址后才能预览配送订单</text>
        <button class="small-action" @tap.stop="createAddress">新增收货地址</button>
      </view>
    </view>

    <view class="section-card goods-card">
      <view class="section-title"><text>商品清单</text><text class="muted">{{ selectedIds.length }} 件</text></view>
      <view v-if="previewLoading" class="state-line">订单金额计算中...</view>
      <view v-if="previewError" class="state-line state-error">{{ previewError }}</view>
      <view v-if="!previewLoading && merchantGroups.length" class="merchant-list">
        <view v-for="group in merchantGroups" :key="group.merchantId || group.id" class="merchant-group">
          <view v-if="group.shopName || group.merchantName" class="merchant-heading"><text class="merchant-name">{{ group.shopName || group.merchantName }}</text><text class="merchant-chevron">›</text></view>
          <view v-for="item in group.items || []" :key="item.id || item.skuId" class="preview-item">
            <image class="preview-cover" :src="normalizeImage(item.picUrl || item.cover)" mode="aspectFill" />
            <view class="preview-main"><text v-if="item.productName || item.name" class="preview-name">{{ item.productName || item.name }}</text><text v-if="item.skuProperties || item.specText" class="preview-spec">{{ item.skuProperties || item.specText }}</text><view class="item-footer"><text class="preview-price">¥{{ formatPrice(item.price) }}</text><text class="preview-count">×{{ item.count || 1 }}</text></view></view>
          </view>
        </view>
      </view>
      <view v-else class="empty-address"><text class="empty-title">暂无可提交的商品</text><text class="empty-note">请返回购物车重新选择商品</text></view>
    </view>

    <view class="section-card delivery-card">
      <view class="section-title"><text>配送与留言</text></view>
      <view class="info-row"><text>配送方式</text><text class="info-value">普通快递</text></view>
      <view class="info-row"><text>运费</text><text class="info-value">{{ previewLoading ? '计算中' : (preview && preview.amountReady ? shippingText(preview.freightAmountCents) : '--') }}</text></view>
      <view class="remark-row" @tap="focusRemark"><text>买家留言</text><input :focus="remarkFocus" v-model.trim="userRemark" maxlength="100" placeholder="选填，给商家留言" @blur="remarkFocus = false" /></view>
    </view>

    <view v-if="preview || previewError" class="section-card summary-card">
      <view class="summary-row"><text>商品金额</text><text>{{ previewLoading ? '计算中' : (preview && preview.amountReady ? `¥${formatAmount(preview.goodsAmountCents)}` : '--') }}</text></view>
      <view class="summary-row"><text>优惠</text><text>{{ previewLoading ? '计算中' : (preview && preview.amountReady ? discountText(preview.discountAmountCents) : '--') }}</text></view>
      <view class="summary-row"><text>运费</text><text>{{ previewLoading ? '计算中' : (preview && preview.amountReady ? shippingText(preview.freightAmountCents) : '--') }}</text></view>
      <text v-if="previewError" class="amount-error">{{ previewError }}</text>
    </view>

    <view class="submit-bar">
      <view class="payable"><text class="payable-label">合计</text><text class="payable-price">{{ previewLoading ? '计算中' : (preview && preview.amountReady ? `¥${formatAmount(preview.payAmountCents)}` : '--') }}</text></view>
      <button class="submit" :disabled="!selectedAddress || !merchantGroups.length || !preview || !preview.amountReady || previewLoading || submitting" @tap="submitOrder">{{ submitting ? '提交中…' : '提交订单' }}</button>
    </view>
  </view>
</template>

<script>
import PageHeader from '@/components/page-header.vue'
import { getMemberAddressList } from '@/common/request/member-address.js'
import { getMemberCartList } from '@/common/request/member-cart.js'
import { createMarketplaceOrder, previewMarketplaceOrder } from '@/common/request/marketplace-order.js'
import { isLoggedIn } from '@/common/session.js'
import { formatPrice, normalizeImage } from '@/common/utils.js'

export default {
  components: { PageHeader },
  data() { return { selectedIds: [], selectedAddress: null, selectedItems: [], preview: null, previewLoading: false, previewError: '', userRemark: '', remarkFocus: false, itemsLoadPromise: null, previewRequestSeq: 0, submitting: false, requestId: '' } },
  computed: {
    merchantGroups() {
      const groups = this.preview && Array.isArray(this.preview.merchantOrders) ? this.preview.merchantOrders.filter((group) => group && Array.isArray(group.items) && group.items.length) : []
      return groups
    }
  },
  onLoad() {
    if (!isLoggedIn()) { uni.navigateTo({ url: '/pages/login/login?backUrl=/pages/shop/order' }); return }
    const rawIds = uni.getStorageSync('checkoutCartItemIds') || []
    this.selectedIds = (Array.isArray(rawIds) ? rawIds : [rawIds]).map((id) => Number(id)).filter((id) => Number.isFinite(id) && id > 0)
    this.itemsLoadPromise = this.loadSelectedCartItems()
  },
  onShow() {
    if (!isLoggedIn() || !this.selectedIds.length) return
    const selected = uni.getStorageSync('selectedCheckoutAddress')
    if (selected && selected.id) { this.selectedAddress = selected; uni.removeStorageSync('selectedCheckoutAddress'); this.loadPreview(); return }
    this.loadAddresses()
  },
  methods: {
    formatPrice, normalizeImage,
    debugCheckout(event, payload) {
      if (typeof process !== 'undefined' && process.env && process.env.NODE_ENV === 'production') return
      // 仅记录订单预览调试元数据，不输出 token、手机号、姓名或完整响应。
      console.info(`[Checkout] ${event}`, payload || {})
    },
    previewErrorMessage(error) {
      const status = Number(error && (error.httpStatus || error.status || error.statusCode))
      if (status === 401 || Number(error && error.code) === 401) return '登录状态已失效，请重新登录'
      if (status === 400 || Number(error && error.code) === 400) return error.msg || '订单参数不完整，请重新选择商品和地址'
      if (status === 403 || Number(error && error.code) === 403) return '当前账号没有提交订单的权限'
      if (status === 404 || Number(error && error.code) === 404) return '订单预览服务暂不可用'
      if (status >= 500 || Number(error && error.code) >= 500) return '订单预览服务暂不可用，请稍后重试'
      if (error && (error.errMsg || error.message)) return '网络异常，请稍后重试'
      return '金额计算失败，请稍后重试'
    },
    formatAmount(value) { return value === null || value === undefined || !Number.isFinite(Number(value)) ? '--' : formatPrice(value) },
    shippingText(value) { const cents = Number(value); return Number.isFinite(cents) && cents === 0 ? '免运费' : `¥${this.formatAmount(value)}` },
    discountText(value) { const cents = Number(value); return Number.isFinite(cents) && cents === 0 ? '暂无优惠' : `-¥${this.formatAmount(value)}` },
    focusRemark() { this.remarkFocus = true },
    maskMobile(mobile) { const text = String(mobile || ''); return text.length >= 7 ? `${text.slice(0, 3)}****${text.slice(-4)}` : text },
    async loadSelectedCartItems() {
      try {
        const data = await getMemberCartList()
        const valid = data && Array.isArray(data.validList) ? data.validList : []
        const invalid = data && Array.isArray(data.invalidList) ? data.invalidList : []
        const fallback = !valid.length && !invalid.length && data && Array.isArray(data.list) ? data.list : []
        const all = valid.concat(invalid).concat(fallback)
        this.selectedItems = all.filter((item) => this.selectedIds.includes(Number(item.id || item.cartItemId))).map((item) => {
          const spu = item.spu || {}; const sku = item.sku || {}; const properties = Array.isArray(sku.properties) ? sku.properties : []
          return { id: item.id || item.cartItemId, skuId: item.skuId || sku.id, name: spu.name || item.name, productName: spu.name || item.name, picUrl: sku.picUrl || spu.picUrl || item.picUrl, price: Number(sku.price ?? item.price ?? 0), count: Number(item.count || 1), skuProperties: properties.map((property) => property.valueName || property.name || '').filter(Boolean).join(' / ') }
        })
        this.debugCheckout('cart-items-loaded', { requestedCount: this.selectedIds.length, selectedCount: this.selectedItems.length })
      } catch (error) {
        this.selectedItems = []
        this.debugCheckout('cart-items-failed', { code: error && error.code, httpStatus: error && error.httpStatus, msg: error && error.msg })
      }
    },
    async loadAddresses() {
      try {
        const list = await getMemberAddressList()
        const addresses = list || []
        this.selectedAddress = addresses.find((item) => item.defaultStatus) || addresses[0] || null
        this.debugCheckout('address-loaded', { addressCount: addresses.length, selectedAddressId: this.selectedAddress && this.selectedAddress.id })
        if (this.selectedAddress) this.loadPreview()
      } catch (error) {
        this.debugCheckout('address-failed', { code: error && error.code, httpStatus: error && error.httpStatus, msg: error && error.msg })
        uni.showToast({ title: error.msg || '地址加载失败', icon: 'none' })
      }
    },
    chooseAddress() { uni.navigateTo({ url: `/pages/address/list?select=1&selectedId=${this.selectedAddress ? this.selectedAddress.id : ''}` }) },
    createAddress() { uni.navigateTo({ url: '/pages/address/edit' }) },
    normalizeOrderPreview(raw) {
      const source = raw && raw.data && typeof raw.data === 'object' ? raw.data : raw
      const amountFields = ['goodsAmount', 'deliveryAmount', 'discountAmount', 'payAmount']
      const amountReady = !!source && amountFields.every((field) => source[field] !== null && source[field] !== undefined && Number.isFinite(Number(source[field])))
      return source ? { ...source, goodsAmountCents: amountReady ? Number(source.goodsAmount) : null, freightAmountCents: amountReady ? Number(source.deliveryAmount) : null, discountAmountCents: amountReady ? Number(source.discountAmount) : null, payAmountCents: amountReady ? Number(source.payAmount) : null, amountReady } : null
    },
    async loadPreview() {
      if (!this.selectedAddress || !this.selectedIds.length) return
      if (this.itemsLoadPromise) await this.itemsLoadPromise
      const addressId = Number(this.selectedAddress.id)
      if (!Number.isFinite(addressId) || addressId <= 0) {
        this.preview = null
        this.previewError = '请选择有效收货地址'
        this.debugCheckout('preview-invalid-address', { selectedAddressId: this.selectedAddress && this.selectedAddress.id })
        return
      }
      const requestSeq = ++this.previewRequestSeq
      this.previewLoading = true
      this.previewError = ''
      this.debugCheckout('preview-request', { cartItemIds: this.selectedIds, addressId, hasRemark: !!this.userRemark })
      try {
        const raw = await previewMarketplaceOrder({ cartItemIds: this.selectedIds, addressId, userRemark: this.userRemark || undefined })
        if (requestSeq !== this.previewRequestSeq) return
        this.preview = this.normalizeOrderPreview(raw)
        const source = this.preview || {}
        const itemCount = Array.isArray(source.merchantOrders) ? source.merchantOrders.reduce((sum, group) => sum + (Array.isArray(group && group.items) ? group.items.length : 0), 0) : 0
        this.debugCheckout('preview-response', { keys: Object.keys(source), goodsAmount: source.goodsAmount, deliveryAmount: source.deliveryAmount, discountAmount: source.discountAmount, payAmount: source.payAmount, merchantGroupCount: Array.isArray(source.merchantOrders) ? source.merchantOrders.length : 0, itemCount })
        if (!this.preview || !this.preview.amountReady) this.previewError = '金额计算暂未完成，请稍后重试'
      } catch (error) {
        if (requestSeq !== this.previewRequestSeq) return
        this.preview = null
        this.previewError = this.previewErrorMessage(error)
        this.debugCheckout('preview-failed', { code: error && error.code, httpStatus: error && error.httpStatus, msg: error && error.msg, message: error && error.message })
        uni.showToast({ title: this.previewError, icon: 'none' })
      } finally {
        if (requestSeq === this.previewRequestSeq) this.previewLoading = false
      }
    },
    createRequestId() {
      if (!this.requestId) this.requestId = `MP-${Date.now()}-${Math.random().toString(36).slice(2, 12)}`
      return this.requestId
    },
    async submitOrder() {
      if (this.submitting || !this.preview || !this.preview.amountReady || !this.selectedAddress || !this.selectedIds.length) return
      this.submitting = true
      try {
        const orderId = await createMarketplaceOrder({
          cartItemIds: this.selectedIds,
          addressId: Number(this.selectedAddress.id),
          userRemark: this.userRemark || undefined,
          requestId: this.createRequestId()
        })
        if (!orderId) throw new Error('ORDER_CREATE_EMPTY')
        uni.removeStorageSync('checkoutCartItemIds')
        uni.redirectTo({ url: `/pages/profile/order-detail?id=${orderId}` })
      } catch (error) {
        uni.showToast({ title: error.msg || '提交订单失败', icon: 'none' })
      } finally {
        this.submitting = false
      }
    }
  }
}
</script>

<style lang="scss" scoped>
.order-page { min-height: 100vh; padding-bottom: calc(150rpx + env(safe-area-inset-bottom)); background: $ichip-color-page; }
.order-head { padding: 12rpx 32rpx 20rpx; }.title { display: block; color: $ichip-color-ink; font-size: 46rpx; font-weight: 600; line-height: 1.25; }.subtitle { display: block; margin-top: 8rpx; color: $ichip-color-muted; font-size: 24rpx; line-height: 1.45; }
.section-card { margin: 0 32rpx 20rpx; padding: 26rpx; border: 1rpx solid $ichip-color-line; border-radius: 22rpx; background: $ichip-color-surface; }.section-title { display: flex; align-items: center; justify-content: space-between; color: $ichip-color-ink; font-size: 29rpx; font-weight: 500; }.chevron, .merchant-chevron { color: $ichip-color-muted; font-size: 34rpx; line-height: 1; }.address-content { margin-top: 18rpx; }.address-line { display: flex; align-items: center; min-width: 0; gap: 14rpx; }.address-name { color: $ichip-color-ink; font-size: 29rpx; font-weight: 500; }.address-mobile, .address-detail, .muted, .empty-note, .info-row, .remark-row { color: $ichip-color-muted; font-size: 23rpx; }.address-mobile { white-space: nowrap; }.address-detail { display: block; margin-top: 12rpx; line-height: 1.55; overflow-wrap: anywhere; }.default-tag { padding: 4rpx 10rpx; border-radius: 8rpx; background: #e3eee5; color: $ichip-color-nav-active; font-size: 20rpx; }.empty-address, .state-line { padding: 26rpx 0 12rpx; text-align: center; }.empty-title { display: block; color: $ichip-color-ink; font-size: 27rpx; }.empty-note { display: block; margin-top: 10rpx; }.small-action { width: 250rpx; margin: 20rpx auto 0; border-radius: 14rpx; background: $ichip-color-nav-active; color: #fff; font-size: 24rpx; line-height: 68rpx; }
.merchant-group { margin-top: 20rpx; padding-top: 18rpx; border-top: 1rpx solid $ichip-color-line; }.merchant-group:first-child { margin-top: 8rpx; padding-top: 0; border-top: 0; }.merchant-heading { display: flex; align-items: center; justify-content: space-between; }.merchant-name { display: block; color: $ichip-color-ink; font-size: 29rpx; font-weight: 500; }.preview-item { display: flex; align-items: flex-start; gap: 18rpx; padding: 20rpx 0 6rpx; }.preview-cover { flex: none; width: 168rpx; height: 168rpx; border-radius: 18rpx; background: #e3eee5; }.preview-main { display: flex; flex: 1; min-width: 0; flex-direction: column; min-height: 168rpx; }.preview-name { display: -webkit-box; overflow: hidden; color: $ichip-color-ink; font-size: 28rpx; font-weight: 500; line-height: 1.4; -webkit-box-orient: vertical; -webkit-line-clamp: 2; }.preview-spec { display: block; margin-top: 8rpx; color: $ichip-color-muted; font-size: 23rpx; line-height: 1.35; }.item-footer { display: flex; align-items: center; justify-content: space-between; margin-top: auto; }.preview-price { color: #a5523d; font-size: 32rpx; font-weight: 500; }.preview-count { color: $ichip-color-ink; font-size: 25rpx; }.info-row, .remark-row { display: flex; align-items: center; justify-content: space-between; min-height: 74rpx; border-bottom: 1rpx solid rgba(232, 224, 213, .72); }.info-value { color: $ichip-color-ink; text-align: right; }.remark-row { border-bottom: 0; }.remark-row input { flex: 1; min-width: 0; margin-left: 24rpx; color: $ichip-color-ink; text-align: right; font-size: 23rpx; }.summary-row { display: flex; justify-content: space-between; margin-top: 16rpx; color: $ichip-color-muted; font-size: 24rpx; }.summary-row:first-child { margin-top: 0; }.summary-row text:last-child { color: $ichip-color-ink; }.amount-error { display: block; margin-top: 18rpx; color: #a5523d; font-size: 22rpx; }
.submit-bar { position: fixed; left: 16rpx; right: 16rpx; bottom: calc(12rpx + env(safe-area-inset-bottom)); z-index: 10; display: flex; align-items: center; justify-content: space-between; min-height: 92rpx; padding: 10rpx 16rpx 10rpx 24rpx; border: 1rpx solid $ichip-color-line; border-radius: 20rpx; background: $ichip-color-surface; box-shadow: 0 3rpx 12rpx rgba(44,39,35,.05); }.payable { display: flex; align-items: baseline; min-width: 0; gap: 12rpx; }.payable-label { color: $ichip-color-ink; font-size: 25rpx; }.payable-price { color: #a5523d; font-size: 40rpx; font-weight: 500; line-height: 1; white-space: nowrap; }.submit { flex: none; width: 224rpx; margin: 0; padding: 0; border-radius: 14rpx; background: $ichip-color-nav-active; color: #fff; font-size: 27rpx; line-height: 76rpx; }.submit[disabled] { opacity: .45; }
</style>
