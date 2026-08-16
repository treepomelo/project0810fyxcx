<template>
  <ContentWrap>
    <!-- 搜索工作栏 -->
    <el-form
      class="-mb-15px"
      :model="queryParams"
      ref="queryFormRef"
      :inline="true"
      label-width="80px"
    >
      <el-form-item label="姓名" prop="name">
        <el-input
          v-model="queryParams.name"
          placeholder="请输入姓名"
          clearable
          @keyup.enter="handleQuery"
          class="!w-220px"
        />
      </el-form-item>
      <el-form-item label="级别" prop="level">
        <el-select
          v-model="queryParams.level"
          placeholder="请选择传承人级别"
          clearable
          class="!w-200px"
        >
          <el-option
            v-for="dict in levelDict"
            :key="dict.value"
            :label="dict.label"
            :value="dict.value"
          />
        </el-select>
      </el-form-item>
      <el-form-item label="审核状态" prop="auditStatus">
        <el-select
          v-model="queryParams.auditStatus"
          placeholder="请选择审核状态"
          clearable
          class="!w-140px"
        >
          <el-option label="待审核" value="0" />
          <el-option label="已通过" value="1" />
          <el-option label="未通过" value="2" />
        </el-select>
      </el-form-item>
      <el-form-item label="状态" prop="status">
        <el-select
          v-model="queryParams.status"
          placeholder="请选择状态"
          clearable
          class="!w-120px"
        >
          <el-option
            v-for="dict in commonStatusDict"
            :key="dict.value"
            :label="dict.label"
            :value="dict.value"
          />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button @click="handleQuery"><Icon icon="ep:search" class="mr-5px" /> 搜索</el-button>
        <el-button @click="resetQuery"><Icon icon="ep:refresh" class="mr-5px" /> 重置</el-button>
        <el-button
          type="primary"
          plain
          @click="openForm()"
          v-hasPermi="['inherit:inheritor:create']"
        >
          <Icon icon="ep:plus" class="mr-5px" /> 新增
        </el-button>
      </el-form-item>
    </el-form>
  </ContentWrap>

  <!-- 列表 -->
  <ContentWrap>
    <el-table v-loading="loading" :data="list" stripe>
      <el-table-column label="头像" align="center" width="80">
        <template #default="scope">
          <el-avatar :src="scope.row.avatar" :size="42">
            {{ scope.row.name?.charAt(0) }}
          </el-avatar>
        </template>
      </el-table-column>
      <el-table-column label="姓名" align="center" prop="name" min-width="100" />
      <el-table-column label="级别" align="center" prop="level" min-width="140" />
      <el-table-column label="地区" align="center" min-width="160">
        <template #default="scope">
          {{ scope.row.provinceName || '' }}{{ scope.row.cityName || '' }}{{
            scope.row.districtName || ''
          }}
        </template>
      </el-table-column>
      <el-table-column label="擅长技艺" align="center" prop="specialty" min-width="150" show-overflow-tooltip />
      <el-table-column label="关注数" align="center" prop="followCount" width="80" />
      <el-table-column label="审核状态" align="center" width="100">
        <template #default="scope">
          <el-tag :type="auditTagType(scope.row.auditStatus)">
            {{ auditStatusText(scope.row.auditStatus) }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column label="展示" align="center" width="80">
        <template #default="scope">
          <el-tag :type="scope.row.displayStatus === 1 ? 'success' : 'info'">
            {{ scope.row.displayStatus === 1 ? '展示中' : '未展示' }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column label="状态" align="center" width="80">
        <template #default="scope">
          <el-tag :type="scope.row.status === 0 ? 'success' : 'danger'">
            {{ scope.row.status === 0 ? '正常' : '停用' }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column
        label="创建时间"
        align="center"
        prop="createTime"
        :formatter="dateFormatter"
        width="160"
      />
      <el-table-column label="操作" align="center" width="190" fixed="right">
        <template #default="scope">
          <el-button
            link
            type="primary"
            @click="openForm(scope.row.id)"
            v-hasPermi="['inherit:inheritor:update']"
          >
            修改
          </el-button>
          <el-button
            link
            type="warning"
            @click="openAudit(scope.row)"
            v-hasPermi="['inherit:inheritor:audit']"
          >
            审核
          </el-button>
          <el-button
            link
            type="danger"
            @click="handleDelete(scope.row.id)"
            v-hasPermi="['inherit:inheritor:delete']"
          >
            删除
          </el-button>
        </template>
      </el-table-column>
    </el-table>
    <!-- 分页 -->
    <Pagination
      :total="total"
      v-model:page="queryParams.pageNo"
      v-model:limit="queryParams.pageSize"
      @pagination="getList"
    />
  </ContentWrap>

  <!-- 新增/修改 对话框 -->
  <InheritorForm ref="formRef" @success="getList" />

  <!-- 审核 对话框 -->
  <el-dialog title="审核传承人" v-model="auditVisible" width="500px">
    <el-form ref="auditFormRef" :model="auditForm" :rules="auditRules" label-width="80px">
      <el-form-item label="姓名">
        <span>{{ auditForm.name }}</span>
      </el-form-item>
      <el-form-item label="审核结果" prop="auditStatus">
        <el-radio-group v-model="auditForm.auditStatus">
          <el-radio :label="1">通过</el-radio>
          <el-radio :label="2">不通过</el-radio>
        </el-radio-group>
      </el-form-item>
      <el-form-item label="审核备注" prop="auditRemark">
        <el-input
          v-model="auditForm.auditRemark"
          type="textarea"
          :rows="3"
          placeholder="请输入审核备注"
        />
      </el-form-item>
    </el-form>
    <template #footer>
      <el-button @click="auditVisible = false">取消</el-button>
      <el-button type="primary" @click="submitAudit" :loading="formLoading">确定</el-button>
    </template>
  </el-dialog>
</template>

<script setup lang="ts">
import { dateFormatter } from '@/utils/formatTime'
import { InheritorApi } from '@/api/inherit/inheritor'
import InheritorForm from './components/InheritorForm.vue'
import { useDict } from '@/utils/dict'

defineOptions({ name: 'InheritInheritor' })

const message = useMessage()
const { t } = useI18n()
const { inherit_inheritor_level: levelDict, common_status: commonStatusDict } = useDict(
  'inherit_inheritor_level',
  'common_status'
)

const loading = ref(true)
const list = ref<any[]>([])
const total = ref(0)
const queryParams = reactive({
  pageNo: 1,
  pageSize: 10,
  name: undefined,
  level: undefined,
  auditStatus: undefined,
  status: undefined
})
const queryFormRef = ref()

/** 查询列表 */
const getList = async () => {
  loading.value = true
  try {
    const data = await InheritorApi.getInheritorPage(queryParams)
    list.value = data.list
    total.value = data.total
  } finally {
    loading.value = false
  }
}

/** 搜索按钮操作 */
const handleQuery = () => {
  queryParams.pageNo = 1
  getList()
}

/** 重置按钮操作 */
const resetQuery = () => {
  queryFormRef.value.resetFields()
  handleQuery()
}

/** 新增/修改 操作 */
const formRef = ref()
const openForm = (id?: number) => {
  formRef.value.open(id)
}

/** 删除按钮操作 */
const handleDelete = async (id: number) => {
  try {
    await message.delConfirm()
    await InheritorApi.deleteInheritor(id)
    message.success(t('common.delSuccess'))
    await getList()
  } catch {}
}

/** 审核状态展示 */
const auditStatusText = (status: number) => {
  const map = { 0: '待审核', 1: '已通过', 2: '未通过' }
  return map[status] ?? '未知'
}
const auditTagType = (status: number) => {
  const map = { 0: 'warning', 1: 'success', 2: 'danger' }
  return map[status] ?? 'info'
}

/** 审核 对话框 */
const auditVisible = ref(false)
const auditFormRef = ref()
const formLoading = ref(false)
const auditForm = ref({
  id: 0,
  name: '',
  auditStatus: 1,
  auditRemark: ''
})
const auditRules = reactive({
  auditStatus: [{ required: true, message: '请选择审核结果', trigger: 'change' }]
})
const openAudit = (row: any) => {
  auditForm.value.id = row.id
  auditForm.value.name = row.name
  auditForm.value.auditStatus = 1
  auditForm.value.auditRemark = ''
  auditVisible.value = true
}
const submitAudit = async () => {
  await auditFormRef.value.validate()
  formLoading.value = true
  try {
    await InheritorApi.updateInheritorAudit({
      id: auditForm.value.id,
      auditStatus: auditForm.value.auditStatus,
      auditRemark: auditForm.value.auditRemark
    })
    message.success(t('common.success'))
    auditVisible.value = false
    await getList()
  } finally {
    formLoading.value = false
  }
}

onMounted(() => {
  getList()
})
</script>
