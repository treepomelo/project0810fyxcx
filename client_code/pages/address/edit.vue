<template>
  <view class="edit-page">
    <page-header :title="addressId ? '编辑地址' : '新增地址'" />
    <view class="form-panel">
      <view class="field"><text>收货人</text><input v-model.trim="form.name" placeholder="请输入收货人姓名" /></view>
      <view class="field"><text>手机号</text><input v-model.trim="form.mobile" type="number" maxlength="11" placeholder="请输入手机号" /></view>
      <picker class="region-picker" mode="region" :value="region" @change="handleRegionChange">
        <view class="field region-field"><text>所在地区</text><text class="field-value" :class="{ muted: !regionText }">{{ regionText || '请选择省市区' }}　›</text></view>
      </picker>
      <view class="field"><text>详细地址</text><input v-model.trim="form.detailAddress" placeholder="请输入街道、门牌号" /></view>
      <view class="default-row"><text>设为默认地址</text><switch :checked="form.defaultStatus" color="#64796e" @change="form.defaultStatus = $event.detail.value" /></view>
    </view>
    <button class="save" @tap="save">保存地址</button>
  </view>
</template>

<script>
import PageHeader from '@/components/page-header.vue'
import { getMemberAddress, createMemberAddress, updateMemberAddress, getAreaTree } from '@/common/request/member-address.js'
import { isLoggedIn } from '@/common/session.js'

export default {
  components: { PageHeader },
  data() { return { addressId: '', form: { name: '', mobile: '', areaId: null, detailAddress: '', defaultStatus: false }, areaName: '', region: [], regionText: '', provinceName: '', cityName: '', districtName: '', areas: [] } },
  onLoad(options) {
    if (!isLoggedIn()) { uni.navigateTo({ url: '/pages/login/login?backUrl=/pages/address/edit' }); return }
    this.addressId = options && options.id ? String(options.id) : ''
    if (this.addressId) this.loadAddress()
    this.loadAreas()
  },
  methods: {
    async loadAddress() { try { const data = await getMemberAddress(this.addressId); if (data) { this.form = { name: data.name || '', mobile: data.mobile || '', areaId: data.areaId ? Number(data.areaId) : null, detailAddress: data.detailAddress || '', defaultStatus: !!data.defaultStatus }; this.areaName = data.areaName || ''; this.regionText = this.areaName; this.syncRegionFromAreaId() } } catch (error) { uni.showToast({ title: error.msg || '地址加载失败', icon: 'none' }) } },
    async loadAreas() { try { this.areas = await getAreaTree() || []; this.syncRegionFromAreaId() } catch (error) { this.areas = [] } },
    normalizeRegionName(name) { return String(name || '').replace(/[省市区县]$/u, '') },
    findRegionNode(nodes, name) {
      const exact = (nodes || []).find((node) => String(node.name) === String(name))
      if (exact) return exact
      const normalized = this.normalizeRegionName(name)
      return (nodes || []).find((node) => this.normalizeRegionName(node.name) === normalized)
    },
    findAreaPath(nodes, targetId, path = []) {
      for (const node of (nodes || [])) {
        const nextPath = path.concat(node)
        if (Number(node.id) === Number(targetId)) return nextPath
        const found = this.findAreaPath(node.children, targetId, nextPath)
        if (found) return found
      }
      return null
    },
    syncRegionFromAreaId() {
      if (!this.form.areaId || !this.areas.length) return
      const path = this.findAreaPath(this.areas, this.form.areaId)
      if (!path) return
      this.region = path.slice(0, 3).map((node) => node.name)
      this.regionText = this.region.join(' ')
      this.provinceName = this.region[0] || ''
      this.cityName = this.region[1] || ''
      this.districtName = this.region[2] || ''
      this.areaName = this.regionText
    },
    handleRegionChange(event) {
      const value = event && event.detail && Array.isArray(event.detail.value) ? event.detail.value : []
      this.region = value
      this.provinceName = value[0] || ''
      this.cityName = value[1] || ''
      this.districtName = value[2] || ''
      this.regionText = value.join(' ')
      this.areaName = this.regionText
      const province = this.findRegionNode(this.areas, this.provinceName)
      const city = province && this.findRegionNode(province.children, this.cityName)
      const district = city && this.findRegionNode(city.children, this.districtName)
      const selected = district || city || province
      this.form.areaId = selected && selected.id !== undefined ? Number(selected.id) : null
    },
    async save() {
      if (!this.form.name) { uni.showToast({ title: '请输入收货人姓名', icon: 'none' }); return }
      if (!/^1\d{10}$/.test(this.form.mobile)) { uni.showToast({ title: '请输入正确的手机号', icon: 'none' }); return }
      if (!this.form.areaId || !this.regionText) { uni.showToast({ title: '请选择所在地区', icon: 'none' }); return }
      if (!this.form.detailAddress) { uni.showToast({ title: '请输入详细地址', icon: 'none' }); return }
      try { if (this.addressId) await updateMemberAddress({ id: Number(this.addressId), ...this.form }); else await createMemberAddress(this.form); uni.showToast({ title: '地址已保存', icon: 'success' }); setTimeout(() => uni.navigateBack(), 350) } catch (error) { uni.showToast({ title: error.msg || '保存失败', icon: 'none' }) }
    }
  }
}
</script>

<style lang="scss" scoped>
.edit-page { min-height: 100vh; padding-bottom: calc(160rpx + env(safe-area-inset-bottom)); background: $ichip-color-page; }.form-panel { margin: 22rpx 24rpx; padding: 8rpx 26rpx; border: 1rpx solid $ichip-color-line; border-radius: 22rpx; background: $ichip-color-surface; }.region-picker { display: block; }.field, .default-row { display: flex; align-items: center; min-height: 94rpx; border-bottom: 1rpx solid $ichip-color-line; color: $ichip-color-ink; font-size: 26rpx; }.region-field { width: 100%; }.field:last-child, .default-row { border-bottom: 0; }.field > text:first-child { width: 160rpx; }.field input { flex: 1; color: $ichip-color-ink; font-size: 26rpx; }.field-value { flex: 1; overflow: hidden; color: $ichip-color-ink; text-align: right; text-overflow: ellipsis; white-space: nowrap; }.muted { color: $ichip-color-muted; }.default-row { justify-content: space-between; }.save { position: fixed; left: 24rpx; right: 24rpx; bottom: calc(24rpx + env(safe-area-inset-bottom)); border-radius: 18rpx; background: $ichip-color-nav-active; color: #fff; font-size: 27rpx; line-height: 82rpx; }
</style>
