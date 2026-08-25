<template>
  <view class="app-page product-page">
    <page-header title="商品详情" variant="quiet" />
    <content-state v-if="loading && !loaded" class="detail-state" type="loading" message="正在打开商品档案…" />
    <content-state v-else-if="error" class="detail-state" type="error" :message="error" :retrying="loading" @retry="loadProduct" />
    <template v-else-if="loaded">
      <swiper class="detail-swiper" :indicator-dots="imageList.length > 1" circular>
        <swiper-item v-for="(item, index) in imageList" :key="`${item}-${index}`">
          <image :src="detailImage(item, index)" mode="aspectFill" class="detail-image" @error="handleDetailImageError(index)" />
        </swiper-item>
      </swiper>

      <view class="product-summary product-info-card">
        <view class="summary-kicker-row">
          <text v-if="product.category" class="summary-category">{{ product.category }}</text>
          <text class="favorite-action" :class="{ 'favorite-action--active': favorited }" @click="handleFavorite">{{ favorited ? '已收藏' : '收藏' }}</text>
        </view>
        <view class="product-title">{{ product.name }}</view>
        <view v-if="product.subtitle" class="product-subtitle">{{ product.subtitle }}</view>
        <view class="product-price">¥{{ formatPrice(displayPrice) }}</view>
        <view class="product-minor-meta">
          <text v-if="stockDisplay" class="low-stock" :class="{ 'low-stock--sold-out': selectedSku && selectedSku.stock <= 0 }">{{ stockDisplay }}</text>
          <text v-if="product.sales" class="sales-copy">已售 {{ product.sales }}</text>
        </view>
      </view>

      <view v-if="merchant && merchant.merchantName" class="content-section detail-card merchant-section">
        <view class="content-section__title">经营商户</view>
        <view class="merchant-name">{{ merchant.merchantName }}</view>
      </view>

      <view v-if="specGroups.length" class="content-section detail-card sku-section">
        <view class="content-section__title">选择规格</view>
        <view v-for="group in specGroups" :key="group.propertyId" class="sku-group">
          <view class="sku-group__title">{{ group.propertyName }}</view>
          <view class="sku-options">
            <view
              v-for="value in group.values"
              :key="value.valueId"
              class="sku-option"
              :class="{ 'sku-option--selected': selectedPropertyValueIds[group.propertyId] === value.valueId, 'sku-option--disabled': isValueDisabled(group, value) }"
              @click="selectProperty(group, value)"
            >{{ value.valueName }}</view>
          </view>
        </view>
        <view v-if="!selectionComplete" class="sku-hint">请选择规格</view>
      </view>

      <view v-if="product.description" class="content-section detail-card">
        <view class="content-section__title">商品介绍</view>
        <view class="product-description">{{ product.description }}</view>
      </view>
      <view v-if="product.category" class="content-section detail-card craft-section">
        <view class="content-section__title">文化类别</view>
        <view class="craft-name">{{ product.category }}</view>
        <view class="craft-note">商品所关联的现有平台分类</view>
      </view>
      <view class="content-section detail-card traceability-card">
        <view class="content-section__title">非遗来源</view>
        <view class="traceability-placeholder">相关非遗资料正在接入</view>
      </view>

      <view class="purchase-bar">
        <view class="cart-shortcut" @click="goCart"><view class="cart-glyph"><view class="cart-glyph__basket"></view></view><text>购物车</text></view>
        <view class="bar-total"><text class="bar-total__label">合计</text><text class="bar-total__price">¥{{ formatPrice(totalPrice) }}</text></view>
        <view class="bar-quantity">
          <text v-if="stockDisplay" class="bar-stock">{{ stockDisplay }}</text>
          <view class="quantity-stepper"><view class="quantity-button" :class="{ disabled: !canPurchase || quantity <= 1 }" @click="changeQuantity(-1)">−</view><view class="quantity-value">{{ quantity }}</view><view class="quantity-button" :class="{ disabled: !canPurchase || quantity >= quantityMax }" @click="changeQuantity(1)">＋</view></view>
        </view>
        <view class="bar-actions"><view class="action-button action-button--cart" :class="{ disabled: !canPurchase }" @click="handleAddCart"><text class="cart-plus-glyph">＋</text></view><view class="action-button action-button--buy" :class="{ disabled: !canPurchase }" @click="buyNow">立即购买</view></view>
      </view>
    </template>
  </view>
</template>

