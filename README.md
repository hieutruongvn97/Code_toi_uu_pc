# Bộ Công Cụ Tối Ưu Hóa & Dọn Rác Windows 10 / Windows 11 (All-in-One Toolkit)

Bộ 4 công cụ Batch Script (`.bat`) chuyên sâu dành cho kỹ thuật viên và người dùng Windows 10 / Windows 11, hỗ trợ tự động nhận diện phần cứng, tự động sao lưu cấu hình gốc trước khi tối ưu và khôi phục an toàn 100%.

---

## Danh sách 4 công cụ trong bộ Toolkit

### 1. `Toi_Uu_Win10_RAM_Yeu.bat` — Tối ưu chuyên sâu cho máy Windows 10 cấu hình yếu
* **Tự động nhận diện phần cứng:** Quét phiên bản Windows (Version & OS Build), CPU, toàn bộ GPU, dung lượng RAM, loại ổ cứng vật lý chứa phân vùng `C:` (`SSD` hay `HDD`), và phân biệt **Laptop (Có Pin)** với **PC Để Bàn (Desktop)**.
* **Menu tương tác thông minh (3 câu hỏi):**
  1. Chọn mức RAM (`4GB`, `6GB`, `8GB`, hoặc `>8GB`) để thiết lập `Pagefile` cố định chống phân mảnh và tinh chỉnh hiệu ứng hình ảnh (`Transparency` / `Memory Compression`).
  2. Chọn loại ổ cứng (`HDD` hoặc `SSD`) để xử lý triệt để lỗi **100% Disk** (`SysMain`, `Windows Search`, `CompatTelRunner`) và tối ưu `Fast Startup` / `Hibernation`.
  3. Tùy chọn chế độ `Windows Update` (Chặn tự động tải ngầm nhưng vẫn giữ `Microsoft Store` hoạt động, hoặc Khóa cứng hoàn toàn).

### 2. `Toi_Uu_Win11_Thong_Minh.bat` — Tối ưu Windows 11 theo nhu cầu sử dụng
* **Hỗ trợ 3 Chế độ (Profiles) chuyên biệt:**
  * **[1] Chơi Game Mượt & Nhanh Nhất (`Gaming Mode`):** Kích hoạt `Ultimate Performance Power Plan`, `Game Mode`, tối ưu `Multimedia SystemProfile`, tắt `GameDVR` / `Widgets` / `Copilot` / `Recall AI` / `Edge Background`, kèm tùy chọn giữ hoặc tắt `VBS / Core Isolation` (tương thích Anti-Cheat *Riot Vanguard / Valorant / FaceIt*).
  * **[2] Làm Việc Văn Phòng / Máy Yếu (`Office & Stability`):** Tiết kiệm RAM tối đa, giữ nguyên dịch vụ in ấn (`Print Spooler`), `OneDrive`, `Clipboard`, `Microsoft Store`.
  * **[3] Xài Toàn Bộ Tính Năng Windows 11 (`Full Features + Clean`):** Giữ nguyên hiệu ứng Mica/Acrylic, `Copilot`, `Widgets`, `Xbox`; chỉ tắt `Telemetry` theo dõi ngầm và dọn sạch quảng cáo rác.
* **Tùy chọn giao diện:** Chuyển **Menu Chuột Phải** về kiểu đầy đủ của Windows 10 (không cần bấm *"Show more options"*) hoặc giữ mặc định Windows 11.

### 3. `Don_Rac_Kiem_Tra_Dung_Luong.bat` — Kiểm tra dung lượng ổ C: & Dọn rác chuyên sâu
* **Báo cáo trực quan ngay khi mở:**
  * Tổng quan dung lượng ổ `C:` (Tổng, Đã dùng, Còn trống).
  * Kiểm tra dung lượng thực tế của 3 file hệ thống ẩn lớn nhất (`C:\hiberfil.sys`, `C:\pagefile.sys`, `C:\swapfile.sys`).
  * Thống kê dung lượng rác có thể dọn ngay (`%TEMP%`, `C:\Windows\Temp`, `Prefetch`, `Windows Update Cache`, `Error Reports`, `CrashDumps`, `DirectX / AMD / NVIDIA Shader Cache`).
  * Quét và dọn **Cache Trình Duyệt (`Chrome`, `Edge`, `Cốc Cốc`, `Discord`)** an toàn 100% (giữ nguyên mật khẩu, tài khoản đăng nhập và lịch sử duyệt web).
* **Tích hợp công cụ chuyên sâu:**
  * Xóa hoặc thu gọn file ngủ đông `hiberfil.sys` (giải phóng từ **4GB – 25GB** ổ C) + Tự động chạy `ReTrim` cho SSD / `Defrag` cho HDD.
  * Nén thư mục hệ thống `WinSxS` (`DISM /StartComponentCleanup`) và xóa `Windows.old`.
  * Soi chi tiết **Top 10 thư mục chiếm nhiều GB nhất** trong `AppData` & `ProgramData`.

### 4. `Khoi_Phuc_Cau_Hinh_Goc.bat` — Khôi phục cấu hình gốc & Cứu hộ hệ thống
* Đọc dữ liệu từ thư mục `Backup_Cau_Hinh_Goc\<TEN_MAY>` (được tự động tạo ra trước khi chạy tối ưu) để trả lại nguyên trạng 100% Registry, Services, Scheduled Tasks, Pagefile và Power Plan.
* Hỗ trợ bật lẻ từng tính năng (`Windows Update & Store`, `Windows Search & SysMain`, `VBS / Core Isolation`) hoặc đưa toàn bộ về mặc định chuẩn của Microsoft Windows.

---

## Hướng dẫn sử dụng
1. Tải toàn bộ bộ công cụ về máy.
2. Nhấp đúp chuột (hoặc bấm chuột phải chọn **Run as administrator**) vào file `.bat` bạn muốn sử dụng.
3. Nhấn các phím số `[1]`, `[2]`, `[3]`... trên bàn phím theo hướng dẫn trên màn hình.
