apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ include "mock_ec2_metadata.fullname" . }}
  labels:
    {{- include "mock_ec2_metadata.labels" . | nindent 4 }}
spec:
  {{- if not .Values.autoscaling.enabled }}
  replicas: {{ .Values.replicaCount }}
  {{- end }}
  selector:
    matchLabels:
      {{- include "mock_ec2_metadata.selectorLabels" . | nindent 6 }}
  template:
    metadata:
      annotations:
        iam.amazonaws.com/role: arn:aws:iam::{{ required "A valid aws.accountId entry required!" .Values.aws.accountId }}:role/{{ required "A valid aws.podRoleName entry required!" .Values.aws.podRoleName }}
        {{- with .Values.podAnnotations }}
        {{- toYaml . | nindent 8 }}
        {{- end }}
      labels:
        {{- include "mock_ec2_metadata.selectorLabels" . | nindent 8 }}
    spec:
      {{- with .Values.imagePullSecrets }}
      imagePullSecrets:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      serviceAccountName: {{ include "mock_ec2_metadata.serviceAccountName" . }}
      securityContext:
        {{- toYaml .Values.podSecurityContext | nindent 8 }}
      initContainers:
        - name: update-iptables-init
          image: "{{ .Values.mockMetadata.updateIptables.image.repository }}:{{ .Values.mockMetadata.updateIptables.image.tag | default "latest" }}"
          imagePullPolicy: {{ .Values.mockMetadata.updateIptables.image.pullPolicy | default "IfNotPresent" }}
          env:
          - name: MOCK_METADATA_IP
            valueFrom:
              fieldRef:
                fieldPath: status.podIP
          - name: MOCK_METADATA_PORT
            value: {{ .Values.mockMetadata.port | default 9081 | quote }}
          securityContext:
            privileged: true
      containers:
        - name: {{ .Chart.Name }}
          securityContext:
            {{- toYaml .Values.securityContext | nindent 12 }}
          image: "{{ .Values.image.repository }}:{{ .Values.image.tag | default .Chart.AppVersion }}"
          imagePullPolicy: {{ .Values.image.pullPolicy }}
          ports:
            - name: http
              containerPort: {{ .Values.service.containerPort }}
              hostPort: 80
          {{- if .Values.livenessProbe }}
          livenessProbe:
            {{- toYaml .Values.livenessProbe | nindent 12 }}
          {{- end }}
          {{- if .Values.readinessProbe }}
          readinessProbe:
            {{- toYaml .Values.readinessProbe | nindent 12 }}
          {{- end }}
          resources:
            {{- toYaml .Values.resources | nindent 12 }}
          env:
          - name: PORT
            value: {{ required "Must provide a value for service.containerPort, which is the port the app will listen on." .Values.service.containerPort | quote }}
          - name: AWS_DEFAULT_REGION
            value: {{ required "Must provide AWS_DEFAULT_REGION value in aws.region"  .Values.aws.region }}
      {{- with .Values.nodeSelector }}
      nodeSelector:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with .Values.affinity }}
      affinity:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with .Values.tolerations }}
      tolerations:
        {{- toYaml . | nindent 8 }}
      {{- end }}
        - name: ectou-metadata-sidecar
          securityContext:
            {{- toYaml .Values.securityContext | nindent 12 }}
          image: "{{ .Values.mockMetadata.image.repository }}:{{ .Values.mockMetadata.image.tag | default "latest" }}"
          imagePullPolicy: {{ .Values.mockMetadata.image.pullPolicy | default "IfNotPresent" }}
          env:
          - name: MOCK_METADATA_IP
            valueFrom:
              fieldRef:
                fieldPath: status.podIP
          - name: MOCK_METADATA_PORT
            value: {{ .Values.mockMetadata.port | default 9081 | quote }}
          - name: MOCK_METADATA_ROLE_ARN
            valueFrom:
              fieldRef:
                fieldPath: metadata.annotations['iam.amazonaws.com/role']
          - name: AWS_ACCESS_KEY_ID
            valueFrom:
              secretKeyRef:
                name: {{ include "charts.secrets" . }}
                key: awsAccessKeyId
          - name: AWS_SECRET_ACCESS_KEY
            valueFrom:
              secretKeyRef:
                name: {{ include "charts.secrets" . }}
                key: awsSecretAccessKey
          - name: AWS_SESSION_TOKEN
            valueFrom:
              secretKeyRef:
                name: {{ include "charts.secrets" . }}
                key: awsSessionToken
          - name: AWS_DEFAULT_REGION
            value: {{ required "Must provide AWS_DEFAULT_REGION value in aws.region"  .Values.aws.region }}
          ports:
          - containerPort: 9080
