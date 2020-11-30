apiVersion: v1
kind: Service
metadata:
  name: {{ include "mock_ec2_metadata.fullname" . }}
  labels:
    {{- include "mock_ec2_metadata.labels" . | nindent 4 }}
spec:
  type: {{ .Values.service.type }}
  ports:
    - port: {{ .Values.service.port }}
      targetPort: http
      name: http
  selector:
    {{- include "mock_ec2_metadata.selectorLabels" . | nindent 4 }}
