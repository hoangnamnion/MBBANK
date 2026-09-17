# HƯỚNG DẪN BUILD FILE .IPA VÀ CÀI LÊN IPHONE (TỪ MÁY TÍNH WINDOWS)

Bạn không cần máy Mac, GitHub Actions sẽ tự động dùng máy ảo macOS miễn phí của GitHub để build file **`.ipa`** cho bạn!

---

## BƯỚC 1: Đưa Mã Nguồn Lên GitHub

1. Truy cập [github.com](https://github.com) và đăng nhập tài khoản.
2. Bấm vào dấu **`+`** ở góc trên cùng bên phải -> chọn **New repository**.
3. Điền thông tin:
   - **Repository name**: `Fake-MBBank` (hoặc tên tùy thích).
   - Chọn chế độ **Private** (để giữ riêng tư).
   - Bấm **Create repository**.
4. Đưa code lên repository theo một trong các cách sau:

   - **Cách A (Dễ nhất - Kéo thả trực tiếp trên Web):**
     1. Ở trang repository vừa tạo, bấm vào dòng chữ **"uploading an existing file"**.
     2. Kéo toàn bộ các file & thư mục trong thư mục này thả vào trình duyệt.
     3. Bấm **Commit changes**.
   
   - **Cách B (Dùng GitHub Desktop):**
     1. Tải [GitHub Desktop](https://desktop.github.com/).
     2. Chọn `File` -> `Add Local Repository` -> Chọn thư mục này rồi bấm `Publish repository`.

   - **Cách C (Dùng dòng lệnh Git nếu máy đã cài Git):**
     ```bash
     git init
     git add .
     git commit -m "Setup auto build IPA via GitHub Actions"
     git branch -M main
     git remote add origin https://github.com/<TEN_GITHUB_CUA_BAN>/<TEN_REPO>.git
     git push -u origin main
     ```

---

## BƯỚC 2: Tải File .ipa Sau Khi Build Xong

1. Sau khi `git push`, vào lại trang repository của bạn trên GitHub.
2. Bấm vào tab **Actions** ở menu phía trên.
3. Bạn sẽ thấy một tiến trình đang chạy có tên **`Build iOS IPA`**:
   - Nếu muốn chạy lại thủ công bất kỳ lúc nào: Chọn mục **Build iOS IPA** ở cột bên trái -> bấm nút **Run workflow** -> bấm **Run workflow**.
4. Chờ máy ảo macOS của GitHub build khoảng **2 - 4 phút**. Khi hoàn tất sẽ hiện dấu tích xanh ✅.
5. Bấm vào lần chạy đó (run), cuộn xuống dưới cùng mục **Artifacts**:
   - Bạn sẽ thấy file **`MB_Bank_iOS_App`**.
   - Bấm vào để tải file zip về máy tính. Giải nén ra bạn sẽ có file: **`MB_Bank.ipa`**.

---

## BƯỚC 3: Cài Đặt File .ipa Lên iPhone

Có 3 cách đơn giản và phổ biến nhất để cài file `.ipa` vừa tải về lên iPhone:

### Cách 1: Dùng phần mềm Sideloadly (Khuyên dùng trên Windows - Rất nhanh & dễ)
1. Tải phần mềm **Sideloadly** trên máy tính Windows: [sideloadly.io](https://sideloadly.io).
2. Cắm iPhone vào máy tính qua cáp USB (nhớ chọn *Tin cậy máy tính này* trên màn hình iPhone nếu được hỏi).
3. Mở Sideloadly:
   - Kéo và thả file `MB_Bank.ipa` vào biểu tượng ứng dụng trong Sideloadly.
   - Nhập tài khoản **Apple ID** của bạn vào ô `Apple account`.
   - Bấm **Start**.
4. Khi Sideloadly báo **Done**, trên iPhone bạn vào:
   - **Cài đặt (Settings)** -> **Cài đặt chung (General)** -> **Quản lý VPN & Thiết bị (VPN & Device Management)**.
   - Chọn tài khoản Apple ID của bạn -> Bấm **Tin cậy (Trust)**.
   - Mở app `MB Bank` và trải nghiệm!

---

### Cách 2: Dùng AltStore
- Nếu bạn đã cài đặt sẵn [AltStore](https://altstore.io) trên iPhone và AltServer trên Windows:
- Chỉ cần gửi file `.ipa` sang iPhone (qua Zalo/Google Drive/Airdrop), mở trong ứng dụng AltStore và chọn cài đặt.

---

### Cách 3: Dùng TrollStore (Nếu iPhone đã hỗ trợ TrollStore)
- Không cần máy tính, chỉ cần mở trực tiếp file `MB_Bank.ipa` bằng TrollStore trên iPhone là cài vĩnh viễn không bị giới hạn 7 ngày.
