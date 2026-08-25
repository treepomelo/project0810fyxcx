<template>
  <view class="home-header">
    <view class="home-header__safe-top" :style="safeStyle"></view>
    <view class="home-header__brand"><slot name="brand">無念万艺</slot></view>
    <home-search-bar :placeholder="placeholder" @search="$emit('search')" />
  </view>
</template>

<script>
import HomeSearchBar from './HomeSearchBar.vue'
export default {
  name: 'HomeHeader',
  components: { HomeSearchBar },
  props: { safeStyle: { type: Object, default: () => ({}) }, placeholder: { type: String, default: '' } },
  emits: ['search']
}
</script>

<style lang="scss" scoped>
.home-header { position:relative; z-index:2; }
.home-header__safe-top { min-height:28rpx; padding-top:env(safe-area-inset-top); }
.home-header__brand { margin:12rpx 28rpx 22rpx; text-align:center; color:#2c2723; font-size:40rpx; font-weight:500; letter-spacing:8rpx; }
</style>
