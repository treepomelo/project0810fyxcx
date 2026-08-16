import request from '@/config/axios'

// 传承人荣誉/资质 VO
export interface InheritorQualificationVO {
  id: number
  inheritorId: number
  type: string
  name: string
  level: string
  issuer: string
  issueDate: string
  certificateNo: string
  description: string
  imageUrl: string
  sort: number
  status: number
  createTime: string
}

// 传承人荣誉/资质 保存/更新 VO
export interface InheritorQualificationSaveVO {
  id?: number
  inheritorId: number
  type: string
  name: string
  level?: string
  issuer?: string
  issueDate?: string
  certificateNo?: string
  description?: string
  imageUrl?: string
  sort?: number
  status?: number
}

// 传承人荣誉/资质 API
export const InheritorQualificationApi = {
  // 获得荣誉/资质分页
  getInheritorQualificationPage: async (params: any) => {
    return await request.get({ url: '/inherit/inheritor-qualification/page', params })
  },
  // 获得荣誉/资质
  getInheritorQualification: async (id: number) => {
    return await request.get({ url: '/inherit/inheritor-qualification/get', params: { id } })
  },
  // 创建荣誉/资质
  createInheritorQualification: async (data: InheritorQualificationSaveVO) => {
    return await request.post({ url: '/inherit/inheritor-qualification/create', data })
  },
  // 更新荣誉/资质
  updateInheritorQualification: async (data: InheritorQualificationSaveVO) => {
    return await request.put({ url: '/inherit/inheritor-qualification/update', data })
  },
  // 删除荣誉/资质
  deleteInheritorQualification: async (id: number) => {
    return await request.delete({ url: '/inherit/inheritor-qualification/delete', params: { id } })
  }
}
