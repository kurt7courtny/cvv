import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import axios from 'axios'
import { useToast } from 'vue-toastification'
import { io } from 'socket.io-client'

export const useProjectsStore = defineStore('projects', () => {
  const projects = ref([])
  const currentProject = ref(null)
  const loading = ref(false)
  const uploadProgress = ref({})
  const processingStatus = ref({})
  const socket = ref(null)
  const toast = useToast()

  const sortedProjects = computed(() => {
    return [...projects.value].sort((a, b) => new Date(b.updated_at) - new Date(a.updated_at))
  })

  const activeProjects = computed(() => {
    return projects.value.filter(p => p.status === 'processing' || p.status === 'queued')
  })

  const completedProjects = computed(() => {
    return projects.value.filter(p => p.status === 'completed')
  })

  // Initialize WebSocket connection
  const initializeSocket = () => {
    if (!socket.value) {
      socket.value = io('ws://localhost:8000', {
        auth: {
          token: localStorage.getItem('token')
        }
      })

      socket.value.on('processing_update', (data) => {
        updateProcessingStatus(data.project_id, data)
        toast.info(`Project ${data.project_id}: ${data.status}`)
      })

      socket.value.on('upload_progress', (data) => {
        uploadProgress.value[data.file_id] = data.progress
      })
    }
  }

  const disconnectSocket = () => {
    if (socket.value) {
      socket.value.disconnect()
      socket.value = null
    }
  }

  const fetchProjects = async () => {
    try {
      loading.value = true
      const response = await axios.get('/api/projects')
      projects.value = response.data
      return { success: true, data: response.data }
    } catch (error) {
      const message = error.response?.data?.message || 'Failed to fetch projects'
      toast.error(message)
      return { success: false, error: message }
    } finally {
      loading.value = false
    }
  }

  const createProject = async (projectData) => {
    try {
      loading.value = true
      const response = await axios.post('/api/projects', projectData)
      projects.value.unshift(response.data)
      toast.success('Project created successfully!')
      return { success: true, data: response.data }
    } catch (error) {
      const message = error.response?.data?.message || 'Failed to create project'
      toast.error(message)
      return { success: false, error: message }
    } finally {
      loading.value = false
    }
  }

  const fetchProject = async (projectId) => {
    try {
      loading.value = true
      const response = await axios.get(`/api/projects/${projectId}`)
      currentProject.value = response.data
      return { success: true, data: response.data }
    } catch (error) {
      const message = error.response?.data?.message || 'Failed to fetch project'
      toast.error(message)
      return { success: false, error: message }
    } finally {
      loading.value = false
    }
  }

  const updateProject = async (projectId, updates) => {
    try {
      const response = await axios.put(`/api/projects/${projectId}`, updates)
      const index = projects.value.findIndex(p => p.id === projectId)
      if (index !== -1) {
        projects.value[index] = response.data
      }
      if (currentProject.value?.id === projectId) {
        currentProject.value = response.data
      }
      toast.success('Project updated successfully!')
      return { success: true, data: response.data }
    } catch (error) {
      const message = error.response?.data?.message || 'Failed to update project'
      toast.error(message)
      return { success: false, error: message }
    }
  }

  const deleteProject = async (projectId) => {
    try {
      await axios.delete(`/api/projects/${projectId}`)
      projects.value = projects.value.filter(p => p.id !== projectId)
      if (currentProject.value?.id === projectId) {
        currentProject.value = null
      }
      toast.success('Project deleted successfully!')
      return { success: true }
    } catch (error) {
      const message = error.response?.data?.message || 'Failed to delete project'
      toast.error(message)
      return { success: false, error: message }
    }
  }

  const uploadVideo = async (projectId, file, onProgress) => {
    try {
      const formData = new FormData()
      formData.append('video', file)
      formData.append('project_id', projectId)

      const response = await axios.post('/api/projects/upload', formData, {
        headers: {
          'Content-Type': 'multipart/form-data'
        },
        onUploadProgress: (progressEvent) => {
          const progress = Math.round((progressEvent.loaded * 100) / progressEvent.total)
          if (onProgress) onProgress(progress)
          uploadProgress.value[file.name] = progress
        }
      })

      toast.success('Video uploaded successfully!')
      return { success: true, data: response.data }
    } catch (error) {
      const message = error.response?.data?.message || 'Failed to upload video'
      toast.error(message)
      return { success: false, error: message }
    }
  }

  const startProcessing = async (projectId, options) => {
    try {
      const response = await axios.post(`/api/projects/${projectId}/process`, options)
      updateProcessingStatus(projectId, { status: 'queued', progress: 0 })
      toast.success('Processing started!')
      return { success: true, data: response.data }
    } catch (error) {
      const message = error.response?.data?.message || 'Failed to start processing'
      toast.error(message)
      return { success: false, error: message }
    }
  }

  const updateProcessingStatus = (projectId, status) => {
    processingStatus.value[projectId] = status
    
    // Update project in the list
    const projectIndex = projects.value.findIndex(p => p.id === projectId)
    if (projectIndex !== -1) {
      projects.value[projectIndex] = {
        ...projects.value[projectIndex],
        status: status.status,
        progress: status.progress
      }
    }

    // Update current project if it matches
    if (currentProject.value?.id === projectId) {
      currentProject.value = {
        ...currentProject.value,
        status: status.status,
        progress: status.progress
      }
    }
  }

  const downloadResult = async (projectId, format = 'mp4') => {
    try {
      const response = await axios.get(`/api/projects/${projectId}/download`, {
        params: { format },
        responseType: 'blob'
      })

      const url = window.URL.createObjectURL(new Blob([response.data]))
      const link = document.createElement('a')
      link.href = url
      link.setAttribute('download', `project_${projectId}.${format}`)
      document.body.appendChild(link)
      link.click()
      link.remove()
      window.URL.revokeObjectURL(url)

      toast.success('Download started!')
      return { success: true }
    } catch (error) {
      const message = error.response?.data?.message || 'Failed to download result'
      toast.error(message)
      return { success: false, error: message }
    }
  }

  return {
    projects,
    currentProject,
    loading,
    uploadProgress,
    processingStatus,
    sortedProjects,
    activeProjects,
    completedProjects,
    initializeSocket,
    disconnectSocket,
    fetchProjects,
    createProject,
    fetchProject,
    updateProject,
    deleteProject,
    uploadVideo,
    startProcessing,
    updateProcessingStatus,
    downloadResult
  }
})
