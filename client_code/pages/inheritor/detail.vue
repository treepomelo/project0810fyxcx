<template>
  <view class="app-page inheritor-detail-page">
    <page-header title="传承人详情" />

    <view v-if="loading && !detail" class="detail-state">
      <content-state type="loading" message="正在加载传承人详情…" />
    </view>
    <view v-else-if="error && !detail" class="detail-state">
      <content-state type="error" :message="error" :retrying="loading" @retry="loadDetail" />
    </view>
    <template v-else-if="detail">
      <!-- ===== [MAIN-INHERIT-MIGRATION START] ===== -->
      <view class="detail-hero">
        <image class="detail-cover" :src="normalizeImage(detail.cover || detail.avatar, '/static/img/lbt1.jpg')" mode="aspectFill" />
        <view class="detail-hero__shade"></view>
        <view class="detail-hero__info">
          <image class="detail-avatar" :src="normalizeImage(detail.avatar || detail.cover, '/static/img/logo.png')" mode="aspectFill" />
          <view class="detail-hero__text">
            <text class="detail-name">{{ detail.name || '未命名传承人' }}</text>
            <text v-if="detail.level" class="detail-level">{{ detail.level }}</text>
            <text v-if="regionText(detail)" class="detail-region">{{ regionText(detail) }}</text>
          </view>
        </view>
      </view>

      <view class="detail-section">
        <text class="section-title">传承人简介</text>
        <text class="section-body">{{ detail.introduction || detail.profile || '暂无简介' }}</text>
        <text v-if="detail.profile && detail.introduction" class="section-body section-body--extra">{{ detail.profile }}</text>
      </view>

      <view v-if="detail.specialty" class="detail-section">
        <text class="section-title">擅长技艺</text>
        <text class="section-body">{{ detail.specialty }}</text>
      </view>

      <view v-if="detail.experience" class="detail-section">
        <text class="section-title">从业 / 传承经历</text>
        <text class="section-body">{{ detail.experience }}</text>
      </view>

      <view class="detail-section">
        <view class="section-title-row">
          <text class="section-title">代表作品</text>
          <text class="section-count">{{ works.length }} 件</text>
        </view>
        <view v-if="works.length" class="work-list">
          <view v-for="work in works" :key="work.id" class="work-card">
            <image class="work-card__image" :src="workImage(work)" mode="aspectFill" />
            <view class="work-card__body">
              <text class="work-card__name">{{ work.name }}</text>
              <text v-if="work.year" class="work-card__meta">创作年份：{{ work.year }}</text>
              <text v-if="work.material" class="work-card__meta">材质：{{ work.material }}</text>
              <text v-if="work.technique" class="work-card__meta">技法：{{ work.technique }}</text>
              <text v-if="work.description" class="work-card__description">{{ work.description }}</text>
            </view>
          </view>
        </view>
        <content-state v-else type="empty" message="暂无代表作品" />
      </view>

      <view class="detail-section">
        <view class="section-title-row">
          <text class="section-title">荣誉资质</text>
          <text class="section-count">{{ qualifications.length }} 项</text>
        </view>
        <view v-if="qualifications.length" class="qualification-list">
          <view v-for="item in qualifications" :key="item.id" class="qualification-item">
            <view class="qualification-item__heading">
              <text class="qualification-item__name">{{ item.name }}</text>
              <text v-if="item.type" class="qualification-item__type">{{ item.type }}</text>
            </view>
            <text v-if="item.level || item.issuer" class="qualification-item__meta">{{ [item.level, item.issuer].filter(Boolean).join(' · ') }}</text>
            <text v-if="item.issueDate" class="qualification-item__meta">颁发日期：{{ item.issueDate }}</text>
            <text v-if="item.description" class="qualification-item__description">{{ item.description }}</text>
            <image v-if="item.imageUrl" class="qualification-item__image" :src="normalizeImage(item.imageUrl, '')" mode="aspectFit" />
          </view>
        </view>
        <content-state v-else type="empty" message="暂无荣誉资质" />
      </view>

      <view class="detail-section">
        <view class="section-title-row">
          <text class="section-title">关联非遗项目</text>
          <text class="section-count">{{ projects.length }} 项</text>
        </view>
        <view v-if="projects.length" class="project-list">
          <view v-for="item in projects" :key="item.id" class="project-item">
            <text>非遗项目 #{{ item.projectId }}</text>
            <text v-if="item.isPrimary" class="project-item__tag">主打项目</text>
          </view>
        </view>
        <content-state v-else type="empty" message="暂无关联项目" />
      </view>
      <!-- ===== [MAIN-INHERIT-MIGRATION END] ===== -->
    </template>

    <view v-if="detail" class="detail-actions">
      <!-- ===== [MAIN-INHERIT-MIGRATION START] ===== -->
      <button class="action-button action-button--follow" :disabled="followLoading" @tap="toggleFollow">
        {{ detail.isFollowed ? '已关注' : '关注' }}{{ detail.followCount ? ` · ${detail.followCount}` : '' }}
      </button>
      <button class="action-button action-button--contact" :disabled="contactLoading" @tap="contactInheritor">
        {{ contactLoading ? '获取中…' : '立即咨询' }}
      </button>
      <!-- ===== [MAIN-INHERIT-MIGRATION END] ===== -->
    </view>
  </view>
