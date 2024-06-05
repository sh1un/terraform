## Logs

如果想要深入了解 Terraform 執行的細節，就可以啟用 Terraform 的 Log 功能，只要去配置好環境變數就可以開啟這功能

我使用 Poweshell，如果是 Mac 用戶，就要使用 `export` 指令來設定環境變量

### 1. 設定 `TF_LOG` 環境變數

`TF_LOG` 環境變數用於設置 Terraform 日誌的層級，可用的層級包括 `TRACE`, `DEBUG`, `INFO`, `WARN`, `ERROR`。

```powershell
$env:TF_LOG = "DEBUG"
terraform apply

```

這樣，Terraform 在執行 `apply` 命令時會顯示 DEBUG 層級的日誌資訊。

### 2. 設定 `TF_LOG_PATH` 環境變數

`TF_LOG_PATH` 環境變數用於指定日誌應該寫入的檔案路徑。這對於需要保存 Log 以便稍後分析非常有用

```powershell
$env:TF_LOG = "DEBUG"
$env:TF_LOG_PATH = "./terraform_debug.log"
terraform apply

```

這樣，Terraform 在執行 `apply` 命令時，會將日誌寫入到當前目錄中的 `terraform_debug.log` 檔案中

### Exmaple

假設您想要使用 `DEBUG` 層級的日誌並將其寫入一個名為 `terraform_debug.log` 的檔案，您可以在 PowerShell 中執行以下命令：

```powershell
$env:TF_LOG = "DEBUG"
$env:TF_LOG_PATH = "./terraform_debug.log"
terraform apply

```

這些環境變數在 Debug Terraform 時非常有用，尤其是需要深入了解 Terraform 執行的內部細節時