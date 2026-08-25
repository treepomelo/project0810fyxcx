<template>
  <view class="heritage-section-header">
    <view><text class="heritage-section-header__title">{{ title }}</text><text v-if="subtitle" class="heritage-section-header__subtitle">{{ subtitle }}</text></view>
    <text v-if="more" class="heritage-section-header__more" @click="$emit('more')">{{ more }}</text>
  </view>
</template>
<script>
export default { name: 'HeritageSectionHeader', props: { title: { type: String, default: '' }, subtitle: { type: String, default: '' }, more: { type: String, default: '' } } }
</script>
<style lang="scss" scoped>
.heritage-section-header { display: flex; align-items: flex-end; justify-content: space-between; margin-bottom: 24rpx; }
.heritage-section-header__title { display: block; color: #285f5c; font-family: "STKaiti", "KaiTi", serif; font-size: 32rpx; font-weight: 600; }
.heritage-section-header__subtitle { display: block; margin-top: 6rpx; color: #857a70; font-size: 20rpx; }
.heritage-section-header__more { color: #64796e; font-size: 20rpx; }
</style>
