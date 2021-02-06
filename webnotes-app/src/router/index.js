import { createRouter, createWebHistory } from 'vue-router'

const routes = [
  {
    path: '/',
    name: 'Start',
    component: () => import('../views/Start.vue')
  },
  {
    path: '/home',
    name: 'Home', 
    component: () => import('../views/Home.vue')
  },
  {
    path: '/home/auth',
    name: 'Auth',
    component: () => import('../views/Auth.vue')
  },
  {
    path: '/about',
    name: 'About',
    component: () => import('../views/About.vue')
  },
  {
    path: '/home/note/:id',
    name: 'Note',
    component: () => import('../views/Note.vue')
  }
]

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes
})

export default router
