<template>
  <div class="p-6">
    <div class="mb-8">
      <h1 class="text-3xl font-bold text-gray-900 dark:text-white">Profile</h1>
      <p class="text-gray-600 dark:text-gray-400 mt-2">
        Manage your account settings and preferences
      </p>
    </div>

    <div class="card p-6">
      <div class="text-center py-12">
        <UserIcon class="w-16 h-16 text-gray-400 mx-auto mb-4" />
        <h3 class="text-lg font-medium text-gray-900 dark:text-white mb-2">
          Profile Settings
        </h3>
        <p class="text-gray-600 dark:text-gray-400 mb-4">
          This view will allow users to manage their profile, subscription, and account settings
        </p>
        <router-link to="/dashboard" class="btn btn-primary">
          Back to Dashboard
        </router-link>
      </div>
    </div>
  </div>
</template>

<script setup>
import { UserIcon } from '@heroicons/vue/24/outline'
</script>
