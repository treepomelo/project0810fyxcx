import request from '@/config/axios'

// 传承人-非遗项目 关系 VO
export interface InheritorProjectRelationVO {
  id: number
  inheritorId: number
  projectId: number
  isPrimary: boolean
  sort: number
  createTime: string
}

// 传承人-非遗项目 关系 保存/更新 VO
export interface InheritorProjectRelationSaveVO {
  id?: number
  inheritorId: number
  projectId: number
  isPrimary?: boolean
  sort?: number
}

// 传承人-非遗项目 关系 API
export const InheritorProjectRelationApi = {
  // 获得关系分页
  getInheritorProjectRelationPage: async (params: any) => {
    return await request.get({ url: '/inherit/inheritor-project-relation/page', params })
  },
  // 获得关系
  getInheritorProjectRelation: async (id: number) => {
    return await request.get({ url: '/inherit/inheritor-project-relation/get', params: { id } })
  },
  // 创建关系
  createInheritorProjectRelation: async (data: InheritorProjectRelationSaveVO) => {
    return await request.post({ url: '/inherit/inheritor-project-relation/create', data })
  },
  // 更新关系
  updateInheritorProjectRelation: async (data: InheritorProjectRelationSaveVO) => {
    return await request.put({ url: '/inherit/inheritor-project-relation/update', data })
  },
  // 删除关系
  deleteInheritorProjectRelation: async (id: number) => {
    return await request.delete({ url: '/inherit/inheritor-project-relation/delete', params: { id } })
  }
}
