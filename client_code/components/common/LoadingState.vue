<template><content-state type="loading" :message="message" /></template>
<script>
import ContentState from '@/components/content-state.vue'
export default { name: 'LoadingState', components: { ContentState }, props: { message: { type: String, default: '正在加载内容…' } } }
</script>
