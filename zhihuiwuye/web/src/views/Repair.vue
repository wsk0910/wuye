<template>
  <div class="page-container">
    <div class="search-bar">
      <el-input v-model="query.keyword" placeholder="搜索标题/内容" clearable style="width: 200px" @keyup.enter="loadData" />
      <el-select v-model="query.status" placeholder="状态" clearable style="width: 120px">
        <el-option label="待处理" :value="0" />
        <el-option label="已派单" :value="1" />
        <el-option label="维修中" :value="2" />
        <el-option label="待缴费" :value="3" />
        <el-option label="待评价" :value="4" />
        <el-option label="已完成" :value="5" />
      </el-select>
      <el-button type="primary" @click="loadData">搜索</el-button>
      <el-button type="success" @click="handleAdd" v-if="user?.role === 3">发起报修</el-button>
    </div>
    <el-table :data="tableData" border stripe>
      <el-table-column prop="id" label="ID" width="80" />
      <el-table-column prop="title" label="标题" />
      <el-table-column prop="content" label="内容" show-overflow-tooltip />
      <el-table-column prop="status" label="状态" width="100">
        <template #default="{ row }">
          <el-tag :type="statusTypes[row.status]">{{ statusNames[row.status] }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="cost" label="维修费" width="100">
        <template #default="{ row }">{{ row.cost ? '¥' + row.cost : '-' }}</template>
      </el-table-column>
      <el-table-column prop="rating" label="评分" width="80">
        <template #default="{ row }">{{ row.rating ? row.rating + '分' : '-' }}</template>
      </el-table-column>
      <el-table-column prop="createTime" label="创建时间" width="180" />
      <el-table-column label="操作" width="220">
        <template #default="{ row }">
          <el-button link type="primary" @click="handleView(row)">详情</el-button>
          <el-button link type="warning" @click="handleAssign(row)" v-if="row.status === 0 && [1,2].includes(user?.role)">派单</el-button>
          <el-button link type="success" @click="handleStart(row)" v-if="row.status === 1 && user?.role === 4">开始</el-button>
          <el-button link type="success" @click="handleComplete(row)" v-if="row.status === 2 && user?.role === 4">完成</el-button>
          <el-button link type="warning" @click="handlePay(row)" v-if="row.status === 3 && user?.role === 3 && row.cost > 0">缴费</el-button>
          <el-button link type="primary" @click="handleEvaluate(row)" v-if="row.status === 4 && user?.role === 3">评价</el-button>
        </template>
      </el-table-column>
    </el-table>
    <div class="pagination">
      <el-pagination v-model:current-page="query.page" v-model:page-size="query.size" :total="total" :page-sizes="[10, 20, 50]" layout="total, sizes, prev, pager, next" @change="loadData" />
    </div>

    <el-dialog v-model="dialogVisible" :title="dialogTitle" width="500px">
      <el-form :model="form" label-width="80px">
        <template v-if="dialogType === 'add'">
          <el-form-item label="标题"><el-input v-model="form.title" /></el-form-item>
          <el-form-item label="内容"><el-input v-model="form.content" type="textarea" :rows="4" /></el-form-item>
        </template>
        <template v-if="dialogType === 'view'">
          <el-descriptions :column="1" border>
            <el-descriptions-item label="标题">{{ form.title }}</el-descriptions-item>
            <el-descriptions-item label="内容">{{ form.content }}</el-descriptions-item>
            <el-descriptions-item label="状态">{{ statusNames[form.status] }}</el-descriptions-item>
            <el-descriptions-item label="维修费用">{{ form.cost ? '¥' + form.cost : '-' }}</el-descriptions-item>
            <el-descriptions-item label="维修记录">{{ form.repairRecord || '-' }}</el-descriptions-item>
            <el-descriptions-item label="评分">{{ form.rating ? form.rating + '分' : '-' }}</el-descriptions-item>
            <el-descriptions-item label="评价">{{ form.comment || '-' }}</el-descriptions-item>
          </el-descriptions>
        </template>
        <template v-if="dialogType === 'assign'">
          <el-form-item label="维修工">
            <el-select v-model="form.workerId" style="width: 100%">
              <el-option v-for="w in workers" :key="w.id" :label="w.realName" :value="w.id" />
            </el-select>
          </el-form-item>
        </template>
        <template v-if="dialogType === 'complete'">
          <el-form-item label="维修费用"><el-input-number v-model="form.cost" :min="0" :precision="2" style="width: 100%" /></el-form-item>
          <el-form-item label="维修记录"><el-input v-model="form.repairRecord" type="textarea" :rows="3" /></el-form-item>
        </template>
        <template v-if="dialogType === 'pay'">
          <el-descriptions :column="1" border>
            <el-descriptions-item label="报修标题">{{ form.title }}</el-descriptions-item>
            <el-descriptions-item label="维修费用"><span style="color: #f56c6c; font-size: 18px; font-weight: bold">¥{{ form.cost }}</span></el-descriptions-item>
            <el-descriptions-item label="维修记录">{{ form.repairRecord || '-' }}</el-descriptions-item>
          </el-descriptions>
          <div style="margin-top: 20px; text-align: center; color: #909399">点击确认缴费后，费用将从您的账户扣除</div>
        </template>
        <template v-if="dialogType === 'evaluate'">
          <el-form-item label="评分"><el-rate v-model="form.rating" /></el-form-item>
          <el-form-item label="评价"><el-input v-model="form.comment" type="textarea" :rows="3" /></el-form-item>
        </template>
      </el-form>
      <template #footer v-if="dialogType !== 'view'">
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleSave">{{ dialogType === 'pay' ? '确认缴费' : '确定' }}</el-button>
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
const statusNames = { 0: '待处理', 1: '已派单', 2: '维修中', 3: '待缴费', 4: '待评价', 5: '已完成' }
const statusTypes = { 0: 'danger', 1: 'warning', 2: 'primary', 3: 'warning', 4: 'success', 5: 'info' }
const query = ref({ page: 1, size: 10, keyword: '', status: null })
const tableData = ref([])
const total = ref(0)
const dialogVisible = ref(false)
const dialogType = ref('')
const form = ref({})
const workers = ref([])

const dialogTitle = computed(() => {
  const titles = { add: '发起报修', view: '报修详情', assign: '派单', complete: '完成维修', pay: '缴纳维修费', evaluate: '评价' }
  return titles[dialogType.value]
})

const loadData = async () => {
  const params = { ...query.value }
  if (user.value?.role === 3) {
    const ownerRes = await request.get(`/owner/user/${user.value.id}`)
    if (ownerRes.data) {
      params.ownerId = ownerRes.data.id
    } else {
      // 业主没有关联owner记录，不显示任何数据
      tableData.value = []
      total.value = 0
      return
    }
  }
  if (user.value?.role === 4) params.workerId = user.value.id
  const res = await request.get('/repair/page', { params })
  tableData.value = res.data.records
  total.value = res.data.total
}

const loadWorkers = async () => {
  const res = await request.get('/user/page', { params: { role: 4, size: 100 } })
  workers.value = res.data.records
}

const handleAdd = async () => {
  const ownerRes = await request.get(`/owner/user/${user.value.id}`)
  if (!ownerRes.data) {
    ElMessage.error('您还未绑定业主信息，请联系物业管理员')
    return
  }
  form.value = { ownerId: ownerRes.data.id }
  dialogType.value = 'add'
  dialogVisible.value = true
}

const handleView = (row) => {
  form.value = { ...row }
  dialogType.value = 'view'
  dialogVisible.value = true
}

const handleAssign = (row) => {
  form.value = { id: row.id, workerId: null }
  dialogType.value = 'assign'
  dialogVisible.value = true
  loadWorkers()
}

const handleStart = async (row) => {
  await request.put(`/repair/start/${row.id}`)
  ElMessage.success('开始维修')
  loadData()
}

const handleComplete = (row) => {
  form.value = { id: row.id, cost: 0, repairRecord: '' }
  dialogType.value = 'complete'
  dialogVisible.value = true
}

const handlePay = (row) => {
  form.value = { ...row }
  dialogType.value = 'pay'
  dialogVisible.value = true
}

const handleEvaluate = (row) => {
  form.value = { id: row.id, rating: 5, comment: '' }
  dialogType.value = 'evaluate'
  dialogVisible.value = true
}

const handleSave = async () => {
  if (dialogType.value === 'add') {
    await request.post('/repair', form.value)
  } else if (dialogType.value === 'assign') {
    await request.put(`/repair/assign/${form.value.id}`, null, { params: { workerId: form.value.workerId } })
  } else if (dialogType.value === 'complete') {
    await request.put(`/repair/complete/${form.value.id}`, form.value)
  } else if (dialogType.value === 'pay') {
    await request.put(`/repair/pay/${form.value.id}`)
  } else if (dialogType.value === 'evaluate') {
    await request.put(`/repair/evaluate/${form.value.id}`, form.value)
  }
  ElMessage.success('操作成功')
  dialogVisible.value = false
  loadData()
}

onMounted(loadData)
</script>
