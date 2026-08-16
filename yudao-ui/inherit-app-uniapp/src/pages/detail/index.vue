<template>
  <view v-if="detail" class="page">
    <!-- 头部 -->
    <view class="header">
      <image class="cover" :src="detail.cover || defaultAvatar" mode="aspectFill" />
      <view class="header-info">
        <view class="name">{{ detail.name }}</view>
        <view class="level" v-if="detail.level">{{ detail.level }}</view>
        <view class="region">{{ detail.provinceName || '' }} {{ detail.cityName || '' }} {{ detail.districtName || '' }}</view>
        <view class="specialty" v-if="detail.specialty">擅长：{{ detail.specialty }}</view>
      </view>
      <view class="follow-btn" :class="{ followed: detail.isFollowed }" @click="toggleFollow">
        {{ detail.isFollowed ? '已关注' : '关注' }}（{{ detail.followCount || 0 }}）
      </view>
    </view>

    <!-- 简介 -->
    <view class="section">
      <view class="section-title">简介</view>
      <view class="section-body">{{ detail.introduction || '暂无简介' }}</view>
      <view class="section-body" v-if="detail.profile">{{ detail.profile }}</view>
    </view>

    <!-- 从业经历 -->
    <view class="section" v-if="detail.experience">
      <view class="section-title">从业经历</view>
      <view class="section-body">{{ detail.experience }}</view>
    </view>

    <!-- 代表作品 -->
    <view class="section">
      <view class="section-title">代表作品（{{ works.length }}）</view>
      <view class="works-grid" v-if="works.length > 0">
        <view class="work-item" v-for="w in works" :key="w.id">
          <image class="work-img" :src="w.cover || defaultAvatar" mode="aspectFill" />
          <view class="work-name">{{ w.name }}</view>
          <view class="work-meta" v-if="w.year">创作于 {{ w.year }}</view>
          <view class="work-meta" v-if="w.material">{{ w.material }}</view>
        </view>
      </view>
      <view v-else class="empty">暂无作品</view>
    </view>

    <!-- 荣誉资质 -->
    <view class="section">
      <view class="section-title">荣誉资质（{{ qualifications.length }}）</view>
      <view class="qual-list" v-if="qualifications.length > 0">
        <view class="qual-item" v-for="q in qualifications" :key="q.id">
          <text class="qual-name">{{ q.name }}</text>
          <text class="qual-type" v-if="q.type">{{ q.type }}</text>
          <view class="qual-meta" v-if="q.issuer">{{ q.issuer }}{{ q.issueDate ? ' · ' + q.issueDate : '' }}</view>
        </view>
      </view>
      <view v-else class="empty">暂无荣誉资质</view>
    </view>

    <!-- 关联非遗项目 -->
    <view class="section">
      <view class="section-title">关联非遗项目（{{ projects.length }}）</view>
      <view class="project-list" v-if="projects.length > 0">
        <view class="project-item" v-for="p in projects" :key="p.id">
          非遗项目 #{{ p.projectId }}
          <text class="primary-tag" v-if="p.isPrimary">主打</text>
        </view>
      </view>
      <view v-else class="empty">暂无关联项目</view>
    </view>

    <!-- 登录弹窗 -->
    <view class="mask" v-if="showLogin" @click="showLogin = false">
      <view class="login-box" @click.stop>
        <view class="login-title">会员登录</view>
        <input class="login-input" v-model="mobile" placeholder="手机号" />
        <input class="login-input" v-model="password" placeholder="密码" />
        <view class="login-btn" @click="doLogin">登录</view>
        <view class="login-hint">演示账号：15601691300 / admin123</view>
      </view>
    </view>
  </view>
  <view v-else class="page tip">加载中...</view>
</template>

<script>
import { get, post, del } from '../../utils/request.js'

export default {
  data() {
    return {
      id: null,
      detail: null,
      works: [],
      qualifications: [],
      projects: [],
      showLogin: false,
      mobile: '15601691300',
      password: 'admin123',
      defaultAvatar: 'https://qiniu-web-assets.dcloud.net.cn/unidoc/zh/uni.png',
    }
  },
  onLoad(options) {
    this.id = options.id
    this.fetchAll()
  },
  methods: {
    async fetchAll() {
      try {
        const params = { id: this.id }
        const [detail, works, qualifications, projects] = await Promise.all([
          get('/app-api/inherit/inheritor/get', params),
          get('/app-api/inherit/inheritor/works', params),
          get('/app-api/inherit/inheritor/qualifications', params),
          get('/app-api/inherit/inheritor/projects', params),
        ])
        this.detail = detail
        this.works = works || []
        this.qualifications = qualifications || []
        this.projects = projects || []
      } catch (e) {
        uni.showToast({ title: (e && e.msg) || '加载失败', icon: 'none' })
      }
    },
    async toggleFollow() {
      if (!uni.getStorageSync('memberToken')) {
        this.showLogin = true
        return
      }
      try {
        if (this.detail.isFollowed) {
          await del('/app-api/inherit/inheritor-follow/delete', { inheritorId: this.id })
        } else {
          await post('/app-api/inherit/inheritor-follow/create', { inheritorId: Number(this.id) })
        }
        // 重新拉取详情，刷新关注状态与关注数
        this.detail = await get('/app-api/inherit/inheritor/get', { id: this.id })
        uni.showToast({ title: this.detail.isFollowed ? '已关注' : '已取消', icon: 'none' })
      } catch (e) {
        uni.showToast({ title: (e && e.msg) || '操作失败', icon: 'none' })
      }
    },
    async doLogin() {
      try {
        const data = await post('/app-api/member/auth/login', {
          mobile: this.mobile,
          password: this.password,
        })
        uni.setStorageSync('memberToken', data.accessToken)
        this.showLogin = false
        uni.showToast({ title: '登录成功', icon: 'success' })
        this.detail = await get('/app-api/inherit/inheritor/get', { id: this.id })
      } catch (e) {
        uni.showToast({ title: (e && e.msg) || '登录失败', icon: 'none' })
      }
    },
  },
}
</script>

