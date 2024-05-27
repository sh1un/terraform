## State

### 說明

Terraform 的 State 是一個儲存基礎設施狀態的文件。它是 Terraform 工作流程中的關鍵部分，因為它記錄了基礎設施的實際狀態，使 Terraform 能夠知道哪些資源已經建立，哪些需要更新或刪除。以下是一些有關 Terraform State 的重要概念：

1. **State 文件格式**：State 文件通常是 JSON 格式，儲存有關每個資源的詳細資訊，例如資源的 ID、屬性和值等。
2. **State 文件位置**：默認情況下，Terraform 會將 State 文件儲存在本地的 **`terraform.tfstate`** 文件中。不過，在團隊合作或需要更高可用性的情況下，可以將 State 文件儲存在遠端，例如 AWS S3、HashiCorp Consul 或 Terraform Cloud。
3. **State 的重要性**：State 文件是 Terraform 確定基礎設施狀態的唯一來源。它允許 Terraform 跟蹤資源的變更，並在應用配置變更時生成必要的計畫（Plan）和執行操作（Apply）。
4. **State 鎖定（State Locking）**：為了避免多個用戶同時修改 State 文件，Terraform 支持 State 鎖定機制。這通常由遠端 State 儲存後端（如 S3 加上 DynamoDB）實現，確保在修改 State 文件時只有一個 Terraform 實例能夠進行操作。
5. **State 的分割（State Splitting）**：在大型基礎設施中，將所有資源的狀態存儲在一個 State 文件中可能會變得笨重且不便於管理。可以通過拆分 State 將不同的資源組合放到不同的 State 文件中，例如將生產環境和開發環境分開管理。
6. **State 敏感資訊**：State 文件中可能包含敏感資訊，例如密碼或密鑰。因此，應該妥善保護 State 文件，確保只有授權人員能夠存取。
7. **State 的備份與恢復**：定期備份 State 文件非常重要，以防止數據丟失或損壞。遠端儲存後端通常會自動處理這部分工作，但本地儲存時需要手動備份。

### Remote State

Remote State 是將 Terraform 的 State 文件儲存在遠端位置，而不是本地磁碟。這對於團隊協作和多環境管理特別有用，因為它能夠確保所有團隊成員都可以訪問最新的基礎設施狀態，並且避免了本地 State 文件的同步問題。以下是有關 Remote State 的一些關鍵概念：

1. **使用情境**：
    - **團隊協作**：當多個開發者需要協作時，Remote State 可以確保所有人都能訪問相同的基礎設施狀態，避免本地 State 文件不同步帶來的問題。
    - **多環境管理**：當需要管理多個環境（例如開發、測試、生產環境）時，使用 Remote State 可以方便地將每個環境的狀態儲存在不同的遠端位置，便於管理和訪問。
2. **常見的遠端 State 儲存後端**：
    - **Amazon S3**：可以將 State 文件儲存在 S3 存儲桶中，並使用 DynamoDB 進行 State 鎖定。
    - **HashiCorp Consul**：一個分散式鍵值存儲，用於儲存 State 文件並提供鎖定機制。
    - **Terraform Cloud**：由 HashiCorp 提供的託管服務，用於儲存和管理 Terraform State。
    - **其他選項**：Google Cloud Storage (GCS)、Azure Blob Storage 等。

### Hands-on

配置 Terraform

```python
# variables.tf

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "vpc_name" {
  type    = string
  default = "demo_vpc"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "private_subnets" {
  default = {
    "private_subnet_1" = 1
    "private_subnet_2" = 2
    "private_subnet_3" = 3
  }
}

variable "public_subnets" {
  default = {
    "public_subnet_1" = 1
    "public_subnet_2" = 2
    "public_subnet_3" = 3
  }
}
```

```python
# main.tf

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

#Retrieve the list of AZs in the current AWS region
data "aws_availability_zones" "available" {}
data "aws_region" "current" {}

#Define the VPC
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name        = var.vpc_name
    Environment = "demo_environment"
    Terraform   = "true"
  }
}

#Deploy the private subnets
resource "aws_subnet" "private_subnets" {
  for_each          = var.private_subnets
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, each.value)
  availability_zone = tolist(data.aws_availability_zones.available.names)[each.value]

  tags = {
    Name      = each.key
    Terraform = "true"
  }
}

#Deploy the public subnets
resource "aws_subnet" "public_subnets" {
  for_each                = var.public_subnets
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, each.value + 100)
  availability_zone       = tolist(data.aws_availability_zones.available.names)[each.value]
  map_public_ip_on_launch = true

  tags = {
    Name      = each.key
    Terraform = "true"
  }
}

#Create route tables for public and private subnets
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    gateway_id     = aws_internet_gateway.internet_gateway.id
    #nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }
  tags = {
    Name      = "demo_public_rtb"
    Terraform = "true"
  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    # gateway_id     = aws_internet_gateway.internet_gateway.id
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }
  tags = {
    Name      = "demo_private_rtb"
    Terraform = "true"
  }
}

#Create route table associations
resource "aws_route_table_association" "public" {
  depends_on     = [aws_subnet.public_subnets]
  route_table_id = aws_route_table.public_route_table.id
  for_each       = aws_subnet.public_subnets
  subnet_id      = each.value.id
}

resource "aws_route_table_association" "private" {
  depends_on     = [aws_subnet.private_subnets]
  route_table_id = aws_route_table.private_route_table.id
  for_each       = aws_subnet.private_subnets
  subnet_id      = each.value.id
}

#Create Internet Gateway
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "demo_igw"
  }
}

#Create EIP for NAT Gateway
resource "aws_eip" "nat_gateway_eip" {
  domain     = "vpc"
  depends_on = [aws_internet_gateway.internet_gateway]
  tags = {
    Name = "demo_igw_eip"
  }
}

#Create NAT Gateway
resource "aws_nat_gateway" "nat_gateway" {
  depends_on    = [aws_subnet.public_subnets]
  allocation_id = aws_eip.nat_gateway_eip.id
  subnet_id     = aws_subnet.public_subnets["public_subnet_1"].id
  tags = {
    Name = "demo_nat_gateway"
  }
}
```

