function ensureNativeTabBarHidden() {
  if (typeof uni === 'undefined' || !uni.hideTabBar) return
  const app = typeof getApp === 'function' ? getApp() : null
  if (app && app.globalData && app.globalData.nativeTabBarHidden) return
  if (app && app.globalData) app.globalData.nativeTabBarHidden = true
  uni.hideTabBar({ animation: false })
}

export default {
  // App.onLaunch handles the normal path. Keep this synchronous fallback for
  // hot reloads and direct page entry without introducing tab-switch waits.
  onReady() { ensureNativeTabBarHidden() },
  onShow() { ensureNativeTabBarHidden() }
}
