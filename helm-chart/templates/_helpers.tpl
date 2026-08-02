{{- define "pa-expunger.allowedHosts" -}}
{{- /* Start with the list of extra hosts from values.yaml */ -}}
{{- $hosts := .Values.backend.allowedHosts.extra | default list | deepCopy -}}
{{- /* Add the internal Kubernetes service names */ -}}
{{- $hosts = append $hosts (printf "%s-backend-svc" .Release.Name) -}}
{{- $hosts = append $hosts (printf "%s-backend-svc.%s.svc.cluster.local" .Release.Name .Release.Namespace) -}}
{{- /* Add all hosts defined in the ingress section */ -}}
{{- range .Values.ingress.hosts -}}
{{- $hosts = append $hosts .host -}}
{{- end -}}
{{- /* Join the list into a comma-separated string, removing duplicates */ -}}
{{- $hosts | uniq | join "," -}}
{{- end -}}

{{/*
Construct the backend API host from the first ingress host
*/}}
{{- define "pa-expunger.backendApiUrl" -}}
{{- if .Values.apiUrlOverride }}
{{- /* If an explicit apiUrl is provided (and is not an empty string), use it. */ -}}
{{- .Values.apiUrlOverride -}}
{{- else if and .Values.ingress.enabled .Values.ingress.hosts }}
{{- /* Otherwise, if ingress hosts exist, derive the URL from the first one. */ -}}
{{- $host := first .Values.ingress.hosts -}}
{{- printf "https://%s" $host.host -}}
{{- end -}}
{{- end -}}

{{/*
Returns the appropriate backend secret name based on the context.
If secrets.create is true (local testing), it uses the local dummy secret name.
Otherwise, it uses the production secret name from values.
*/}}
{{- define "pa-expunger.backendSecretName" -}}
{{- ternary .Values.secrets.backendSecretName .Values.backend.existingSecret .Values.secrets.create -}}
{{- end -}}

{{/*
As in the above function, returns the appropriate postgres secret name based on the context.
*/}}
{{- define "pa-expunger.postgresSecretName" -}}
{{- ternary .Values.secrets.postgresSecretName .Values.postgres.existingSecret .Values.secrets.create -}}
{{- end -}}
