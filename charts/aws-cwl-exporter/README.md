# AWS CloudWatch Log Exporter Helm Chart

![Version: 0.2.0](https://img.shields.io/badge/Version-0.2.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 2.15.43](https://img.shields.io/badge/AppVersion-2.15.43-informational?style=flat-square) 

A productivity tool that makes it easy to schedule automated log exports to an AWS S3 Bucket.

## Source Code

* <https://github.com/StevenJDH/aws-cwl-exporter>

## Requirements

Kubernetes: `>= 1.19.0-0`

| Repository | Name | Version |
|------------|------|---------|
| https://StevenJDH.github.io/helm-charts | shared-library | 0.1.2 |## Usage example

```bash
helm repo add stevenjdh https://StevenJDH.github.io/helm-charts
helm repo update
helm upgrade --install my-aws-cwl-exporter stevenjdh/aws-cwl-exporter --version 0.2.0 \
    --set serviceAccount.aws.irsa.enabled=true \
    --set-string serviceAccount.aws.irsa.roleArn=arn:aws:iam::000000000000:role/example-irsa-role \
    --set-string configMap.logGroupName=/aws/lambda/hello-world-dev \
    --set-string configMap.s3BucketName=s3-example-log-exports \
    --set-string configMap.exportPrefix=export-task-output \
    --set-string configMap.exportPeriod=hourly \
    --namespace example \
    --create-namespace \
    --atomic
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` | affinity for pod scheduling. Reference [Assign Pods to Nodes using Node Affinity](https://kubernetes.io/docs/tasks/configure-pod-container/assign-pods-nodes-using-node-affinity). |
| configMap.awsDefaultRegion | string | `""` | Optional. The AWS Region to use for requests. Must match log group and S3 bucket region. Not required when using [IRSA](https://github.com/StevenJDH/Terraform-Modules/tree/main/aws/irsa). |
| configMap.exportPeriod | string | `"hourly"` | Optional. The `hourly` or `daily` period used for collecting logs. Not required unless set to `daily`. |
| configMap.exportPrefix | string | `"export-task-output"` | Required. The prefix used as the start of the key for every object exported. |
| configMap.logGroupName | string | `""` | Required. The name of the log group source for exporting logs from. |
| configMap.s3BucketName | string | `""` | Required. The name of S3 bucket storing the exported log data. The bucket must be in the same AWS region. |
| cronjob.annotations | object | `{}` | annotations to be added to the CronJob resource. |
| cronjob.job.extraEnvs | list | `[]` | Additional environment variables to set. |
| cronjob.job.extraInitContainers | list | `[]` | Containers, which are run before the app containers are started. |
| cronjob.job.podAnnotations | object | `{}` | podAnnotations are the annotations to be added to the job pods. |
| cronjob.job.priorityClassName | string | `""` | priorityClassName is the name of the PriorityClass resource that indicates the importance of a Pod relative to other Pods. If a Pod cannot be scheduled, the scheduler tries to preempt (evict) lower priority Pods to make scheduling of the pending Pod possible. Reference [Pod Priority and Preemption](https://kubernetes.io/docs/concepts/scheduling-eviction/pod-priority-preemption). |
| cronjob.job.resources | object | `{}` | Optionally request and limit how much CPU and memory (RAM) the container needs. Reference [Resource Management for Pods and Containers](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers). |
| cronjob.schedule | string | `"5 * * * *"` | The Cron schedule to trigger a CreateExportTask for the previous hour or day based on `configMap.exportPeriod`. Default is every hour at minute 5. Note: There is a limit of "one active (running or pending) export task at a time, per account. This quota can't be changed." See [CloudWatch Logs quotas](https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/cloudwatch_limits_cwl.html) for more information. |
| fullnameOverride | string | `""` | Override for generated resource names. |
| image.pullPolicy | string | `"Always"` | pullPolicy is the strategy for pulling images from a registry. |
| image.pullSecret.password | string | `""` | password is a PAT with at least read:packages permissions. |
| image.pullSecret.username | string | `""` | username is the GitHub username associated with the password. |
| image.repository | string | `"stevenjdh/aws-cwl-exporter"` | repository can alternatively use "ghcr.io/stevenjdh/aws-cwl-exporter", which requires a pull secret, or "public.ecr.aws/stevenjdh/aws-cwl-exporter". |
| image.tag | string | `""` | Overrides the image tag whose default is the chart appVersion. |
| nameOverride | string | `""` | Override for chart name in helm common labels. |
| nodeSelector | object | `{"kubernetes.io/os":"linux"}` | nodeSelector is the simplest way to constrain Pods to nodes with specific labels. Use affinity for more advance options. Reference [Assigning Pods to Nodes](https://kubernetes.io/docs/user-guide/node-selection). |
| secrets.awsAccessKeyId | string | `""` | Optional. The AWS access key associated with an IAM user or role. Not required when using [IRSA](https://github.com/StevenJDH/Terraform-Modules/tree/main/aws/irsa). |
| secrets.awsSecretAccessKey | string | `""` | Optional. The AWS secret key associated with the access key. Not required when using [IRSA](https://github.com/StevenJDH/Terraform-Modules/tree/main/aws/irsa). |
| serviceAccount.annotations | object | `{}` | annotations to be added to the Service Account resource. |
| serviceAccount.aws.irsa.audience | string | `"sts.amazonaws.com"` | audience sets the intended recipient of the token. |
| serviceAccount.aws.irsa.enabled | bool | `true` | Specifies whether or not to enable support for AWS IAM Roles for Service Accounts (IRSA). Static credentials will be required if this is set to false and AWS resources are needed. |
| serviceAccount.aws.irsa.roleArn | string | `""` | roleArn is the ARN of an IAM role with a web identity provider. For example, `arn:aws:iam::000000000000:role/example-irsa-role`. |
| serviceAccount.aws.irsa.stsRegionalEndpoints | string | `"true"` | stsRegionalEndpoints specifies whether or not to use an STS regional endpoint instead of a global one. It is recommended to use a regional endpoint in almost all cases. |
| serviceAccount.aws.irsa.tokenExpiration | int | `86400` | tokenExpiration is the token expiration duration in seconds. Default is 1 day. |
| serviceAccount.create | bool | `true` | Specifies whether a service account should be created. |
| serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template. |
| tolerations | list | `[]` | tolerations allow the scheduler to schedule pods onto nodes with matching taints. Reference [Taints and Tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration). |


// Steven Jenkins De Haro ("StevenJDH" on GitHub)
