## Data Sources

Terraform 中的 Data Sources 是指從現有資源中讀取或取得資料的來源。這些來源可以是雲服務提供者(如AWS、Azure、GCP等)上的資源,也可以是Terraform狀態文件或其他外部數據來源。

## Example

```bash
provider "aws" {
  region = "us-east-1"
}

data "aws_region" "current" {}

output "current_region_name" {
  value = data.aws_region.current.name
}

```

**引用 Data Source**：使用 `data.<provider>_<type>.<name>.<attribute>` 的格式引用 Data Source 的屬性。

## Resources

[Data | Terraform 的一百零一種姿勢](https://shazi7804.github.io/terraform-manage-guide/basic/data.html)

[Terraform Registry](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region)