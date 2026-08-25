<template>
  <view class="app-page home-page with-bottom-nav">
    <home-header :safe-style="topSafeStyle" @search="goSearch">
      <template #brand>無念万艺</template>
    </home-header>
    <home-hero :assets="homeAssets" />
    <view class="home-content">
      <product-system-grid :items="homeServiceCategories" @select="openServiceCategory" />
      <home-feature-grid
        :assets="homeAssets"
        :city-name="selectedCityName"
        :city-error="cityError"
        :cities="cities"
        :city-index="cityIndex"
        :loading="loading"
        @unavailable="handleUnavailable"
        @activity="goActivity"
        @inheritor="goInheritor"
        @city-change="handleCityChange"
      />
      <home-recommend-tabs
        :tabs="recommendationTabs"
        :active="activeRecommendation"
        :items="recommendationItems"
        :empty-text="activeRecommendationEmptyText"
        @change="setRecommendation"
        @select="openRecommendation"
      />
    </view>
    <bottom-nav current="home" />
  </view>
</template>

<script>
import BottomNav from '@/components/bottom-nav.vue'
import HomeHeader from '@/components/home/HomeHeader.vue'
import HomeHero from '@/components/home/HomeHero.vue'
import ProductSystemGrid from '@/components/home/ProductSystemGrid.vue'
import HomeFeatureGrid from '@/components/home/HomeFeatureGrid.vue'
import HomeRecommendTabs from '@/components/home/HomeRecommendTabs.vue'
import tabbarPageMixin from '@/mixins/tabbar-page.js'
import { getMallProductCategories, getMallProductPage } from '@/common/request/mall-product.js'
import { formatPrice, normalizeImage } from '@/common/utils.js'

const CITY_STORAGE_KEY = 'home-city-code'
const HOME_SERVICE_CATEGORIES = [
  { key: 'craft', label: '非遗文创好物', icon: '/static/home/traditional-craft.svg', action: 'shop' },
  { key: 'food', label: '非遗美食风物', icon: '/static/home/traditional-food.svg', action: 'shop' },
  { key: 'experience', label: '非遗手作体验', icon: '/static/home/traditional-art.svg', action: 'pending' },
  { key: 'wellness', label: '非遗康养陪伴服务', icon: '/static/home/traditional-medicine.svg', action: 'pending' },
  { key: 'folk', label: '非遗民俗演艺', icon: '/static/home/traditional-folk.svg', action: 'pending' }
]
const HOME_ASSETS = {
  hero: '/static/home/home-hero.jpg',
  mascot: '/static/home/bronze-beast.png',
  aiBackground: '/static/home/feature-ai-bg.png',
  sideBackground: '/static/home/feature-side-bg.png'
}
const RECOMMENDATION_TABS = [
  { key: 'projects', label: '精选推荐' },
  { key: 'products', label: '爆款文创' },
  { key: 'courses', label: '本周手作课' },
  { key: 'activities', label: '近期线下活动' }
]

function toArray(value) { return Array.isArray(value) ? value : [] }
function createEmptyHomeData() { return { city: null, banners: [], categories: [], heritageProjects: [], inheritors: [], courses: [], products: [], activities: [], news: [] } }

