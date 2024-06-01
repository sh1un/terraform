## Provisioners

Terraform Provisioners 是用來在資源創建或銷毀時執行自定義動作的工具。這些動作通常是指在虛擬機上安裝軟體、配置系統設定，或是執行一些初始化腳本。Provisioners 可以讓使用者在基礎設施部署完成後，進一步自動化配置流程。

> 很類似 [EC2 User data](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/user-data.html)

> Provisioners 就像是在基礎設施建好後，讓你可以自動執行一些特定的工作或設定的工具。想像你在建一個新家，建好了之後，你需要把家具擺好、電器安裝好，這些動作就是 Provisioners 在做的事。

### Connection Block

在 Terraform 中，`connection` 區塊用於定義 Terraform 在創建或修改資源後如何連接到該資源。這通常用於在資源創建後執行一些自定義操作，例如配置伺服器、部署應用程式等

以下是 `connection` 區塊內每個屬性的解釋：

- `user`：指定連接到資源（例如 EC2 實例）時使用的用戶名。例如: `ubuntu`
- `private_key`：指定用於 SSH 連接的私鑰
- `host`：指定要連接的主機地址

### Provisioner 的替代方案 - [Ansible](https://www.ansible.com/)

Terraform Provisioners 在某些情況下可能不太好用，特別是當配置流程較為複雜時。這主要是因為：

1. **狀態不一致**：Provisioners 在執行過程中可能會遇到連接問題或執行失敗，這會導致基礎設施的狀態不一致，從而增加管理和排錯的難度。
2. **重複性和可移植性**：使用 Provisioners 來進行配置時，這些配置往往嵌入在 Terraform 腳本中，不容易重用或移植到其他環境中。
3. **複雜性**：當配置需求變得複雜時，使用 Provisioners 會讓 Terraform 腳本變得難以維護。

**使用 Ansible 替代 Provisioners**:
Ansible 是一個強大的配置管理工具，可以更好地管理複雜的配置流程。相比於 Terraform Provisioners，Ansible 提供了更靈活、可重用和易於維護的配置方式。

### Resources

- [Shiun's Learning Journal - 20240601](https://shiun.notion.site/20240601-2fcfcea5f2d94aa1aaad78a519476d8b?pvs=4)
- [Homepage | Ansible Collaborative](https://www.ansible.com/)
- [Run commands on your Linux instance at launch - Amazon Elastic Compute Cloud](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/user-data.html)
- [Provisioners | Terraform | HashiCorp Developer](https://developer.hashicorp.com/terraform/language/resources/provisioners/syntax)
- [Terraform Registry](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group.html#argument-reference)
- [https://github.com/btkrausen/hashicorp/blob/master/terraform/Hands-On Labs/Section 04 - Understand Terraform Basics/17 - Terraform_Provisioners.md](https://github.com/btkrausen/hashicorp/blob/master/terraform/Hands-On%20Labs/Section%2004%20-%20Understand%20Terraform%20Basics/17%20-%20Terraform_Provisioners.md)
