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
import { getHeritageProductSystems, getHeritageSystemItems } from '@/common/request/heritage-ecosystem.js'
import { formatPrice, normalizeImage } from '@/common/utils.js'

const CITY_STORAGE_KEY = 'home-city-code'
const SYSTEM_ICONS = {
  CULTURAL_CREATIVE: '/static/home/traditional-craft.svg',
  HERITAGE_FOOD: '/static/home/traditional-food.svg',
  HANDCRAFT_EXPERIENCE: '/static/home/traditional-art.svg',
  WELLNESS_COMPANION: '/static/home/traditional-medicine.svg',
  FOLK_PERFORMANCE: '/static/home/traditional-folk.svg'
}
const HOME_ASSETS = {
  hero: '/static/home/home-hero.jpg',
  mascot: '/static/home/bronze-beast.png',
  aiBackground: '/static/home/feature-ai-bg.png',
  sideBackground: '/static/home/feature-side-bg.png'
}
const RECOMMENDATION_TABS = [
  { key: 'projects', label: '精选推荐' },
  { key: 'products', label: '爆款文创' },
  { key: 'courses', label: '热门手作体验' },
  { key: 'wellness', label: '康养服务' },
  { key: 'activities', label: '近期线下活动' }
]

function toArray(value) { return Array.isArray(value) ? value : [] }
function createEmptyHomeData() {
  return { productSystems: [], recommendations: [], products: [], courses: [], wellness: [], activities: [] }
}

export default {
  name: 'HomePage',
  components: { BottomNav, HomeHeader, HomeHero, ProductSystemGrid, HomeFeatureGrid, HomeRecommendTabs },
  mixins: [tabbarPageMixin],
  data() {
    return {
      homeData: createEmptyHomeData(),
      homeAssets: HOME_ASSETS,
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
    homeServiceCategories() {
      return toArray(this.homeData.productSystems).slice().sort((a, b) => Number(a.sort || 0) - Number(b.sort || 0)).map((item) => ({
        key: item.code,
        code: item.code,
        label: item.name,
        icon: SYSTEM_ICONS[item.code] || '/static/home/traditional-craft.svg',
        action: 'shop'
      }))
    },
    cityIndex() {
      const index = this.cities.findIndex(item => item.code === this.selectedCityCode)
      return index >= 0 ? index : 0
    },
    selectedCityName() {
      const selected = this.cities[this.cityIndex]
      return selected && selected.name ? selected.name : '选择城市'
    },
    topSafeStyle() {
      return this.topInsetRpx > 0 ? { height: `${this.topInsetRpx}rpx`, paddingTop: '0' } : {}
    },
    recommendationItems() {
      const source = toArray(this.homeData[this.activeRecommendation === 'projects' ? 'recommendations' : this.activeRecommendation])
      return source.slice(0, 6).map((item, index) => ({
        key: `${item.targetType || 'ITEM'}-${item.targetId || index}`,
        title: item.title || '非遗内容',
        image: normalizeImage(item.coverUrl, ''),
        eyebrow: item.targetType === 'SERVICE' ? (item.location || '非遗服务') : (item.systemCode || '非遗好物'),
        description: item.summary || '',
        priceText: item.targetType === 'PRODUCT' && item.price !== undefined && item.price !== null ? `¥${formatPrice(item.price)}` : '',
        meta: item.location || item.startTime || '了解详情',
        type: item.targetType,
        targetType: item.targetType,
        targetId: item.targetId
      }))
    },
    activeRecommendationEmptyText() { return this.activeRecommendation === 'wellness' ? '暂无康养服务' : '暂无内容' }
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
        const systems = toArray(await getHeritageProductSystems().catch(() => []))
        const sortedSystems = systems.slice().sort((a, b) => Number(a.sort || 0) - Number(b.sort || 0))
        const results = await Promise.all(sortedSystems.map((system) => getHeritageSystemItems({ code: system.code, pageNo: 1, pageSize: 4 }).catch(() => ({ list: [], total: 0 }))))
        const allItems = results.reduce((items, result) => items.concat(toArray(result && result.list)), [])
        const products = allItems.filter(item => item.targetType === 'PRODUCT')
        this.homeData = {
          ...createEmptyHomeData(),
          productSystems: sortedSystems,
          recommendations: products.filter(item => item.systemCode === 'CULTURAL_CREATIVE' || item.systemCode === 'HERITAGE_FOOD').slice(0, 4),
          products: products.filter(item => item.systemCode === 'CULTURAL_CREATIVE').slice(0, 4),
          courses: allItems.filter(item => item.systemCode === 'HANDCRAFT_EXPERIENCE' && item.targetType === 'SERVICE').slice(0, 4),
          wellness: allItems.filter(item => item.systemCode === 'WELLNESS_COMPANION' && item.targetType === 'SERVICE').slice(0, 4),
          activities: allItems.filter(item => item.systemCode === 'FOLK_PERFORMANCE')
        }
        this.loaded = true
      } catch (error) {
        this.homeData = createEmptyHomeData()
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
    openServiceCategory(item) { if (item && item.code) return this.goShop(); this.handleUnavailable(item && item.label) },
    openRecommendation(item) { this.openHeritageItem(item) },
    openHeritageItem(item) {
      if (!item || !item.targetId) return
      if (item.targetType === 'SERVICE') return uni.navigateTo({ url: `/pages/service/detail?id=${item.targetId}` })
      if (item.targetType === 'PRODUCT') return uni.navigateTo({ url: `/pages/shop/detail?id=${item.targetId}` })
      uni.showToast({ title: '暂不支持该内容类型', icon: 'none' })
    },
    async handleCityChange(event) {
      const next = this.cities[Number(event.detail.value)]
      if (!next || next.code === this.selectedCityCode) return
      this.selectedCityCode = next.code
      uni.setStorageSync(CITY_STORAGE_KEY, next.code)
      await this.loadHome()
    },
    goSearch() { uni.navigateTo({ url: '/pages/search/index' }) },
    goShop() { uni.switchTab({ url: '/pages/shop/list' }) },
    goActivity() { uni.switchTab({ url: '/pages/activity/list' }) },
    goInheritor() { uni.navigateTo({ url: '/pages/inheritor/index' }) },
    handleUnavailable(name) { uni.showToast({ title: `${name || '该'}功能即将开放`, icon: 'none' }) }
  }
}
</script>

<style lang="scss" src="./index-recovered.scss" scoped></style>