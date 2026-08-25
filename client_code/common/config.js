const ruoyiBaseUrl = import.meta.env.VITE_RUOYI_APP_API_BASE_URL || 'http://localhost:48080/app-api'
const config = {
  baseUrl: import.meta.env.VITE_API_BASE_URL || ruoyiBaseUrl,
  ruoyiBaseUrl,
  appName: '非遗文化互动平台',
  themeColor: '#a6472d'
}

export default config
