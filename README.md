# Windows-Clean-Optimize

Batch script สำหรับ Automate งาน Maintenance พื้นฐาน: ลบ Temp Files และ Optimize Drives (HDD/SSD) รองรับ Auto-Admin Elevation ในตัว

## Features

* **Auto-Privilege Escalation:** เช็กสิทธิ์ Admin และขอสิทธิ์เพิ่มให้อัตโนมัติ (ไม่ต้องคลิกขวา Run as admin เอง)
* **Silent Cleanup:** ล้าง `%TEMP%` และ `Windows\Temp` โดยข้ามไฟล์ที่ Lock อยู่ (No error interrupts)
* **All-Drive Optimization:** - สั่ง **TRIM** สำหรับ SSD เพื่อรักษา Write Speed
* สั่ง **Defragment** สำหรับ HDD เพื่อจัดเรียง Data Block


* **Detailed Verbose:** แสดง Report สรุปสถานะ Disk หลังทำเสร็จ (Fragmentation %, Free space consolidation)

## Code Structure

ใช้คำสั่ง Native ของ Windows เพื่อความเบาและปลอดภัย:

* `net session`: ตรวจสอบสิทธิ์ Access ระดับระบบ
* `Start-Process -Verb RunAs`: เรียกใช้ Elevation Prompt ผ่าน PowerShell Wrapper
* `defrag /C /H /U /V`: รัน Optimization ทุกไดรฟ์ที่ตรวจพบแบบ Full Report

## How to Use

1. Clone หรือ Copy โค้ดในไฟล์ `.bat`
2. Double-click รันไฟล์ได้ทันที
3. กด **Yes** เมื่อหน้าต่าง UAC ปรากฏขึ้นเพื่ออนุญาตให้สิทธิ์ Admin
4. รอจนขึ้นหน้าต่างสรุปผล (Verbose Report) แล้วกดคีย์ใดๆ เพื่อจบการทำงาน

## Flags Used

| Flag | Description |
| --- | --- |
| `/C` | ทำงานกับ Local Drives ทุกตัวในเครื่อง |
| `/H` | รันแบบ Normal Priority (ใช้ CPU เต็มประสิทธิภาพเพื่อลดเวลาทำงาน) |
| `/U` | แสดง Progress ระหว่างทำงาน |
| `/V` | Verbose Mode: แสดงสถิติ Disk และสรุปผลหลังทำเสร็จ |

---

**Note:** ระยะเวลาทำงานขึ้นอยู่กับขนาดข้อมูลและประเภทของ Drive\
(SSD จะเสร็จเร็วกว่า HDD มาก)
