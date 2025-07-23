<template>
  <div class="p-6">
    <!-- Header -->
    <div class="mb-8">
      <h1 class="text-3xl font-bold text-gray-900 dark:text-white">Upload Video</h1>
      <p class="text-gray-600 dark:text-gray-400 mt-2">
        Upload your video file to start the voice cloning process
      </p>
    </div>

    <!-- Upload Area -->
    <div class="max-w-4xl mx-auto">
      <div class="card p-8">
        <div
          ref="dropZone"
          class="upload-area"
          :class="{ 'dragover': isDragOver }"
          @drop="handleDrop"
          @dragover="handleDragOver"
          @dragenter="handleDragEnter"
          @dragleave="handleDragLeave"
          @click="triggerFileInput"
        >
          <input
            ref="fileInput"
            type="file"
            accept="video/*"
            multiple
            class="hidden"
            @change="handleFileSelect"
          />

          <div class="text-center">
            <CloudArrowUpIcon class="w-16 h-16 text-gray-400 mx-auto mb-4" />
            <h3 class="text-lg font-medium text-gray-900 dark:text-white mb-2">
              Drop your videos here, or click to browse
            </h3>
            <p class="text-gray-600 dark:text-gray-400 mb-4">
              Supports MP4, AVI, MOV, MKV, WebM up to 2GB
            </p>
            <button class="btn btn-primary">
              Choose Files
            </button>
          </div>
        </div>

        <!-- File List -->
        <div v-if="selectedFiles.length > 0" class="mt-8">
          <h3 class="text-lg font-semibold text-gray-900 dark:text-white mb-4">
            Selected Files ({{ selectedFiles.length }})
          </h3>
          
          <div class="space-y-4">
            <div
              v-for="(file, index) in selectedFiles"
              :key="index"
              class="flex items-center justify-between p-4 border border-gray-200 dark:border-gray-700 rounded-lg"
            >
              <div class="flex items-center space-x-4">
                <div class="w-12 h-12 bg-gray-100 dark:bg-gray-700 rounded-lg flex items-center justify-center">
                  <VideoCameraIcon class="w-6 h-6 text-gray-600 dark:text-gray-400" />
                </div>
                <div>
                  <p class="font-medium text-gray-900 dark:text-white">{{ file.name }}</p>
                  <p class="text-sm text-gray-600 dark:text-gray-400">
                    {{ formatFileSize(file.size) }} • {{ file.type }}
                  </p>
                </div>
              </div>

              <div class="flex items-center space-x-2">
                <!-- Upload Progress -->
                <div v-if="uploadProgress[file.name]" class="flex items-center space-x-2">
                  <div class="w-32 bg-gray-200 dark:bg-gray-700 rounded-full h-2">
                    <div
                      class="bg-primary-600 h-2 rounded-full transition-all duration-300"
                      :style="{ width: `${uploadProgress[file.name]}%` }"
                    ></div>
                  </div>
                  <span class="text-sm text-gray-600 dark:text-gray-400">
                    {{ uploadProgress[file.name] }}%
                  </span>
                </div>

                <button
                  @click="removeFile(index)"
                  class="text-red-600 hover:text-red-500 p-1"
                >
                  <XMarkIcon class="w-5 h-5" />
                </button>
              </div>
            </div>
          </div>

          <!-- Project Settings -->
          <div class="mt-8 p-6 bg-gray-50 dark:bg-gray-800 rounded-lg">
            <h3 class="text-lg font-semibold text-gray-900 dark:text-white mb-4">
              Project Settings
            </h3>
            
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
              <div>
                <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                  Project Name
                </label>
                <input
                  v-model="projectSettings.name"
                  type="text"
                  class="input"
                  placeholder="Enter project name"
                />
              </div>

              <div>
                <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                  Target Language
                </label>
                <select v-model="projectSettings.targetLanguage" class="input">
                  <option value="">Select language</option>
                  <option v-for="lang in languages" :key="lang.code" :value="lang.code">
                    {{ lang.name }}
                  </option>
                </select>
              </div>

              <div>
                <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                  Voice Style
                </label>
                <select v-model="projectSettings.voiceStyle" class="input">
                  <option value="auto">Auto-detect</option>
                  <option value="male">Male</option>
                  <option value="female">Female</option>
                  <option value="child">Child</option>
                </select>
              </div>

              <div>
                <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                  Quality
                </label>
                <select v-model="projectSettings.quality" class="input">
                  <option value="standard">Standard</option>
                  <option value="high">High Quality</option>
                  <option value="premium">Premium</option>
                </select>
              </div>
            </div>

            <div class="mt-6">
              <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                Description (Optional)
              </label>
              <textarea
                v-model="projectSettings.description"
                rows="3"
                class="input"
                placeholder="Add a description for your project"
              ></textarea>
            </div>
          </div>

          <!-- Upload Button -->
          <div class="mt-8 flex justify-end space-x-4">
            <button
              @click="clearFiles"
              class="btn btn-secondary"
            >
              Clear All
            </button>
            <button
              @click="startUpload"
              :disabled="!canUpload || isUploading"
              class="btn btn-primary"
            >
              <span v-if="!isUploading">Start Upload</span>
              <span v-else class="flex items-center">
                <div class="loading-spinner w-4 h-4 mr-2"></div>
                Uploading...
              </span>
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, computed } from 'vue'
import { useRouter } from 'vue-router'
import { useProjectsStore } from '@/stores/projects'
import { useToast } from 'vue-toastification'
import {
  CloudArrowUpIcon,
  VideoCameraIcon,
  XMarkIcon
} from '@heroicons/vue/24/outline'

