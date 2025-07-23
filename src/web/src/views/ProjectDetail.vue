<template>
  <div class="p-6">
    <div class="mb-8">
      <h1 class="text-3xl font-bold text-gray-900 dark:text-white">Project Details</h1>
      <p class="text-gray-600 dark:text-gray-400 mt-2">
        Project ID: {{ id }}
      </p>
    </div>

    <div class="card p-6">
      <div class="text-center py-12">
        <VideoCameraIcon class="w-16 h-16 text-gray-400 mx-auto mb-4" />
        <h3 class="text-lg font-medium text-gray-900 dark:text-white mb-2">
          Project Detail View
        </h3>
        <p class="text-gray-600 dark:text-gray-400 mb-4">
          This view will show detailed project information, processing status, and results
        </p>
        <router-link to="/projects" class="btn btn-secondary">
          Back to Projects
        </router-link>
      </div>
    </div>
  </div>
</template>

<script setup>
import { VideoCameraIcon } from '@heroicons/vue/24/outline'

const props = defineProps({
  id: {
    type: String,
    required: true
  }
})
</script>
