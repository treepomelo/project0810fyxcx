import request from '@/config/axios'

// 传承人 VO
export interface InheritorVO {
  id: number
  name: string
  avatar: string
  cover: string
  gender: number
  phone: string
  idCard: string
  level: string
  provinceCode: number
  cityCode: number
  districtCode: number
  introduction: string
  profile: string
  specialty: string
  experience: string
  displayStatus: number
  isRecommend: number
  recommendSort: number
  sort: number
  status: number
  auditStatus: number
  auditRemark: string
  auditTime: string
  createTime: string
  provinceName: string
  cityName: string
  districtName: string
  followCount: number
}

// 传承人 保存/更新 VO
export interface InheritorSaveVO {
  id?: number
  name: string
  avatar?: string
  cover?: string
  gender?: number
  phone?: string
  idCard?: string
  level?: string
  provinceCode?: number
  cityCode?: number
  districtCode?: number
  introduction?: string
  profile?: string
  specialty?: string
  experience?: string
  displayStatus?: number
  isRecommend?: number
  recommendSort?: number
  sort?: number
  status?: number
}

// 传承人 审核 VO
export interface InheritorAuditVO {
  id: number
  auditStatus: number
  auditRemark?: string
}

// 传承人 API
export const InheritorApi = {
  // 获得传承人分页
  getInheritorPage: async (params: any) => {
    return await request.get({ url: '/inherit/inheritor/page', params })
  },
  // 获得传承人
  getInheritor: async (id: number) => {
    return await request.get({ url: '/inherit/inheritor/get', params: { id } })
  },
  // 创建传承人
  createInheritor: async (data: InheritorSaveVO) => {
    return await request.post({ url: '/inherit/inheritor/create', data })
  },
  // 更新传承人
  updateInheritor: async (data: InheritorSaveVO) => {
    return await request.put({ url: '/inherit/inheritor/update', data })
  },
  // 审核传承人
  updateInheritorAudit: async (data: InheritorAuditVO) => {
    return await request.put({ url: '/inherit/inheritor/update-audit', data })
  },
  // 删除传承人
  deleteInheritor: async (id: number) => {
    return await request.delete({ url: '/inherit/inheritor/delete', params: { id } })
  }
}

// 地区树 API（复用底座 /system/area/tree）
export const AreaApi = {
  // 获得地区树
  getAreaTree: async () => {
    return await request.get({ url: '/system/area/tree' })
  }
}
