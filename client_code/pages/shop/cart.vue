<template>
  <view class="cart-page">
    <page-header :title="labels.cart" />
    <view class="cart-head"><text class="eyebrow">{{ labels.collection }}</text><text class="title">{{ labels.cart }}</text><text class="subtitle">{{ labels.subtitle }}</text></view>
    <view v-if="!loggedIn" class="state-card guest-card"><text class="state-icon">袋</text><text class="state-title">{{ labels.signInCart }}</text><text class="state-note">{{ labels.signInNote }}</text><button class="primary-button" @tap="goToLogin">{{ labels.signIn }}</button><button class="ghost-button" @tap="goToShop">{{ labels.explore }}</button></view>
    <view v-else>
      <view v-if="loading" class="state-card">{{ labels.loading }}</view>
      <view v-else-if="!cartList.length" class="state-card"><text class="state-icon">袋</text><text class="state-title">{{ labels.empty }}</text><text class="state-note">{{ labels.emptyNote }}</text><button class="primary-button" @tap="goToShop">{{ labels.explore }}</button></view>
    <view v-else class="cart-list">
        <view class="manage-row"><text class="list-title">{{ labels.items }}</text><text class="manage" @tap="editing = !editing">{{ editing ? labels.done : labels.manage }}</text></view>
        <view class="select-row" @tap="toggleAll"><view class="check" :class="{ checked: isAllSelected }">✓</view><text>{{ isAllSelected ? labels.clearAll : labels.selectAll }}</text><text class="muted">{{ labels.selected }} {{ selectedIds.length }}</text></view>
        <view v-for="item in cartList" :key="item.id" class="cart-item"><view class="check" :class="{ checked: item.selected }" @tap.stop="toggleSelect(item)">✓</view><image class="cover" :src="normalizeImage(item.cover)" mode="aspectFill" /><view class="item-main"><text class="item-name">{{ item.name }}</text><text v-if="item.skuProperties" class="item-spec">{{ item.skuProperties }}</text><view class="item-bottom"><text class="price">¥{{ formatPrice(item.price) }}</text><view class="stepper"><text class="step" @tap.stop="changeQuantity(item, -1)">−</text><text class="count">{{ item.count }}</text><text class="step" @tap.stop="changeQuantity(item, 1)">＋</text></view></view><text v-if="item.stock !== null && item.stock !== undefined && Number(item.stock) <= 5" class="stock">{{ Number(item.stock) === 0 ? labels.soldOut : labels.stock + ' ' + item.stock }}</text></view><text v-if="editing" class="delete" @tap="removeItem(item)">{{ labels.remove }}</text></view>
      </view>
    </view>
    <view v-if="loggedIn && cartList.length" class="cart-footer"><view><text class="muted">{{ labels.total }}</text><text class="total">¥{{ formatPrice(totalPrice) }}</text></view><button class="checkout" @tap="toCheckout">{{ labels.checkout }}</button></view>
    <bottom-nav current="cart" />
  </view>
