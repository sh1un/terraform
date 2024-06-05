## Workspace

Terraform 的 workspace 功能允許你在同一套 Terraform 配置文件中管理多個獨立的狀態。例如，你可以使用 workspaces 來管理開發、測試和生產環境，而不需要為每個環境維護不同的配置文件

### 基本概念

1. **工作空間 (Workspace)**
    - 工作空間是獨立的 Terraform 狀態實例
    - 每個工作空間有自己獨立的狀態文件，因此可以在同一套配置文件中同時管理多個環境
2. **預設工作空間 (Default Workspace)**
    - 每個 Terraform 配置文件默認有一個名為 `default` 的工作空間
    - 你可以在該工作空間內開始工作，但在需要管理多個環境時，可以創建其他工作空間

### Example

要創建一個 workspace 需要使用到 `terraform workspace new` 指令

```bash
$ terraform workspace new dev

Created and switched to workspace "dev"!

You're now on a new, empty workspace. Workspaces isolate their state,
so if you run "terraform plan" Terraform will not see any existing state
for this configuration.
```

輸入 `terraform workspace show` 查看目前所處的 workspace

```bash
$ terraform workspace show

dev
```

要列出現在擁有的 workspace，可以使用 `terraform worksapce list`

```bash
$ terraform workspace list

  default
* dev
```

要切換 workspace 的話，可以使用 `terraform workspace select`

```bash
$ terraform workspace select default

Switched to workspace "default".
```

有一個很棒的用法是然後你還可以透過 `terraform.workspace` 來把這個值插入到程式碼

```bash
provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      Environment = terraform.workspace
    }
  }
}
```

### Resources

- [Shiun's Learning Journal - 20240605](https://www.notion.so/20240605-a29a522dba9d4e8eb7a60fe899595908?pvs=21)
- [State: Workspaces | Terraform | HashiCorp Developer](https://developer.hashicorp.com/terraform/language/state/workspaces)
