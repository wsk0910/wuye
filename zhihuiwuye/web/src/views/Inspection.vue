<template>
  <div class="page-container">
    <div class="search-bar">
      <el-input v-model="query.keyword" placeholder="搜索区域/内容" clearable style="width: 200px" @keyup.enter="loadData" />
      <el-select v-model="query.status" placeholder="状态" clearable style="width: 100px">
        <el-option label="正常" :value="0" />
        <el-option label="有问题" :value="1" />
      </el-select>
      <el-button type="primary" @click="loadData">搜索</el-button>
      <el-button type="success" @click="handleAdd">新增巡检</el-button>
    </div>
    <el-table :data="tableData" border stripe>
      <el-table-column prop="id" label="ID" width="80" />
      <el-table-column prop="area" label="巡检区域" />
      <el-table-column prop="content" label="巡检内容" show-overflow-tooltip />
      <el-table-column prop="result" label="巡检结果" show-overflow-tooltip />
      <el-table-column prop="status" label="状态" width="80">
        <template #default="{ row }">
          <el-tag :type="row.status === 0 ? 'success' : 'danger'">{{ row.status === 0 ? '正常' : '有问题' }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="problem" label="问题描述" show-overflow-tooltip />
      <el-table-column prop="createTime" label="巡检时间" width="180" />
      <el-table-column label="操作" width="150">
        <template #default="{ row }">
          <el-button link type="primary" @click="handleEdit(row)">编辑</el-button>
          <el-popconfirm title="确定删除?" @confirm="handleDelete(row.id)">
            <template #reference><el-button link type="danger">删除</el-button></template>
          </el-popconfirm>
        </template>
      </el-table-column>
    </el-table>
    <div class="pagination">
      <el-pagination v-model:current-page="query.page" v-model:page-size="query.size" :total="total" :page-sizes="[10, 20, 50]" layout="total, sizes, prev, pager, next" @change="loadData" />
    </div>

    <el-dialog v-model="dialogVisible" :title="form.id ? '编辑巡检' : '新增巡检'" width="500px">
      <el-form :model="form" label-width="80px">
        <el-form-item label="巡检区域"><el-input v-model="form.area" placeholder="如: A栋1层" /></el-form-item>
        <el-form-item label="巡检内容"><el-input v-model="form.content" type="textarea" :rows="3" /></el-form-item>
        <el-form-item label="巡检结果"><el-input v-model="form.result" type="textarea" :rows="2" /></el-form-item>
        <el-form-item label="状态">
          <el-radio-group v-model="form.status">
            <el-radio :value="0">正常</el-radio>
            <el-radio :value="1">有问题</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="问题描述" v-if="form.status === 1">
          <el-input v-model="form.problem" type="textarea" :rows="2" />
        </el-form-item>
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
const query = ref({ page: 1, size: 10, keyword: '', status: null })
const tableData = ref([])
const total = ref(0)
const dialogVisible = ref(false)
const form = ref({})

const loadData = async () => {
  const res = await request.get('/inspection/page', { params: query.value })
  tableData.value = res.data.records
  total.value = res.data.total
}

const handleAdd = () => {
  form.value = { inspectorId: user.value?.id, status: 0 }
  dialogVisible.value = true
}

const handleEdit = (row) => {
  form.value = { ...row }
  dialogVisible.value = true
}

const handleSave = async () => {
  await request.post('/inspection', form.value)
  ElMessage.success('操作成功')
  dialogVisible.value = false
  loadData()
}

const handleDelete = async (id) => {
  await request.delete(`/inspection/${id}`)
  ElMessage.success('删除成功')
  loadData()
}

onMounted(loadData)
</script>
