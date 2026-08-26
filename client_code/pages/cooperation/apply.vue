<template>
  <view class="app-page">
    <input v-model.trim="form.companyName" placeholder="公司/机构名称" />
    <input v-model.trim="form.contactName" placeholder="联系人" />
    <input v-model.trim="form.contactPhone" type="number" placeholder="手机号" />
    <picker :range="types" range-key="name" @change="selectType"><view class="type-picker">合作类型：{{ selectedTypeName || '请选择' }}</view></picker>
    <textarea v-model.trim="form.requirement" placeholder="合作需求" />
    <button :disabled="submitting" @click="submit">{{ submitting ? '提交中…' : '提交申请' }}</button>
  </view>
</template>
<script>
import { createHeritageCooperation, getHeritageCooperationTypes } from '@/common/request/heritage-ecosystem.js'
import { ensureLogin } from '@/common/session.js'
export default {
  data: () => ({ types: [], submitting: false, form: { companyName: '', contactName: '', contactPhone: '', cooperationType: '', requirement: '' } }),
  computed: { selectedTypeName() { const item = this.types.find((type) => type.code === this.form.cooperationType); return item && item.name } },
  async onLoad() { try { this.types = await getHeritageCooperationTypes() || []; if (!this.form.cooperationType && this.types.length) this.form.cooperationType = this.types[0].code } catch (e) {} },
  methods: {
    selectType(event) { const item = this.types[Number(event.detail.value)]; if (item) this.form.cooperationType = item.code },
    validate() { if (!this.form.companyName || !this.form.contactName || !/^1\d{10}$/.test(this.form.contactPhone) || !this.form.cooperationType || !this.form.requirement) return '请完整填写合作信息'; return '' },
    async submit() {
      if (!ensureLogin() || this.submitting) return
      const message = this.validate(); if (message) { uni.showToast({ title: message, icon: 'none' }); return }
      this.submitting = true
      try { await createHeritageCooperation(this.form); uni.showToast({ title: '申请已提交', icon: 'success' }); setTimeout(() => uni.navigateBack(), 500) } catch (e) { uni.showToast({ title: e && e.msg ? e.msg : '提交失败', icon: 'none' }) } finally { this.submitting = false }
    }
  }
}
</script>
<style scoped>.app-page{padding:24rpx;background:#f7f2eb;min-height:100vh}input,textarea,.type-picker{display:block;width:100%;box-sizing:border-box;padding:22rpx 0;border-bottom:1rpx solid #ddd;margin-bottom:16rpx}textarea{min-height:180rpx}button{margin-top:24rpx}</style>