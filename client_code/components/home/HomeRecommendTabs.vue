<template>
  <view class="home-recommend">
    <view class="home-recommend__tabs"><view v-for="tab in tabs" :key="tab.key" class="home-recommend__tab" :class="{ 'is-active': active === tab.key }" @tap="$emit('change', tab.key)"><text>{{ tab.label }}</text></view></view>
    <view v-if="items.length" class="home-recommend__grid"><view v-for="item in items" :key="item.key" class="home-recommend__card" @tap="$emit('select', item)"><view class="home-recommend__cover"><image v-if="item.image" class="home-recommend__image" :src="item.image" mode="aspectFill" lazy-load></image><view v-else class="home-recommend__placeholder"></view><text>{{ item.eyebrow }}</text></view><view class="home-recommend__body"><text class="home-recommend__name">{{ item.title }}</text><text class="home-recommend__desc">{{ item.description }}</text><text class="home-recommend__meta">{{ item.priceText || item.meta }}</text></view></view></view>
    <view v-else class="home-recommend__empty"><content-state type="empty" :message="emptyText" /></view>
  </view>
</template>

<script>
import ContentState from '@/components/content-state.vue'
export default { name: 'HomeRecommendTabs', components: { ContentState }, props: { tabs: { type: Array, default: () => [] }, active: { type: String, default: '' }, items: { type: Array, default: () => [] }, emptyText: { type: String, default: '暂无可展示内容' } }, emits: ['change', 'select'] }
</script>

<style lang="scss" scoped>
.home-recommend { margin:48rpx 28rpx 0; }
.home-recommend__tabs { display:flex; gap:28rpx; border-bottom:1rpx solid #e8e0d5; }
.home-recommend__tab { padding-bottom:16rpx; color:#857a70; font-size:24rpx; }
.home-recommend__tab.is-active { border-bottom:4rpx solid #a98b5b; color:#2c2723; font-weight:600; }
.home-recommend__grid { display:grid; grid-template-columns:repeat(2,minmax(0,1fr)); gap:16rpx; padding-top:24rpx; }
.home-recommend__card { overflow:hidden; border:1rpx solid #e8e0d5; border-radius:16rpx; background:#fbf8f2; }
.home-recommend__cover { position:relative; height:190rpx; background:#ede8dc; }
.home-recommend__image { width:100%; height:100%; display:block; }
.home-recommend__cover>text { position:absolute; left:12rpx; bottom:10rpx; padding:4rpx 8rpx; border-radius:8rpx; background:rgba(44,39,35,.58); color:#fff; font-size:18rpx; }
.home-recommend__placeholder { width:100%; height:100%; background:linear-gradient(135deg,#f3eee4,#ded6c8); }
.home-recommend__body { display:flex; flex-direction:column; gap:8rpx; padding:18rpx; }
.home-recommend__name { color:#2c2723; font-size:26rpx; font-weight:500; }
.home-recommend__desc,.home-recommend__meta { color:#857a70; font-size:21rpx; line-height:1.4; }
.home-recommend__empty { min-height:180rpx; border:1rpx dashed #d9cfbf; border-radius:16rpx; }
</style>
