<template>
  <el-dialog
    :title="formData.id ? '修改传承人' : '新增传承人'"
    v-model="visible"
    width="720px"
    top="5vh"
    destroy-on-close
  >
    <el-form ref="formRef" :model="formData" :rules="formRules" label-width="110px">
      <el-row :gutter="16">
        <el-col :span="12">
          <el-form-item label="姓名" prop="name">
            <el-input v-model="formData.name" placeholder="请输入姓名" maxlength="64" />
          </el-form-item>
        </el-col>
        <el-col :span="12">
          <el-form-item label="性别" prop="gender">
            <el-radio-group v-model="formData.gender">
              <el-radio v-for="dict in sexDict" :key="dict.value" :label="Number(dict.value)">
                {{ dict.label }}
              </el-radio>
            </el-radio-group>
          </el-form-item>
        </el-col>
        <el-col :span="12">
          <el-form-item label="传承人级别" prop="level">
            <el-select v-model="formData.level" placeholder="请选择传承人级别" clearable class="!w-full">
              <el-option
                v-for="dict in levelDict"
                :key="dict.value"
                :label="dict.label"
                :value="dict.value"
              />
            </el-select>
          </el-form-item>
        </el-col>
        <el-col :span="12">
          <el-form-item label="联系电话" prop="phone">
            <el-input v-model="formData.phone" placeholder="请输入联系电话" maxlength="20" />
          </el-form-item>
        </el-col>
        <el-col :span="12">
          <el-form-item label="身份证号" prop="idCard">
            <el-input v-model="formData.idCard" placeholder="请输入身份证号" maxlength="18" />
          </el-form-item>
        </el-col>
        <el-col :span="12">
          <el-form-item label="地区" prop="region">
            <el-cascader
              v-model="region"
              :options="areaTree"
              :props="areaProps"
              placeholder="请选择省/市/区县"
              clearable
              class="!w-full"
            />
          </el-form-item>
        </el-col>
        <el-col :span="12">
          <el-form-item label="头像" prop="avatar">
            <FileUpload v-model="formData.avatar" />
          </el-form-item>
        </el-col>
        <el-col :span="12">
          <el-form-item label="封面图" prop="cover">
            <FileUpload v-model="formData.cover" />
          </el-form-item>
        </el-col>
        <el-col :span="24">
          <el-form-item label="简介" prop="introduction">
            <el-input v-model="formData.introduction" placeholder="一句话简介" maxlength="500" />
          </el-form-item>
        </el-col>
        <el-col :span="24">
          <el-form-item label="擅长技艺" prop="specialty">
            <el-input
              v-model="formData.specialty"
              placeholder="多个技艺用逗号分隔，例如：景泰蓝,掐丝珐琅"
              maxlength="255"
            />
          </el-form-item>
        </el-col>
        <el-col :span="24">
          <el-form-item label="详细介绍" prop="profile">
            <el-input v-model="formData.profile" type="textarea" :rows="3" placeholder="详细介绍" />
          </el-form-item>
        </el-col>
        <el-col :span="24">
          <el-form-item label="从业经历" prop="experience">
            <el-input
              v-model="formData.experience"
              type="textarea"
              :rows="3"
              placeholder="从业经历"
            />
          </el-form-item>
        </el-col>
        <el-col :span="12">
          <el-form-item label="展示状态" prop="displayStatus">
            <el-switch
              v-model="formData.displayStatus"
              :active-value="1"
              :inactive-value="0"
              active-text="展示"
              inactive-text="不展示"
            />
          </el-form-item>
        </el-col>
        <el-col :span="12">
          <el-form-item label="首页推荐" prop="isRecommend">
            <el-switch
              v-model="formData.isRecommend"
              :active-value="1"
              :inactive-value="0"
              active-text="推荐"
              inactive-text="不推荐"
            />
          </el-form-item>
        </el-col>
        <el-col :span="12">
          <el-form-item label="推荐排序" prop="recommendSort">
            <el-input-number v-model="formData.recommendSort" :min="0" controls-position="right" class="!w-full" />
          </el-form-item>
        </el-col>
        <el-col :span="12">
          <el-form-item label="排序" prop="sort">
            <el-input-number v-model="formData.sort" :min="0" controls-position="right" class="!w-full" />
          </el-form-item>
        </el-col>
        <el-col :span="12">
          <el-form-item label="状态" prop="status">
            <el-radio-group v-model="formData.status">
              <el-radio
                v-for="dict in commonStatusDict"
                :key="dict.value"
                :label="Number(dict.value)"
              >
                {{ dict.label }}
              </el-radio>
            </el-radio-group>
          </el-form-item>
        </el-col>
      </el-row>
    </el-form>
    <template #footer>
      <el-button @click="visible = false">取消</el-button>
      <el-button type="primary" @click="submitForm" :loading="formLoading">确定</el-button>
    </template>
  </el-dialog>
