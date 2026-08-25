import { isSuccessCode, getResponseMessage } from './response.js'
import config from '@/common/config.js'
import { getAccessToken } from '@/common/session.js'

export function uploadFile(filePath, directory) {
  return new Promise((resolve, reject) => {
    const token = getAccessToken()
    uni.uploadFile({
      url: `${config.ruoyiBaseUrl}/infra/file/upload`, filePath, name: 'file',
      formData: directory ? { directory } : {},
      header: token ? { Authorization: `Bearer ${token}` } : {},
      success: (response) => {
        try {
          const payload = JSON.parse(response.data || '{}')
          if (isSuccessCode(payload.code)) { resolve(payload.data); return }
          reject({ ...payload, message: getResponseMessage(payload, '上传失败') })
        } catch (error) { reject(error) }
      },
      fail: reject
    })
  })
}