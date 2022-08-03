{{/*
Common labels shared across objects
*/}}
{{- define "librepod.labels" -}}
helm.sh/chart: {{ include "librepod.names.chart" . }}
{{ include "librepod.labels.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels shared across objects
*/}}
{{- define "librepod.labels.selectorLabels" -}}
app.kubernetes.io/name: {{ include "librepod.names.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}


