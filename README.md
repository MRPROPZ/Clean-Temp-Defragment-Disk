# Windows-Clean-Optimize

Batch script สำหรับตั้งค่าประสิทธิภาพระบบ ลบTemp Files ประวัติเบราเซอร์ และ ปรับปรุงประสิทธิภาพไดร์ฟ (HDD/SSD)

## Features

* **Auto-Privilege Escalation:** เช็กสิทธิ์ Admin และขอสิทธิ์เพิ่มให้อัตโนมัติ (ไม่ต้องคลิกขวา Run as admin เอง)
* **System Performance Tuning:** ปรับแต่งค่า Registry เพื่อเลือก "Adjust for best performance" ปิดเอฟเฟกต์ที่หนักเครื่องเพื่อให้ระบบตอบสนองเร็วที่สุด
* **Multi-Browser Cleanup:** เมนูพิเศษสำหรับล้าง Cache และ History แยกตามเบราว์เซอร์: Google Chrome, Microsoft Edge, Brave Browser, Mozilla Firefox
* **Silent Cleanup:** ล้าง `%TEMP%` และ `Windows\Temp` โดยข้ามไฟล์ที่ Lock อยู่ (No error interrupts)
* **All-Drive Optimization:** - สั่ง **TRIM** สำหรับ SSD เพื่อรักษา Write Speed และ **Defragment** สำหรับ HDD เพื่อจัดเรียง Data Block
* **Detailed Verbose:** แสดง Report สรุปสถานะ Disk หลังทำเสร็จ (Fragmentation %, Free space consolidation)

## Code Structure

สคริปต์ทำงานผ่านคำสั่ง Native ของ Windows เพื่อความเบาและปลอดภัย:

* `net session`: ตรวจสอบสิทธิ์ Access ระดับระบบ
* `Start-Process -Verb RunAs`: เรียกใช้ Elevation Prompt ผ่าน PowerShell Wrapper เรียกใช้ผ่านสิทธิ์ผู้ดูแลระบบ
* `defrag /C /H /U /V`: รัน Optimization ทุกไดรฟ์ที่ตรวจพบแบบ Full Report
* `reg add`: แก้ไขค่า Registry สำหรับการปรับ Performance และ Visual Effects
* `taskkill`: ปิดโปรเซสเบราว์เซอร์ชั่วคราวเพื่อให้ลบไฟล์ Cache ได้สมบูรณ์

## How to Use
พืมพ์คำสั่งต่อไปนี้ใน (CMD หรือ PowerShell):

1. **Clone the repository**
   ```bash
      git clone [https://github.com/YOUR_USERNAME/Windows-Clean-Optimize.git](https://github.com/YOUR_USERNAME/Windows-Clean-Optimize.git)
   ```

2. **Navigate to directory**
    ```bash
      cd Windows-Clean-Optimize
    ```
    
3. **Execute the script**
    ```bash
      .\optimizer.bat
    ```
    
4. **Grant Permissions**
      กด **Yes** เมื่อหน้าต่าง UAC ปรากฏขึ้นเพื่ออนุญาตให้สิทธิ์ Admin

5. **Usage Workflow**
   * เลือก Option 1 เพื่อปรับความเร็วเครื่อง (Visual Effects)
   * เลือก Option 2 เพื่อรันสคริปต์ Cleanup & Defrag ตัวต้นฉบับ
   * เลือก Option 3 เข้าสู่เมนูจัดการเบราว์เซอร์ (Chrome, Edge, Brave, Firefox)
  
6. **สิ้นสุดการทำงาน**
      รอจนขึ้นหน้าต่างสรุปผล (Verbose Report) แล้วกดคีย์ใดๆ เพื่อจบการทำงาน
   
## Flags Used

| Flag | Description |
| --- | --- |
| `/C` | ทำงานกับ Local Drives ทุกตัวในเครื่อง |
| `/H` | รันแบบ Normal Priority (ใช้ CPU เต็มประสิทธิภาพเพื่อลดเวลาทำงาน) |
| `/U` | แสดงความคืบหน้าระหว่างทำงาน |
| `/V` | Verbose Mode: แสดงสถิติก่อนและสรุปผลหลังทำเสร็จ |

---

**Note:** ระยะเวลาทำงานขึ้นอยู่กับขนาดข้อมูลและประเภทของ Drive\
(SSD จะเสร็จเร็วกว่า HDD มาก)
