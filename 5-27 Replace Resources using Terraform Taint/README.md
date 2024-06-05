## Taint


> [!IMPORTANT]
> 在 Terraform 0.15 及以後的版本中，taint 命令已被棄用，建議使用 terraform apply -replace 來代替。

</aside>

在 Terraform 中，`taint` 是一個命令，用於標記特定的資源為「損壞」，這樣在下一次執行 `terraform apply` 時，這個資源會被強制銷毀並重新創建。這在需要重新創建某個資源的情況下非常有用，無需手動刪除該資源

### Synopsis

```bash
$ terraform taint [options] ADDRESS
```

- `ADDRESS`: 資源的完整地址。例如，`aws_instance.my_instance`。

**Options:**

- `allow-missing`: 默認情況下，如果指定的資源不存在，`terraform taint` 會返回錯誤。如果使用這個選項，則不會返回錯誤。
- `lock`: 鎖定狀態文件。默認為 `true`。
- `lock-timeout`: 設置狀態文件鎖定的最大等待時間。
- `state`: 指定狀態文件的路徑。

### Example

```bash
$ terraform taint aws_instance.my_instance

Resource instance aws_instance.my_instance has been marked as tainted.
```