**`terraform init`** 是在開始使用 Terraform 配置之前需要執行的第一步。它確保工作目錄已正確設置，所需的 Provider 插件已安裝，並且遠端或本地的 State 文件已準備就緒。這樣可以確保後續的 **`terraform plan`** 和 **`terraform apply`** 命令能夠順利執行。

```bash
$ terraform init

Initializing the backend...

Initializing provider plugins...
- Finding latest version of hashicorp/aws...
- Installing hashicorp/aws v5.51.1...
- Installed hashicorp/aws v5.51.1 (signed by HashiCorp)

Terraform has created a lock file .terraform.lock.hcl to record the provider  
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when   
you run "terraform init" in the future.

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```

**`terraform plan`** 是 Terraform 中的一個命令，用來生成和顯示基礎設施的執行計劃。這個計劃會展示 Terraform 將對基礎設施執行的操作，包括創建、更新和刪除資源。這樣用戶可以在實際應用變更之前檢查將會發生的變化，確保其符合預期。

```bash
$ terraform plan
```

執行 plan 的變更:

```bash
$ terraform apply -auto-approve
```

顯示 Terraform 狀態文件或計劃文件的內容:

```bash
$ terraform show
```

打開 `main.tf` ，新增以下程式碼:

```python
# Terraform Data Block - To Lookup Latest Ubuntu 20.04 AMI Image
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

# Terraform Resource Block - To Build EC2 instance in Public Subnet
resource "aws_instance" "web_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnets["public_subnet_1"].id
  tags = {
    Name = "Ubuntu EC2 Server"
  }
}
```

透過 `terraform plan` 檢查變更:

```python
$ terraform plan

# ... 略

      + user_data_base64                     = (known after apply)
      + user_data_replace_on_change          = false
      + vpc_security_group_ids               = (known after apply)
    }

Plan: 1 to add, 0 to change, 0 to destroy.
```

重新查看 terraform state

```python
	$ terraform show
	
	# aws_instance.web_server:
resource "aws_instance" "web_server" {
    ami                                  = "ami-03e9149278a6f457c"
    arn                                  = "arn:aws:ec2:us-east-1:132132132132:instance/i-052ad6ee4b337147f"
    associate_public_ip_address          = true
    availability_zone                    = "us-east-1b"
    cpu_core_count                       = 1
    cpu_threads_per_core                 = 1
    disable_api_stop                     = false
    disable_api_termination              = false
    ebs_optimized                        = false
    get_password_data                    = false
```

查看簡化版的 State:

```python
$ terraform state list

data.aws_ami.ubuntu
data.aws_availability_zones.available
data.aws_region.current
aws_eip.nat_gateway_eip
aws_instance.web_server
aws_internet_gateway.internet_gateway
aws_nat_gateway.nat_gateway
aws_route_table.private_route_table
aws_route_table.public_route_table
aws_route_table_association.private["private_subnet_1"]
aws_route_table_association.private["private_subnet_2"]
aws_route_table_association.private["private_subnet_3"]
aws_route_table_association.public["public_subnet_1"]  
aws_route_table_association.public["public_subnet_2"]  
aws_route_table_association.public["public_subnet_3"]  
aws_subnet.private_subnets["private_subnet_1"]
aws_subnet.private_subnets["private_subnet_2"]
aws_subnet.private_subnets["private_subnet_3"]
aws_subnet.public_subnets["public_subnet_1"]
aws_subnet.public_subnets["public_subnet_2"]
aws_subnet.public_subnets["public_subnet_3"]
aws_vpc.vpc
```

### Resources

- [State | Terraform | HashiCorp Developer](https://developer.hashicorp.com/terraform/language/state)

- [State: Remote Storage | Terraform | HashiCorp Developer](https://developer.hashicorp.com/terraform/language/state/remote)

- [Lab: Benefits of State](https://github.com/btkrausen/hashicorp/blob/master/terraform/Hands-On%20Labs/Section%2003%20-%20Understand%20The%20Purpose%20of%20Terraform/02%20-%20Benefits_of_State.md)