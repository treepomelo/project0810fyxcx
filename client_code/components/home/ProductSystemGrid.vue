<template>
  <view class="product-system">
    <section-title :title="title" ornament />
    <view class="product-system__row">
      <view v-for="item in items" :key="item.key" class="product-system__item" @tap="$emit('select', item)">
        <view class="product-system__hex"><image class="product-system__icon" :src="item.icon" mode="aspectFit" lazy-load></image></view>
        <text class="product-system__name">{{ item.label }}</text>
      </view>
    </view>
  </view>
</template>

<script>
import SectionTitle from '@/components/common/SectionTitle.vue'
export default { name: 'ProductSystemGrid', components: { SectionTitle }, props: { items: { type: Array, default: () => [] }, title: { type: String, default: '五大产品体系' } }, emits: ['select'] }
</script>

<style lang="scss" scoped>
.product-system { margin:48rpx 28rpx 0; }
.product-system__row { display:flex; justify-content:space-between; gap:12rpx; margin-top:22rpx; }
.product-system__item { flex:1; min-width:0; text-align:center; }
.product-system__hex { width:82rpx; height:82rpx; margin:0 auto 12rpx; display:flex; align-items:center; justify-content:center; border:2rpx solid rgba(169,139,91,.68); clip-path:polygon(25% 6%,75% 6%,100% 50%,75% 94%,25% 94%,0 50%); background:rgba(251,248,242,.56); }
.product-system__icon { width:48rpx; height:48rpx; }
.product-system__name { display:block; color:#857a70; font-size:20rpx; line-height:1.4; }
</style>
