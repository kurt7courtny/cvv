<template>
  <div class="p-6">
    <!-- Header -->
    <div class="mb-8">
      <h1 class="text-3xl font-bold text-gray-900 dark:text-white">Dashboard</h1>
      <p class="text-gray-600 dark:text-gray-400 mt-2">
        Welcome back, {{ authStore.user?.name }}! Here's your project overview.
      </p>
    </div>

    <!-- Stats Cards -->
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
      <div class="card p-6">
        <div class="flex items-center">
          <div class="p-2 bg-blue-100 dark:bg-blue-900 rounded-lg">
            <FolderIcon class="w-6 h-6 text-blue-600 dark:text-blue-400" />
          </div>
          <div class="ml-4">
            <p class="text-sm font-medium text-gray-600 dark:text-gray-400">Total Projects</p>
            <p class="text-2xl font-semibold text-gray-900 dark:text-white">{{ stats.totalProjects }}</p>
          </div>
        </div>
      </div>

      <div class="card p-6">
        <div class="flex items-center">
          <div class="p-2 bg-green-100 dark:bg-green-900 rounded-lg">
            <CheckCircleIcon class="w-6 h-6 text-green-600 dark:text-green-400" />
          </div>
          <div class="ml-4">
            <p class="text-sm font-medium text-gray-600 dark:text-gray-400">Completed</p>
            <p class="text-2xl font-semibold text-gray-900 dark:text-white">{{ stats.completedProjects }}</p>
          </div>
        </div>
      </div>

      <div class="card p-6">
        <div class="flex items-center">
          <div class="p-2 bg-yellow-100 dark:bg-yellow-900 rounded-lg">
            <ClockIcon class="w-6 h-6 text-yellow-600 dark:text-yellow-400" />
          </div>
          <div class="ml-4">
            <p class="text-sm font-medium text-gray-600 dark:text-gray-400">Processing</p>
            <p class="text-2xl font-semibold text-gray-900 dark:text-white">{{ stats.processingProjects }}</p>
          </div>
        </div>
      </div>

      <div class="card p-6">
        <div class="flex items-center">
          <div class="p-2 bg-purple-100 dark:bg-purple-900 rounded-lg">
            <ChartBarIcon class="w-6 h-6 text-purple-600 dark:text-purple-400" />
          </div>
          <div class="ml-4">
            <p class="text-sm font-medium text-gray-600 dark:text-gray-400">Success Rate</p>
            <p class="text-2xl font-semibold text-gray-900 dark:text-white">{{ stats.successRate }}%</p>
          </div>
        </div>
      </div>
    </div>

    <!-- Quick Actions -->
    <div class="grid grid-cols-1 lg:grid-cols-3 gap-6 mb-8">
      <div class="lg:col-span-2">
        <div class="card p-6">
          <h2 class="text-xl font-semibold text-gray-900 dark:text-white mb-4">Quick Actions</h2>
          <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
            <router-link
              to="/upload"
              class="flex items-center p-4 border-2 border-dashed border-gray-300 dark:border-gray-600 rounded-lg hover:border-primary-500 hover:bg-primary-50 dark:hover:bg-primary-900/20 transition-colors duration-200"
            >
              <CloudArrowUpIcon class="w-8 h-8 text-primary-600 dark:text-primary-400 mr-3" />
              <div>
                <h3 class="font-medium text-gray-900 dark:text-white">Upload Video</h3>
                <p class="text-sm text-gray-600 dark:text-gray-400">Start a new project</p>
              </div>
            </router-link>

            <router-link
              to="/projects"
              class="flex items-center p-4 border-2 border-dashed border-gray-300 dark:border-gray-600 rounded-lg hover:border-primary-500 hover:bg-primary-50 dark:hover:bg-primary-900/20 transition-colors duration-200"
            >
              <FolderOpenIcon class="w-8 h-8 text-primary-600 dark:text-primary-400 mr-3" />
              <div>
                <h3 class="font-medium text-gray-900 dark:text-white">View Projects</h3>
                <p class="text-sm text-gray-600 dark:text-gray-400">Manage your work</p>
              </div>
            </router-link>
          </div>
        </div>
      </div>

      <div class="card p-6">
        <h2 class="text-xl font-semibold text-gray-900 dark:text-white mb-4">Usage This Month</h2>
        <div class="space-y-4">
          <div>
            <div class="flex justify-between text-sm mb-1">
              <span class="text-gray-600 dark:text-gray-400">Videos Processed</span>
              <span class="font-medium text-gray-900 dark:text-white">{{ usage.videosProcessed }}/{{ usage.videoLimit }}</span>
            </div>
            <div class="w-full bg-gray-200 dark:bg-gray-700 rounded-full h-2">
              <div
                class="bg-primary-600 h-2 rounded-full"
                :style="{ width: `${(usage.videosProcessed / usage.videoLimit) * 100}%` }"
              ></div>
            </div>
          </div>

          <div>
            <div class="flex justify-between text-sm mb-1">
              <span class="text-gray-600 dark:text-gray-400">Storage Used</span>
              <span class="font-medium text-gray-900 dark:text-white">{{ usage.storageUsed }}GB/{{ usage.storageLimit }}GB</span>
            </div>
            <div class="w-full bg-gray-200 dark:bg-gray-700 rounded-full h-2">
              <div
                class="bg-green-600 h-2 rounded-full"
                :style="{ width: `${(usage.storageUsed / usage.storageLimit) * 100}%` }"
              ></div>
            </div>
          </div>
        </div>

        <button class="w-full mt-4 btn btn-primary text-sm">
          Upgrade Plan
        </button>
      </div>
    </div>

    <!-- Recent Projects -->
    <div class="card p-6">
      <div class="flex items-center justify-between mb-6">
        <h2 class="text-xl font-semibold text-gray-900 dark:text-white">Recent Projects</h2>
        <router-link to="/projects" class="text-primary-600 hover:text-primary-500 text-sm font-medium">
          View All
        </router-link>
      </div>

      <div v-if="projectsStore.loading" class="flex justify-center py-8">
        <div class="loading-spinner w-8 h-8"></div>
      </div>

      <div v-else-if="recentProjects.length === 0" class="text-center py-8">
        <FolderIcon class="w-12 h-12 text-gray-400 mx-auto mb-4" />
        <p class="text-gray-600 dark:text-gray-400">No projects yet</p>
        <router-link to="/upload" class="btn btn-primary mt-4">
          Create Your First Project
        </router-link>
      </div>

      <div v-else class="space-y-4">
        <div
          v-for="project in recentProjects"
          :key="project.id"
          class="flex items-center justify-between p-4 border border-gray-200 dark:border-gray-700 rounded-lg hover:bg-gray-50 dark:hover:bg-gray-800 transition-colors duration-200"
        >
          <div class="flex items-center space-x-4">
            <div class="w-12 h-12 bg-gray-200 dark:bg-gray-700 rounded-lg flex items-center justify-center">
              <VideoCameraIcon class="w-6 h-6 text-gray-600 dark:text-gray-400" />
            </div>
            <div>
              <h3 class="font-medium text-gray-900 dark:text-white">{{ project.name }}</h3>
              <p class="text-sm text-gray-600 dark:text-gray-400">
                {{ formatDate(project.updated_at) }}
              </p>
            </div>
          </div>

          <div class="flex items-center space-x-4">
            <span
              class="px-2 py-1 text-xs font-medium rounded-full"
              :class="getStatusClass(project.status)"
            >
              {{ project.status }}
            </span>
            <router-link
              :to="`/project/${project.id}`"
              class="text-primary-600 hover:text-primary-500 text-sm font-medium"
            >
              View
            </router-link>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useAuthStore } from '@/stores/auth'
