<template>
  <view class="auth-page auth-page--register">
    <view class="auth-safe-top"></view>
    <view class="auth-back" @click="goBack">‹</view>
    <view class="auth-brand auth-brand--register">
      <image class="auth-mascot" :src="mascotImage" mode="aspectFit"></image>
      <text class="auth-eyebrow">QUICK MEMBER ACCESS</text>
      <text class="auth-title">手机号验证码登录</text>
      <text class="auth-subtitle">首次验证成功将自动创建账号</text>
    </view>
    <view class="auth-card">
      <view class="auth-field">
        <text class="auth-field__label">手机号</text>
        <input v-model.trim="mobile" class="auth-input" type="number" maxlength="11" placeholder="请输入手机号" placeholder-class="auth-placeholder" />
      </view>
      <view class="auth-field auth-code-row">
        <text class="auth-field__label">验证码</text>
        <view class="auth-code-line">
          <input v-model.trim="code" class="auth-input auth-code-input" type="number" maxlength="6" placeholder="请输入验证码" placeholder-class="auth-placeholder" @confirm="handleLogin" />
          <button class="auth-code-button" :disabled="sending || countdown > 0" @click="sendCode">{{ countdown > 0 ? `${countdown}s` : (sending ? '发送中…' : '获取验证码') }}</button>
        </view>
      </view>
      <button class="auth-primary" :disabled="loggingIn" @click="handleLogin">{{ loggingIn ? '登录中…' : '登录 / 注册' }}</button>
      <text class="auth-flow-note">验证成功后将自动创建或登录会员</text>
    </view>
    <view class="auth-footer">
      <text class="auth-footer__muted">已有密码账号？</text>
      <text class="auth-footer__link" @click="goLogin">手机号密码登录</text>
    </view>
  </view>
</template>

<script>
import { getCurrentMember, memberSmsLogin, sendMemberSmsCode } from '@/common/request/member-auth.js'
import { getUserInfo, setAuthSession, setUserInfo } from '@/common/session.js'

const MOBILE_PATTERN = /^(?:(?:\+|00)86)?1(?:(?:3\d)|(?:4[0,1,4-9])|(?:5[0-3,5-9])|(?:6[2,5-7])|(?:7[0-8])|(?:8\d)|(?:9[0-3,5-9]))\d{8}$/
const SMS_SCENE_MEMBER_LOGIN = 1

export default {
  data() {
    return { mobile: '', code: '', sending: false, loggingIn: false, countdown: 0, timer: null, mascotImage: '/static/home/bronze-beast.png' }
  },
  onUnload() {
    if (this.timer) clearInterval(this.timer)
  },
  methods: {
    goBack() { uni.navigateBack() },
    goLogin() { uni.redirectTo({ url: '/pages/login/login?mode=password' }) },
    validateMobile() {
      if (!MOBILE_PATTERN.test(String(this.mobile || '').trim())) {
        uni.showToast({ title: '请输入有效手机号', icon: 'none' })
        return false
      }
      return true
    },
    startCountdown() {
      this.countdown = 60
      this.timer = setInterval(() => {
        this.countdown -= 1
        if (this.countdown <= 0) {
          clearInterval(this.timer)
          this.timer = null
          this.countdown = 0
        }
      }, 1000)
    },
    async sendCode() {
      if (this.sending || this.countdown > 0 || !this.validateMobile()) return
      this.sending = true
      try {
        await sendMemberSmsCode({ mobile: this.mobile.trim(), scene: SMS_SCENE_MEMBER_LOGIN })
        uni.showToast({ title: '验证码已发送', icon: 'success' })
        this.startCountdown()
      } catch (error) {
        uni.showToast({ title: error && (error.msg || error.message) ? (error.msg || error.message) : '验证码发送失败', icon: 'none' })
      } finally {
        this.sending = false
      }
    },
    async refreshMemberInfo() {
      try {
        setUserInfo(await getCurrentMember())
      } catch (error) {
        const cached = getUserInfo()
        setUserInfo({ ...cached, nickname: cached.nickname || '微信用户', avatar: cached.avatar || '/static/mall-demo/placeholder.png' })
      }
    },
    async handleLogin() {
      if (this.loggingIn || !this.validateMobile()) return
      if (!/^\d{4,6}$/.test(String(this.code || '').trim())) {
        uni.showToast({ title: '请输入有效验证码', icon: 'none' })
        return
      }
      this.loggingIn = true
      try {
        const session = await memberSmsLogin({ mobile: this.mobile.trim(), code: this.code.trim() })
        setAuthSession(session)
        await this.refreshMemberInfo()
        uni.showToast({ title: '登录成功', icon: 'success' })
        setTimeout(() => uni.navigateBack(), 300)
      } catch (error) {
        uni.showToast({ title: error && (error.msg || error.message) ? (error.msg || error.message) : '验证码登录失败', icon: 'none' })
      } finally {
        this.loggingIn = false
      }
    }
  }
}
</script>

<style lang="scss" src="./register-recovered.scss" scoped></style>
<style lang="scss" scoped>
.auth-code-line { display: flex; align-items: center; gap: 16rpx; }
.auth-code-input { flex: 1; min-width: 0; }
.auth-flow-note { display: block; margin-top: 16rpx; color: #aaa096; font-size: 21rpx; text-align: center; }
</style>
