## **TLS Provider**

Terraform TLS Provider 是一個 Terraform 提供者（Provider），用於生成和管理 TLS（Transport Layer Security）證書。它支持多種類型的證書，包括自簽名證書和來自其他 CA（Certificate Authority）簽發的證書。這個提供者主要用於那些需要 TLS 證書來加密通信的基礎設施，例如 Web 伺服器、API 伺服器、VPN 伺服器等。

[Terraform+TLS+Provider.pdf](https://prod-files-secure.s3.us-west-2.amazonaws.com/426ec9bd-6a89-46b3-a15c-704b8d895a35/83c14998-6c52-4f62-a4d5-a1447c1f3d54/TerraformTLSProvider.pdf)

### Exmaple

- terraform.tf
    
    ```bash
    terraform {
      required_version = ">= 1.8.2"
      required_providers {
        tls = {
          source  = "hashicorp/tls"
          version = "3.1.0"
        }
      }
    }
    ```


- main.tf

    ```bash
    resource "tls_private_key" "example" {
      algorithm = "RSA"
      rsa_bits  = 4096
    }
    ```


### Resource

- [Terraform Registry](https://registry.terraform.io/providers/hashicorp/tls/latest/docs)
- [Shiun's Learning Journal - 20240601](https://shiun.notion.site/20240601-2fcfcea5f2d94aa1aaad78a519476d8b?pvs=4)

---

## Local Provider

Terraform 的 Local Provider 是一個允許你在本地執行操作的提供者。這些操作通常涉及讀取或寫入本地檔案系統中的檔案。Local Provider 可以用來創建、管理和讀取本地檔案，這在自動化配置、測試和開發過程中非常有用。

Local Provider 支持以下主要資源：

1. **local_file**：用於在本地檔案系統中創建和管理檔案。
2. **local_sensitive_file**：類似於 `local_file`，但對內容進行加密處理，以防止敏感資料洩露。

### Example

- local_file

    ```bash
    resource "local_file" "foo" {
      content  = "foo!"
      filename = "${path.module}/foo.bar"
    }
    ```


- local_sensitive_file

    ```bash
    resource "local_sensitive_file" "foo" {
      content  = "foo!"
      filename = "${path.module}/foo.bar"
    }
    ```


### Resources

- [Terraform Registry](https://registry.terraform.io/providers/hashicorp/local/latest/docs)
- [Shiun's Learning Journal - 20240601](https://shiun.notion.site/20240601-2fcfcea5f2d94aa1aaad78a519476d8b?pvs=4)