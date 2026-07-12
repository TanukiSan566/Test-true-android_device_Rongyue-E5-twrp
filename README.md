# ums9621_1h10 TWRP 设备树 v3 —— 按 ZTE P720S16 参考树重建

这次不是打补丁式修改，是照着 `android_device_ZTE_P720S16-twrp-main`（同平台
ums9620/9621家族、已验证成功的真实案例）的结构整个重新搭的，同时保留我们
这一路验证过的所有真实硬件数据。

## 相比上一版的关键改动

1. **改用真实内核文件，而不是 TARGET_NO_KERNEL**
   之前用 `TARGET_NO_KERNEL := true` 试图跳过内核环节，一直在跟"root目录
   生成不出来"这个报错周旋。这次改用 `TARGET_FORCE_PREBUILT_KERNEL := true`，
   并且我直接从你之前上传过的 `boot.img` 里提取出了真实的内核文件
   （`prebuilt/kernel`，44.6MB，ARM64 Image格式，已验证magic正确），这是
   参考树的做法，很可能才是之前那一连串"root目录"报错的真正解法。

2. **USB控制器改用 system.prop 配置，而不是手写脚本**
   之前我自己写了一个 `init.recovery.usb.rc` 去手动配置ConfigFS，其实是
   在没有真实参考的情况下"发明轮子"。参考树告诉我们，标准做法是通过
   `system.prop` 里的 `sys.usb.controller` 属性，交给TWRP/AOSP自带的、
   已经调试好的默认脚本去处理。新加的 `system.prop` 里填的是你之前真机上
   `ls /sys/class/udc/` 查到的真实值 `musb-hdrc.1.auto`。

3. **recovery.fstab 挪到了新路径**
   从原来的 `device/xxx/recovery.fstab` 挪到了
   `recovery/root/system/etc/recovery.fstab`，跟参考树保持一致的目录结构。

4. **PRODUCT_SHIPPING_API_LEVEL 保持 31**
   这个之前已经踩过坑确认了：这套老源码写死只认28-32，33会直接报错拒绝，
   不是我们能配置绕过的，所以保留31。

## 你还需要做的事

### 1. 补齐内核模块
把 `prebuilt/modules/` 文件夹里放上你设备真实的 `.ko` 文件（我们之前解包
Hovatek镜像时已经拿到过完整的一份，也可以从 `origin-vendor_boot_a.img`
重新解包platform ramdisk拿到）。

### 2. dtbo.img（可选，不确定是否必需）
参考树用了 `BOARD_PREBUILT_DTBOIMAGE`，但我们目前没有你设备真实的
`dtbo.img` 文件（只知道分区大小是8388608字节）。这次先不加这个配置，
如果编译报错说缺 dtbo，再从你手机上 `dd` 一份 `dtbo_a` 分区发我。

### 3. 触发编译时的 lunch 目标
记得填完整： `twrp_ums9621_1h10-eng`（不要漏了 `-eng`）。

## 说句实话

这次改动幅度比之前任何一次都大，是因为找到了真正有分量的参考（同平台、
真实发布过），值得推倒重来而不是继续小修小补。但"这次一定成功"我不能
打包票——真实内核文件是否被这套老构建系统正确识别、UDC走system.prop这条
路径是否真的对你这套ConfigFS驱动生效，都还需要真机验证。报错继续发我。
