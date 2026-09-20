<template>
  <div class="page-container">
    <div class="search-bar">
      <el-select v-model="query.type" placeholder="费用类型" clearable style="width: 120px">
        <el-option label="物业费" :value="1" />
        <el-option label="水费" :value="2" />
        <el-option label="电费" :value="3" />
        <el-option label="停车费" :value="4" />
        <el-option label="其他" :value="5" />
      </el-select>
      <el-select v-model="query.status" placeholder="状态" clearable style="width: 100px">
        <el-option label="未缴" :value="0" />
        <el-option label="已缴" :value="1" />
      </el-select>
      <el-input v-model="query.period" placeholder="费用周期如2024-01" clearable style="width: 150px" />
      <el-button type="primary" @click="loadData">搜索</el-button>
      <el-button type="success" @click="handleAdd" v-if="[1,2].includes(user?.role)">新增费用</el-button>
    </div>
    <el-table :data="tableData" border stripe>
      <el-table-column prop="id" label="ID" width="80" />
      <el-table-column prop="ownerId" label="业主ID" width="80" />
      <el-table-column prop="type" label="类型" width="100">
        <template #default="{ row }">{{ typeNames[row.type] }}</template>
      </el-table-column>
      <el-table-column prop="amount" label="金额" width="100">
        <template #default="{ row }">¥{{ row.amount }}</template>
      </el-table-column>
      <el-table-column prop="period" label="周期" width="100" />
      <el-table-column prop="status" label="状态" width="80">
        <template #default="{ row }">
          <el-tag :type="row.status === 1 ? 'success' : 'danger'">{{ row.status === 1 ? '已缴' : '未缴' }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="payTime" label="缴费时间" width="180" />
      <el-table-column prop="remark" label="备注" show-overflow-tooltip />
      <el-table-column label="操作" width="150">
        <template #default="{ row }">
          <el-button link type="success" @click="handlePay(row)" v-if="row.status === 0">缴费</el-button>
          <el-popconfirm title="确定删除?" @confirm="handleDelete(row.id)" v-if="[1,2].includes(user?.role)">
            <template #reference><el-button link type="danger">删除</el-button></template>
          </el-popconfirm>
        </template>
      </el-table-column>
    </el-table>
    <div class="pagination">
      <el-pagination v-model:current-page="query.page" v-model:page-size="query.size" :total="total" :page-sizes="[10, 20, 50]" layout="total, sizes, prev, pager, next" @change="loadData" />
    </div>

    <el-dialog v-model="dialogVisible" title="新增费用" width="500px">
      <el-form :model="form" label-width="80px">
        <el-form-item label="业主">
          <el-select v-model="form.ownerId" filterable style="width: 100%">
            <el-option v-for="o in owners" :key="o.id" :label="`${o.name} - ${o.building}栋${o.unit}单元${o.room}室`" :value="o.id" />
          </el-select>
        </el-form-item>
        <el-form-item label="类型">
          <el-select v-model="form.type" style="width: 100%">
            <el-option label="物业费" :value="1" />
            <el-option label="水费" :value="2" />
            <el-option label="电费" :value="3" />
            <el-option label="停车费" :value="4" />
            <el-option label="其他" :value="5" />
          </el-select>
        </el-form-item>
        <el-form-item label="金额"><el-input-number v-model="form.amount" :min="0" :precision="2" style="width: 100%" /></el-form-item>
        <el-form-item label="周期"><el-input v-model="form.period" placeholder="如: 2024-01" /></el-form-item>
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
const typeNames = { 1: '物业费', 2: '水费', 3: '电费', 4: '停车费', 5: '其他' }
const query = ref({ page: 1, size: 10, type: null, status: null, period: '' })
const tableData = ref([])
const total = ref(0)
const dialogVisible = ref(false)
const form = ref({})
const owners = ref([])

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
  const res = await request.get('/fee/page', { params })
  tableData.value = res.data.records
  total.value = res.data.total
}

const loadOwners = async () => {
  const res = await request.get('/owner/page', { params: { size: 1000 } })
  owners.value = res.data.records
}

const handleAdd = () => {
  form.value = { type: 1, amount: 0 }
  dialogVisible.value = true
  loadOwners()
}

const handleSave = async () => {
  await request.post('/fee', form.value)
  ElMessage.success('操作成功')
  dialogVisible.value = false
  loadData()
}

const handlePay = async (row) => {
  await request.put(`/fee/pay/${row.id}`)
  ElMessage.success('缴费成功')
  loadData()
}

const handleDelete = async (id) => {
  await request.delete(`/fee/${id}`)
  ElMessage.success('删除成功')
  loadData()
}

onMounted(loadData)
</script>
