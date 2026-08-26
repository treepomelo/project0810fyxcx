<template>
  <view class="app-page shop-page with-bottom-nav">
    <view class="safe-top"></view>
    <view class="shop-header">
      <image class="shop-header__mascot" :src="homeAssets.mascot" mode="aspectFit"></image>
      <view class="shop-header__kicker">HERITAGE DISCOVERY</view>
      <view class="shop-title">分类</view>
      <view class="shop-subtitle">从非遗好物，到正在发生的文化体验</view>
      <view class="search-field"><text class="search-field__icon" @click="handleSearch">⌕</text><input v-model.trim="keyword" class="search-field__input" placeholder="搜非遗好物、文创、美食" confirm-type="search" @confirm="handleSearch" /><text v-if="keyword" class="search-field__clear" @click="clearSearch">×</text></view>
    </view>
    <view v-if="heritageSystems.length" class="heritage-system-strip"><view v-for="system in heritageSystems" :key="system.code" class="heritage-system-chip" :class="{ active: selectedHeritageCode === system.code }" @click="selectHeritageSystem(system.code)">{{ system.name }}</view></view><view v-if="heritageItems.length" class="heritage-item-strip"><view v-for="item in heritageItems" :key="item.targetType + '-' + item.targetId" class="heritage-item-card" @click="openHeritageItem(item)"><image :src="productImage(item)" mode="aspectFill" /><text>{{ item.title }}</text></view></view><view class="category-body">
      <scroll-view scroll-y enable-flex class="category-sidebar">
        <view
          v-for="item in categoryOptions"
          :key="item.value"
          class="category-side-item"
          :class="{ 'category-side-item--active': selectedCategory === item.value }"
          @click="selectCategory(item.value)"
        >{{ item.label }}</view>
      </scroll-view>
      <scroll-view scroll-y enable-flex class="product-panel" @scrolltolower="loadMore">
        <view class="section-heading"><view><view class="section-heading__title">{{ currentCategory.label }}</view></view><view class="cart-entry" @click="goCart">购物车 →</view></view>
        <content-state v-if="loading && !loaded" type="loading" message="正在挑选非遗好物…" />
        <content-state v-else-if="error" type="error" :message="error" :retrying="loading" @retry="loadProducts" />
        <view v-else-if="visibleProducts.length" class="product-list">
          <view v-for="item in visibleProducts" :key="item.id" class="product-card-wrapper" @click="toDetail(item.id)">
            <image class="product-card__image" :src="productImage(item)" mode="aspectFill" @error="handleProductImageError(item.id)" />
            <view class="product-card__body">
              <view class="product-card__name">{{ item.name }}</view>
              <view class="product-card__note">{{ item.merchantName || item.category || '' }}</view>
              <view class="product-card__price">¥{{ formatPrice(item.price) }}</view>
            </view>
          </view>
        </view>
        <content-state v-else-if="!loadingMore" type="empty" message="暂无商品" />
        <view v-if="loadingMore && visibleProducts.length" class="list-loading">正在加载更多…</view>
      </scroll-view>
    </view>
    <bottom-nav current="shop" />
  </view>
</template>

<script>
import BottomNav from '@/components/bottom-nav.vue'
import ContentState from '@/components/content-state.vue'
import tabbarPageMixin from '@/mixins/tabbar-page.js'
import { getMallProductCategories, getMallProductPage } from '@/common/request/mall-product.js'
import { getMarketplaceProductRelations } from '@/common/request/marketplace-product-relation.js'
import { formatPrice, normalizeImage } from '@/common/utils.js'

