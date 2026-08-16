import request from '@/config/axios'

// 传承人作品 VO
export interface InheritorWorkVO {
  id: number
  inheritorId: number
  name: string
  cover: string
  images: string[]
  description: string
  year: string
  material: string
  technique: string
  sort: number
  status: number
  createTime: string
}

// 传承人作品 保存/更新 VO
export interface InheritorWorkSaveVO {
  id?: number
  inheritorId: number
  name: string
  cover?: string
  images?: string[]
  description?: string
  year?: string
  material?: string
  technique?: string
  sort?: number
  status?: number
}

// 传承人作品 API
export const InheritorWorkApi = {
  // 获得作品分页
  getInheritorWorkPage: async (params: any) => {
    return await request.get({ url: '/inherit/inheritor-work/page', params })
  },
  // 获得作品
  getInheritorWork: async (id: number) => {
    return await request.get({ url: '/inherit/inheritor-work/get', params: { id } })
  },
  // 创建作品
  createInheritorWork: async (data: InheritorWorkSaveVO) => {
    return await request.post({ url: '/inherit/inheritor-work/create', data })
  },
  // 更新作品
  updateInheritorWork: async (data: InheritorWorkSaveVO) => {
    return await request.put({ url: '/inherit/inheritor-work/update', data })
  },
  // 删除作品
  deleteInheritorWork: async (id: number) => {
    return await request.delete({ url: '/inherit/inheritor-work/delete', params: { id } })
  }
}
