{{/* Merge the local chart values and the librepod chart defaults */}}
{{- define "librepod.values.setup" -}}
  {{- if .Values.librepod -}}
    {{- $defaultValues := deepCopy .Values.librepod -}}
    {{- $userValues := deepCopy (omit .Values "librepod") -}}
    {{- $mergedValues := mustMergeOverwrite $defaultValues $userValues -}}
    {{- $_ := set . "Values" (deepCopy $mergedValues) -}}
  {{- end -}}
{{- end -}}
