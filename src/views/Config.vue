<template>
  <div class="page-container">
    <div class="search-bar">
      <el-button type="success" @click="handleAdd">新增配置</el-button>
    </div>
    <el-table :data="tableData" border stripe>
      <el-table-column prop="id" label="ID" width="80" />
      <el-table-column prop="configKey" label="配置键" />
      <el-table-column prop="configName" label="配置名称" />
      <el-table-column prop="configValue" label="配置值" />
      <el-table-column prop="remark" label="备注" />
      <el-table-column prop="updateTime" label="更新时间" width="180" />
      <el-table-column label="操作" width="150">
        <template #default="{ row }">
          <el-button link type="primary" @click="handleEdit(row)">编辑</el-button>
          <el-popconfirm title="确定删除?" @confirm="handleDelete(row.id)">
            <template #reference><el-button link type="danger">删除</el-button></template>
          </el-popconfirm>
        </template>
      </el-table-column>
    </el-table>

    <el-dialog v-model="dialogVisible" :title="form.id ? '编辑配置' : '新增配置'" width="500px">
      <el-form :model="form" label-width="80px">
        <el-form-item label="配置键"><el-input v-model="form.configKey" placeholder="如: property_fee_rate" /></el-form-item>
        <el-form-item label="配置名称"><el-input v-model="form.configName" placeholder="如: 物业费单价" /></el-form-item>
        <el-form-item label="配置值"><el-input v-model="form.configValue" placeholder="如: 2.5" /></el-form-item>
        <el-form-item label="备注"><el-input v-model="form.remark" type="textarea" /></el-form-item>
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

const tableData = ref([])
const dialogVisible = ref(false)
const form = ref({})

const loadData = async () => {
  const res = await request.get('/config/list')
  tableData.value = res.data || []
}

const handleAdd = () => {
  form.value = {}
  dialogVisible.value = true
}

const handleEdit = (row) => {
  form.value = { ...row }
  dialogVisible.value = true
}

const handleSave = async () => {
  await request.post('/config', form.value)
  ElMessage.success('操作成功')
  dialogVisible.value = false
  loadData()
}

const handleDelete = async (id) => {
  await request.delete(`/config/${id}`)
  ElMessage.success('删除成功')
  loadData()
}

onMounted(loadData)
</script>
