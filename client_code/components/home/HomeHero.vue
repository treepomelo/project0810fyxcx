<template>
  <view class="home-hero">
    <image class="home-hero__image" :src="assets.hero" mode="aspectFill" lazy-load></image>
    <image class="home-hero__mascot" :src="assets.mascot" mode="aspectFit"></image>
  </view>
</template>

<script>
export default { name: 'HomeHero', props: { assets: { type: Object, required: true } } }
</script>

<style lang="scss" scoped>
.home-hero { position:relative; height:336rpx; margin:20rpx 28rpx 0; overflow:hidden; border-radius:24rpx; background:#e9e3d7; }
.home-hero__image { width:100%; height:100%; display:block; }
.home-hero__mascot { position:absolute; right:18rpx; bottom:8rpx; width:150rpx; height:170rpx; }
</style>