export default {
  name: 'ShopListPage',
  components: { BottomNav, ContentState },
  mixins: [tabbarPageMixin],
  data() {
    return {
      homeAssets: { mascot: '/static/home/bronze-beast.png' },
      keyword: '',
      categories: [],
      products: [],
      heritageSystems: [],
      selectedHeritageCode: '',
      heritageItems: [],
      selectedCategory: 'all',
      pageNo: 1,
      pageSize: 20,
      total: 0,
      loading: false,
      loadingMore: false,
      loaded: false,
      error: '',
      requestSerial: 0,
      failedProductImages: {}
    }
  },
  computed: {
    categoryOptions() {
      const seenIds = new Set()
      const seenNames = new Set()
      const visible = this.categories.filter(item => {
        const id = String(item && item.id)
        const name = String(item && item.name || '').trim()
        const parentId = Number(item && item.parentId || 0)
        if (parentId !== 0 || !id || seenIds.has(id) || !name || name.startsWith('DEV_DEMO_') || seenNames.has(name)) return false
        seenIds.add(id)
        seenNames.add(name)
        return true
      }).sort((a, b) => Number(a.sort || 0) - Number(b.sort || 0)).slice(0, 6).map(item => ({ label: item.name, value: String(item.id) }))
      return [{ label: '全部', value: 'all' }, ...visible]
    },
    currentCategory() { return this.categoryOptions.find((item) => item.value === this.selectedCategory) || this.categoryOptions[0] },
    visibleProducts() { return this.products },
    hasNext() { return this.products.length < this.total }
  },
  onLoad() { this.initializeCatalog() },
  onShow() { if (!this.loaded) this.loadProducts() },
  onPullDownRefresh() { this.initializeCatalog().finally(() => uni.stopPullDownRefresh()) },
  methods: {
    formatPrice,
    async initializeCatalog() {
      await this.loadHeritageSystems()
      await this.loadCategories()
      await this.loadProducts()
    },
    async loadHeritageSystems() {
      try {
        const { getHeritageProductSystems, getHeritageSystemItems } = await import('@/common/request/heritage-ecosystem.js')
        const systems = await getHeritageProductSystems()
        this.heritageSystems = Array.isArray(systems) ? systems : []
        if (!this.selectedHeritageCode && this.heritageSystems.length) this.selectedHeritageCode = this.heritageSystems[0].code
        if (this.selectedHeritageCode) {
          const result = await getHeritageSystemItems({ code: this.selectedHeritageCode, pageNo: 1, pageSize: 6 })
          this.heritageItems = Array.isArray(result && result.list) ? result.list : []
        }
      } catch (error) { this.heritageSystems = []; this.heritageItems = [] }
    },
    async selectHeritageSystem(code) {
      this.selectedHeritageCode = code
      try {
        const { getHeritageSystemItems } = await import('@/common/request/heritage-ecosystem.js')
        const result = await getHeritageSystemItems({ code, pageNo: 1, pageSize: 6 })
        this.heritageItems = Array.isArray(result && result.list) ? result.list : []
      } catch (error) { this.heritageItems = [] }
    },
    openHeritageItem(item) {
      if (item.targetType === 'SERVICE') uni.navigateTo({ url: `/pages/service/detail?id=${item.targetId}` })
      else uni.navigateTo({ url: `/pages/shop/detail?id=${item.targetId}` })
    },
    async loadCategories() {
      try {
        const result = await getMallProductCategories()
        this.categories = Array.isArray(result) ? result : (result && Array.isArray(result.list) ? result.list : [])
        if (!this.categoryOptions.some((item) => item.value === this.selectedCategory)) this.selectedCategory = 'all'
      } catch (error) { this.categories = [] }
    },
    async loadProducts(append = false) {
      if (this.loading || this.loadingMore || (append && !this.hasNext)) return
      const requestSerial = append ? this.requestSerial : ++this.requestSerial
      if (append) this.loadingMore = true
      else { this.loading = true; this.error = ''; this.pageNo = 1 }
      try {
        const result = await getMallProductPage({ pageNo: this.pageNo, pageSize: this.pageSize, categoryId: this.selectedCategory === 'all' ? undefined : this.selectedCategory, keyword: this.keyword })
        const list = result && Array.isArray(result.list) ? result.list : []
        const products = await this.enrichMerchantRelations(list)
        if (requestSerial !== this.requestSerial) return
        this.products = append ? this.products.concat(products) : products
        this.total = Number(result && result.total) || this.products.length
        this.loaded = true
      } catch (error) {
        if (requestSerial === this.requestSerial && !append) { this.products = []; this.total = 0; this.error = error && error.message ? error.message : '商品加载失败，请稍后重试' }
      } finally { if (append) this.loadingMore = false; else this.loading = false }
    },
    loadMore() { if (this.loading || this.loadingMore || !this.hasNext) return; this.pageNo += 1; this.loadProducts(true) },
    async enrichMerchantRelations(products) {
      const relations = await getMarketplaceProductRelations(products.map((item) => item.id)).catch(() => [])
      const merchantBySpuId = new Map((Array.isArray(relations) ? relations : []).map((item) => [Number(item.spuId), item]))
      return products.map((item) => {
        const relation = merchantBySpuId.get(Number(item.id))
        return relation ? { ...item, merchantId: relation.merchantId, merchantName: relation.merchantName || '' } : item
      })
    },
    selectCategory(value) { if (this.selectedCategory === value) return; this.selectedCategory = value; this.loadProducts() },
    handleSearch() { this.loadProducts() },
    clearSearch() { this.keyword = ''; this.loadProducts() },
    productImage(item) { return this.failedProductImages[item.id] ? '/static/mall-demo/placeholder.png' : normalizeImage(item.picUrl || item.cover, '/static/mall-demo/placeholder.png') },
    handleProductImageError(id) { this.failedProductImages[id] = true },
    toDetail(id) { uni.navigateTo({ url: `/pages/shop/detail?id=${id}` }) },
    goCart() { uni.switchTab({ url: '/pages/shop/cart' }) }
  }
}
</script>

<style lang="scss" src="./list-recovered.scss" scoped></style>