const router = useRouter()
const projectsStore = useProjectsStore()
const toast = useToast()

const dropZone = ref(null)
const fileInput = ref(null)
const selectedFiles = ref([])
const isDragOver = ref(false)
const isUploading = ref(false)
const uploadProgress = ref({})

const projectSettings = reactive({
  name: '',
  targetLanguage: '',
  voiceStyle: 'auto',
  quality: 'standard',
  description: ''
})

const languages = [
  { code: 'en', name: 'English' },
  { code: 'es', name: 'Spanish' },
  { code: 'fr', name: 'French' },
  { code: 'de', name: 'German' },
  { code: 'it', name: 'Italian' },
  { code: 'pt', name: 'Portuguese' },
  { code: 'ru', name: 'Russian' },
  { code: 'ja', name: 'Japanese' },
  { code: 'ko', name: 'Korean' },
  { code: 'zh', name: 'Chinese' },
  { code: 'ar', name: 'Arabic' },
  { code: 'hi', name: 'Hindi' }
]

const canUpload = computed(() => {
  return selectedFiles.value.length > 0 && 
         projectSettings.name && 
         projectSettings.targetLanguage
})

const triggerFileInput = () => {
  fileInput.value?.click()
}

const handleFileSelect = (event) => {
  const files = Array.from(event.target.files)
  addFiles(files)
}

const handleDrop = (event) => {
  event.preventDefault()
  isDragOver.value = false
  
  const files = Array.from(event.dataTransfer.files)
  const videoFiles = files.filter(file => file.type.startsWith('video/'))
  
  if (videoFiles.length !== files.length) {
    toast.warning('Only video files are allowed')
  }
  
  addFiles(videoFiles)
}

const handleDragOver = (event) => {
  event.preventDefault()
}

const handleDragEnter = (event) => {
  event.preventDefault()
  isDragOver.value = true
}

const handleDragLeave = (event) => {
  event.preventDefault()
  if (!dropZone.value?.contains(event.relatedTarget)) {
    isDragOver.value = false
  }
}

const addFiles = (files) => {
  const maxSize = 2 * 1024 * 1024 * 1024 // 2GB
  const validFiles = []
  
  files.forEach(file => {
    if (file.size > maxSize) {
      toast.error(`File ${file.name} is too large. Maximum size is 2GB.`)
      return
    }
    
    if (!selectedFiles.value.some(f => f.name === file.name && f.size === file.size)) {
      validFiles.push(file)
    }
  })
  
  selectedFiles.value.push(...validFiles)
  
  // Auto-generate project name if empty
  if (!projectSettings.name && validFiles.length > 0) {
    const baseName = validFiles[0].name.replace(/\.[^/.]+$/, '')
    projectSettings.name = `Voice Clone - ${baseName}`
  }
}

const removeFile = (index) => {
  const fileName = selectedFiles.value[index].name
  selectedFiles.value.splice(index, 1)
  delete uploadProgress.value[fileName]
}

const clearFiles = () => {
  selectedFiles.value = []
  uploadProgress.value = {}
  projectSettings.name = ''
  projectSettings.description = ''
}

const formatFileSize = (bytes) => {
  if (bytes === 0) return '0 Bytes'
  const k = 1024
  const sizes = ['Bytes', 'KB', 'MB', 'GB']
  const i = Math.floor(Math.log(bytes) / Math.log(k))
  return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i]
}

const startUpload = async () => {
  if (!canUpload.value) return
  
  isUploading.value = true
  
  try {
    // Create project first
    const projectResult = await projectsStore.createProject({
      name: projectSettings.name,
      description: projectSettings.description,
      target_language: projectSettings.targetLanguage,
      voice_style: projectSettings.voiceStyle,
      quality: projectSettings.quality
    })
    
    if (!projectResult.success) {
      throw new Error('Failed to create project')
    }
    
    const projectId = projectResult.data.id
    
    // Upload files
    for (const file of selectedFiles.value) {
      await projectsStore.uploadVideo(projectId, file, (progress) => {
        uploadProgress.value[file.name] = progress
      })
    }
    
    toast.success('Upload completed successfully!')
    router.push(`/project/${projectId}`)
    
  } catch (error) {
    console.error('Upload error:', error)
    toast.error('Upload failed. Please try again.')
  } finally {
    isUploading.value = false
  }
}
</script>
