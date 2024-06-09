## Module

Terraform Module 只是一組 Terraform 配置文件。Module 只是位於文件夾中的 Terraform 配置，它們沒有什麼特別之處。事實上，你到目前為止編寫的程式碼就是一個 Module: root Module

### 使用場景

- **Infra 標準化**: 當你的團隊需要在多個環境中部署類似的基礎設施時，可以創建一個 Module 來標準化這些配置。例如，創建一個 VPC Module，統一管理 VPC、子網、路由表等配置
- **程式碼重用**: 當你需要在多個專案中使用相同的 infra 配置時，可以創建 Module 並在不同的項目中引用它們。例如，一個常見的 EC2 實例配置可以打包成一個 Module，並在多個 Terraform 配置中使用
- **簡化管理**: 將大而複雜的 Terraform 配置拆分成多個更小的 Module，可以使管理和維護變得更簡單。例如，將數據庫配置、應用服務器配置和網絡配置分別打包成不同的 Module
- **版本控制**: 使用 Module 可以幫助你對基礎設施的變更進行版本控制。你可以在 Terraform 配置中指定 Module 的版本，確保在不同環境中使用一致的基礎設施配置

### 如何引用 module

假設你在 `/workspace/terraform` 目錄下有以下結構

```bash
/workspace/terraform/
  ├── main.tf
  ├── variables.tf
  ├── outputs.tf
  └── file_service/
      ├── main.tf
      ├── variables.tf
      └── outputs.tf
```

當你在 `/workspace/terraform` 目錄中運行 `terraform apply` 時，Terraform 只會讀取該目錄中的 `.tf` 檔
要讓 Terraform 讀取 `/workspace/terraform/file_service` 目錄中的 `.tf` 檔，你需要在 root module 中使用 `module` block 來引用它

你需要在 `/workspace/terraform/main.tf` 文件中添加一個 module block 來引用 `file_service` 目錄中的配置

```bash
# main.tf

module "file_service" {
  source = "./file_service"

  # 這裡是 module 所需的變數，可以根據需要設置
  # ami = "ami-123456"
  # size = "t2.micro"
  # subnet_id = "subnet-123456"
  # security_groups = ["sg-123456"]
}
```

**運行 Terraform CLI:**
在 `/workspace/terraform` 目錄中運行 `terraform init` 和 `terraform apply`，這樣 Terraform 會讀取根 module 中的配置，並引用和應用 `file_service` 目錄中的配置

### Resources

- [Shiun's Learning Journal - 20240609](https://shiun.notion.site/20240609-88a04d60e1454668b5ca5b098c595273?pvs=4)
- [Day 05-撰文在疫苗發作時，之module 是 terraform 執行與調用的基本單位 - iT 邦幫忙::一起幫忙解決難題，拯救 IT 人的一天](https://ithelp.ithome.com.tw/articles/10260316)
