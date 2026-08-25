export function isSuccessCode(code) {
  return code === 0 || code === 200
}

export function getResponseMessage(payload, fallback = '请求失败') {
  return (payload && (payload.msg || payload.message)) || fallback
}