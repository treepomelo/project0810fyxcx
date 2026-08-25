<template>
  <view class="auth-page auth-page--login">
    <view class="auth-safe-top"></view>
    <view class="auth-back" @click="goBack">‹</view>
    <view class="auth-brand">
      <image class="auth-mascot" :src="mascotImage" mode="aspectFit"></image>
      <text class="auth-eyebrow">ICHIP · HERITAGE</text>
      <text class="auth-title">欢迎回来</text>
      <text class="auth-subtitle">登录后继续探索非遗文化与传统技艺</text>
    </view>
    <view class="auth-card">
      <button class="auth-wechat auth-wechat--primary" open-type="getPhoneNumber" :loading="loggingIn" :disabled="loggingIn" @getphonenumber="handleWechatLogin">
        <text class="auth-wechat__icon">◎</text>
        <text>微信快捷登录</text>
      </button>
      <view class="auth-divider"><text>或使用已有账号登录</text></view>
      <view class="auth-field">
        <text class="auth-field__label">手机号</text>
        <input v-model.trim="form.mobile" class="auth-input" type="number" maxlength="11" placeholder="请输入手机号" placeholder-class="auth-placeholder" />
      </view>
      <template v-if="loginMode === 'password'">
        <view class="auth-field">
          <text class="auth-field__label">密码</text>
          <input v-model.trim="form.password" class="auth-input" password placeholder="请输入已有账号密码" placeholder-class="auth-placeholder" @confirm="handlePasswordLogin" />
        </view>
        <view class="auth-forgot" @click="handleUnavailable">忘记密码</view>
        <button class="auth-primary" :disabled="loggingIn" @click="handlePasswordLogin">{{ loggingIn ? '登录中…' : '手机号密码登录' }}</button>
        <view class="auth-mode-toggle" @click="switchLoginMode('sms')">手机号验证码登录</view>
      </template>
      <template v-else>
        <view class="auth-field auth-code-row">
          <text class="auth-field__label">验证码</text>
          <view class="auth-code-line">
            <input v-model.trim="form.code" class="auth-input auth-code-input" type="number" maxlength="6" placeholder="请输入验证码" placeholder-class="auth-placeholder" @confirm="handleSmsLogin" />
            <button class="auth-code-button" :disabled="smsSending || smsCountdown > 0" @click="sendSmsCode">{{ smsCountdown > 0 ? `${smsCountdown}s` : (smsSending ? '发送中…' : '获取验证码') }}</button>
          </view>
        </view>
        <button class="auth-primary" :disabled="loggingIn" @click="handleSmsLogin">{{ loggingIn ? '登录中…' : '验证码登录 / 注册' }}</button>
        <view class="auth-mode-toggle" @click="switchLoginMode('password')">已有密码？使用手机号密码登录</view>
        <text class="auth-flow-note">首次验证成功将自动创建账号</text>
      </template>
    </view>
    <view class="auth-footer">
      <text class="auth-footer__muted">微信快捷登录或验证码登录均可创建账号</text>
    </view>
  </view>
</template>

<script>
import { getCurrentMember, memberPasswordLogin, memberSmsLogin, sendMemberSmsCode, weixinMiniAppLogin } from '@/common/request/member-auth.js'
import { getUserInfo, setAuthSession, setUserInfo } from '@/common/session.js'

const MOBILE_PATTERN = /^(?:(?:\+|00)86)?1(?:(?:3\d)|(?:4[0,1,4-9])|(?:5[0-3,5-9])|(?:6[2,5-7])|(?:7[0-8])|(?:8\d)|(?:9[0-3,5-9]))\d{8}$/
const SMS_SCENE_MEMBER_LOGIN = 1