</template>

<script setup lang="ts">
import { AreaApi, InheritorApi, InheritorSaveVO } from '@/api/inherit/inheritor'
import { useDict } from '@/utils/dict'

defineOptions({ name: 'InheritInheritorForm' })

const message = useMessage()
const { t } = useI18n()
const { system_user_sex: sexDict, inherit_inheritor_level: levelDict, common_status: commonStatusDict } =
  useDict('system_user_sex', 'inherit_inheritor_level', 'common_status')

const visible = ref(false)
const formLoading = ref(false)
const formRef = ref()
const formData = ref<InheritorSaveVO>({
  id: undefined,
  name: '',
  gender: 0,
  avatar: '',
  cover: '',
  phone: '',
  idCard: '',
  level: undefined,
  provinceCode: undefined,
  cityCode: undefined,
  districtCode: undefined,
  introduction: '',
  profile: '',
  specialty: '',
  experience: '',
  displayStatus: 1,
  isRecommend: 0,
  recommendSort: 0,
  sort: 0,
  status: 0
})
const formRules = reactive({
  name: [{ required: true, message: '姓名不能为空', trigger: 'blur' }]
})

/** 地区级联 */
const areaTree = ref<any[]>([])
const areaProps = { value: 'id', label: 'name', children: 'children', checkStrictly: true }
const region = ref<number[]>([])

const resetForm = () => {
  formData.value = {
    id: undefined,
    name: '',
    gender: 0,
    avatar: '',
    cover: '',
    phone: '',
    idCard: '',
    level: undefined,
    provinceCode: undefined,
    cityCode: undefined,
    districtCode: undefined,
    introduction: '',
    profile: '',
    specialty: '',
    experience: '',
    displayStatus: 1,
    isRecommend: 0,
    recommendSort: 0,
    sort: 0,
    status: 0
  }
  region.value = []
}

/** 打开对话框（新增或编辑） */
const open = async (id?: number) => {
  visible.value = true
  resetForm()
  formRef.value?.clearValidate()
  if (areaTree.value.length === 0) {
    areaTree.value = await AreaApi.getAreaTree()
  }
  if (id) {
    formData.value = await InheritorApi.getInheritor(id)
    region.value = [
      formData.value.provinceCode,
      formData.value.cityCode,
      formData.value.districtCode
    ].filter((v) => v != null)
  }
}
defineExpose({ open })

/** 提交表单 */
const submitForm = async () => {
  await formRef.value.validate()
  // 同步地区
  if (region.value?.length >= 1) {
    formData.value.provinceCode = region.value[0]
  }
  if (region.value?.length >= 2) {
    formData.value.cityCode = region.value[1]
  }
  if (region.value?.length >= 3) {
    formData.value.districtCode = region.value[2]
  }
  formLoading.value = true
  try {
    if (formData.value.id) {
      await InheritorApi.updateInheritor(formData.value)
    } else {
      await InheritorApi.createInheritor(formData.value)
    }
    message.success(t('common.success'))
    visible.value = false
    emit('success')
  } finally {
    formLoading.value = false
  }
}

const emit = defineEmits(['success'])
</script>
