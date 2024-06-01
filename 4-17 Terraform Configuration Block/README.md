## Configuration Block

Terraform Configuration Block 是用來定義 Terraform 設定的區塊。這些區塊用來設定 Terraform 的行為、所需的版本、插件等配置。常見的 Configuration Block 包括 `terraform` 區塊、`provider` 區塊和 `resource` 區塊等。

### Example

```shell
terraform {
  required_version = ">= 1.8.0, < 2.0.0"
  backend "s3" {
    bucket = "my-terraform-state"
    key    = "path/to/my/key"
    region = "us-west-2"
  }
}
```