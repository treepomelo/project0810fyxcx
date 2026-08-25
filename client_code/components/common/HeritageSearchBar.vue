<template>
  <view class="heritage-search-bar">
    <text class="heritage-search-bar__icon" @tap="$emit('submit')">⌕</text>
    <input class="heritage-search-bar__input" :value="modelValue" :placeholder="placeholder" confirm-type="search" maxlength="100" @input="$emit('update:modelValue', $event.detail.value); $emit('input', $event)" @confirm="$emit('submit')" />
    <text v-if="modelValue" class="heritage-search-bar__clear" @tap="$emit('clear')">×</text>
  </view>
</template>
<script>
export default { name: 'HeritageSearchBar', props: { modelValue: { type: String, default: '' }, placeholder: { type: String, default: '搜索非遗项目、传承人、商品或课程' } }, emits: ['update:modelValue', 'input', 'submit', 'clear'] }
</script>
<style lang="scss" scoped>
.heritage-search-bar { display:flex; align-items:center; min-height:78rpx; padding:0 22rpx; border:1rpx solid #e8e0d5; border-radius:18rpx; background:#fbf8f2; }
.heritage-search-bar__icon { margin-right:14rpx; color:#728077; font-size:34rpx; line-height:1; }
.heritage-search-bar__input { flex:1; min-width:0; color:#2c2723; font-size:26rpx; }
.heritage-search-bar__clear { padding:8rpx; color:#857a70; font-size:30rpx; line-height:1; }
</style>
