## Requirements

No requirements.

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_lambda"></a> [lambda](#module\_lambda) | ./modules/terraform-aws-lambda | n/a |
| <a name="module_s3"></a> [s3](#module\_s3) | ./modules/terraform-aws-s3 | n/a |
| <a name="module_sns"></a> [sns](#module\_sns) | ./modules/terraform-aws-sns | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bucket_1"></a> [bucket\_1](#input\_bucket\_1) | Name for bucket\_1 | `string` | n/a | yes |
| <a name="input_bucket_2"></a> [bucket\_2](#input\_bucket\_2) | Name for bucket\_2 | `string` | n/a | yes |
| <a name="input_sns_endpoint"></a> [sns\_endpoint](#input\_sns\_endpoint) | The recipient mail for gettting an alert | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_raw_bucket_id"></a> [raw\_bucket\_id](#output\_raw\_bucket\_id) | n/a |
