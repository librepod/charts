{{- /*
The pod definition included in the controller.
*/ -}}
{{- define "librepod.controller.pod" -}}
  {{- with .Values.imagePullSecrets }}
imagePullSecrets:
    {{- toYaml . | nindent 2 }}
  {{- end }}
serviceAccountName: {{ include "librepod.names.serviceAccountName" . }}
  {{- with .Values.podSecurityContext }}
securityContext:
    {{- toYaml . | nindent 2 }}
  {{- end }}
  {{- with .Values.priorityClassName }}
priorityClassName: {{ . }}
  {{- end }}
  {{- with .Values.schedulerName }}
schedulerName: {{ . }}
  {{- end }}
  {{- with .Values.hostNetwork }}
hostNetwork: {{ . }}
  {{- end }}
  {{- with .Values.hostname }}
hostname: {{ . }}
  {{- end }}
  {{- if .Values.dnsPolicy }}
dnsPolicy: {{ .Values.dnsPolicy }}
  {{- else if .Values.hostNetwork }}
dnsPolicy: ClusterFirstWithHostNet
  {{- else }}
dnsPolicy: ClusterFirst
  {{- end }}
  {{- with .Values.dnsConfig }}
dnsConfig:
    {{- toYaml . | nindent 2 }}
  {{- end }}
enableServiceLinks: {{ .Values.enableServiceLinks }}
  {{- with .Values.initContainers }}
initContainers:
    {{- toYaml . | nindent 2 }}
  {{- end }}
containers:
  {{- include "librepod.controller.mainContainer" . | nindent 2 }}
  {{- with .Values.additionalContainers }}
    {{- tpl (toYaml .) $ | nindent 2 }}
  {{- end }}
  {{- with (include "librepod.controller.volumes" . | trim) }}
volumes:
    {{- nindent 2 . }}
  {{- end }}
  {{- with .Values.hostAliases }}
hostAliases:
    {{- toYaml . | nindent 2 }}
  {{- end }}
  {{- with .Values.nodeSelector }}
nodeSelector:
    {{- toYaml . | nindent 2 }}
  {{- end }}
  {{- with .Values.affinity }}
affinity:
    {{- toYaml . | nindent 2 }}
  {{- end }}
  {{- with .Values.tolerations }}
tolerations:
    {{- toYaml . | nindent 2 }}
  {{- end }}
{{- end -}}
