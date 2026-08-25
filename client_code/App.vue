<script>
export default {
  globalData: {
    nativeTabBarHidden: false
  },
  onLaunch() {
    // The app uses the lightweight BottomNav component. Hide the native
    // tab bar once at startup instead of invoking the bridge on every tab
    // page's onShow lifecycle.
    this.globalData.nativeTabBarHidden = true
    if (typeof uni !== 'undefined' && uni.hideTabBar) {
      uni.hideTabBar({ animation: false })
    }
  }
}
</script>
<style lang="scss">
page { background: #f5f0e7; color: #2c2723; font-family: "PingFang SC", "Microsoft YaHei", sans-serif; }
view, text, button, input, textarea, image, scroll-view, swiper, swiper-item { box-sizing: border-box; }
button::after { border: none; }
.app-page { min-height: 100vh; background: #f5f0e7; color: #2c2723; }
.with-bottom-nav { padding-bottom: calc(152rpx + env(safe-area-inset-bottom)); }
.safe-top { height: calc(28rpx + env(safe-area-inset-top)); }
.hero-card, .section-card { border: 1rpx solid #e8e0d5; border-radius: 20rpx; background: #fbf8f2; box-shadow: 0 6rpx 20rpx rgba(44,39,35,.04); }
.section-card { margin: 24rpx; padding: 28rpx; }
.section-head { display: flex; align-items: center; justify-content: space-between; margin-bottom: 24rpx; }
.section-title { color: #2c2723; font-size: 32rpx; font-weight: 500; }
.section-note { color: #857a70; font-size: 22rpx; }
.soft-pill { display: inline-flex; align-items: center; padding: 10rpx 18rpx; border-radius: 8rpx; background: rgba(100,121,110,.12); color: #64796e; font-size: 22rpx; }
.primary-button { display: flex; align-items: center; justify-content: center; height: 82rpx; border-radius: 20rpx; background: #64796e; color: #fff; font-size: 28rpx; font-weight: 500; }
.secondary-button { display: flex; align-items: center; justify-content: center; height: 82rpx; border-radius: 20rpx; background: #fbf8f2; color: #64796e; font-size: 28rpx; border: 1rpx solid #64796e; }
.empty-block { padding: 48rpx 20rpx; text-align: center; color: #857a70; font-size: 26rpx; }
.field-label { display: block; margin-bottom: 14rpx; color: #2c2723; font-size: 26rpx; font-weight: 500; }
.field-input, .field-textarea, .field-picker { width: 100%; padding: 0 26rpx; border: 1rpx solid #e8e0d5; border-radius: 16rpx; background: #fbf8f2; color: #2c2723; font-size: 28rpx; }
.field-input, .field-picker { height: 82rpx; line-height: 82rpx; }
.field-textarea { min-height: 220rpx; padding-top: 22rpx; padding-bottom: 22rpx; }
</style>
