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
      <el-form-item label="类型" prop="type">
        <el-select v-model="queryParams.type" placeholder="请选择类型" clearable class="!w-200px">
          <el-option
            v-for="dict in qualificationTypeDict"
            :key="dict.value"
            :label="dict.label"
            :value="dict.value"
          />
        </el-select>
      </el-form-item>
      <el-form-item label="名称" prop="name">
        <el-input
          v-model="queryParams.name"
          placeholder="请输入名称"
          clearable
          @keyup.enter="handleQuery"
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
          v-hasPermi="['inherit:inheritor-qualification:create']"
        >
          <Icon icon="ep:plus" class="mr-5px" /> 新增
        </el-button>
      </el-form-item>
    </el-form>
  </ContentWrap>

  <!-- 列表 -->
  <ContentWrap>
    <el-table v-loading="loading" :data="list" stripe>
      <el-table-column label="传承人编号" align="center" prop="inheritorId" width="110" />
      <el-table-column label="类型" align="center" width="120">
        <template #default="scope">
          <DictTag :type="DICT_TYPE.INHERIT_QUALIFICATION_TYPE" :value="scope.row.type" />
        </template>
      </el-table-column>
      <el-table-column label="名称" align="center" prop="name" min-width="160" show-overflow-tooltip />
      <el-table-column label="级别" align="center" prop="level" min-width="100" />
      <el-table-column label="颁发机构" align="center" prop="issuer" min-width="140" show-overflow-tooltip />
      <el-table-column label="颁发日期" align="center" prop="issueDate" width="110" />
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
      <el-table-column label="操作" align="center" width="140" fixed="right">
        <template #default="scope">
          <el-button
            link
            type="primary"
            @click="openForm(scope.row.id)"
            v-hasPermi="['inherit:inheritor-qualification:update']"
          >
            修改
          </el-button>
          <el-button
            link
            type="danger"
            @click="handleDelete(scope.row.id)"
            v-hasPermi="['inherit:inheritor-qualification:delete']"
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
  <QualificationForm ref="formRef" @success="getList" />
</template>

<script setup lang="ts">
import { dateFormatter } from '@/utils/formatTime'
import { InheritorQualificationApi } from '@/api/inherit/inheritorQualification'
import QualificationForm from './components/QualificationForm.vue'
import { DICT_TYPE, useDict } from '@/utils/dict'

defineOptions({ name: 'InheritInheritorQualification' })

const message = useMessage()
const { t } = useI18n()
const { inherit_qualification_type: qualificationTypeDict } = useDict('inherit_qualification_type')

const loading = ref(true)
const list = ref<any[]>([])
const total = ref(0)
const queryParams = reactive({
  pageNo: 1,
  pageSize: 10,
  inheritorId: undefined,
  type: undefined,
  name: undefined
})
const queryFormRef = ref()

/** 查询列表 */
const getList = async () => {
  loading.value = true
  try {
    const data = await InheritorQualificationApi.getInheritorQualificationPage(queryParams)
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
    await InheritorQualificationApi.deleteInheritorQualification(id)
    message.success(t('common.delSuccess'))
    await getList()
  } catch {}
}

onMounted(() => {
  getList()
})
</script>
