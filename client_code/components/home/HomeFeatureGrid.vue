<template>
  <view class="home-feature-grid">
    <view class="home-feature-grid__large feature-card feature-card--ai" @tap="$emit('unavailable', 'AI虚拟体验')">
      <image class="feature-card__background" :src="assets.aiBackground" mode="aspectFill"></image>
      <view class="feature-card__copy"><text class="feature-card__title">AI数字体验专区</text><text class="feature-card__desc">AI数字人讲解、非遗互动与语音问答</text><text class="feature-card__link">即将开放 →</text></view>
      <image class="feature-card__mascot" :src="assets.mascot" mode="aspectFit"></image>
    </view>
    <view class="home-feature-grid__stack">
      <view class="feature-card feature-card--city">
        <image class="feature-card__background" :src="assets.sideBackground" mode="aspectFill"></image>
        <view class="feature-card__copy" @tap="$emit('activity')"><text class="feature-card__title">同城 · {{ cityName }}非遗</text><text class="feature-card__desc">发现身边的手艺与活动</text><text v-if="cityError" class="feature-card__error">{{ cityError }}</text></view>
        <picker class="feature-card__picker" :range="cities" range-key="name" :value="cityIndex" :disabled="loading || !cities.length" @change="$emit('city-change', $event)"><text>切换 →</text></picker>
      </view>
      <view class="feature-card feature-card--inheritor" @tap="$emit('inheritor')">
        <image class="feature-card__background" :src="assets.sideBackground" mode="aspectFill"></image>
        <view class="feature-card__copy"><text class="feature-card__title">热门传承人</text><text class="feature-card__desc">认识守艺人的故事</text><text class="feature-card__link">查看传承人 →</text></view>
        <view class="feature-card__emblem">承</view>
      </view>
    </view>
  </view>
</template>

<script>
export default { name: 'HomeFeatureGrid', props: { assets: { type: Object, required: true }, cityName: { type: String, default: '选择城市' }, cityError: { type: String, default: '' }, cities: { type: Array, default: () => [] }, cityIndex: { type: Number, default: 0 }, loading: Boolean }, emits: ['unavailable', 'activity', 'inheritor', 'city-change'] }
</script>

<style lang="scss" scoped>
.home-feature-grid { display:grid; grid-template-columns:minmax(0,1fr) minmax(0,1fr); gap:16rpx; margin:48rpx 28rpx 0; }
.home-feature-grid__large { min-height:326rpx; }
.home-feature-grid__stack { display:flex; flex-direction:column; gap:16rpx; }
.feature-card { position:relative; min-height:155rpx; overflow:hidden; border:1rpx solid rgba(169,139,91,.18); border-radius:20rpx; background:#fbf8f2; }
.feature-card__background { position:absolute; inset:0; width:100%; height:100%; opacity:.25; }
.feature-card__copy { position:relative; z-index:1; display:flex; flex-direction:column; gap:8rpx; padding:24rpx; }
.feature-card__title { color:#2c2723; font-size:27rpx; font-weight:600; }
.feature-card__desc { max-width:80%; color:#857a70; font-size:21rpx; line-height:1.45; }
.feature-card__link { color:#a98b5b; font-size:20rpx; }
.feature-card__mascot { position:absolute; right:8rpx; bottom:8rpx; z-index:1; width:130rpx; height:150rpx; }
.feature-card__picker { position:absolute; right:16rpx; bottom:16rpx; z-index:2; color:#a98b5b; font-size:20rpx; }
.feature-card__error { color:#a5523d; font-size:19rpx; }
.feature-card__emblem { position:absolute; right:16rpx; bottom:16rpx; z-index:2; width:48rpx; height:48rpx; display:flex; align-items:center; justify-content:center; border-radius:50%; background:rgba(169,139,91,.3); color:#7e653e; font-size:22rpx; }
</style>
