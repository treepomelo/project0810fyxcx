<template>
  <el-dialog
    :title="formData.id ? '修改关系' : '新增关系'"
    v-model="visible"
    width="560px"
    top="10vh"
    destroy-on-close
  >
    <el-form ref="formRef" :model="formData" :rules="formRules" label-width="110px">
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
      <el-form-item label="非遗项目编号" prop="projectId">
        <el-input-number
          v-model="formData.projectId"
          placeholder="请输入非遗项目编号"
          :min="1"
          controls-position="right"
          class="!w-full"
        />
        <div class="text-gray-500 text-12px">
          非遗项目主数据属未来 HeritageProject 模块，此处仅填项目编号（弱关联）。
        </div>
      </el-form-item>
      <el-form-item label="是否主打" prop="isPrimary">
        <el-switch v-model="formData.isPrimary" />
      </el-form-item>
      <el-form-item label="排序" prop="sort">
        <el-input-number v-model="formData.sort" :min="0" controls-position="right" class="!w-full" />
      </el-form-item>
    </el-form>
    <template #footer>
      <el-button @click="visible = false">取消</el-button>
      <el-button type="primary" @click="submitForm" :loading="formLoading">确定</el-button>
    </template>
  </el-dialog>
</template>

<script setup lang="ts">
import {
  InheritorProjectRelationApi,
  InheritorProjectRelationSaveVO
} from '@/api/inherit/inheritorProjectRelation'
import { InheritorApi } from '@/api/inherit/inheritor'

defineOptions({ name: 'InheritInheritorProjectRelationForm' })

const message = useMessage()
const { t } = useI18n()

const visible = ref(false)
const formLoading = ref(false)
const formRef = ref()
const inheritorOptions = ref<any[]>([])
const formData = ref<InheritorProjectRelationSaveVO>({
  id: undefined,
  inheritorId: undefined,
  projectId: undefined,
  isPrimary: false,
  sort: 0
})
const formRules = reactive({
  inheritorId: [{ required: true, message: '传承人不能为空', trigger: 'change' }],
  projectId: [{ required: true, message: '非遗项目编号不能为空', trigger: 'blur' }]
})

const resetForm = () => {
  formData.value = {
    id: undefined,
    inheritorId: undefined,
    projectId: undefined,
    isPrimary: false,
    sort: 0
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
    formData.value = await InheritorProjectRelationApi.getInheritorProjectRelation(id)
  }
}
defineExpose({ open })

/** 提交表单 */
const submitForm = async () => {
  await formRef.value.validate()
  formLoading.value = true
  try {
    if (formData.value.id) {
      await InheritorProjectRelationApi.updateInheritorProjectRelation(formData.value)
    } else {
      await InheritorProjectRelationApi.createInheritorProjectRelation(formData.value)
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
