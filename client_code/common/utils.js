import config from '@/common/config.js'

export function formatDateTime(value) {
  if (!value) return ''
  const text = String(value).replace('T', ' ')
  return text.length > 16 ? text.slice(0, 16) : text
}

export function formatPrice(value) {
  const number = Number(value || 0)
  return Number.isFinite(number) ? (number / 100).toFixed(2) : '0.00'
}

export function shortText(value, max = 48) {
  if (!value) return ''
  const text = String(value).replace(/<[^>]+>/g, '').replace(/&nbsp;/g, ' ').trim()
  return text.length > max ? `${text.slice(0, max)}...` : text
}

export function resolveMediaUrl(value) {
  if (!value) return ''
  const raw = String(value).trim()
  if (!raw) return ''
  // 微信小程序不能加载当前开发环境的 HTTP uploads 地址；让调用方
  // 通过 normalizeImage 使用本地占位图，而不是触发运行时图片警告。
  if (/^http:\/\/localhost(?::\d+)?\/uploads(?:\/|$)/i.test(raw)) return ''
  if (/^\/uploads(?:\/|$)/i.test(raw)) return ''
  if (/^https?:\/\//i.test(raw)) return raw
  if (raw.startsWith('/static/')) return raw
  const origin = String(config.ruoyiBaseUrl || config.baseUrl || '').replace(/\/app-api\/?$/, '').replace(/\/api\/?$/, '')
  if (/^\/(app-api|admin-api|infra)\//.test(raw)) return `${origin}${raw}`
  return raw
}

export function normalizeImage(value, fallback = '/static/img/logo.png') {
  return resolveMediaUrl(value) || fallback
}

export function genderText(value) {
  if (value === 1 || value === '1') return '男'
  if (value === 2 || value === '2') return '女'
  return '保密'
}
