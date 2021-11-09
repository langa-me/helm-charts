{{/*
Expand the name of the chart.
*/}}
{{- define "parlai.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "parlai.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "parlai.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "parlai.labels" -}}
helm.sh/chart: {{ include "parlai.chart" . }}
{{ include "parlai.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "parlai.selectorLabels" -}}
app.kubernetes.io/name: {{ include "parlai.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "parlai.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "parlai.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/* 
Create the parlai bot configuration 
*/}}
{{- define "parlai.botConfig" -}}
botConfig:
  tasks:
    default:
      onboard_world: MessengerBotChatOnboardWorld
      task_world: MessengerBotChatTaskWorld
      timeout: 1800
      agents_required: 1
  task_name: chatbot
  world_module: parlai.chat_service.tasks.chatbot.worlds
  overworld: MessengerOverworld
  max_workers: 30
  opt:
    debug: True
    models:
      blender_90M:
        model: transformer/generator
        model_file: zoo:blender/blender_90M/model
        interactive_mode: True
        no_cuda: True
{{- end }}