<script>
import PageHeader from '@/components/page-header.vue'
import ContentState from '@/components/content-state.vue'
import { addMemberCartItem } from '@/common/request/member-cart.js'
import { getMallProductDetail } from '@/common/request/mall-product.js'
import { getMarketplaceProductRelation } from '@/common/request/marketplace-product-relation.js'
import { requireLogin } from '@/common/session.js'
import { formatPrice, normalizeImage } from '@/common/utils.js'

export default {
  components: { PageHeader, ContentState },
  data() {
    return {
      productId: null,
      product: {},
      merchant: null,
      selectedSkuId: null,
      selectedPropertyValueIds: {},
      quantity: 1,
      favorited: false,
      loading: false,
      loaded: false,
      error: '',
      failedDetailImages: {}
    }
  },
  computed: {
    specGroups() {
      const groups = new Map()
      for (const sku of this.product.skus || []) {
        for (const property of sku.properties || []) {
          const propertyId = String(property.propertyId)
          if (!groups.has(propertyId)) groups.set(propertyId, { propertyId, propertyName: property.propertyName || '规格', values: [] })
          const group = groups.get(propertyId)
          const valueId = Number(property.valueId)
          if (!group.values.some(item => item.valueId === valueId)) group.values.push({ valueId, valueName: property.valueName || String(property.valueId) })
        }
      }
      return Array.from(groups.values())
    },
    selectedSku() { return (this.product.skus || []).find(item => Number(item.id) === Number(this.selectedSkuId)) || null },
    selectionComplete() { return !this.specGroups.length || !!this.selectedSku },
    canPurchase() { return !!this.selectedSku && Number(this.selectedSku.stock) > 0 && this.selectionComplete },
    quantityMax() { return this.selectedSku ? Math.max(Number(this.selectedSku.stock) || 0, 1) : 1 },
    displayPrice() { return this.selectedSku ? this.selectedSku.price : (this.product.price || 0) },
    totalPrice() { return Number(this.displayPrice || 0) * Number(this.quantity || 1) },
    stockDisplay() {
      if (this.specGroups.length && !this.selectedSku) return '请选择规格'
      if (!this.selectedSku) return ''
      const stock = Number(this.selectedSku.stock)
      if (stock <= 0) return '暂时缺货'
      if (stock <= 5) return `仅余 ${stock} 件`
      return `库存 ${stock} 件`
    },
    imageList() {
      const skuPic = this.selectedSku && this.selectedSku.picUrl
      const images = Array.isArray(this.product.images) ? this.product.images : []
      const list = [skuPic, ...images].filter(Boolean).map(item => normalizeImage(item, '/static/mall-demo/placeholder.png'))
      return list.length ? Array.from(new Set(list)) : ['/static/mall-demo/placeholder.png']
    }
  },
  onLoad(options) { this.productId = options && options.id; this.loadProduct() },
  methods: {
    formatPrice,
    async loadProduct() {
      if (!this.productId || this.loading) return
      this.loading = true
      this.error = ''
      try {
        const data = await getMallProductDetail(this.productId)
        this.product = this.normalizeProduct(data)
        this.merchant = await getMarketplaceProductRelation(this.product.id).catch(() => null)
        this.initializeSkuSelection()
        this.quantity = 1
        this.loaded = true
        this.favorited = false
      } catch (error) {
        this.loaded = false
        const unavailable = error && (error.httpStatus === 404 || error.code === 404)
        this.error = unavailable ? '商品不存在或已下架' : (error && error.message ? error.message : '商品详情加载失败，请稍后重试')
      } finally { this.loading = false }
    },
    normalizeProduct(data = {}) {
      return {
        id: data.id,
        name: data.name || '',
        subtitle: data.introduction || '',
        description: data.description || '',
        category: data.categoryName || '',
        cover: data.picUrl || '',
        images: Array.isArray(data.sliderPicUrls) ? data.sliderPicUrls : [],
        price: Number(data.price || 0),
        stock: data.stock,
        sales: data.salesCount,
        skus: Array.isArray(data.skus) ? data.skus.map(sku => ({ ...sku, id: Number(sku.id), price: Number(sku.price || 0), stock: Number(sku.stock || 0), properties: Array.isArray(sku.properties) ? sku.properties.map(property => ({ ...property, propertyId: Number(property.propertyId ?? property.property?.id ?? property.propertyValue?.propertyId), valueId: Number(property.valueId ?? property.propertyValueId ?? property.value?.id), propertyName: property.propertyName || property.property?.name || '', valueName: property.valueName || property.value?.name || String(property.valueId || '') })) : [] })) : []
      }
    },
    initializeSkuSelection() {
      const skus = this.product.skus || []
      if (!skus.length) { this.selectedSkuId = null; this.selectedPropertyValueIds = {}; return }
      const candidate = skus.find(sku => Number(sku.stock) > 0) || skus[0]
      this.applySkuSelection(candidate)
    },
    applySkuSelection(sku) {
      this.selectedSkuId = sku ? Number(sku.id) : null
      const selected = {}
      for (const property of (sku && sku.properties) || []) selected[String(property.propertyId)] = Number(property.valueId)
      this.selectedPropertyValueIds = selected
      if (sku && Number(sku.stock) > 0 && this.quantity > Number(sku.stock)) this.quantity = Number(sku.stock)
    },
    selectProperty(group, value) {
      if (this.isValueDisabled(group, value)) return
      const next = { ...this.selectedPropertyValueIds, [group.propertyId]: value.valueId }
      const match = (this.product.skus || []).find(sku => (sku.properties || []).every(property => Number(next[String(property.propertyId)]) === Number(property.valueId)) && (sku.properties || []).length === Object.keys(next).length)
      this.selectedPropertyValueIds = next
      this.selectedSkuId = match ? Number(match.id) : null
      this.quantity = 1
    },
    isValueDisabled(group, value) {
      const next = { ...this.selectedPropertyValueIds, [group.propertyId]: value.valueId }
      const candidates = (this.product.skus || []).filter(sku => (sku.properties || []).every(property => next[String(property.propertyId)] === undefined || Number(next[String(property.propertyId)]) === Number(property.valueId)))
      return !candidates.some(sku => Number(sku.stock) > 0)
    },
    detailImage(item, index) { return this.failedDetailImages[index] ? '/static/mall-demo/placeholder.png' : item },
    handleDetailImageError(index) { this.failedDetailImages[index] = true },
    changeQuantity(step) {
      if (!this.canPurchase) { uni.showToast({ title: this.stockDisplay || '请选择规格', icon: 'none' }); return }
      const next = this.quantity + step
      if (next < 1 || next > this.quantityMax) return
      this.quantity = next
    },
    async handleAddCart() {
      if (!this.canPurchase) { uni.showToast({ title: this.stockDisplay || '请选择规格', icon: 'none' }); return }
      if (!requireLogin()) return
      await addMemberCartItem({ skuId: Number(this.selectedSku.id), count: Number(this.quantity) })
      uni.showToast({ title: '已加入购物车', icon: 'success' })
    },
    async legacyFavoriteUnavailable() {},
    handleFavorite() { uni.showToast({ title: '收藏功能正在接入', icon: 'none' }) },
    goCart() { uni.switchTab({ url: '/pages/shop/cart' }) },
    buyNow() { if (!this.canPurchase) { uni.showToast({ title: this.stockDisplay || '请选择规格', icon: 'none' }); return } if (!requireLogin()) return; uni.setStorageSync('checkoutItems', [{ skuId: this.selectedSku.id, count: this.quantity, product: this.product }]); uni.navigateTo({ url: '/pages/shop/order' }) }
  }
}
</script>

<style lang="scss" src="./detail-recovered.scss" scoped></style>

<style lang="scss" scoped>
.sku-section { padding-bottom: 24rpx; }
.sku-group + .sku-group { margin-top: 24rpx; }
.sku-group__title { color: #857a70; font-size: 24rpx; margin-bottom: 14rpx; }
.sku-options { display: flex; flex-wrap: wrap; gap: 16rpx; }
.sku-option { min-width: 112rpx; padding: 14rpx 22rpx; border: 1rpx solid #e8e0d5; border-radius: 12rpx; color: #2c2723; font-size: 24rpx; text-align: center; box-sizing: border-box; }
.sku-option--selected { border-color: #64796e; color: #64796e; background: rgba(100,121,110,.08); }
.sku-option--disabled { color: #aaa096; background: #f0ece4; border-color: #e8e0d5; text-decoration: line-through; }
.sku-hint { margin-top: 18rpx; color: #a5523d; font-size: 22rpx; }
.low-stock--sold-out { color: #a5523d; }
.quantity-button.disabled, .action-button.disabled { opacity: .45; }
</style>
