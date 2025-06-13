# 🗑️ Google Chrome Complete Removal Script

<div align="center">

![Windows](https://img.shields.io/badge/Windows-0078D6?style=for-the-badge&logo=windows&logoColor=white)
![Batch](https://img.shields.io/badge/Batch-4D4D4D?style=for-the-badge&logo=windows-terminal&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)

**Một script Windows Batch mạnh mẽ để gỡ bỏ hoàn toàn Google Chrome khỏi hệ thống của bạn**

</div>

## 📋 Mô tả

Script này thực hiện việc gỡ bỏ **hoàn toàn** Google Chrome khỏi hệ thống Windows, bao gồm tất cả các thành phần liên quan như:

-   ✅ Tiến trình Chrome đang chạy
-   ✅ Ứng dụng Chrome qua Control Panel
-   ✅ Google Update Service
-   ✅ Registry entries của Chrome
-   ✅ Program files và thư mục cài đặt
-   ✅ Dữ liệu người dùng và profiles
-   ✅ Shortcuts và desktop icons
-   ✅ Temporary files

## ⚠️ Cảnh báo quan trọng

> **LƯU Ý:** Script này sẽ xóa **TẤT CẢ** dữ liệu Chrome bao gồm bookmarks, passwords, extensions và lịch sử duyệt web (trừ khi đã đồng bộ với tài khoản Google).

## 🚀 Cách sử dụng

### Yêu cầu hệ thống

-   Windows 7/8/10/11
-   Quyền Administrator
-   PowerShell hoặc Command Prompt

### Hướng dẫn chi tiết

1. **Tải về script**

    ```bash
    git clone https://github.com/ocampoje17/remove_chrome_win_cmd_script.git
    cd remove_chrome_win_cmd_script
    ```

2. **Chạy với quyền Administrator**

    - Click chuột phải vào `remove_chrome.bat`
    - Chọn "Run as administrator"
    - Hoặc mở Command Prompt với quyền Admin và chạy:

    ```cmd
    remove_chrome.bat
    ```

3. **Làm theo hướng dẫn**
    - Script sẽ yêu cầu xác nhận trước khi bắt đầu
    - Nhập `Y` để tiếp tục hoặc `N` để hủy bỏ

## 🔧 Quy trình hoạt động

Script thực hiện 8 bước chính:

| Bước | Mô tả                      | Hành động                          |
| ---- | -------------------------- | ---------------------------------- |
| 1️⃣   | **Stop Processes**         | Dừng tất cả tiến trình Chrome      |
| 2️⃣   | **Standard Uninstall**     | Gỡ cài đặt qua Windows Uninstaller |
| 3️⃣   | **Remove Services**        | Xóa Google Update Services         |
| 4️⃣   | **Registry Cleanup**       | Sao lưu và xóa registry entries    |
| 5️⃣   | **Remove Program Files**   | Xóa thư mục cài đặt                |
| 6️⃣   | **Clean Application Data** | Xóa dữ liệu ứng dụng               |
| 7️⃣   | **Remove User Data**       | Xóa dữ liệu người dùng             |
| 8️⃣   | **Clean Shortcuts**        | Xóa shortcuts và icons             |

## 💾 Tính năng sao lưu

Script tự động tạo bản sao lưu registry với timestamp:

```
C:\ChromeRemoval_Backup_YYYYMMDD_HHMMSS\
├── HKLM_SOFTWARE_Google.reg
├── HKLM_SOFTWARE_WOW6432Node_Google.reg
├── HKLM_Uninstall_Chrome.reg
└── ...
```

## 🔄 Khôi phục (nếu cần)

Để khôi phục registry entries đã sao lưu:

1. Mở thư mục backup được tạo
2. Double-click vào file `.reg` cần khôi phục
3. Xác nhận merge vào registry

## 📱 Tương thích

| Phiên bản Windows | Hỗ trợ |
| ----------------- | ------ |
| Windows 11        | ✅     |
| Windows 10        | ✅     |
| Windows 8.1       | ✅     |
| Windows 8         | ✅     |
| Windows 7         | ✅     |

## 🛠️ Troubleshooting

### Lỗi phổ biến

**❌ "Access Denied"**

-   Đảm bảo chạy script với quyền Administrator

**❌ "Registry key not found"**

-   Bình thường, một số key có thể không tồn tại

**❌ "Process cannot be terminated"**

-   Chrome có thể đã được đóng trước đó

### Sau khi chạy script

-   Restart máy tính để hoàn tất quá trình
-   Kiểm tra Programs & Features để đảm bảo Chrome đã được gỡ bỏ
-   Xóa thủ công các file còn sót lại (nếu có)

## 📄 License

Dự án này được phân phối dưới giấy phép MIT. Xem file `LICENSE` để biết thêm chi tiết.

## 🤝 Đóng góp

Mọi đóng góp đều được chào đón! Vui lòng:

1. Fork repository này
2. Tạo feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Mở Pull Request

## ⭐ Support

Nếu script này hữu ích, hãy cho một ⭐ để ủng hộ dự án!

---

<div align="center">

**💡 Tip:** Luôn tạo system restore point trước khi chạy script này!

Made with ❤️ for Windows users

</div>