import { useProjectsStore } from '@/stores/projects'
import { format } from 'date-fns'
import {
  FolderIcon,
  FolderOpenIcon,
  CheckCircleIcon,
  ClockIcon,
  ChartBarIcon,
  CloudArrowUpIcon,
  VideoCameraIcon
} from '@heroicons/vue/24/outline'

const authStore = useAuthStore()
const projectsStore = useProjectsStore()

const stats = ref({
  totalProjects: 0,
  completedProjects: 0,
  processingProjects: 0,
  successRate: 0
})

const usage = ref({
  videosProcessed: 12,
  videoLimit: 50,
  storageUsed: 2.4,
  storageLimit: 10
})

const recentProjects = computed(() => {
  return projectsStore.sortedProjects.slice(0, 5)
})

const formatDate = (dateString) => {
  return format(new Date(dateString), 'MMM dd, yyyy')
}

const getStatusClass = (status) => {
  switch (status) {
    case 'completed':
      return 'bg-green-100 text-green-800 dark:bg-green-900 dark:text-green-300'
    case 'processing':
      return 'bg-yellow-100 text-yellow-800 dark:bg-yellow-900 dark:text-yellow-300'
    case 'queued':
      return 'bg-blue-100 text-blue-800 dark:bg-blue-900 dark:text-blue-300'
    case 'failed':
      return 'bg-red-100 text-red-800 dark:bg-red-900 dark:text-red-300'
    default:
      return 'bg-gray-100 text-gray-800 dark:bg-gray-900 dark:text-gray-300'
  }
}

const calculateStats = () => {
  const projects = projectsStore.projects
  stats.value.totalProjects = projects.length
  stats.value.completedProjects = projects.filter(p => p.status === 'completed').length
  stats.value.processingProjects = projects.filter(p => p.status === 'processing' || p.status === 'queued').length
  
  if (stats.value.totalProjects > 0) {
    stats.value.successRate = Math.round((stats.value.completedProjects / stats.value.totalProjects) * 100)
  }
}

onMounted(async () => {
  await projectsStore.fetchProjects()
  calculateStats()
})
</script>