</template>

<script>
import PageHeader from '@/components/page-header.vue'
import ContentState from '@/components/content-state.vue'
import {
  followInheritor,
  getInheritorContact,
  getInheritorDetail,
  getInheritorProjects,
  getInheritorQualifications,
  getInheritorWorks,
  unfollowInheritor
} from '@/common/request/api.js'
import { ensureLogin } from '@/common/session.js'
import { normalizeImage } from '@/common/utils.js'

// ===== [MAIN-INHERIT-MIGRATION START] =====
// 从 main 分支拼接传承人页面业务，Phase 1 仅完成功能接入。
export default {
  components: { PageHeader, ContentState },
  data() {
    return {
      id: null,
      detail: null,
      works: [],
      qualifications: [],
      projects: [],
      loading: false,
      error: '',
      followLoading: false,
      contactLoading: false
    }
  },
  onLoad(options) {
    this.id = options && options.id
    this.loadDetail()
  },
  methods: {
    normalizeImage,
    async loadDetail() {
      if (!this.id) {
        this.error = '缺少传承人编号'
        return
      }
      this.loading = true
      this.error = ''
      try {
        this.detail = await getInheritorDetail(this.id)
        await Promise.all([
          this.loadWorks(),
          this.loadQualifications(),
          this.loadProjects()
        ])
      } catch (requestError) {
        this.detail = null
        this.error = this.getErrorMessage(requestError, '传承人详情加载失败，请稍后重试')
      } finally {
        this.loading = false
      }
    },
    async loadWorks() {
      try {
        const result = await getInheritorWorks(this.id)
        this.works = Array.isArray(result) ? result : []
      } catch (error) {
        this.works = []
      }
    },
    async loadQualifications() {
      try {
        const result = await getInheritorQualifications(this.id)
        this.qualifications = Array.isArray(result) ? result : []
      } catch (error) {
        this.qualifications = []
      }
    },
    async loadProjects() {
      try {
        const result = await getInheritorProjects(this.id)
        this.projects = Array.isArray(result) ? result : []
      } catch (error) {
        this.projects = []
      }
    },
    async toggleFollow() {
      if (!ensureLogin() || this.followLoading) return
      this.followLoading = true
      try {
        if (this.detail.isFollowed) {
          await unfollowInheritor(this.id)
        } else {
          await followInheritor(this.id)
        }
        this.detail = await getInheritorDetail(this.id)
      } catch (error) {
        // dev request 已负责统一错误提示，这里不引入新的错误体系。
      } finally {
        this.followLoading = false
      }
    },
    async contactInheritor() {
      if (!ensureLogin() || this.contactLoading) return
      this.contactLoading = true
      try {
        const result = await getInheritorContact(this.id)
        const phone = result && typeof result.phone === 'string' ? result.phone.trim() : ''
        if (!phone) return
        uni.showModal({
          title: '联系传承人',
          content: `联系电话：${phone}`,
          confirmText: '拨打电话',
          cancelText: '取消',
          success: (modalResult) => {
            if (!modalResult.confirm) return
            uni.makePhoneCall({
              phoneNumber: phone,
              fail: () => uni.showToast({ title: '拨打电话失败', icon: 'none' })
            })
          }
        })
      } catch (error) {
        // 后端业务错误由 dev request 统一展示，例如联系电话未配置。
      } finally {
        this.contactLoading = false
      }
    },
    workImage(work) {
      const images = Array.isArray(work && work.images) ? work.images : []
      return normalizeImage(work && (work.cover || images[0]), '/static/img/lbt1.jpg')
    },
    regionText(item) {
      return [item.provinceName, item.cityName, item.districtName].filter(Boolean).join(' ')
    },
    getErrorMessage(error, fallback) {
      return (error && (error.message || error.msg)) || fallback
    }
  }
}
// ===== [MAIN-INHERIT-MIGRATION END] =====
</script>

<style lang="scss" scoped>
/* ===== [MAIN-INHERIT-MIGRATION START] ===== */
/* Phase 1: 传承人详情及电话咨询业务拼接，后续统一视觉优化。 */
.inheritor-detail-page {
  min-height: 100vh;
  padding-bottom: 168rpx;
  background: #f5f0e7;
}

.detail-state {
  margin: 24rpx;
  border-radius: 22rpx;
  background: #fffaf5;
}

.detail-hero {
  position: relative;
  height: 430rpx;
  overflow: hidden;
  background: #dac5b4;
}

