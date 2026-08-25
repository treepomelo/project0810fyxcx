<template><content-state type="empty" :message="message" /></template>
<script>
import ContentState from '@/components/content-state.vue'
export default { name: 'EmptyState', components: { ContentState }, props: { message: { type: String, default: '暂无内容' } } }
</script>