<style>
.page {
  background: #f7f7f7;
  min-height: 100vh;
  padding-bottom: 60rpx;
}

.header {
  display: flex;
  background: #fff;
  padding: 24rpx;
  align-items: center;
}

.cover {
  width: 160rpx;
  height: 160rpx;
  border-radius: 12rpx;
  background: #eee;
  flex-shrink: 0;
}

.header-info {
  flex: 1;
  margin-left: 20rpx;
}

.name {
  font-size: 36rpx;
  font-weight: bold;
  color: #333;
}

.level {
  display: inline-block;
  margin-top: 6rpx;
  font-size: 22rpx;
  color: #c8102e;
  border: 1rpx solid #c8102e;
  border-radius: 6rpx;
  padding: 0 8rpx;
}

.region {
  margin-top: 6rpx;
  font-size: 24rpx;
  color: #999;
}

.specialty {
  margin-top: 6rpx;
  font-size: 26rpx;
  color: #555;
}

.follow-btn {
  flex-shrink: 0;
  margin-left: 16rpx;
  padding: 0 24rpx;
  height: 60rpx;
  line-height: 60rpx;
  background: #c8102e;
  color: #fff;
  border-radius: 30rpx;
  font-size: 26rpx;
}

.follow-btn.followed {
  background: #eee;
  color: #666;
}

.section {
  margin: 20rpx 24rpx;
  background: #fff;
  border-radius: 16rpx;
  padding: 24rpx;
}

.section-title {
  font-size: 30rpx;
  font-weight: bold;
  color: #333;
  margin-bottom: 16rpx;
}

.section-body {
  font-size: 28rpx;
  color: #555;
  line-height: 1.7;
}

.works-grid {
  display: flex;
  flex-wrap: wrap;
}

.work-item {
  width: 33.3%;
  box-sizing: border-box;
  padding: 8rpx;
}

.work-img {
  width: 100%;
  height: 220rpx;
  border-radius: 10rpx;
  background: #eee;
}

.work-name {
  font-size: 26rpx;
  color: #333;
  margin-top: 6rpx;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.work-meta {
  font-size: 22rpx;
  color: #999;
}

.qual-item {
  padding: 14rpx 0;
  border-bottom: 1rpx solid #f0f0f0;
}

.qual-name {
  font-size: 28rpx;
  color: #333;
}

.qual-type {
  margin-left: 12rpx;
  font-size: 22rpx;
  color: #c8102e;
}

.qual-meta {
  margin-top: 4rpx;
  font-size: 22rpx;
  color: #999;
}

.project-item {
  padding: 14rpx 0;
  font-size: 28rpx;
  color: #333;
}

.primary-tag {
  margin-left: 12rpx;
  font-size: 22rpx;
  color: #c8102e;
  border: 1rpx solid #c8102e;
  border-radius: 6rpx;
  padding: 0 8rpx;
}

.empty {
  color: #999;
  font-size: 26rpx;
  padding: 20rpx 0;
  text-align: center;
}

.tip {
  text-align: center;
  color: #999;
  font-size: 28rpx;
  padding: 100rpx 0;
}

.mask {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.5);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 999;
}

.login-box {
  width: 560rpx;
  background: #fff;
  border-radius: 16rpx;
  padding: 40rpx;
}

.login-title {
  font-size: 32rpx;
  font-weight: bold;
  text-align: center;
  margin-bottom: 24rpx;
}

.login-input {
  height: 76rpx;
  border: 1rpx solid #ddd;
  border-radius: 10rpx;
  padding: 0 20rpx;
  margin-bottom: 20rpx;
  font-size: 28rpx;
}

.login-btn {
  height: 76rpx;
  line-height: 76rpx;
  background: #c8102e;
  color: #fff;
  text-align: center;
  border-radius: 10rpx;
  font-size: 30rpx;
}

.login-hint {
  margin-top: 16rpx;
  text-align: center;
  font-size: 22rpx;
  color: #999;
}
</style>
