<template>
  <div class="min-h-screen flex items-center justify-center bg-gray-50 dark:bg-gray-900 py-12 px-4 sm:px-6 lg:px-8">
    <div class="max-w-md w-full text-center">
      <div class="mb-8">
        <h1 class="text-9xl font-bold text-gray-300 dark:text-gray-700">404</h1>
        <h2 class="text-2xl font-semibold text-gray-900 dark:text-white mb-4">
          Page Not Found
        </h2>
        <p class="text-gray-600 dark:text-gray-400 mb-8">
          The page you're looking for doesn't exist or has been moved.
        </p>
      </div>
      
      <div class="space-y-4">
        <router-link to="/" class="btn btn-primary w-full">
          Go Home
        </router-link>
        <button @click="$router.go(-1)" class="btn btn-secondary w-full">
          Go Back
        </button>
      </div>
    </div>
  </div>
</template>

<script setup>
// 404 Not Found page
</script>