export default {
  data() {
    return {
      form: { mobile: '', password: '', code: '' },
      loginMode: 'password',
      loggingIn: false,
      smsSending: false,
      smsCountdown: 0,
      smsTimer: null,
      returnUrl: '',
      mascotImage: '/static/home/bronze-beast.png'
    }
  },
  onLoad(options = {}) {
    const raw = options.redirect || options.backUrl || ''
    if (!raw) return
    try {
      const decoded = decodeURIComponent(raw)
      this.returnUrl = decoded.indexOf('/pages/') === 0 ? decoded : ''
    } catch (error) {
      this.returnUrl = raw.indexOf('/pages/') === 0 ? raw : ''
    }
    if (options.mode === 'sms') this.loginMode = 'sms'
  },
  onUnload() {
    if (this.smsTimer) clearInterval(this.smsTimer)
  },
  methods: {
    goBack() { uni.navigateBack() },
    handleUnavailable() { uni.showToast({ title: '密码找回功能即将开放', icon: 'none' }) },
    switchLoginMode(mode) { this.loginMode = mode; this.form.code = ''; this.form.password = '' },
    createLoginState() { return `${Date.now()}-${Math.random().toString(36).slice(2)}` },
    requestLoginCode() {
      return new Promise((resolve, reject) => uni.login({
        provider: 'weixin',
        success: result => result && result.code ? resolve(result.code) : reject(new Error('WECHAT_LOGIN_CODE_MISSING')),
        fail: reject
      }))
    },
    showLoginSuccess() {
      uni.showToast({ title: '登录成功', icon: 'success' })
      setTimeout(() => {
        if (this.returnUrl) {
          const route = this.returnUrl.split('?')[0]
          const tabs = ['/pages/index/index', '/pages/community/index', '/pages/shop/list', '/pages/activity/list', '/pages/profile/index']
          tabs.includes(route) ? uni.switchTab({ url: this.returnUrl }) : uni.redirectTo({ url: this.returnUrl })
          return
        }
        const pages = getCurrentPages()
        pages.length > 1 ? uni.navigateBack({ delta: 1 }) : uni.switchTab({ url: '/pages/profile/index' })
      }, 300)
    },
    async refreshMemberInfo() {
      try {
        setUserInfo(await getCurrentMember())
      } catch (error) {
        const cached = getUserInfo()
        setUserInfo({ ...cached, nickname: cached.nickname || '微信用户', avatar: cached.avatar || '/static/mall-demo/placeholder.png' })
      }
    },
    getLoginErrorMessage(error, mode) {
      if (mode === 'wechat' && error && error.message === 'WECHAT_LOGIN_CODE_MISSING') return '微信登录失败，请重试'
      if (error && error.errMsg && error.errMsg.indexOf('request:fail') > -1) return '网络异常，请稍后重试'
      if (error && error.msg) return error.msg
      if (error && error.message) return error.message
      return mode === 'password' ? '手机号或密码错误' : (mode === 'sms' ? '验证码登录失败' : '微信登录失败，请稍后重试')
    },
    validateMobile() {
      if (!MOBILE_PATTERN.test(String(this.form.mobile || '').trim())) {
        uni.showToast({ title: '请输入有效手机号', icon: 'none' })
        return false
      }
      return true
    },
    startSmsCountdown() {
      this.smsCountdown = 60
      this.smsTimer = setInterval(() => {
        this.smsCountdown -= 1
        if (this.smsCountdown <= 0) {
          clearInterval(this.smsTimer)
          this.smsTimer = null
          this.smsCountdown = 0
        }
      }, 1000)
    },
    async sendSmsCode() {
      if (this.smsSending || this.smsCountdown > 0 || !this.validateMobile()) return
      this.smsSending = true
      try {
        await sendMemberSmsCode({ mobile: this.form.mobile.trim(), scene: SMS_SCENE_MEMBER_LOGIN })
        uni.showToast({ title: '验证码已发送', icon: 'success' })
        this.startSmsCountdown()
      } catch (error) {
        uni.showToast({ title: this.getLoginErrorMessage(error, 'sms'), icon: 'none' })
      } finally {
        this.smsSending = false
      }
    },
    async handleSmsLogin() {
      if (this.loggingIn || !this.validateMobile()) return
      if (!/^\d{4,6}$/.test(String(this.form.code || '').trim())) {
        uni.showToast({ title: '请输入有效验证码', icon: 'none' })
        return
      }
      this.loggingIn = true
      try {
        const session = await memberSmsLogin({ mobile: this.form.mobile.trim(), code: this.form.code.trim() })
        setAuthSession(session)
        await this.refreshMemberInfo()
        this.showLoginSuccess()
      } catch (error) {
        uni.showToast({ title: this.getLoginErrorMessage(error, 'sms'), icon: 'none' })
      } finally {
        this.loggingIn = false
      }
    },
    async handleWechatLogin(event) {
      const phoneCode = event && event.detail && event.detail.code
      if (!phoneCode) {
        uni.showToast({ title: '需要手机号授权完成快捷登录', icon: 'none' })
        return
      }
      if (this.loggingIn) return
      this.loggingIn = true
      try {
        const loginCode = await this.requestLoginCode()
        const session = await weixinMiniAppLogin({ phoneCode, loginCode, state: this.createLoginState() })
        setAuthSession(session)
        await this.refreshMemberInfo()
        this.showLoginSuccess()
      } catch (error) {
        uni.showToast({ title: this.getLoginErrorMessage(error, 'wechat'), icon: 'none' })
      } finally {
        this.loggingIn = false
      }
    },
    async handlePasswordLogin() {
      if (this.loggingIn || !this.validateMobile()) return
      if (!this.form.password) {
        uni.showToast({ title: '请输入密码', icon: 'none' })
        return
      }
      this.loggingIn = true
      try {
        const session = await memberPasswordLogin({ mobile: this.form.mobile.trim(), password: this.form.password })
        setAuthSession(session)
        await this.refreshMemberInfo()
        this.showLoginSuccess()
      } catch (error) {
        uni.showToast({ title: this.getLoginErrorMessage(error, 'password'), icon: 'none' })
      } finally {
        this.loggingIn = false
      }
    }
  }
}
</script>

<style lang="scss" src="./login-recovered.scss" scoped></style>
<style lang="scss" scoped>
.auth-wechat--primary { margin-bottom: 24rpx; }
.auth-code-line { display: flex; align-items: center; gap: 16rpx; }
.auth-code-input { flex: 1; min-width: 0; }
.auth-code-button { flex: none; height: 68rpx; padding: 0 18rpx; border: 1rpx solid #728077; border-radius: 14rpx; background: transparent; color: #64796e; font-size: 22rpx; line-height: 66rpx; }
.auth-code-button::after { border: 0; }
.auth-code-button[disabled] { opacity: .55; }
.auth-mode-toggle { margin-top: 22rpx; color: #64796e; font-size: 23rpx; text-align: center; }
.auth-flow-note { display: block; margin-top: 14rpx; color: #aaa096; font-size: 21rpx; text-align: center; }
</style>
