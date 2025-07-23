<template>
  <nav class="fixed top-0 left-0 h-full w-64 bg-white dark:bg-gray-800 shadow-lg border-r border-gray-200 dark:border-gray-700 z-40">
    <div class="flex flex-col h-full">
      <!-- Logo -->
      <div class="flex items-center justify-center h-16 px-4 border-b border-gray-200 dark:border-gray-700">
        <h1 class="text-xl font-bold text-gradient">VoiceClone</h1>
      </div>

      <!-- User Info -->
      <div class="p-4 border-b border-gray-200 dark:border-gray-700">
        <div class="flex items-center space-x-3">
          <div class="w-10 h-10 bg-primary-500 rounded-full flex items-center justify-center">
            <span class="text-white font-medium">
              {{ userInitials }}
            </span>
          </div>
          <div class="flex-1 min-w-0">
            <p class="text-sm font-medium text-gray-900 dark:text-gray-100 truncate">
              {{ authStore.user?.name || 'User' }}
            </p>
            <p class="text-xs text-gray-500 dark:text-gray-400 truncate">
              {{ authStore.user?.email }}
            </p>
          </div>
        </div>
      </div>

      <!-- Navigation Links -->
      <div class="flex-1 px-4 py-4 space-y-2">
        <router-link
          v-for="item in navigationItems"
          :key="item.name"
          :to="item.to"
          class="flex items-center px-3 py-2 text-sm font-medium rounded-lg transition-colors duration-200"
          :class="[
            $route.name === item.name
              ? 'bg-primary-100 text-primary-700 dark:bg-primary-900 dark:text-primary-300'
              : 'text-gray-700 hover:bg-gray-100 dark:text-gray-300 dark:hover:bg-gray-700'
          ]"
        >
          <component :is="item.icon" class="w-5 h-5 mr-3" />
          {{ item.label }}
        </router-link>
      </div>

      <!-- Bottom Actions -->
      <div class="p-4 border-t border-gray-200 dark:border-gray-700 space-y-2">
        <!-- Theme Toggle -->
        <button
          @click="toggleDarkMode"
          class="flex items-center w-full px-3 py-2 text-sm font-medium text-gray-700 dark:text-gray-300 rounded-lg hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors duration-200"
        >
          <SunIcon v-if="isDarkMode" class="w-5 h-5 mr-3" />
          <MoonIcon v-else class="w-5 h-5 mr-3" />
          {{ isDarkMode ? 'Light Mode' : 'Dark Mode' }}
        </button>

        <!-- Logout -->
        <button
          @click="handleLogout"
          class="flex items-center w-full px-3 py-2 text-sm font-medium text-red-600 dark:text-red-400 rounded-lg hover:bg-red-50 dark:hover:bg-red-900/20 transition-colors duration-200"
        >
          <ArrowRightOnRectangleIcon class="w-5 h-5 mr-3" />
          Logout
        </button>
      </div>
    </div>
  </nav>
</template>

<script setup>
import { computed, inject } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import {
  HomeIcon,
  CloudArrowUpIcon,
  FolderIcon,
  ChartBarIcon,
  UserIcon,
  SunIcon,
  MoonIcon,
  ArrowRightOnRectangleIcon
} from '@heroicons/vue/24/outline'

const router = useRouter()
const authStore = useAuthStore()

const toggleDarkMode = inject('toggleDarkMode')
const isDarkMode = inject('isDarkMode')

const navigationItems = [
  {
    name: 'Dashboard',
    label: 'Dashboard',
    to: '/dashboard',
    icon: HomeIcon
  },
  {
    name: 'Upload',
    label: 'Upload Video',
    to: '/upload',
    icon: CloudArrowUpIcon
  },
  {
    name: 'Projects',
    label: 'My Projects',
    to: '/projects',
    icon: FolderIcon
  },
  {
    name: 'Profile',
    label: 'Profile',
    to: '/profile',
    icon: UserIcon
  }
]

const userInitials = computed(() => {
  const name = authStore.user?.name || 'U'
  return name.split(' ').map(n => n[0]).join('').toUpperCase().slice(0, 2)
})

const handleLogout = async () => {
  await authStore.logout()
  router.push('/login')
}
</script>
