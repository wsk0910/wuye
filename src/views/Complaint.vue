<template>
  <div class="page-container">
    <div class="search-bar">
      <el-input v-model="query.keyword" placeholder="搜索标题/内容" clearable style="width: 200px" @keyup.enter="loadData" />
      <el-select v-model="query.type" placeholder="类型" clearable style="width: 100px">
        <el-option label="投诉" :value="1" />
        <el-option label="建议" :value="2" />
      </el-select>
      <el-select v-model="query.status" placeholder="状态" clearable style="width: 100px">
        <el-option label="待处理" :value="0" />
        <el-option label="处理中" :value="1" />
        <el-option label="已处理" :value="2" />
      </el-select>
      <el-button type="primary" @click="loadData">搜索</el-button>
      <el-button type="success" @click="handleAdd" v-if="user?.role === 3">提交投诉/建议</el-button>
    </div>
    <el-table :data="tableData" border stripe>
      <el-table-column prop="id" label="ID" width="80" />
      <el-table-column prop="type" label="类型" width="80">
        <template #default="{ row }">
          <el-tag :type="row.type === 1 ? 'danger' : 'success'">{{ row.type === 1 ? '投诉' : '建议' }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="title" label="标题" />
      <el-table-column prop="content" label="内容" show-overflow-tooltip />
      <el-table-column prop="status" label="状态" width="80">
        <template #default="{ row }">
          <el-tag :type="statusTypes[row.status]">{{ statusNames[row.status] }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="reply" label="回复" show-overflow-tooltip />
      <el-table-column prop="createTime" label="创建时间" width="180" />
      <el-table-column label="操作" width="150">
        <template #default="{ row }">
          <el-button link type="primary" @click="handleView(row)">详情</el-button>
          <el-button link type="success" @click="handleHandle(row)" v-if="row.status !== 2 && [1,2].includes(user?.role)">处理</el-button>
        </template>
      </el-table-column>
    </el-table>
    <div class="pagination">
      <el-pagination v-model:current-page="query.page" v-model:page-size="query.size" :total="total" :page-sizes="[10, 20, 50]" layout="total, sizes, prev, pager, next" @change="loadData" />
    </div>

    <el-dialog v-model="dialogVisible" :title="dialogTitle" width="500px">
      <el-form :model="form" label-width="80px" v-if="dialogType === 'add'">
        <el-form-item label="类型">
          <el-radio-group v-model="form.type">
            <el-radio :value="1">投诉</el-radio>
            <el-radio :value="2">建议</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="标题"><el-input v-model="form.title" /></el-form-item>
        <el-form-item label="内容"><el-input v-model="form.content" type="textarea" :rows="4" /></el-form-item>
      </el-form>
      <el-descriptions :column="1" border v-if="dialogType === 'view'">
        <el-descriptions-item label="类型">{{ form.type === 1 ? '投诉' : '建议' }}</el-descriptions-item>
        <el-descriptions-item label="标题">{{ form.title }}</el-descriptions-item>
        <el-descriptions-item label="内容">{{ form.content }}</el-descriptions-item>
        <el-descriptions-item label="状态">{{ statusNames[form.status] }}</el-descriptions-item>
        <el-descriptions-item label="回复">{{ form.reply || '-' }}</el-descriptions-item>
      </el-descriptions>
      <el-form :model="form" label-width="80px" v-if="dialogType === 'handle'">
        <el-form-item label="回复"><el-input v-model="form.reply" type="textarea" :rows="4" /></el-form-item>
      </el-form>
      <template #footer v-if="dialogType !== 'view'">
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
const statusNames = { 0: '待处理', 1: '处理中', 2: '已处理' }
const statusTypes = { 0: 'danger', 1: 'warning', 2: 'success' }
const query = ref({ page: 1, size: 10, keyword: '', type: null, status: null })
const tableData = ref([])
const total = ref(0)
const dialogVisible = ref(false)
const dialogType = ref('')
const form = ref({})

const dialogTitle = computed(() => {
  const titles = { add: '提交投诉/建议', view: '详情', handle: '处理' }
  return titles[dialogType.value]
})

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
  const res = await request.get('/complaint/page', { params })
  tableData.value = res.data.records
  total.value = res.data.total
}

const handleAdd = async () => {
  const ownerRes = await request.get(`/owner/user/${user.value.id}`)
  if (!ownerRes.data) {
    ElMessage.error('您还未绑定业主信息，请联系物业管理员')
    return
  }
  form.value = { ownerId: ownerRes.data.id, type: 1 }
  dialogType.value = 'add'
  dialogVisible.value = true
}

const handleView = (row) => {
  form.value = { ...row }
  dialogType.value = 'view'
  dialogVisible.value = true
}

const handleHandle = (row) => {
  form.value = { id: row.id, reply: '', handlerId: user.value?.id }
  dialogType.value = 'handle'
  dialogVisible.value = true
}

const handleSave = async () => {
  if (dialogType.value === 'add') {
    await request.post('/complaint', form.value)
  } else {
    await request.put(`/complaint/handle/${form.value.id}`, form.value)
  }
  ElMessage.success('操作成功')
  dialogVisible.value = false
  loadData()
}

onMounted(loadData)
</script>