.detail-cover {
  width: 100%;
  height: 100%;
}

.detail-hero__shade {
  position: absolute;
  inset: 0;
  background: linear-gradient(180deg, rgba(34, 23, 17, 0.02), rgba(34, 23, 17, 0.72));
}

.detail-hero__info {
  position: absolute;
  right: 28rpx;
  bottom: 28rpx;
  left: 28rpx;
  display: flex;
  align-items: flex-end;
}

.detail-avatar {
  width: 152rpx;
  height: 152rpx;
  border: 5rpx solid rgba(255, 250, 245, 0.92);
  border-radius: 22rpx;
  background: #eee2d6;
}

.detail-hero__text {
  min-width: 0;
  flex: 1;
  margin-left: 20rpx;
}

.detail-name,
.detail-level,
.detail-region {
  display: block;
  overflow: hidden;
  color: #fffaf5;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.detail-name {
  font-size: 40rpx;
  font-weight: 700;
}

.detail-level {
  margin-top: 8rpx;
  font-size: 24rpx;
}

.detail-region {
  margin-top: 8rpx;
  font-size: 23rpx;
  opacity: 0.9;
}

.detail-section {
  margin: 20rpx 24rpx 0;
  padding: 26rpx;
  border-radius: 22rpx;
  background: #fffaf5;
  box-shadow: 0 8rpx 24rpx rgba(83, 53, 37, 0.05);
}

.section-title-row {
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.section-title {
  display: block;
  color: #34251f;
  font-size: 30rpx;
  font-weight: 700;
}

.section-count {
  color: #9a877a;
  font-size: 22rpx;
}

.section-body {
  display: block;
  margin-top: 16rpx;
  color: #725e52;
  font-size: 27rpx;
  line-height: 1.75;
  white-space: pre-wrap;
}

.section-body--extra {
  margin-top: 10rpx;
}

.work-list,
.qualification-list,
.project-list {
  margin-top: 12rpx;
}

.work-card {
  display: flex;
  padding: 16rpx 0;
  border-bottom: 1rpx solid rgba(166, 71, 45, 0.09);
}

.work-card:last-child,
.qualification-item:last-child {
  border-bottom: none;
}

.work-card__image {
  width: 178rpx;
  height: 150rpx;
  flex-shrink: 0;
  border-radius: 16rpx;
  background: #eee2d6;
}

.work-card__body {
  min-width: 0;
  margin-left: 18rpx;
}

.work-card__name,
.work-card__meta,
.work-card__description {
  display: block;
  margin-top: 6rpx;
  color: #806e62;
  font-size: 23rpx;
  line-height: 1.5;
}

.work-card__name {
  margin-top: 0;
  color: #34251f;
  font-size: 28rpx;
  font-weight: 600;
}

.work-card__description {
  display: -webkit-box;
  overflow: hidden;
  -webkit-box-orient: vertical;
  -webkit-line-clamp: 2;
}

.qualification-item {
  padding: 16rpx 0;
  border-bottom: 1rpx solid rgba(166, 71, 45, 0.09);
}

.qualification-item__heading {
  display: flex;
  align-items: center;
  flex-wrap: wrap;
  gap: 10rpx;
}

.qualification-item__name {
  color: #34251f;
  font-size: 28rpx;
  font-weight: 600;
}

.qualification-item__type,
.project-item__tag {
  padding: 4rpx 10rpx;
  border-radius: 10rpx;
  background: rgba(166, 71, 45, 0.1);
  color: #a6472d;
  font-size: 20rpx;
}

.qualification-item__meta,
.qualification-item__description {
  display: block;
  margin-top: 8rpx;
  color: #806e62;
  font-size: 23rpx;
  line-height: 1.5;
}

.qualification-item__image {
  width: 100%;
  height: 180rpx;
  margin-top: 12rpx;
}

.project-item {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 16rpx 0;
  border-bottom: 1rpx solid rgba(166, 71, 45, 0.09);
  color: #725e52;
  font-size: 27rpx;
}

.detail-actions {
  position: fixed;
  right: 0;
  bottom: 0;
  left: 0;
  z-index: 100;
  display: flex;
  gap: 18rpx;
  padding: 18rpx 24rpx calc(18rpx + env(safe-area-inset-bottom));
  background: rgba(245, 240, 231, 0.96);
  box-shadow: 0 -8rpx 24rpx rgba(83, 53, 37, 0.08);
}

.action-button {
  flex: 1;
  height: 82rpx;
  margin: 0;
  border-radius: 18rpx;
  font-size: 27rpx;
  line-height: 82rpx;
}

.action-button--follow {
  border: 1rpx solid #64796e;
  background: #fffaf5;
  color: #64796e;
}

.action-button--contact {
  background: #64796e;
  color: #fff;
}
/* ===== [MAIN-INHERIT-MIGRATION END] ===== */
</style>