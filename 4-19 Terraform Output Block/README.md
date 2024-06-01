## Output

Terraform 的 Output Block 用於在執行完 Terraform 配置後，顯示或導出一些有用的信息。這些信息可以是由 Terraform 配置中產生的資源屬性，例如 IP 地址、URL、ARN 等。使用 Output Block 可以方便地檢視和引用這些信息，特別是在部署完成後需要使用這些資訊時

### Synopsis

```bash
output "output_name" {
  value = <expression>
  description = "Description of the output" # 可選
  sensitive = true # 可選，若設置為 true，會隱藏輸出值（適用於敏感信息）
}
```

### Example

```bash
output "public_url" {
  description = "public url of the load balancer"
  value       = "https://${aws_instance.web_server.public_ip}:8080/index.html"
}
```

**CLI**

- **顯示所有 output**

```bash
$ terraform output

vpc_id = "vpc-123abc456def"
instance_ip = "54.123.45.67"
```

- 顯示特定 output

```bash
$ terraform output vpc_id

vpc_id = "vpc-123abc456def"
```

- 格式化 output

```bash
$ terraform output -json

{
  "vpc_id": {
    "value": "vpc-123abc456def"
  },
  "instance_ip": {
    "value": "54.123.45.67"
  }
}
```

### Resources

- [Output Values - Configuration Language | Terraform | HashiCorp Developer](https://developer.hashicorp.com/terraform/language/values/outputs)

- [https://github.com/btkrausen/hashicorp/blob/master/terraform/Hands-On Labs/Section 04 - Understand Terraform Basics/11 - Intro_to_the_Terraform_Output_Block.md](https://github.com/btkrausen/hashicorp/blob/master/terraform/Hands-On%20Labs/Section%2004%20-%20Understand%20Terraform%20Basics/11%20-%20Intro_to_the_Terraform_Output_Block.md)
- [Shiun's Learning Journal - 20240601](https://shiun.notion.site/20240601-2fcfcea5f2d94aa1aaad78a519476d8b?pvs=4)