import { createRouter, createWebHistory } from 'vue-router'
import { useUserStore } from '../stores/user'

const routes = [
  {
    path: '/login',
    name: 'Login',
    component: () => import('../views/Login.vue')
  },
  {
    path: '/',
    component: () => import('../layout/Layout.vue'),
    redirect: '/dashboard',
    children: [
      { path: 'dashboard', name: 'Dashboard', component: () => import('../views/Dashboard.vue'), meta: { title: '首页' } },
      { path: 'user', name: 'User', component: () => import('../views/User.vue'), meta: { title: '用户管理', roles: [1] } },
      { path: 'owner', name: 'Owner', component: () => import('../views/Owner.vue'), meta: { title: '业主管理', roles: [1, 2] } },
      { path: 'repair', name: 'Repair', component: () => import('../views/Repair.vue'), meta: { title: '报修管理' } },
      { path: 'fee', name: 'Fee', component: () => import('../views/Fee.vue'), meta: { title: '费用管理' } },
      { path: 'notice', name: 'Notice', component: () => import('../views/Notice.vue'), meta: { title: '通知公告' } },
      { path: 'complaint', name: 'Complaint', component: () => import('../views/Complaint.vue'), meta: { title: '投诉建议' } },
      { path: 'visitor', name: 'Visitor', component: () => import('../views/Visitor.vue'), meta: { title: '访客预约' } },
      { path: 'inspection', name: 'Inspection', component: () => import('../views/Inspection.vue'), meta: { title: '巡检管理', roles: [1, 2] } },
      { path: 'config', name: 'Config', component: () => import('../views/Config.vue'), meta: { title: '系统配置', roles: [1] } }
    ]
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

router.beforeEach((to, from, next) => {
  const userStore = useUserStore()
  if (to.path !== '/login' && !userStore.user) {
    next('/login')
  } else {
    next()
  }
})

export default router
