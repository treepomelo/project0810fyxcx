<template>
  <view class="app-page heritage-service-page">
    <view v-if="service" class="service-card">
      <image v-if="service.coverUrl" :src="service.coverUrl" mode="aspectFill" class="service-cover" />
      <text class="service-system">{{ service.systemName || service.systemCode }}</text>
      <text class="service-title">{{ service.title }}</text>
      <text class="service-summary">{{ service.summary || service.description }}</text>
      <text class="service-description">{{ service.description }}</text>
      <text class="service-price">¥{{ formatPrice(service.price) }}</text>
      <text class="service-location">{{ service.location || service.city || '非遗体验服务' }}</text>
    </view>
    <view class="schedule-card">
      <text class="section-title">可预约场次</text>
      <view v-for="item in schedules" :key="item.id" class="schedule-row" :class="{ disabled: !item.available }" @click="choose(item)">
        <text>{{ item.startTime }} - {{ item.endTime }}</text>
        <text>{{ item.available ? (item.remaining === null ? '不限人数' : `余 ${item.remaining}`) : '已满' }}</text>
      </view>
      <text v-if="!schedules.length">暂无可预约场次</text>
    </view>
    <view v-if="service && !service.bookingEnabled" class="booking-disabled">暂未开放预约</view>
    <view v-else-if="selected" class="booking-card">
      <input v-model.trim="form.contactName" placeholder="联系人姓名" />
      <input v-model.trim="form.contactPhone" type="number" placeholder="11位手机号" />
      <input v-model.number="form.peopleCount" type="number" placeholder="人数（1-20）" />
      <button :disabled="submitting" @click="submit">{{ submitting ? '提交中…' : '提交预约' }}</button>
    </view>
  </view>
</template>
<script>
import { getHeritageService, getHeritageServiceSchedules, createHeritageBooking } from '@/common/request/heritage-ecosystem.js'
import { ensureLogin } from '@/common/session.js'
import { formatPrice } from '@/common/utils.js'
export default {
  data: () => ({ id: '', service: null, schedules: [], selected: null, submitting: false, form: { contactName: '', contactPhone: '', peopleCount: 1, remark: '' } }),
  onLoad(query) { this.id = query && query.id; this.load() },
  methods: {
    formatPrice,
    async load() { try { this.service = await getHeritageService(this.id); this.schedules = await getHeritageServiceSchedules(this.id) || []; this.selected = null } catch (error) { uni.showToast({ title: '服务加载失败', icon: 'none' }) } },
    choose(item) { if (item.available && this.service && this.service.bookingEnabled) this.selected = item },
    validateForm() {
      if (!this.selected) return '请选择可预约场次'
      if (!this.form.contactName) return '请输入联系人姓名'
      if (!/^1\d{10}$/.test(this.form.contactPhone)) return '请输入有效手机号'
      if (!Number.isInteger(Number(this.form.peopleCount)) || Number(this.form.peopleCount) < 1 || Number(this.form.peopleCount) > 20) return '人数需为1-20'
      return ''
    },
    async submit() {
      if (!ensureLogin() || this.submitting) return
      const validation = this.validateForm()
      if (validation) { uni.showToast({ title: validation, icon: 'none' }); return }
      this.submitting = true
      try { await createHeritageBooking({ ...this.form, serviceId: Number(this.id), scheduleId: this.selected.id, peopleCount: Number(this.form.peopleCount) }); uni.showToast({ title: '预约已提交', icon: 'success' }); await this.load() } catch (error) { uni.showToast({ title: error && error.msg ? error.msg : '预约失败', icon: 'none' }) } finally { this.submitting = false }
    }
  }
}
</script>
<style scoped>
.heritage-service-page{padding:24rpx;background:#f7f2eb;min-height:100vh}.service-card,.schedule-card,.booking-card,.booking-disabled{margin-bottom:24rpx;padding:28rpx;border-radius:20rpx;background:#fff}.service-cover{width:100%;height:300rpx;border-radius:16rpx}.service-system,.service-summary,.service-description,.service-location{display:block;margin-top:12rpx;color:#765f54}.service-title{display:block;font-size:36rpx;font-weight:700;margin-top:20rpx}.service-price{display:block;margin-top:16rpx;color:#a6472d;font-size:30rpx;font-weight:700}.schedule-row{display:flex;justify-content:space-between;padding:24rpx 0;border-bottom:1rpx solid #eee}.schedule-row.disabled{color:#aaa}.booking-card input{padding:20rpx 0;border-bottom:1rpx solid #eee}.booking-card button{margin-top:24rpx}.booking-disabled{text-align:center;color:#a17b68}
</style>