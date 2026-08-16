<template>
  <el-dialog
    :title="formData.id ? '修改荣誉/资质' : '新增荣誉/资质'"
    v-model="visible"
    width="640px"
    top="5vh"
    destroy-on-close
  >
    <el-form ref="formRef" :model="formData" :rules="formRules" label-width="100px">
      <el-form-item label="传承人" prop="inheritorId">
        <el-select
          v-model="formData.inheritorId"
          placeholder="请选择传承人"
          filterable
          class="!w-full"
        >
          <el-option
            v-for="item in inheritorOptions"
            :key="item.id"
            :label="`${item.name}（${item.id}）`"
            :value="item.id"
          />
        </el-select>
      </el-form-item>
      <el-form-item label="类型" prop="type">
        <el-select v-model="formData.type" placeholder="请选择类型" clearable class="!w-full">
          <el-option
            v-for="dict in qualificationTypeDict"
            :key="dict.value"
            :label="dict.label"
            :value="dict.value"
          />
        </el-select>
      </el-form-item>
      <el-form-item label="名称" prop="name">
        <el-input v-model="formData.name" placeholder="请输入名称" maxlength="128" />
      </el-form-item>
      <el-form-item label="级别" prop="level">
        <el-input v-model="formData.level" placeholder="请输入级别" maxlength="64" />
      </el-form-item>
      <el-form-item label="颁发机构" prop="issuer">
        <el-input v-model="formData.issuer" placeholder="请输入颁发机构" maxlength="128" />
      </el-form-item>
      <el-form-item label="颁发日期" prop="issueDate">
        <el-date-picker
          v-model="formData.issueDate"
          type="date"
          value-format="YYYY-MM-DD"
          placeholder="请选择颁发日期"
          class="!w-full"
        />
      </el-form-item>
      <el-form-item label="证书编号" prop="certificateNo">
        <el-input v-model="formData.certificateNo" placeholder="请输入证书编号" maxlength="64" />
      </el-form-item>
      <el-form-item label="图片" prop="imageUrl">
        <FileUpload v-model="formData.imageUrl" />
      </el-form-item>
      <el-form-item label="描述" prop="description">
        <el-input
          v-model="formData.description"
          type="textarea"
          :rows="2"
          placeholder="请输入描述"
        />
      </el-form-item>
      <el-row :gutter="16">
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
import {
  InheritorQualificationApi,
  InheritorQualificationSaveVO
} from '@/api/inherit/inheritorQualification'
import { InheritorApi } from '@/api/inherit/inheritor'
import { useDict } from '@/utils/dict'

defineOptions({ name: 'InheritInheritorQualificationForm' })

const message = useMessage()
const { t } = useI18n()
const { inherit_qualification_type: qualificationTypeDict, common_status: commonStatusDict } =
  useDict('inherit_qualification_type', 'common_status')

const visible = ref(false)
const formLoading = ref(false)
const formRef = ref()
const inheritorOptions = ref<any[]>([])
const formData = ref<InheritorQualificationSaveVO>({
  id: undefined,
  inheritorId: undefined,
  type: undefined,
  name: '',
  level: '',
  issuer: '',
  issueDate: undefined,
  certificateNo: '',
  description: '',
  imageUrl: '',
  sort: 0,
  status: 0
})
const formRules = reactive({
  inheritorId: [{ required: true, message: '传承人不能为空', trigger: 'change' }],
  type: [{ required: true, message: '类型不能为空', trigger: 'change' }],
  name: [{ required: true, message: '名称不能为空', trigger: 'blur' }]
})

const resetForm = () => {
  formData.value = {
    id: undefined,
    inheritorId: undefined,
    type: undefined,
    name: '',
    level: '',
    issuer: '',
    issueDate: undefined,
    certificateNo: '',
    description: '',
    imageUrl: '',
    sort: 0,
    status: 0
  }
}

/** 打开对话框（新增或编辑） */
const open = async (id?: number) => {
  visible.value = true
  resetForm()
  formRef.value?.clearValidate()
  if (inheritorOptions.value.length === 0) {
    const data = await InheritorApi.getInheritorPage({ pageNo: 1, pageSize: 100 })
    inheritorOptions.value = data.list
  }
  if (id) {
    formData.value = await InheritorQualificationApi.getInheritorQualification(id)
  }
}
defineExpose({ open })

/** 提交表单 */
const submitForm = async () => {
  await formRef.value.validate()
  formLoading.value = true
  try {
    if (formData.value.id) {
      await InheritorQualificationApi.updateInheritorQualification(formData.value)
    } else {
      await InheritorQualificationApi.createInheritorQualification(formData.value)
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
