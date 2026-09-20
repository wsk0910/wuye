<template>
  <div class="login-container">
    <div class="login-left">
      <div class="welcome-text">
        <h1>智慧物业管理系统</h1>
        <p>Smart Property Management System</p>
        <div class="features">
          <div class="feature-item">
            <el-icon :size="24"><HomeFilled /></el-icon>
            <span>便捷报修</span>
          </div>
          <div class="feature-item">
            <el-icon :size="24"><Money /></el-icon>
            <span>在线缴费</span>
          </div>
          <div class="feature-item">
            <el-icon :size="24"><Bell /></el-icon>
            <span>通知公告</span>
          </div>
          <div class="feature-item">
            <el-icon :size="24"><Service /></el-icon>
            <span>贴心服务</span>
          </div>
        </div>
      </div>
    </div>
    <div class="login-right">
      <div class="login-box">
        <div class="login-header">
          <h2>欢迎登录</h2>
          <p>请输入您的账号信息</p>
        </div>
        <el-form :model="form" :rules="rules" ref="formRef" class="login-form">
          <el-form-item prop="username">
            <el-input 
              v-model="form.username" 
              placeholder="请输入用户名" 
              prefix-icon="User" 
              size="large"
              clearable
            />
          </el-form-item>
          <el-form-item prop="password">
            <el-input 
              v-model="form.password" 
              type="password" 
              placeholder="请输入密码" 
              prefix-icon="Lock" 
              size="large" 
              show-password 
              @keyup.enter="handleLogin"
              clearable
            />
          </el-form-item>
          <el-form-item>
            <el-button 
              type="primary" 
              size="large" 
              class="login-btn" 
              @click="handleLogin" 
              :loading="loading"
            >
              登 录
            </el-button>
          </el-form-item>
        </el-form>
        <div class="login-footer">
          <span>© 2026 智慧物业管理系统</span>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { useUserStore } from '../stores/user'
import request from '../utils/request'
import { ElMessage } from 'element-plus'

const router = useRouter()
const userStore = useUserStore()
const formRef = ref()
const loading = ref(false)
const form = ref({ username: '', password: '' })
const rules = {
  username: [{ required: true, message: '请输入用户名', trigger: 'blur' }],
  password: [{ required: true, message: '请输入密码', trigger: 'blur' }]
}

const handleLogin = async () => {
  await formRef.value.validate()
  loading.value = true
  try {
    const res = await request.post('/user/login', form.value)
    userStore.setUser(res.data)
    ElMessage.success('登录成功')
    router.push('/')
  } finally {
    loading.value = false
  }
}
</script>

<style scoped>
.login-container {
  height: 100vh;
  display: flex;
  background: #f0f2f5;
}

.login-left {
  flex: 1;
  background: linear-gradient(135deg, #1890ff 0%, #096dd9 50%, #0050b3 100%);
  display: flex;
  align-items: center;
  justify-content: center;
  position: relative;
  overflow: hidden;
}

.login-left::before {
  content: '';
  position: absolute;
  width: 600px;
  height: 600px;
  background: rgba(255, 255, 255, 0.1);
  border-radius: 50%;
  top: -200px;
  left: -200px;
}

.login-left::after {
  content: '';
  position: absolute;
  width: 400px;
  height: 400px;
  background: rgba(255, 255, 255, 0.08);
  border-radius: 50%;
  bottom: -100px;
  right: -100px;
}

.welcome-text {
  text-align: center;
  color: #fff;
  z-index: 1;
}

.welcome-text h1 {
  font-size: 36px;
  font-weight: 600;
  margin-bottom: 10px;
  letter-spacing: 2px;
}

.welcome-text p {
  font-size: 16px;
  opacity: 0.85;
  margin-bottom: 50px;
}

.features {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 30px;
  margin-top: 40px;
}

.feature-item {
  display: flex;
  align-items: center;
  gap: 10px;
  font-size: 16px;
  opacity: 0.9;
}

.login-right {
  width: 480px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: #fff;
}

.login-box {
  width: 360px;
  padding: 40px;
}

.login-header {
  text-align: center;
  margin-bottom: 40px;
}

.login-header h2 {
  font-size: 28px;
  color: #333;
  margin-bottom: 10px;
  font-weight: 600;
}

.login-header p {
  color: #999;
  font-size: 14px;
}

.login-form {
  margin-top: 30px;
}

.login-form :deep(.el-input__wrapper) {
  padding: 8px 15px;
  border-radius: 8px;
}

.login-form :deep(.el-form-item) {
  margin-bottom: 25px;
}

.login-btn {
  width: 100%;
  height: 48px;
  font-size: 16px;
  border-radius: 8px;
  background: linear-gradient(135deg, #1890ff, #096dd9);
  border: none;
  margin-top: 10px;
}

.login-btn:hover {
  background: linear-gradient(135deg, #40a9ff, #1890ff);
}

.login-footer {
  text-align: center;
  margin-top: 40px;
  color: #bbb;
  font-size: 12px;
}

@media (max-width: 900px) {
  .login-left {
    display: none;
  }
  .login-right {
    width: 100%;
  }
}
</style>
