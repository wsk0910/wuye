<template>
  <div class="page-container">
    <div class="search-bar">
      <el-input v-model="query.keyword" placeholder="搜索姓名/手机号/楼栋/房号" clearable style="width: 250px" @keyup.enter="loadData" />
      <el-button type="primary" @click="loadData">搜索</el-button>
      <el-button type="success" @click="handleAdd">新增业主</el-button>
    </div>
    <el-table :data="tableData" border stripe>
      <el-table-column prop="id" label="ID" width="80" />
      <el-table-column prop="name" label="姓名" />
      <el-table-column prop="phone" label="手机号" />
      <el-table-column prop="idCard" label="身份证号" />
      <el-table-column label="房屋信息">
        <template #default="{ row }">{{ row.building }}栋{{ row.unit }}单元{{ row.room }}室</template>
      </el-table-column>
      <el-table-column prop="area" label="面积(㎡)" width="100" />
      <el-table-column label="绑定账号" width="120">
        <template #default="{ row }">
          <el-tag v-if="row.userId" type="success">已绑定</el-tag>
          <el-tag v-else type="info">未绑定</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="操作" width="200">
        <template #default="{ row }">
          <el-button link type="primary" @click="handleEdit(row)">编辑</el-button>
          <el-button link type="warning" @click="handleBind(row)" v-if="!row.userId">绑定账号</el-button>
          <el-button link type="info" @click="handleUnbind(row)" v-else>解绑</el-button>
          <el-popconfirm title="确定删除?" @confirm="handleDelete(row.id)">
            <template #reference><el-button link type="danger">删除</el-button></template>
          </el-popconfirm>
        </template>
      </el-table-column>
    </el-table>
    <div class="pagination">
      <el-pagination v-model:current-page="query.page" v-model:page-size="query.size" :total="total" :page-sizes="[10, 20, 50]" layout="total, sizes, prev, pager, next" @change="loadData" />
    </div>

    <el-dialog v-model="dialogVisible" :title="form.id ? '编辑业主' : '新增业主'" width="500px">
      <el-form :model="form" label-width="80px">
        <el-form-item label="姓名"><el-input v-model="form.name" /></el-form-item>
        <el-form-item label="手机号"><el-input v-model="form.phone" /></el-form-item>
        <el-form-item label="身份证号"><el-input v-model="form.idCard" /></el-form-item>
        <el-form-item label="楼栋"><el-input v-model="form.building" placeholder="如: 1" /></el-form-item>
        <el-form-item label="单元"><el-input v-model="form.unit" placeholder="如: 1" /></el-form-item>
        <el-form-item label="房号"><el-input v-model="form.room" placeholder="如: 101" /></el-form-item>
        <el-form-item label="面积"><el-input-number v-model="form.area" :precision="2" :min="0" style="width: 100%" /></el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleSave">确定</el-button>
      </template>
    </el-dialog>

    <el-dialog v-model="bindDialogVisible" title="绑定用户账号" width="500px">
      <el-form :model="bindForm" label-width="100px">
        <el-form-item label="选择方式">
          <el-radio-group v-model="bindType">
            <el-radio value="exist">选择已有用户</el-radio>
            <el-radio value="create">创建新账号</el-radio>
          </el-radio-group>
        </el-form-item>
        <template v-if="bindType === 'exist'">
          <el-form-item label="选择用户">
            <el-select v-model="bindForm.userId" filterable placeholder="搜索用户" style="width: 100%">
              <el-option v-for="u in unboundUsers" :key="u.id" :label="`${u.realName || u.username} (${u.username})`" :value="u.id" />
            </el-select>
          </el-form-item>
        </template>
        <template v-else>
          <el-form-item label="用户名"><el-input v-model="bindForm.username" placeholder="建议使用手机号" /></el-form-item>
          <el-form-item label="密码"><el-input v-model="bindForm.password" placeholder="默认123456" /></el-form-item>
        </template>
      </el-form>
      <template #footer>
        <el-button @click="bindDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleBindSave">确定绑定</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import request from '../utils/request'
import { ElMessage, ElMessageBox } from 'element-plus'

const query = ref({ page: 1, size: 10, keyword: '' })
const tableData = ref([])
const total = ref(0)
const dialogVisible = ref(false)
const form = ref({})
const bindDialogVisible = ref(false)
const bindForm = ref({})
const bindType = ref('exist')
const unboundUsers = ref([])
const currentOwner = ref(null)

const loadData = async () => {
  const res = await request.get('/owner/page', { params: query.value })
  tableData.value = res.data.records
  total.value = res.data.total
}

const loadUnboundUsers = async () => {
  const res = await request.get('/user/unbound')
  unboundUsers.value = res.data || []
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
  await request.post('/owner', form.value)
  ElMessage.success('操作成功')
  dialogVisible.value = false
  loadData()
}

const handleDelete = async (id) => {
  await request.delete(`/owner/${id}`)
  ElMessage.success('删除成功')
  loadData()
}

const handleBind = async (row) => {
  currentOwner.value = row
  bindForm.value = { username: row.phone, password: '123456' }
  bindType.value = 'exist'
  await loadUnboundUsers()
  bindDialogVisible.value = true
}

const handleBindSave = async () => {
  if (bindType.value === 'exist') {
    if (!bindForm.value.userId) {
      ElMessage.warning('请选择用户')
      return
    }
    await request.put(`/owner/bind/${currentOwner.value.id}`, null, { params: { userId: bindForm.value.userId } })
  } else {
    if (!bindForm.value.username) {
      ElMessage.warning('请输入用户名')
      return
    }
    await request.post(`/owner/bindNew/${currentOwner.value.id}`, bindForm.value)
  }
  ElMessage.success('绑定成功')
  bindDialogVisible.value = false
  loadData()
}

const handleUnbind = async (row) => {
  await ElMessageBox.confirm('确定解除该业主的账号绑定吗？', '提示', { type: 'warning' })
  await request.put(`/owner/unbind/${row.id}`)
  ElMessage.success('解绑成功')
  loadData()
}

onMounted(loadData)
</script>
