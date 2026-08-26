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
    <view class="category-body">
      <scroll-view scroll-y enable-flex class="category-sidebar">
        <view
          v-for="system in sortedHeritageSystems"
          :key="system.code"
          class="category-side-item"
          :class="{ 'category-side-item--active': selectedHeritageCode === system.code }"
          @click="selectHeritageSystem(system.code)"
        >{{ system.name }}</view>
      </scroll-view>
      <scroll-view scroll-y enable-flex class="product-panel" @scrolltolower="loadMore">
        <view class="section-heading"><view><view class="section-heading__title">{{ currentSystem.name || '非遗内容' }}</view></view><view v-if="showCart" class="cart-entry" @click="goCart">购物车 →</view></view>
        <content-state v-if="loading && !loaded" type="loading" message="正在挑选非遗内容…" />
        <content-state v-else-if="error" type="error" :message="error" :retrying="loading" @retry="loadHeritageItems" />
        <view v-else-if="heritageItems.length" class="product-list">
          <view v-for="item in heritageItems" :key="item.targetType + '-' + item.targetId" class="product-card-wrapper" @click="openHeritageItem(item)">
            <image class="product-card__image" :src="productImage(item)" mode="aspectFill" />
            <view class="product-card__body">
              <view class="product-card__name">{{ item.title }}</view>
              <view class="product-card__note">{{ item.summary || item.location || item.startTime || '' }}</view>
              <view v-if="item.targetType === 'PRODUCT' && item.price !== undefined && item.price !== null" class="product-card__price">¥{{ formatPrice(item.price) }}</view>
            </view>
          </view>
        </view>
        <content-state v-else-if="!loadingMore" type="empty" message="暂无内容" />
        <view v-if="loadingMore && heritageItems.length" class="list-loading">正在加载更多…</view>
      </scroll-view>
    </view>
    <bottom-nav current="shop" />
  </view>
</template>

<script>
import BottomNav from '@/components/bottom-nav.vue'
import ContentState from '@/components/content-state.vue'
import tabbarPageMixin from '@/mixins/tabbar-page.js'
import { getHeritageProductSystems, getHeritageSystemItems } from '@/common/request/heritage-ecosystem.js'
import { formatPrice, normalizeImage } from '@/common/utils.js'

export default {
  name: 'ShopListPage',
  components: { BottomNav, ContentState },
  mixins: [tabbarPageMixin],
  data() {
    return {
      homeAssets: { mascot: '/static/home/bronze-beast.png' },
      keyword: '',
      heritageSystems: [],
      selectedHeritageCode: '',
      heritageItems: [],
      pageNo: 1,
      pageSize: 10,
      total: 0,
      loading: false,
      loadingMore: false,
      loaded: false,
      error: '',
      requestSerial: 0
    }
  },
  computed: {
    sortedHeritageSystems() { return this.heritageSystems.slice().sort((a, b) => Number(a.sort || 0) - Number(b.sort || 0)) },
    currentSystem() { return this.sortedHeritageSystems.find((item) => item.code === this.selectedHeritageCode) || {} },
    showCart() { return ['CULTURAL_CREATIVE', 'HERITAGE_FOOD'].includes(this.selectedHeritageCode) },
    hasNext() { return this.heritageItems.length < this.total }
  },
  onLoad(options = {}) {
    if (options.systemCode) this.selectedHeritageCode = options.systemCode
    this.initializeCatalog()
  },
  onShow() { if (!this.loaded) this.initializeCatalog() },
  onPullDownRefresh() { this.initializeCatalog().finally(() => uni.stopPullDownRefresh()) },
  methods: {
    formatPrice,
    async initializeCatalog() {
      await this.loadHeritageSystems()
    },
    async loadHeritageSystems() {
      try {
        const systems = await getHeritageProductSystems()
        this.heritageSystems = (Array.isArray(systems) ? systems : []).slice().sort((a, b) => Number(a.sort || 0) - Number(b.sort || 0))
        if (!this.heritageSystems.some((item) => item.code === this.selectedHeritageCode)) this.selectedHeritageCode = this.heritageSystems[0] && this.heritageSystems[0].code || ''
        await this.loadHeritageItems()
      } catch (error) {
        this.heritageSystems = []
        this.heritageItems = []
        this.loaded = true
        this.error = '非遗内容加载失败，请稍后重试'
      }
    },
    selectHeritageSystem(code) {
      if (!code || code === this.selectedHeritageCode) return
      this.selectedHeritageCode = code
      this.pageNo = 1
      this.loadHeritageItems()
    },
    openHeritageItem(item) {
      if (!item || !item.targetId) return
      if (item.targetType === 'SERVICE') return uni.navigateTo({ url: `/pages/service/detail?id=${item.targetId}` })
      if (item.targetType === 'PRODUCT') return uni.navigateTo({ url: `/pages/shop/detail?id=${item.targetId}` })
      uni.showToast({ title: '暂不支持该内容类型', icon: 'none' })
    },
    async loadHeritageItems(append = false) {
      if (!this.selectedHeritageCode || (append && (this.loading || this.loadingMore || !this.hasNext))) return
      const requestSerial = append ? this.requestSerial : ++this.requestSerial
      if (append) this.loadingMore = true
      else { this.loading = true; this.loadingMore = false; this.error = ''; this.pageNo = 1; this.heritageItems = [] }
      try {
        const result = await getHeritageSystemItems({ code: this.selectedHeritageCode, pageNo: this.pageNo, pageSize: this.pageSize, keyword: this.keyword || undefined })
        if (requestSerial !== this.requestSerial) return
        const list = result && Array.isArray(result.list) ? result.list : []
        this.heritageItems = append ? this.heritageItems.concat(list) : list
        this.total = Number(result && result.total) || this.heritageItems.length
        this.loaded = true
      } catch (error) {
        if (requestSerial === this.requestSerial && !append) {
          this.heritageItems = []
          this.total = 0
          this.error = error && error.message ? error.message : '非遗内容加载失败，请稍后重试'
        }
      } finally {
        if (requestSerial === this.requestSerial) {
          if (append) this.loadingMore = false
          else this.loading = false
        }
      }
    },
    loadMore() { if (this.loading || this.loadingMore || !this.hasNext) return; this.pageNo += 1; this.loadHeritageItems(true) },
    handleSearch() { this.loadHeritageItems() },
    clearSearch() { this.keyword = ''; this.loadHeritageItems() },
    productImage(item) { return normalizeImage(item && item.coverUrl, '/static/mall-demo/placeholder.png') },
    goCart() { uni.switchTab({ url: '/pages/shop/cart' }) }
  }
}
</script>

<style lang="scss" src="./list-recovered.scss" scoped></style>