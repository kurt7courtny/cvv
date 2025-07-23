<template>
  <div class="p-6">
    <div class="mb-8">
      <h1 class="text-3xl font-bold text-gray-900 dark:text-white">My Projects</h1>
      <p class="text-gray-600 dark:text-gray-400 mt-2">
        Manage and track your voice cloning projects
      </p>
    </div>

    <div class="card p-6">
      <div class="text-center py-12">
        <FolderIcon class="w-16 h-16 text-gray-400 mx-auto mb-4" />
        <h3 class="text-lg font-medium text-gray-900 dark:text-white mb-2">
          Projects View
        </h3>
        <p class="text-gray-600 dark:text-gray-400 mb-4">
          This view will show all your projects with filtering and management options
        </p>
        <router-link to="/upload" class="btn btn-primary">
          Create New Project
        </router-link>
      </div>
    </div>
  </div>
</template>

<script setup>
import { FolderIcon } from '@heroicons/vue/24/outline'
</script>
