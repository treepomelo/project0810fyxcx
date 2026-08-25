import { ruoyiRequest } from './ruoyi.js'

function normalizeArticle(article = {}) {
  return { ...article, cover: article.picUrl || article.cover || '', summary: article.introduction || article.summary || '', source: article.author || article.source || '', views: article.browseCount === undefined ? (article.views || 0) : article.browseCount, category: article.category || article.categoryId || '' }
}

export async function getPromotionArticlePage(params = {}) {
  const data = {
    pageNo: params.pageNo === undefined ? (params.page === undefined ? 1 : params.page) : params.pageNo,
    pageSize: params.pageSize === undefined ? (params.size === undefined ? 10 : params.size) : params.pageSize
  }
  if (params.categoryId !== undefined && params.categoryId !== null) data.categoryId = params.categoryId
  const page = await ruoyiRequest({
    url: '/promotion/article/page',
    data,
    auth: false
  })
  return { ...(page || {}), list: Array.isArray(page && page.list) ? page.list.map(normalizeArticle) : [] }
}

export async function getPromotionArticle(id) {
  return normalizeArticle(await ruoyiRequest({ url: '/promotion/article/get', data: { id }, auth: false }))
}