</template>
<script>
import PageHeader from '@/components/page-header.vue'
import BottomNav from '@/components/bottom-nav.vue'
import { getMemberCartList, updateMemberCartCount, updateMemberCartSelected, deleteMemberCartItems } from '@/common/request/member-cart.js'
import { getMallProductDetail } from '@/common/request/mall-product.js'
import { isLoggedIn } from '@/common/session.js'
import { formatPrice, normalizeImage } from '@/common/utils.js'
export default {
  components: { PageHeader, BottomNav },
  data() { return { loggedIn: false, loading: false, editing: false, cartList: [], labels: { cart: '\u8D2D\u7269\u8F66', collection: '\u975E\u9057\u597D\u7269', subtitle: '\u628A\u559C\u6B22\u7684\u597D\u7269\u7559\u5728\u8EAB\u8FB9', signInCart: '\u767B\u5F55\u540E\u67E5\u770B\u8D2D\u7269\u8F66', signInNote: '\u767B\u5F55\u540E\u53EF\u67E5\u770B\u5DF2\u52A0\u5165\u7684\u975E\u9057\u597D\u7269', signIn: '\u7ACB\u5373\u767B\u5F55', explore: '\u53BB\u901B\u901B', loading: '\u6B63\u5728\u52A0\u8F7D...', empty: '\u8D2D\u7269\u8F66\u8FD8\u662F\u7A7A\u7684', emptyNote: '\u5148\u53BB\u6311\u9009\u559C\u6B22\u7684\u975E\u9057\u597D\u7269\u5427', clearAll: '\u53D6\u6D88\u5168\u9009', selectAll: '\u5168\u9009\u5546\u54C1', selected: '\u5DF2\u9009', stock: '\u5E93\u5B58', soldOut: '\u5DF2\u552E\u7F44', remove: '\u5220\u9664', items: '\u5546\u54C1\u6E05\u5355', manage: '\u7BA1\u7406', done: '\u5B8C\u6210', total: '\u5408\u8BA1', checkout: '\u53BB\u7ED3\u7B97' } } },
  computed: { selectedIds() { return this.cartList.filter((item) => item.selected).map((item) => item.id) }, isAllSelected() { return this.cartList.length > 0 && this.cartList.every((item) => item.selected) }, totalPrice() { return this.cartList.filter((item) => item.selected).reduce((sum, item) => sum + Number(item.price || 0) * Number(item.count || 0), 0) } },
  onShow() { this.loggedIn = isLoggedIn(); if (this.loggedIn) this.loadCart(); else this.cartList = [] },
  methods: {
    formatPrice, normalizeImage,
    async loadCart() {
      if (!this.loggedIn) return
      this.loading = true
      try {
        const data = await getMemberCartList()
        const validList = data && Array.isArray(data.validList) ? data.validList : []
        const invalidList = data && Array.isArray(data.invalidList) ? data.invalidList : []
        const fallbackList = !validList.length && !invalidList.length && data && Array.isArray(data.list) ? data.list : []
        const rawItems = validList.map((item) => ({ item, invalid: false }))
          .concat(invalidList.map((item) => ({ item, invalid: true })))
          .concat(fallbackList.map((item) => ({ item, invalid: false })))

        this.debugCartStage('RAW_COUNT', rawItems)
        this.cartList = rawItems.map(({ item, invalid }) => this.normalizeCartItem(item, invalid))
        this.debugCartStage('AFTER_NORMALIZE_COUNT', this.cartList)
        this.debugCartStage('AFTER_FILTER_COUNT', this.cartList)
        await this.hydrateMissingSkuProperties()
        this.debugCartStage('AFTER_ENRICH_COUNT', this.cartList)
        this.debugCartStage('RENDER_COUNT', this.cartList)
      } catch (error) {
        if (error && (error.code === 401 || error.httpStatus === 401)) this.loggedIn = false
        else uni.showToast({ title: error && error.msg ? error.msg : '购物车加载失败', icon: 'none' })
      } finally { this.loading = false }
    },
    normalizeCartItem(item = {}, invalid = false) {
      const spu = item.spu || {}
      const sku = item.sku || {}
      const properties = Array.isArray(sku.properties) ? sku.properties : []
      const propertyText = properties.map((property) => property.valueName || property.name || '').filter((value) => value).join(' / ')
      const id = item.id ?? item.cartItemId
      const spuId = item.spuId ?? spu.id
      const skuId = item.skuId ?? sku.id
      return {
        id,
        spuId,
        skuId,
        count: Number(item.count ?? 1),
        selected: item.selected !== false,
        invalid,
        invalidReason: item.invalidReason || (invalid ? '商品当前不可购买' : ''),
        name: spu.name || item.name || '商品信息待完善',
        cover: sku.picUrl || spu.picUrl || item.picUrl || '',
        picUrl: sku.picUrl || spu.picUrl || item.picUrl || '',
        price: Number(sku.price ?? item.price ?? 0),
        stock: sku.stock ?? spu.stock ?? item.stock ?? null,
        skuProperties: propertyText,
        specText: propertyText
      }
    },
    debugCartStage(stage, items) {
      if (typeof process !== 'undefined' && process.env && process.env.NODE_ENV === 'production') return
      // Counts are safe to log and make raw -> rendered drops observable in DEV.
      console.info(`[cart] ${stage}=${Array.isArray(items) ? items.length : 0}`)
    },
    async hydrateMissingSkuProperties() {
      // Enrich every referenced SPU, including invalidList entries. The
      // cart record remains visible even when its nested product snapshot is
      // incomplete or the product detail request fails.
      const spuIds = Array.from(new Set(this.cartList
        .map((item) => item.spuId)
        .filter((id) => id !== null && id !== undefined && id !== '')))
      if (!spuIds.length) return
      const results = await Promise.allSettled(spuIds.map((id) => getMallProductDetail(id)))
      results.forEach((result) => {
        if (result.status !== 'fulfilled' || !result.value) return
        const detail = result.value
        const detailSkus = Array.isArray(detail.skus) ? detail.skus : []
        this.cartList.forEach((item) => {
          if (Number(item.spuId) !== Number(detail.id || item.spuId)) return
          const sku = detailSkus.find((candidate) => Number(candidate.id) === Number(item.skuId))
          if (!sku) return
          const properties = Array.isArray(sku.properties) ? sku.properties : []
          const propertyText = properties.map((property) => property.valueName || property.name || '').filter((value) => value).join(' / ')
          item.name = item.name === '商品信息待完善' ? (detail.name || item.name) : item.name
          item.skuProperties = propertyText || item.skuProperties
          item.specText = item.skuProperties
          item.cover = item.cover || sku.picUrl || detail.picUrl || ''
          item.picUrl = item.picUrl || sku.picUrl || detail.picUrl || ''
          item.price = Number(sku.price ?? item.price ?? 0)
          item.stock = sku.stock ?? item.stock
        })
      })
    },
    goToLogin() { uni.navigateTo({ url: `/pages/login/login?backUrl=${encodeURIComponent('/pages/shop/cart')}` }) },
    goToShop() { uni.switchTab({ url: '/pages/shop/list' }) },
    async toggleSelect(item) { const next = !item.selected; try { await updateMemberCartSelected({ ids: [item.id], selected: next }); item.selected = next } catch (error) { uni.showToast({ title: error.msg || '\u66F4\u65B0\u5931\u8D25', icon: 'none' }) } },
    async toggleAll() { const next = !this.isAllSelected; try { await updateMemberCartSelected({ ids: this.cartList.map((item) => item.id), selected: next }); this.cartList.forEach((item) => { item.selected = next }) } catch (error) { uni.showToast({ title: error.msg || '\u66F4\u65B0\u5931\u8D25', icon: 'none' }) } },
    async changeQuantity(item, delta) {
      if (delta < 0 && Number(item.count) === 1) {
        this.confirmRemoveCartItem(item)
        return
      }
      const next = Math.max(1, Number(item.count || 1) + delta)
      if (item.stock !== null && item.stock !== undefined && next > Number(item.stock)) { uni.showToast({ title: '\u8D85\u8FC7\u5E93\u5B58', icon: 'none' }); return }
      try { await updateMemberCartCount({ id: item.id, count: next }); item.count = next } catch (error) { uni.showToast({ title: error.msg || '\u6570\u91CF\u4E0D\u53EF\u7528', icon: 'none' }) }
    },
    confirmRemoveCartItem(item) {
      uni.showModal({
        title: '\u79FB\u9664\u5546\u54C1',
        content: '\u786E\u5B9A\u5C06\u8BE5\u5546\u54C1\u4ECE\u8D2D\u7269\u8F66\u4E2D\u79FB\u9664\u5417\uFF1F',
        cancelText: '\u53D6\u6D88',
        confirmText: '\u786E\u8BA4\u79FB\u9664',
        success: async (res) => {
          if (!res.confirm) return
          try { await deleteMemberCartItems([item.id]); await this.loadCart() } catch (error) { uni.showToast({ title: error.msg || '\u5220\u9664\u5931\u8D25', icon: 'none' }) }
        }
      })
    },
    removeItem(item) { this.confirmRemoveCartItem(item) },
    toCheckout() { if (!this.selectedIds.length) { uni.showToast({ title: '\u8BF7\u9009\u62E9\u5546\u54C1', icon: 'none' }); return } uni.setStorageSync('checkoutCartItemIds', this.selectedIds); uni.navigateTo({ url: '/pages/shop/order' }) }
  }
}
</script>
<style lang="scss" scoped>
.cart-page { min-height: 100vh; padding-bottom: 240rpx; background: $ichip-color-page; }.cart-head { padding: 18rpx 32rpx 30rpx; }.eyebrow { display: block; color: $ichip-color-nav-active; font-size: 20rpx; letter-spacing: 5rpx; }.title { display: block; margin-top: 12rpx; color: $ichip-color-ink; font-size: 48rpx; font-weight: 600; }.subtitle { display: block; margin-top: 10rpx; color: $ichip-color-muted; font-size: 25rpx; }.state-card, .cart-list { margin: 0 24rpx 28rpx; padding: 34rpx 28rpx; border: 1rpx solid $ichip-color-line; border-radius: 24rpx; background: $ichip-color-surface; }.state-card { display: flex; align-items: center; flex-direction: column; text-align: center; }.state-icon { display: flex; align-items: center; justify-content: center; width: 96rpx; height: 96rpx; border-radius: 50%; background: #e3eee5; color: $ichip-color-nav-active; font-size: 28rpx; }.state-title { margin-top: 20rpx; color: $ichip-color-ink; font-size: 31rpx; font-weight: 600; }.state-note, .muted, .stock { margin-top: 10rpx; color: $ichip-color-muted; font-size: 23rpx; }.primary-button, .ghost-button { width: 280rpx; margin-top: 26rpx; border-radius: 18rpx; font-size: 27rpx; line-height: 78rpx; }.primary-button { background: $ichip-color-nav-active; color: #fff; }.ghost-button { border: 1rpx solid $ichip-color-line; background: transparent; color: $ichip-color-nav-active; }.manage-row { display: flex; align-items: center; justify-content: space-between; margin-bottom: 22rpx; }.list-title { color: $ichip-color-ink; font-size: 29rpx; font-weight: 500; }.manage { color: $ichip-color-nav-active; font-size: 24rpx; }.select-row { display: flex; align-items: center; gap: 12rpx; padding-bottom: 22rpx; border-bottom: 1rpx solid $ichip-color-line; color: $ichip-color-ink; font-size: 26rpx; }.select-row .muted { margin: 0 0 0 auto; }.check { display: flex; align-items: center; justify-content: center; width: 34rpx; height: 34rpx; border: 1rpx solid $ichip-color-muted; border-radius: 50%; color: transparent; font-size: 18rpx; }.check.checked { border-color: $ichip-color-nav-active; background: $ichip-color-nav-active; color: #fff; }.cart-item { position: relative; display: flex; align-items: flex-start; gap: 14rpx; padding: 24rpx 0; border-bottom: 1rpx solid $ichip-color-line; }.cart-item:last-child { border-bottom: 0; }.cover { width: 150rpx; height: 150rpx; border-radius: 16rpx; background: #e3eee5; }.item-main { flex: 1; min-width: 0; }.item-name { display: block; color: $ichip-color-ink; font-size: 28rpx; font-weight: 500; }.item-spec { display: block; margin-top: 8rpx; color: $ichip-color-muted; font-size: 22rpx; }.item-bottom { display: flex; align-items: center; justify-content: space-between; margin-top: 22rpx; }.price, .total { color: #a5523d; font-size: 29rpx; font-weight: 500; }.stepper { display: flex; align-items: center; border: 1rpx solid $ichip-color-line; border-radius: 12rpx; }.step, .count { display: flex; align-items: center; justify-content: center; width: 48rpx; height: 48rpx; color: $ichip-color-ink; font-size: 26rpx; }.count { width: 58rpx; border-left: 1rpx solid $ichip-color-line; border-right: 1rpx solid $ichip-color-line; }.stock { display: block; margin-top: 8rpx; }.delete { position: absolute; right: 0; top: 26rpx; color: $ichip-color-muted; font-size: 21rpx; }.cart-footer { position: fixed; left: 16rpx; right: 16rpx; bottom: calc(132rpx + env(safe-area-inset-bottom)); z-index: 10; display: flex; align-items: center; justify-content: space-between; padding: 18rpx 22rpx; border: 1rpx solid $ichip-color-line; border-radius: 20rpx; background: $ichip-color-surface; box-shadow: 0 4rpx 16rpx rgba(44,39,35,.06); }.cart-footer .muted { display: block; margin: 0; }.total { display: block; margin-top: 4rpx; font-size: 34rpx; }.checkout { margin: 0; padding: 0 42rpx; border-radius: 18rpx; background: $ichip-color-nav-active; color: #fff; font-size: 27rpx; line-height: 76rpx; }
</style>
