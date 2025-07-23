<template>
  <div id="app" :class="{ 'dark': isDarkMode }">
    <div class="min-h-screen bg-gray-50 dark:bg-gray-900 transition-colors duration-200">
      <!-- Navigation -->
      <AppNavigation v-if="!isAuthPage" />
      
      <!-- Main Content -->
      <main :class="{ 'ml-64': !isAuthPage && !isMobileMenuOpen }">
        <router-view />
      </main>
      
      <!-- Loading Overlay -->
      <div v-if="isLoading" class="fixed inset-0 bg-black/50 flex items-center justify-center z-50">
        <div class="bg-white dark:bg-gray-800 rounded-lg p-6 flex items-center space-x-4">
          <div class="loading-spinner w-6 h-6"></div>
          <span class="text-gray-700 dark:text-gray-300">Loading...</span>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, watch, provide } from 'vue'
import { useRoute } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import { useProjectsStore } from '@/stores/projects'
import AppNavigation from '@/components/layout/AppNavigation.vue'

const route = useRoute()
const authStore = useAuthStore()
const projectsStore = useProjectsStore()

const isDarkMode = ref(localStorage.getItem('darkMode') === 'true')
const isMobileMenuOpen = ref(false)
const isLoading = ref(false)

const isAuthPage = computed(() => {
  return ['Login', 'Register'].includes(route.name)
})

// Initialize app
onMounted(async () => {
  isLoading.value = true
  
  try {
    // Initialize authentication
    await authStore.initializeAuth()
    
    // Initialize WebSocket connection if authenticated
    if (authStore.isAuthenticated) {
      projectsStore.initializeSocket()
    }
  } catch (error) {
    console.error('App initialization error:', error)
  } finally {
    isLoading.value = false
  }
})

// Watch for authentication changes
watch(() => authStore.isAuthenticated, (isAuth) => {
  if (isAuth) {
    projectsStore.initializeSocket()
  } else {
    projectsStore.disconnectSocket()
  }
})

// Watch for dark mode changes
watch(isDarkMode, (newValue) => {
  localStorage.setItem('darkMode', newValue.toString())
  if (newValue) {
    document.documentElement.classList.add('dark')
  } else {
    document.documentElement.classList.remove('dark')
  }
})

// Initialize dark mode
if (isDarkMode.value) {
  document.documentElement.classList.add('dark')
}

// Global event listeners
const handleKeydown = (event) => {
  // Toggle dark mode with Ctrl/Cmd + Shift + D
  if ((event.ctrlKey || event.metaKey) && event.shiftKey && event.key === 'D') {
    event.preventDefault()
    isDarkMode.value = !isDarkMode.value
  }
  
  // Close mobile menu with Escape
  if (event.key === 'Escape') {
    isMobileMenuOpen.value = false
  }
}

onMounted(() => {
  document.addEventListener('keydown', handleKeydown)
})

// Provide global functions
const toggleDarkMode = () => {
  isDarkMode.value = !isDarkMode.value
}

const toggleMobileMenu = () => {
  isMobileMenuOpen.value = !isMobileMenuOpen.value
}

// Make functions available to child components
provide('toggleDarkMode', toggleDarkMode)
provide('toggleMobileMenu', toggleMobileMenu)
provide('isDarkMode', isDarkMode)
provide('isMobileMenuOpen', isMobileMenuOpen)
</script>

<style>
/* Global styles are handled in style.css */
</style>
