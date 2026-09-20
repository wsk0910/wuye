<template>
  <div class="page-container">
    <div class="search-bar">
      <el-input v-model="query.keyword" placeholder="搜索访客姓名/电话" clearable style="width: 200px" @keyup.enter="loadData" />
      <el-select v-model="query.status" placeholder="状态" clearable style="width: 100px">
        <el-option label="待审核" :value="0" />
        <el-option label="已通过" :value="1" />
        <el-option label="已拒绝" :value="2" />
        <el-option label="已来访" :value="3" />
      </el-select>
      <el-button type="primary" @click="loadData">搜索</el-button>
      <el-button type="success" @click="handleAdd" v-if="user?.role === 3">预约访客</el-button>
    </div>
    <el-table :data="tableData" border stripe>
      <el-table-column prop="id" label="ID" width="80" />
      <el-table-column prop="visitorName" label="访客姓名" />
      <el-table-column prop="visitorPhone" label="访客电话" />
      <el-table-column prop="reason" label="来访事由" show-overflow-tooltip />
      <el-table-column prop="visitTime" label="预计来访时间" width="180" />
      <el-table-column prop="status" label="状态" width="80">
        <template #default="{ row }">
          <el-tag :type="statusTypes[row.status]">{{ statusNames[row.status] }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="createTime" label="创建时间" width="180" />
      <el-table-column label="操作" width="200">
        <template #default="{ row }">
          <template v-if="row.status === 0 && [1,2].includes(user?.role)">
            <el-button link type="success" @click="handleApprove(row, 1)">通过</el-button>
            <el-button link type="danger" @click="handleApprove(row, 2)">拒绝</el-button>
          </template>
          <el-button link type="primary" @click="handleVisit(row)" v-if="row.status === 1 && [1,2].includes(user?.role)">登记来访</el-button>
          <el-popconfirm title="确定删除?" @confirm="handleDelete(row.id)" v-if="[1,2].includes(user?.role) || (user?.role === 3 && row.status === 0)">
            <template #reference><el-button link type="danger">删除</el-button></template>
          </el-popconfirm>
        </template>
      </el-table-column>
    </el-table>
    <div class="pagination">
      <el-pagination v-model:current-page="query.page" v-model:page-size="query.size" :total="total" :page-sizes="[10, 20, 50]" layout="total, sizes, prev, pager, next" @change="loadData" />
    </div>

    <el-dialog v-model="dialogVisible" title="预约访客" width="500px">
      <el-form :model="form" label-width="100px">
        <el-form-item label="访客姓名"><el-input v-model="form.visitorName" /></el-form-item>
        <el-form-item label="访客电话"><el-input v-model="form.visitorPhone" /></el-form-item>
        <el-form-item label="访客身份证"><el-input v-model="form.visitorIdCard" /></el-form-item>
        <el-form-item label="来访事由"><el-input v-model="form.reason" /></el-form-item>
        <el-form-item label="预计来访时间">
          <el-date-picker v-model="form.visitTime" type="datetime" style="width: 100%" />
        </el-form-item>
        <el-form-item label="备注"><el-input v-model="form.remark" /></el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleSave">确定</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue'
import request from '../utils/request'
import { ElMessage } from 'element-plus'
import { useUserStore } from '../stores/user'

const userStore = useUserStore()
const user = computed(() => userStore.user)
const statusNames = { 0: '待审核', 1: '已通过', 2: '已拒绝', 3: '已来访' }
const statusTypes = { 0: 'warning', 1: 'success', 2: 'danger', 3: 'info' }
const query = ref({ page: 1, size: 10, keyword: '', status: null })
const tableData = ref([])
const total = ref(0)
const dialogVisible = ref(false)
const form = ref({})

const loadData = async () => {
  const params = { ...query.value }
  if (user.value?.role === 3) {
    const ownerRes = await request.get(`/owner/user/${user.value.id}`)
    if (ownerRes.data) {
      params.ownerId = ownerRes.data.id
    } else {
      tableData.value = []
      total.value = 0
      return
    }
  }
  const res = await request.get('/visitor/page', { params })
  tableData.value = res.data.records
  total.value = res.data.total
}

const handleAdd = async () => {
  const ownerRes = await request.get(`/owner/user/${user.value.id}`)
  if (!ownerRes.data) {
    ElMessage.error('您还未绑定业主信息，请联系物业管理员')
    return
  }
  form.value = { ownerId: ownerRes.data.id }
  dialogVisible.value = true
}

const handleSave = async () => {
  await request.post('/visitor', form.value)
  ElMessage.success('操作成功')
  dialogVisible.value = false
  loadData()
}

const handleApprove = async (row, status) => {
  await request.put(`/visitor/approve/${row.id}`, null, { params: { status } })
  ElMessage.success('操作成功')
  loadData()
}

const handleVisit = async (row) => {
  await request.put(`/visitor/visit/${row.id}`)
  ElMessage.success('登记成功')
  loadData()
}

const handleDelete = async (id) => {
  await request.delete(`/visitor/${id}`)
  ElMessage.success('删除成功')
  loadData()
}

onMounted(loadData)
</script>
