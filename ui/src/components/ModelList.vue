<template>
  <div class="model-list">
    <div class="section-header">
      <h3 class="section-title">Models</h3>
      <span v-if="missingCount === 0" class="summary-text all-found">All found</span>
      <span v-else class="summary-text has-missing">Missing: {{ missingCount }} of {{ resources.length }}</span>
    </div>
    <div class="cards">
      <ModelCard
        v-for="(resource, index) in resources"
        :key="index"
        :resource="resource"
        @download="(r) => $emit('download', r)"
        @cancel="(r) => $emit('cancel', r)"
        @retry="(r) => $emit('retry', r)"
      />
    </div>

    <!-- Download All / Cancel All buttons -->
    <div v-if="downloadableCount > 0 || batchDownloading" class="batch-actions">
      <button
        v-if="!batchDownloading"
        class="batch-btn download-all-btn"
        @click="$emit('download-all')"
      >
        Download All Missing
      </button>
      <template v-else>
        <button class="batch-btn downloading-btn" disabled>
          Downloading... ({{ batchProgress }}/{{ batchTotal }})
        </button>
        <button class="batch-btn cancel-all-btn" @click="$emit('cancel-all')">
          Cancel All
        </button>
      </template>
    </div>

    <!-- Generate Workflow button -->
    <div class="workflow-actions">
      <button
        class="batch-btn generate-btn"
        :disabled="generatingWorkflow"
        @click="$emit('generate-workflow')"
      >
        <template v-if="generatingWorkflow">
          <span class="btn-spinner"></span>
          Generating...
        </template>
        <template v-else>
          Generate Workflow
        </template>
      </button>

      <!-- Workflow result confirmation -->
      <div v-if="workflowResult" class="workflow-result">
        <span class="workflow-result-icon">&#x2705;</span>
        <div class="workflow-result-text">
          <strong>Workflow loaded</strong>
          <span>{{ workflowResult.nodeCount }} nodes &middot; {{ workflowResult.type }}</span>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import type { Resource } from '../types'
import ModelCard from './ModelCard.vue'

const props = defineProps<{
  resources: Resource[]
  batchDownloading: boolean
  batchProgress: number
  batchTotal: number
  generatingWorkflow: boolean
  workflowResult: { type: string; nodeCount: number } | null
}>()

defineEmits<{
  download: [resource: Resource]
  cancel: [resource: Resource]
  retry: [resource: Resource]
  'download-all': []
  'cancel-all': []
  'generate-workflow': []
}>()

const missingCount = computed(() =>
  props.resources.filter(r => !r.already_downloaded).length
)

const downloadableCount = computed(() =>
  props.resources.filter(r => r.resolved && !r.already_downloaded && (!r.downloadStatus || r.downloadStatus === 'idle' || r.downloadStatus === 'failed' || r.downloadStatus === 'cancelled')).length
)
</script>

<style scoped>
.model-list {
  margin-bottom: 16px;
}

.section-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 8px;
}

.section-title {
  font-size: 12px;
  font-weight: 600;
  color: var(--fg-color);
  margin: 0;
  text-transform: uppercase;
  letter-spacing: 0.5px;
}

.summary-text {
  font-size: 11px;
}

.summary-text.all-found {
  color: var(--p-green-600);
  font-weight: 600;
}

.summary-text.has-missing {
  color: var(--error-text);
  font-weight: 600;
}

.cards {
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.batch-actions {
  display: flex;
  flex-direction: column;
  gap: 6px;
  margin-top: 10px;
}

.batch-btn {
  display: block;
  width: 100%;
  padding: 6px 12px;
  font-size: 12px;
  font-weight: 600;
  border: 1px solid var(--border-color);
  border-radius: 4px;
  cursor: pointer;
  background: var(--comfy-input-bg);
  color: var(--fg-color);
  transition: background 0.15s, border-color 0.15s;
}

.batch-btn:hover:not(:disabled) {
  background: var(--border-color);
}

.download-all-btn {
  color: var(--p-primary-500);
  border-color: var(--p-primary-500);
}

.download-all-btn:hover {
  background: rgba(var(--p-primary-500-rgb, 59, 130, 246), 0.15);
}

.downloading-btn {
  color: var(--descrip-text);
  cursor: default;
  opacity: 0.7;
}

.cancel-all-btn {
  color: var(--error-text);
  border-color: var(--error-text);
}

.cancel-all-btn:hover {
  background: rgba(220, 38, 38, 0.1);
}

.workflow-actions {
  margin-top: 10px;
}

.generate-btn {
  color: var(--p-primary-500);
  border-color: var(--p-primary-500);
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 6px;
}

.generate-btn:hover:not(:disabled) {
  background: rgba(var(--p-primary-500-rgb, 59, 130, 246), 0.15);
}

.generate-btn:disabled {
  opacity: 0.7;
  cursor: default;
}

.btn-spinner {
  display: inline-block;
  width: 12px;
  height: 12px;
  border: 2px solid var(--border-color);
  border-top-color: var(--p-primary-500);
  border-radius: 50%;
  animation: spin 0.6s linear infinite;
}

@keyframes spin {
  to { transform: rotate(360deg); }
}

.workflow-result {
  display: flex;
  align-items: flex-start;
  gap: 8px;
  margin-top: 8px;
  padding: 8px 10px;
  border-radius: 6px;
  background: var(--comfy-input-bg);
  border: 1px solid var(--border-color);
  font-size: 12px;
}

.workflow-result-icon {
  flex-shrink: 0;
  line-height: 1.4;
}

.workflow-result-text {
  display: flex;
  flex-direction: column;
  gap: 2px;
  color: var(--fg-color);
}

.workflow-result-text strong {
  font-weight: 600;
}

.workflow-result-text span {
  color: var(--descrip-text);
  font-size: 11px;
}
</style>
