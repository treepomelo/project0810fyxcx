import { defineConfig } from 'vite'
import uni from '@dcloudio/vite-plugin-uni'
// https://vitejs.dev/config/
export default defineConfig({
  plugins: [
    uni(),
  ],
  server: {
    port: 5173,
    proxy: {
      // H5 开发环境，将后端接口代理到本地 yudao-server
      '/app-api': { target: 'http://127.0.0.1:48080', changeOrigin: true },
      '/admin-api': { target: 'http://127.0.0.1:48080', changeOrigin: true },
    },
  },
})
