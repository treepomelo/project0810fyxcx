<template>
  <el-dialog
    :title="formData.id ? '修改作品' : '新增作品'"
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
      <el-form-item label="作品名称" prop="name">
        <el-input v-model="formData.name" placeholder="请输入作品名称" maxlength="128" />
      </el-form-item>
      <el-row :gutter="16">
        <el-col :span="12">
          <el-form-item label="创作年份" prop="year">
            <el-input v-model="formData.year" placeholder="请输入创作年份" maxlength="32" />
          </el-form-item>
        </el-col>
        <el-col :span="12">
          <el-form-item label="材质" prop="material">
            <el-input v-model="formData.material" placeholder="请输入材质" maxlength="64" />
          </el-form-item>
        </el-col>
      </el-row>
      <el-form-item label="工艺/技法" prop="technique">
        <el-input v-model="formData.technique" placeholder="请输入工艺/技法" maxlength="128" />
      </el-form-item>
      <el-form-item label="封面图" prop="cover">
        <FileUpload v-model="formData.cover" />
      </el-form-item>
      <el-form-item label="作品图集" prop="images">
        <FileUpload v-model="formData.images" :limit="9" />
      </el-form-item>
      <el-form-item label="作品描述" prop="description">
        <el-input
          v-model="formData.description"
          type="textarea"
          :rows="2"
          placeholder="请输入作品描述"
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
import { InheritorWorkApi, InheritorWorkSaveVO } from '@/api/inherit/inheritorWork'
import { InheritorApi } from '@/api/inherit/inheritor'
import { useDict } from '@/utils/dict'

defineOptions({ name: 'InheritInheritorWorkForm' })

const message = useMessage()
const { t } = useI18n()
const { common_status: commonStatusDict } = useDict('common_status')

const visible = ref(false)
const formLoading = ref(false)
const formRef = ref()
const inheritorOptions = ref<any[]>([])
const formData = ref<InheritorWorkSaveVO>({
  id: undefined,
  inheritorId: undefined,
  name: '',
  cover: '',
  images: [],
  description: '',
  year: '',
  material: '',
  technique: '',
  sort: 0,
  status: 0
})
const formRules = reactive({
  inheritorId: [{ required: true, message: '传承人不能为空', trigger: 'change' }],
  name: [{ required: true, message: '作品名称不能为空', trigger: 'blur' }]
})

const resetForm = () => {
  formData.value = {
    id: undefined,
    inheritorId: undefined,
    name: '',
    cover: '',
    images: [],
    description: '',
    year: '',
    material: '',
    technique: '',
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
    formData.value = await InheritorWorkApi.getInheritorWork(id)
  }
}
defineExpose({ open })

/** 提交表单 */
const submitForm = async () => {
  await formRef.value.validate()
  formLoading.value = true
  try {
    if (formData.value.id) {
      await InheritorWorkApi.updateInheritorWork(formData.value)
    } else {
      await InheritorWorkApi.createInheritorWork(formData.value)
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