export default {
  name: 'HomePage',
  components: { BottomNav, HomeHeader, HomeHero, ProductSystemGrid, HomeFeatureGrid, HomeRecommendTabs },
  mixins: [tabbarPageMixin],
  data() {
    return {
      homeData: createEmptyHomeData(),
      homeAssets: HOME_ASSETS,
      homeServiceCategories: HOME_SERVICE_CATEGORIES,
      recommendationTabs: RECOMMENDATION_TABS,
      activeRecommendation: 'projects',
      cities: [],
      selectedCityCode: '',
      loading: false,
      loaded: false,
      loadError: '',
      cityError: '',
      topInsetRpx: 0
    }
  },
  computed: {
    cityIndex() {
      const index = this.cities.findIndex(item => item.code === this.selectedCityCode)
      return index >= 0 ? index : 0
    },
    selectedCityName() {
      if (this.homeData.city && this.homeData.city.name) return this.homeData.city.name
      const selected = this.cities[this.cityIndex]
      return selected && selected.name ? selected.name : '选择城市'
    },
    topSafeStyle() {
      return this.topInsetRpx > 0 ? { height: `${this.topInsetRpx}rpx`, paddingTop: '0' } : {}
    },
    recommendationItems() {
      const sourceKey = this.activeRecommendation === 'projects' ? 'heritageProjects' : this.activeRecommendation
      const source = this.homeData[sourceKey] || []
      return toArray(source).slice(0, 6).map((item, index) => ({
        key: item.id || index,
        title: item.name || item.title || '非遗内容',
        image: this.activeRecommendation === 'products' ? normalizeImage(item.cover || item.picUrl, '') : normalizeImage(item.cover || item.coverUrl || item.picUrl || item.image, ''),
        eyebrow: item.level || item.category || item.location || '非遗推荐',
        description: item.summary || item.description || item.subtitle || '',
        priceText: this.activeRecommendation === 'products' && item.price !== undefined ? `¥${formatPrice(item.price)}` : '',
        meta: item.location || item.cityName || '了解详情',
        type: this.activeRecommendation,
        id: item.id
      }))
    },
    activeRecommendationEmptyText() { return '当前暂无可展示内容' }
  },
  onLoad() {
    this.calculateTopInset()
    const stored = uni.getStorageSync(CITY_STORAGE_KEY)
    this.selectedCityCode = typeof stored === 'string' ? stored : ''
    this.loadHome()
  },
  onPullDownRefresh() { this.loadHome().finally(() => uni.stopPullDownRefresh()) },
  methods: {
    formatPrice,
    normalizeImage,
    async loadHome() {
      if (this.loading) return
      this.loading = true
      this.loadError = ''
      this.cityError = ''
      try {
        const [categoryResult, productResult] = await Promise.all([
          getMallProductCategories().catch(() => []),
          getMallProductPage({ pageNo: 1, pageSize: 6 }).catch(() => ({ list: [], total: 0 }))
        ])
        const categories = toArray(categoryResult)
        const categoryMap = categories.reduce((map, item) => { map[String(item.id)] = item.name; return map }, {})
        const products = toArray(productResult && productResult.list).map(item => ({
          ...item,
          cover: item.picUrl || item.cover || (Array.isArray(item.sliderPicUrls) ? item.sliderPicUrls[0] : ''),
          category: categoryMap[String(item.categoryId)] || '',
          subtitle: item.introduction || ''
        }))
        this.homeData = { ...createEmptyHomeData(), products }
        this.loaded = true
      } catch (error) {
        this.homeData = { ...createEmptyHomeData() }
        this.loaded = true
      } finally { this.loading = false }
    },
    calculateTopInset() {
      if (!uni.getSystemInfoSync) return
      const systemInfo = uni.getSystemInfoSync() || {}
      const windowWidth = Number(systemInfo.windowWidth || systemInfo.screenWidth || 0)
      if (windowWidth) this.topInsetRpx = Math.ceil(Number(systemInfo.statusBarHeight || 0) * (750 / windowWidth) + 4)
    },
    setRecommendation(key) { this.activeRecommendation = key },
    openServiceCategory(item) { if (item && item.action === 'shop') return this.goShop(); this.handleUnavailable(item && item.label) },
    openRecommendation(item) { if (item && item.type === 'products' && item.id) return this.goProductDetail(item.id); this.handleUnavailable(item && item.type === 'courses' ? '手作课程' : '非遗内容') },
    async handleCityChange(event) {
      const next = this.cities[Number(event.detail.value)]
      if (!next || next.code === this.selectedCityCode) return
      this.selectedCityCode = next.code
      uni.setStorageSync(CITY_STORAGE_KEY, next.code)
      await this.loadHome()
    },
    goSearch() { uni.navigateTo({ url: '/pages/search/index' }) },
    goProductDetail(id) { uni.navigateTo({ url: `/pages/shop/detail?id=${id}` }) },
    goShop() { uni.switchTab({ url: '/pages/shop/list' }) },
    goActivity() { uni.switchTab({ url: '/pages/activity/list' }) },
    goInheritor() { uni.navigateTo({ url: '/pages/inheritor/index' }) },
    handleUnavailable(name) { uni.showToast({ title: `${name || '该'}功能即将开放`, icon: 'none' }) }
  }
}
</script>

<style lang="scss" src="./index-recovered.scss" scoped></style>
