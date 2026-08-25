<template>
  <view class="product-card" @tap="$emit('select')">
    <view class="product-card__image-wrap"><image class="product-card__image" :src="image" mode="aspectFill" lazy-load @error="$emit('image-error')"></image><text v-if="badge" class="product-card__badge">{{ badge }}</text></view>
    <view class="product-card__body"><text class="product-card__name">{{ name }}</text><text v-if="description" class="product-card__description">{{ description }}</text><text v-if="merchantName" class="product-card__merchant">{{ merchantName }}</text><text v-if="price !== '' && price !== null && price !== undefined" class="product-card__price">{{ price }}</text></view>
  </view>
</template>

<script>
export default { name: 'ProductCard', props: { image: { type: String, default: '/static/mall-demo/placeholder.png' }, name: { type: String, default: '' }, description: { type: String, default: '' }, merchantName: { type: String, default: '' }, price: { type: [String, Number], default: '' }, badge: { type: String, default: '' } }, emits: ['select', 'image-error'] }
</script>

<style lang="scss" scoped>
.product-card { overflow:hidden; border-radius:16rpx; background:#fbf8f2; }
.product-card__image-wrap { position:relative; aspect-ratio:1; background:#eee8dd; }
.product-card__image { width:100%; height:100%; display:block; }
.product-card__badge { position:absolute; left:12rpx; top:12rpx; padding:5rpx 9rpx; border-radius:8rpx; background:rgba(44,39,35,.6); color:#fff; font-size:18rpx; }
.product-card__body { display:flex; flex-direction:column; gap:7rpx; padding:16rpx 4rpx 4rpx; }
.product-card__name { overflow:hidden; color:#2c2723; font-size:27rpx; font-weight:500; white-space:nowrap; text-overflow:ellipsis; }
.product-card__description { overflow:hidden; color:#857a70; font-size:21rpx; white-space:nowrap; text-overflow:ellipsis; }
.product-card__merchant { overflow:hidden; color:#857a70; font-size:20rpx; white-space:nowrap; text-overflow:ellipsis; }
.product-card__price { color:#a5523d; font-size:26rpx; font-weight:500; }
</style>
