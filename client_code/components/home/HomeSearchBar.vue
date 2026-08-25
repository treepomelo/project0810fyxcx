<template>
  <view class="home-search-bar" @tap="$emit('search')">
    <text class="home-search-bar__placeholder">{{ placeholder }}</text>
    <text class="home-search-bar__more">···</text>
    <view class="home-search-bar__icon"></view>
  </view>
</template>

<script>
export default {
  name: 'HomeSearchBar',
  props: { placeholder: { type: String, default: '搜索非遗项目、传承人、商品或课程' } },
  emits: ['search']
}
</script>

<style lang="scss" scoped>
.home-search-bar { display:flex; align-items:center; min-height:76rpx; margin:0 28rpx; padding:0 24rpx; border:1rpx solid rgba(169,139,91,.16); border-radius:38rpx; background:rgba(251,248,242,.86); color:#857a70; }
.home-search-bar__placeholder { flex:1; overflow:hidden; white-space:nowrap; text-overflow:ellipsis; font-size:24rpx; }
.home-search-bar__more { margin-right:20rpx; color:#a98b5b; font-size:30rpx; letter-spacing:3rpx; line-height:1; }
.home-search-bar__icon { width:24rpx; height:24rpx; border:3rpx solid #728077; border-radius:50%; position:relative; }
.home-search-bar__icon::after { content:''; position:absolute; width:10rpx; height:3rpx; right:-8rpx; bottom:-4rpx; transform:rotate(45deg); border-radius:2rpx; background:#728077; }
</style>
