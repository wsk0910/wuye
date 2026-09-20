<template>
  <div class="page-container">
    <div class="search-bar">
      <el-input v-model="query.keyword" placeholder="搜索标题/内容" clearable style="width: 200px" @keyup.enter="loadData" />
      <el-select v-model="query.status" placeholder="状态" clearable style="width: 100px" v-if="[1,2].includes(user?.role)">
        <el-option label="草稿" :value="0" />
        <el-option label="已发布" :value="1" />
      </el-select>
      <el-button type="primary" @click="loadData">搜索</el-button>
      <el-button type="success" @click="handleAdd" v-if="[1,2].includes(user?.role)">发布公告</el-button>
    </div>
    <el-table :data="tableData" border stripe>
      <el-table-column prop="id" label="ID" width="80" />
      <el-table-column prop="title" label="标题" />
      <el-table-column prop="content" label="内容" show-overflow-tooltip />
      <el-table-column prop="status" label="状态" width="80" v-if="[1,2].includes(user?.role)">
        <template #default="{ row }">
          <el-tag :type="row.status === 1 ? 'success' : 'info'">{{ row.status === 1 ? '已发布' : '草稿' }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="createTime" label="发布时间" width="180" />
      <el-table-column label="操作" width="200" v-if="[1,2].includes(user?.role)">
        <template #default="{ row }">
          <el-button link type="primary" @click="handleEdit(row)">编辑</el-button>
          <el-button link type="success" @click="handlePublish(row)" v-if="row.status === 0">发布</el-button>
          <el-popconfirm title="确定删除?" @confirm="handleDelete(row.id)">
            <template #reference><el-button link type="danger">删除</el-button></template>
          </el-popconfirm>
        </template>
      </el-table-column>
    </el-table>
    <div class="pagination">
      <el-pagination v-model:current-page="query.page" v-model:page-size="query.size" :total="total" :page-sizes="[10, 20, 50]" layout="total, sizes, prev, pager, next" @change="loadData" />
    </div>

    <el-dialog v-model="dialogVisible" :title="form.id ? '编辑公告' : '发布公告'" width="600px">
      <el-form :model="form" label-width="80px">
        <el-form-item label="标题"><el-input v-model="form.title" /></el-form-item>
        <el-form-item label="内容"><el-input v-model="form.content" type="textarea" :rows="6" /></el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button @click="handleSave(0)">保存草稿</el-button>
        <el-button type="primary" @click="handleSave(1)">发布</el-button>
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
  const params = { ...query.value }
  if (user.value?.role === 3) params.status = 1
  const res = await request.get('/notice/page', { params })
  tableData.value = res.data.records
  total.value = res.data.total
}

const handleAdd = () => {
  form.value = { publisherId: user.value?.id }
  dialogVisible.value = true
}

const handleEdit = (row) => {
  form.value = { ...row }
  dialogVisible.value = true
}

const handleSave = async (status) => {
  form.value.status = status
  await request.post('/notice', form.value)
  ElMessage.success('操作成功')
  dialogVisible.value = false
  loadData()
}

const handlePublish = async (row) => {
  await request.put(`/notice/publish/${row.id}`)
  ElMessage.success('发布成功')
  loadData()
}

const handleDelete = async (id) => {
  await request.delete(`/notice/${id}`)
  ElMessage.success('删除成功')
  loadData()
}

onMounted(loadData)
</script>
