<template>
  <div class="page-container">
    <div class="search-bar">
      <el-input v-model="query.keyword" placeholder="搜索用户名/姓名/手机号" clearable style="width: 200px" @keyup.enter="loadData" />
      <el-select v-model="query.role" placeholder="角色" clearable style="width: 120px">
        <el-option label="超级管理员" :value="1" />
        <el-option label="物业管理员" :value="2" />
        <el-option label="业主" :value="3" />
        <el-option label="维修工" :value="4" />
      </el-select>
      <el-button type="primary" @click="loadData">搜索</el-button>
      <el-button type="success" @click="handleAdd">新增用户</el-button>
    </div>
    <el-table :data="tableData" border stripe>
      <el-table-column prop="id" label="ID" width="80" />
      <el-table-column prop="username" label="用户名" />
      <el-table-column prop="realName" label="姓名" />
      <el-table-column prop="phone" label="手机号" />
      <el-table-column prop="role" label="角色">
        <template #default="{ row }">
          <el-tag :type="roleTypes[row.role]">{{ roleNames[row.role] }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="status" label="状态">
        <template #default="{ row }">
          <el-switch :model-value="row.status === 1" @change="handleStatus(row)" />
        </template>
      </el-table-column>
      <el-table-column prop="createTime" label="创建时间" width="180" />
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

    <el-dialog v-model="dialogVisible" :title="form.id ? '编辑用户' : '新增用户'" width="500px">
      <el-form :model="form" label-width="80px">
        <el-form-item label="用户名"><el-input v-model="form.username" /></el-form-item>
        <el-form-item label="密码"><el-input v-model="form.password" type="password" placeholder="不修改请留空" /></el-form-item>
        <el-form-item label="姓名"><el-input v-model="form.realName" /></el-form-item>
        <el-form-item label="手机号"><el-input v-model="form.phone" /></el-form-item>
        <el-form-item label="角色">
          <el-select v-model="form.role" style="width: 100%">
            <el-option label="超级管理员" :value="1" />
            <el-option label="物业管理员" :value="2" />
            <el-option label="业主" :value="3" />
            <el-option label="维修工" :value="4" />
          </el-select>
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
import { ref, onMounted } from 'vue'
import request from '../utils/request'
import { ElMessage } from 'element-plus'

const roleNames = { 1: '超级管理员', 2: '物业管理员', 3: '业主', 4: '维修工' }
const roleTypes = { 1: 'danger', 2: 'warning', 3: '', 4: 'success' }
const query = ref({ page: 1, size: 10, keyword: '', role: null })
const tableData = ref([])
const total = ref(0)
const dialogVisible = ref(false)
const form = ref({})

const loadData = async () => {
  const res = await request.get('/user/page', { params: query.value })
  tableData.value = res.data.records
  total.value = res.data.total
}

const handleAdd = () => {
  form.value = { status: 1, role: 2 }
  dialogVisible.value = true
}

const handleEdit = (row) => {
  form.value = { ...row, password: '' }
  dialogVisible.value = true
}

const handleSave = async () => {
  const data = { ...form.value }
  if (!data.password) delete data.password
  await request.post('/user', data)
  ElMessage.success('操作成功')
  dialogVisible.value = false
  loadData()
}

const handleDelete = async (id) => {
  await request.delete(`/user/${id}`)
  ElMessage.success('删除成功')
  loadData()
}

const handleStatus = async (row) => {
  await request.put(`/user/status/${row.id}`, null, { params: { status: row.status === 1 ? 0 : 1 } })
  loadData()
}

onMounted(loadData)
</script>
