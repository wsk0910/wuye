<template>
  <el-container style="height: 100%">
    <el-aside width="220px" style="background: #304156">
      <div class="logo">智慧物业</div>
      <el-menu :default-active="route.path" router background-color="#304156" text-color="#bfcbd9" active-text-color="#409eff">
        <el-menu-item index="/dashboard"><el-icon><HomeFilled /></el-icon><span>首页</span></el-menu-item>
        <el-menu-item index="/user" v-if="user?.role === 1"><el-icon><User /></el-icon><span>用户管理</span></el-menu-item>
        <el-menu-item index="/owner" v-if="[1,2].includes(user?.role)"><el-icon><UserFilled /></el-icon><span>业主管理</span></el-menu-item>
        <el-menu-item index="/repair"><el-icon><Tools /></el-icon><span>报修管理</span></el-menu-item>
        <el-menu-item index="/fee" v-if="[1,2,3].includes(user?.role)"><el-icon><Money /></el-icon><span>费用管理</span></el-menu-item>
        <el-menu-item index="/notice" v-if="[1,2,3].includes(user?.role)"><el-icon><Bell /></el-icon><span>通知公告</span></el-menu-item>
        <el-menu-item index="/complaint" v-if="[1,2,3].includes(user?.role)"><el-icon><ChatDotRound /></el-icon><span>投诉建议</span></el-menu-item>
        <el-menu-item index="/visitor" v-if="[1,2,3].includes(user?.role)"><el-icon><Promotion /></el-icon><span>访客预约</span></el-menu-item>
        <el-menu-item index="/inspection" v-if="[1,2].includes(user?.role)"><el-icon><View /></el-icon><span>巡检管理</span></el-menu-item>
        <el-menu-item index="/config" v-if="user?.role === 1"><el-icon><Setting /></el-icon><span>系统配置</span></el-menu-item>
      </el-menu>
    </el-aside>
    <el-container>
      <el-header style="background: #fff; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 1px 4px rgba(0,0,0,0.1)">
        <span style="font-size: 18px; font-weight: 500">{{ route.meta.title || '首页' }}</span>
        <el-dropdown @command="handleCommand">
          <span style="cursor: pointer; display: flex; align-items: center; gap: 8px">
            <el-avatar :size="32">{{ user?.realName?.charAt(0) }}</el-avatar>
            {{ user?.realName }}
            <el-icon><ArrowDown /></el-icon>
          </span>
          <template #dropdown>
            <el-dropdown-menu>
              <el-dropdown-item command="logout">退出登录</el-dropdown-item>
            </el-dropdown-menu>
          </template>
        </el-dropdown>
      </el-header>
      <el-main style="background: #f0f2f5">
        <router-view />
      </el-main>
    </el-container>
  </el-container>
</template>

<script setup>
import { useRoute, useRouter } from 'vue-router'
import { useUserStore } from '../stores/user'
import { computed } from 'vue'

const route = useRoute()
const router = useRouter()
const userStore = useUserStore()
const user = computed(() => userStore.user)

const handleCommand = (cmd) => {
  if (cmd === 'logout') {
    userStore.logout()
    router.push('/login')
  }
}
</script>

<style scoped>
.logo {
  height: 60px;
  line-height: 60px;
  text-align: center;
  color: #fff;
  font-size: 20px;
  font-weight: bold;
  background: #263445;
}
</style>
