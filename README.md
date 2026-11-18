# terraform-gcp-scc

[![Build Status](https://github.com/JamesWoolfenden/terraform-gcp-scc/workflows/Verify/badge.svg?branch=main)](https://github.com/JamesWoolfenden/terraform-gcp-scc/actions)
[![Latest Release](https://img.shields.io/github/release/JamesWoolfenden/terraform-gcp-scc.svg)](https://github.com/JamesWoolfenden/terraform-gcp-scc/releases/latest)
[![GitHub tag (latest SemVer)](https://img.shields.io/github/tag/JamesWoolfenden/terraform-gcp-scc.svg?label=latest)](https://github.com/JamesWoolfenden/terraform-gcp-scc/releases/latest)
![Terraform Version](https://img.shields.io/badge/tf-%3E%3D1.5.0-blue.svg)
[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white)](https://github.com/pre-commit/pre-commit)

Terraform module for Security Command Center. Creates an organization-level SCC notification config that streams findings matching a filter (default: active, unmuted, high and critical) to a CMEK-encrypted Pub/Sub topic with a data-residency storage policy, grants the SCC notification service agent publisher on that topic and the Pub/Sub service agent encrypter/decrypter on the key, and optionally creates Security Health Analytics custom modules and organization mute configs.

## Usage

Add **module.scc.tf** to your code:-

```terraform
module "scc" {
  source          = "jameswoolfenden/scc/gcp"
  organization_id = var.organization_id
  kms_key_name    = google_kms_crypto_key.scc.id
}
```

See [example/examplea](example/examplea) for a complete working example; set `organization_id` in `examplea.auto.tfvars`. Organization-scoped resources need SCC enabled on the organization and org-level permissions for the deploying identity.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_google"></a> [google](#provider\_google) | n/a |
| <a name="provider_google-beta"></a> [google-beta](#provider\_google-beta) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
| ---- | ---- |
| [google-beta_google_project_service_identity.pubsub](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_project_service_identity) | resource |
| [google_kms_crypto_key_iam_member.pubsub_service_agent](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/kms_crypto_key_iam_member) | resource |
| [google_pubsub_topic.findings](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/pubsub_topic) | resource |
| [google_pubsub_topic_iam_member.scc_publisher](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/pubsub_topic_iam_member) | resource |
| [google_scc_management_organization_security_health_analytics_custom_module.main](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/scc_management_organization_security_health_analytics_custom_module) | resource |
| [google_scc_mute_config.main](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/scc_mute_config) | resource |
| [google_scc_notification_config.main](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/scc_notification_config) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_allowed_persistence_regions"></a> [allowed\_persistence\_regions](#input\_allowed\_persistence\_regions) | Regions where findings messages may be stored at rest (data residency) | `list(string)` | <pre>[<br/>  "europe-west2"<br/>]</pre> | no |
| <a name="input_config_id"></a> [config\_id](#input\_config\_id) | ID of the SCC notification config | `string` | `"scc-findings"` | no |
| <a name="input_custom_modules"></a> [custom\_modules](#input\_custom\_modules) | Optional Security Health Analytics custom modules keyed by display name: a CEL predicate over the listed resource types, with severity and recommendation | <pre>map(object({<br/>    predicate        = string<br/>    resource_types   = list(string)<br/>    severity         = string<br/>    recommendation   = string<br/>    description      = optional(string)<br/>    enablement_state = optional(string, "ENABLED")<br/>  }))</pre> | `{}` | no |
| <a name="input_description"></a> [description](#input\_description) | Description of the SCC notification config | `string` | `"Streams active, unmuted high and critical SCC findings to Pub/Sub"` | no |
| <a name="input_kms_key_name"></a> [kms\_key\_name](#input\_kms\_key\_name) | Cloud KMS crypto key used to encrypt the findings topic (CMEK) | `string` | n/a | yes |
| <a name="input_labels"></a> [labels](#input\_labels) | Labels to apply to the findings topic, for cost allocation and ownership tracking | `map(string)` | `{}` | no |
| <a name="input_message_retention_duration"></a> [message\_retention\_duration](#input\_message\_retention\_duration) | How long the topic retains published messages, in seconds (e.g. 86400s), so subscribers can replay findings | `string` | `"604800s"` | no |
| <a name="input_mute_configs"></a> [mute\_configs](#input\_mute\_configs) | Optional organization-level SCC mute configs keyed by mute config ID. Each needs a narrow filter and a description justifying why the findings are muted | <pre>map(object({<br/>    filter      = string<br/>    description = string<br/>  }))</pre> | `{}` | no |
| <a name="input_organization_id"></a> [organization\_id](#input\_organization\_id) | Numeric ID of the GCP organization Security Command Center is enabled on | `string` | n/a | yes |
| <a name="input_streaming_filter"></a> [streaming\_filter](#input\_streaming\_filter) | SCC findings filter for the streaming notification config | `string` | `"state = \"ACTIVE\" AND mute != \"MUTED\" AND (severity = \"HIGH\" OR severity = \"CRITICAL\")"` | no |
| <a name="input_topic_name"></a> [topic\_name](#input\_topic\_name) | Name of the Pub/Sub topic SCC findings are published to | `string` | `"scc-findings"` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_custom_module_ids"></a> [custom\_module\_ids](#output\_custom\_module\_ids) | Map of Security Health Analytics custom module display name to ID |
| <a name="output_mute_config_ids"></a> [mute\_config\_ids](#output\_mute\_config\_ids) | Map of mute config ID to resource ID |
| <a name="output_notification_config_id"></a> [notification\_config\_id](#output\_notification\_config\_id) | ID of the SCC notification config |
| <a name="output_topic_id"></a> [topic\_id](#output\_topic\_id) | ID of the Pub/Sub topic SCC findings are published to; attach subscriptions to this |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Role and Permissions

<!-- BEGINNING OF PRE-COMMIT-PIKE DOCS HOOK -->
The Terraform resource required is:

```golang
# apply role
resource "google_project_iam_custom_role" "terraform_pike" {
  project     = "pike-477416"
  role_id     = "terraform_pike"
  title       = "terraform_pike"
  description = "A user with least privileges"
  permissions = [
    "cloudkms.cryptoKeys.getIamPolicy",
    "cloudkms.cryptoKeys.setIamPolicy",
    "pubsub.topics.create",
    "pubsub.topics.delete",
    "pubsub.topics.get",
    "pubsub.topics.getIamPolicy",
    "pubsub.topics.setIamPolicy",
    "pubsub.topics.update",
    "securitycenter.muteconfigs.create",
    "securitycenter.muteconfigs.delete",
    "securitycenter.muteconfigs.get",
    "securitycenter.muteconfigs.update",
    "securitycenter.notificationconfig.create",
    "securitycenter.notificationconfig.delete",
    "securitycenter.notificationconfig.get",
    "securitycenter.notificationconfig.update",
    "securitycentermanagement.securityHealthAnalyticsCustomModules.create",
    "securitycentermanagement.securityHealthAnalyticsCustomModules.delete",
    "securitycentermanagement.securityHealthAnalyticsCustomModules.get",
    "securitycentermanagement.securityHealthAnalyticsCustomModules.update"
  ]
}

# plan role
resource "google_project_iam_custom_role" "terraform_pike_plan" {
  project     = "pike-477416"
  role_id     = "terraform_pike_plan"
  title       = "terraform_pike_plan"
  description = "A user with least privileges"
  permissions = [
    "cloudkms.cryptoKeys.getIamPolicy",
    "pubsub.topics.get",
    "pubsub.topics.getIamPolicy",
    "securitycenter.muteconfigs.get",
    "securitycenter.notificationconfig.get",
    "securitycentermanagement.securityHealthAnalyticsCustomModules.get"
  ]
}


```
<!-- END OF PRE-COMMIT-PIKE DOCS HOOK -->

## Help

**Got a question?**

File a GitHub [issue](https://github.com/jameswoolfenden/terraform-gcp-scc/issues).

## Contributing

### Bug Reports & Feature Requests

Please use the [issue tracker](https://github.com/jameswoolfenden/terraform-gcp-scc/issues) to report any bugs or file feature requests.

## Copyrights

Copyright © 2026 James Woolfenden

## License

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

See [LICENSE](LICENSE) for full details.

Licensed to the Apache Software Foundation (ASF) under one
or more contributor license agreements. See the NOTICE file
distributed with this work for additional information
regarding copyright ownership. The ASF licenses this file
to you under the Apache License, Version 2.0 (the
"License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at

<https://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing,
software distributed under the License is distributed on an
"AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
KIND, either express or implied. See the License for the
specific language governing permissions and limitations
under the License.

### Contributors

[![James Woolfenden][jameswoolfenden_avatar]][jameswoolfenden_homepage]<br/>[James Woolfenden][jameswoolfenden_homepage]

[jameswoolfenden_homepage]: https://github.com/jameswoolfenden
[jameswoolfenden_avatar]: https://github.com/jameswoolfenden.png?size=150
