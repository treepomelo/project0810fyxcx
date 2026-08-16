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
      <el-form-item label="传承人编号" prop="inheritorId">
        <el-input-number
          v-model="queryParams.inheritorId"
          placeholder="请输入传承人编号"
          :min="1"
          controls-position="right"
          class="!w-200px"
        />
      </el-form-item>
      <el-form-item label="非遗项目" prop="projectId">
        <el-input-number
          v-model="queryParams.projectId"
          placeholder="请输入非遗项目编号"
          :min="1"
          controls-position="right"
          class="!w-200px"
        />
      </el-form-item>
      <el-form-item>
        <el-button @click="handleQuery"><Icon icon="ep:search" class="mr-5px" /> 搜索</el-button>
        <el-button @click="resetQuery"><Icon icon="ep:refresh" class="mr-5px" /> 重置</el-button>
        <el-button
          type="primary"
          plain
          @click="openForm()"
          v-hasPermi="['inherit:inheritor-project-relation:create']"
        >
          <Icon icon="ep:plus" class="mr-5px" /> 新增
        </el-button>
      </el-form-item>
    </el-form>
  </ContentWrap>

  <!-- 列表 -->
  <ContentWrap>
    <el-table v-loading="loading" :data="list" stripe>
      <el-table-column label="传承人编号" align="center" prop="inheritorId" width="120" />
      <el-table-column label="非遗项目编号" align="center" prop="projectId" width="130" />
      <el-table-column label="是否主打" align="center" width="100">
        <template #default="scope">
          <el-tag :type="scope.row.isPrimary ? 'warning' : 'info'">
            {{ scope.row.isPrimary ? '主打' : '非主打' }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column label="排序" align="center" prop="sort" width="80" />
      <el-table-column
        label="创建时间"
        align="center"
        prop="createTime"
        :formatter="dateFormatter"
        width="160"
      />
      <el-table-column label="操作" align="center" width="140" fixed="right">
        <template #default="scope">
          <el-button
            link
            type="primary"
            @click="openForm(scope.row.id)"
            v-hasPermi="['inherit:inheritor-project-relation:update']"
          >
            修改
          </el-button>
          <el-button
            link
            type="danger"
            @click="handleDelete(scope.row.id)"
            v-hasPermi="['inherit:inheritor-project-relation:delete']"
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
  <ProjectRelationForm ref="formRef" @success="getList" />
</template>

<script setup lang="ts">
import { dateFormatter } from '@/utils/formatTime'
import { InheritorProjectRelationApi } from '@/api/inherit/inheritorProjectRelation'
import ProjectRelationForm from './components/ProjectRelationForm.vue'

defineOptions({ name: 'InheritInheritorProjectRelation' })

const message = useMessage()
const { t } = useI18n()

const loading = ref(true)
const list = ref<any[]>([])
const total = ref(0)
const queryParams = reactive({
  pageNo: 1,
  pageSize: 10,
  inheritorId: undefined,
  projectId: undefined
})
const queryFormRef = ref()

/** 查询列表 */
const getList = async () => {
  loading.value = true
  try {
    const data = await InheritorProjectRelationApi.getInheritorProjectRelationPage(queryParams)
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
    await InheritorProjectRelationApi.deleteInheritorProjectRelation(id)
    message.success(t('common.delSuccess'))
    await getList()
  } catch {}
}

onMounted(() => {
  getList()
})
</script>
