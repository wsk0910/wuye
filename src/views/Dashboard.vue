<template>
  <div class="dashboard">
    <el-row :gutter="20">
      <el-col :span="6">
        <el-card shadow="hover">
          <div class="stat-card" style="background: linear-gradient(135deg, #1890ff, #36cfc9)">
            <div class="stat-icon"><el-icon :size="40"><UserFilled /></el-icon></div>
            <div class="stat-info"><div class="stat-value">{{ stats.ownerCount || 0 }}</div><div class="stat-label">业主总数</div></div>
          </div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card shadow="hover">
          <div class="stat-card" style="background: linear-gradient(135deg, #f5222d, #fa8c16)">
            <div class="stat-icon"><el-icon :size="40"><Tools /></el-icon></div>
            <div class="stat-info"><div class="stat-value">{{ stats.repairPending || 0 }}</div><div class="stat-label">待处理报修</div></div>
          </div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card shadow="hover">
          <div class="stat-card" style="background: linear-gradient(135deg, #faad14, #ffc53d)">
            <div class="stat-icon"><el-icon :size="40"><ChatDotRound /></el-icon></div>
            <div class="stat-info"><div class="stat-value">{{ stats.complaintPending || 0 }}</div><div class="stat-label">待处理投诉</div></div>
          </div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card shadow="hover">
          <div class="stat-card" style="background: linear-gradient(135deg, #52c41a, #73d13d)">
            <div class="stat-icon"><el-icon :size="40"><Money /></el-icon></div>
            <div class="stat-info"><div class="stat-value">¥{{ stats.unpaidAmount || 0 }}</div><div class="stat-label">待缴费用</div></div>
          </div>
        </el-card>
      </el-col>
    </el-row>
    <el-row :gutter="20" style="margin-top: 20px">
      <el-col :span="12">
        <el-card header="报修统计">
          <div ref="repairChartRef" style="height: 300px"></div>
        </el-card>
      </el-col>
      <el-col :span="12">
        <el-card header="最新公告">
          <el-empty v-if="!notices.length" description="暂无公告" />
          <div v-else class="notice-list">
            <div v-for="item in notices" :key="item.id" class="notice-item">
              <span class="notice-title">{{ item.title }}</span>
              <span class="notice-time">{{ item.createTime?.substring(0, 10) }}</span>
            </div>
          </div>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import request from '../utils/request'
import * as echarts from 'echarts'

const stats = ref({})
const notices = ref([])
const repairChartRef = ref()

onMounted(async () => {
  const res = await request.get('/dashboard/stats')
  stats.value = res.data
  
  const noticeRes = await request.get('/notice/page', { params: { size: 5, status: 1 } })
  notices.value = noticeRes.data.records || []
  
  const chart = echarts.init(repairChartRef.value)
  chart.setOption({
    tooltip: { trigger: 'item' },
    legend: { bottom: 0 },
    series: [{
      type: 'pie',
      radius: ['40%', '70%'],
      data: [
        { value: stats.value.repairPending || 0, name: '待处理', itemStyle: { color: '#f5222d' } },
        { value: stats.value.repairProcessing || 0, name: '处理中', itemStyle: { color: '#faad14' } },
        { value: stats.value.repairCompleted || 0, name: '已完成', itemStyle: { color: '#52c41a' } }
      ]
    }]
  })
})
</script>

<style scoped>
.stat-card {
  display: flex;
  align-items: center;
  padding: 20px;
  border-radius: 8px;
  color: #fff;
}
.stat-icon { margin-right: 20px; }
.stat-value { font-size: 28px; font-weight: bold; }
.stat-label { font-size: 14px; opacity: 0.9; }
.notice-item {
  display: flex;
  justify-content: space-between;
  padding: 12px 0;
  border-bottom: 1px solid #f0f0f0;
}
.notice-item:last-child { border-bottom: none; }
.notice-title { color: #333; }
.notice-time { color: #999; font-size: 12px; }
</style>
