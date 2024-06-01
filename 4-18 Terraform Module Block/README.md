## Module Block

在 Terraform 中，`module` 區塊用來引用和組織可重用的基礎設施組件。`module` 可以讓你將一組相關的資源打包成一個模組，然後在你的 Terraform 配置中引用這些模組，從而提高代碼的重用性和可維護性。這樣可以讓你在不同的環境或項目中使用相同的基礎設施配置。

### Synopsis

```shell
module "example" {
  source = "path_to_module" # 模組的來源，可以是本地路徑、遠端存儲庫或 Terraform Registry

  # 傳遞給模組的輸入變數
  variable_name1 = "value1"
  variable_name2 = "value2"
  ...
}
```

`source` 是必需的，它指定了模組的來源。這可以是本地檔案路徑、Git 儲存庫、Terraform Registry 中的模組，甚至是其他遠端位置。

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

引用一個 Git Repo 的 module:

```shell
module "network" {
  source = "git::https://github.com/username/repo.git//modules/network"

  vpc_id     = "vpc-123456"
  subnet_ids = ["subnet-123456", "subnet-654321"]
}
```

### Resources

- [Modules - Configuration Language | Terraform | HashiCorp Developer](https://developer.hashicorp.com/terraform/language/modules/syntax)

- [https://github.com/btkrausen/hashicorp/blob/master/terraform/Hands-On Labs/Section 04 - Understand Terraform Basics/10 - Intro_to_the_Module_Block.md](https://github.com/btkrausen/hashicorp/blob/master/terraform/Hands-On%20Labs/Section%2004%20-%20Understand%20Terraform%20Basics/10%20-%20Intro_to_the_Module_Block.md)

- https://github.com/hashicorp/terraform-cidr-subnets
