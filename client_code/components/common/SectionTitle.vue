<template>
  <view class="section-title" :class="{ 'section-title--ornament': ornament }"><view v-if="ornament" class="section-title__line"></view><view class="section-title__copy"><text class="section-title__title">{{ title }}</text><text v-if="subtitle" class="section-title__subtitle">{{ subtitle }}</text></view><view v-if="ornament" class="section-title__line"></view></view>
</template>

<script>
export default { name: 'SectionTitle', props: { title: { type: String, default: '' }, subtitle: { type: String, default: '' }, ornament: Boolean } }
</script>

<style lang="scss" scoped>
.section-title { display:flex; align-items:flex-end; justify-content:space-between; gap:18rpx; margin-bottom:20rpx; }
.section-title--ornament { align-items:center; justify-content:center; }
.section-title__copy { display:flex; flex-direction:column; align-items:center; gap:6rpx; }
.section-title__title { color:#2c2723; font-size:32rpx; font-weight:500; letter-spacing:2rpx; }
.section-title__subtitle { color:#857a70; font-size:21rpx; }
.section-title__line { flex:1; height:1rpx; max-width:80rpx; background:#a98b5b; opacity:.65; }
</style>
