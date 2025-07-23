<template>
  <div class="min-h-screen">
    <!-- Hero Section -->
    <section class="relative bg-gradient-to-br from-primary-600 via-purple-600 to-pink-600 text-white">
      <div class="absolute inset-0 bg-black/20"></div>
      <div class="relative max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-24">
        <div class="text-center">
          <h1 class="text-4xl md:text-6xl font-bold mb-6">
            Transform Your Videos with
            <span class="text-gradient bg-gradient-to-r from-yellow-400 to-orange-500 bg-clip-text text-transparent">
              AI Voice Cloning
            </span>
          </h1>
          <p class="text-xl md:text-2xl mb-8 text-gray-100 max-w-3xl mx-auto">
            Convert any video to speak in any language with our advanced voice cloning technology. 
            Preserve the original speaker's voice while changing the language seamlessly.
          </p>
          <div class="flex flex-col sm:flex-row gap-4 justify-center">
            <router-link
              v-if="!authStore.isAuthenticated"
              to="/register"
              class="btn btn-primary text-lg px-8 py-3 bg-white text-primary-600 hover:bg-gray-100"
            >
              Get Started Free
            </router-link>
            <router-link
              v-else
              to="/dashboard"
              class="btn btn-primary text-lg px-8 py-3 bg-white text-primary-600 hover:bg-gray-100"
            >
              Go to Dashboard
            </router-link>
            <button class="btn btn-secondary text-lg px-8 py-3 border-2 border-white text-white hover:bg-white hover:text-primary-600">
              Watch Demo
            </button>
          </div>
        </div>
      </div>
    </section>

    <!-- Features Section -->
    <section class="py-20 bg-white dark:bg-gray-900">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="text-center mb-16">
          <h2 class="text-3xl md:text-4xl font-bold text-gray-900 dark:text-white mb-4">
            Powerful Features
          </h2>
          <p class="text-xl text-gray-600 dark:text-gray-400 max-w-2xl mx-auto">
            Everything you need to create professional voice-cloned videos
          </p>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
          <div
            v-for="feature in features"
            :key="feature.title"
            class="card p-6 text-center hover:shadow-lg transition-shadow duration-200"
          >
            <div class="w-12 h-12 bg-primary-100 dark:bg-primary-900 rounded-lg flex items-center justify-center mx-auto mb-4">
              <component :is="feature.icon" class="w-6 h-6 text-primary-600 dark:text-primary-400" />
            </div>
            <h3 class="text-xl font-semibold text-gray-900 dark:text-white mb-2">
              {{ feature.title }}
            </h3>
            <p class="text-gray-600 dark:text-gray-400">
              {{ feature.description }}
            </p>
          </div>
        </div>
      </div>
    </section>

    <!-- How It Works Section -->
    <section class="py-20 bg-gray-50 dark:bg-gray-800">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="text-center mb-16">
          <h2 class="text-3xl md:text-4xl font-bold text-gray-900 dark:text-white mb-4">
            How It Works
          </h2>
          <p class="text-xl text-gray-600 dark:text-gray-400 max-w-2xl mx-auto">
            Simple 4-step process to transform your videos
          </p>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8">
          <div
            v-for="(step, index) in steps"
            :key="step.title"
            class="text-center"
          >
            <div class="relative mb-6">
              <div class="w-16 h-16 bg-primary-600 rounded-full flex items-center justify-center mx-auto">
                <span class="text-2xl font-bold text-white">{{ index + 1 }}</span>
              </div>
              <div
                v-if="index < steps.length - 1"
                class="hidden lg:block absolute top-8 left-full w-full h-0.5 bg-primary-200 dark:bg-primary-800"
              ></div>
            </div>
            <h3 class="text-lg font-semibold text-gray-900 dark:text-white mb-2">
              {{ step.title }}
            </h3>
            <p class="text-gray-600 dark:text-gray-400">
              {{ step.description }}
            </p>
          </div>
        </div>
      </div>
    </section>

    <!-- CTA Section -->
    <section class="py-20 bg-primary-600">
      <div class="max-w-4xl mx-auto text-center px-4 sm:px-6 lg:px-8">
        <h2 class="text-3xl md:text-4xl font-bold text-white mb-4">
          Ready to Transform Your Videos?
        </h2>
        <p class="text-xl text-primary-100 mb-8">
          Join thousands of creators who are already using our platform
        </p>
        <router-link
          v-if="!authStore.isAuthenticated"
          to="/register"
          class="btn btn-primary text-lg px-8 py-3 bg-white text-primary-600 hover:bg-gray-100"
        >
          Start Your Free Trial
        </router-link>
        <router-link
          v-else
          to="/upload"
          class="btn btn-primary text-lg px-8 py-3 bg-white text-primary-600 hover:bg-gray-100"
        >
          Upload Your First Video
        </router-link>
      </div>
    </section>
  </div>
</template>

<script setup>
import { useAuthStore } from '@/stores/auth'
import {
  VideoCameraIcon,
  SpeakerWaveIcon,
  GlobeAltIcon,
  SparklesIcon,
  CloudArrowUpIcon,
  CogIcon
} from '@heroicons/vue/24/outline'

const authStore = useAuthStore()

const features = [
  {
    title: 'AI Voice Cloning',
    description: 'Advanced AI technology that preserves the original speaker\'s voice characteristics while changing the language.',
    icon: SpeakerWaveIcon
  },
  {
    title: '50+ Languages',
    description: 'Support for over 50 languages with natural-sounding accents and dialects.',
    icon: GlobeAltIcon
  },
  {
    title: 'High Quality Output',
    description: 'Professional-grade video and audio quality with seamless lip-sync technology.',
    icon: VideoCameraIcon
  },
  {
    title: 'Easy Upload',
    description: 'Simple drag-and-drop interface supporting multiple video formats up to 2GB.',
    icon: CloudArrowUpIcon
  },
  {
    title: 'Fast Processing',
    description: 'Quick turnaround times with real-time progress tracking and notifications.',
    icon: SparklesIcon
  },
  {
    title: 'Custom Settings',
    description: 'Fine-tune voice characteristics, speaking speed, and emotional tone.',
    icon: CogIcon
  }
]

const steps = [
  {
    title: 'Upload Video',
    description: 'Upload your video file in any supported format'
  },
  {
    title: 'Select Language',
    description: 'Choose your target language and voice preferences'
  },
  {
    title: 'AI Processing',
    description: 'Our AI analyzes and processes your video'
  },
  {
    title: 'Download Result',
    description: 'Get your transformed video in minutes'
  }
]
</script>
