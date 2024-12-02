.code16

# 注意！这些值必须与 bootsect.s 中的相同！

    .equ INITSEG, 0x9000    # 我们将引导程序移动到这里 - 让开位置
    .equ SETUPSEG, 0x9020   # 这是当前段

    .global _start, begtext, begdata, begbss, endtext, enddata, endbss
    .text
    begtext:
    .data
    begdata:
    .bss
    begbss:
    .text

    ljmp $SETUPSEG, $_start  # 远跳转到设置段的 _start 位置

_start:
    call setup_segments      # 设置段寄存器
    call print_boot_info     # 打印启动信息
    call save_cursor_pos     # 保存光标位置
    call get_memory_size     # 获取内存大小
    call get_video_card_data # 获取显卡数据
    call get_hd0_data        # 获取硬盘数据
    call print_info          # 打印所有信息
    jmp inf_loop             # 进入无限循环

# 设置段寄存器
setup_segments:
    mov $SETUPSEG, %ax
    mov %ax, %ds
    mov %ax, %es
    ret

# 打印启动信息
print_boot_info:
    mov $0x03, %ah        # 读取光标位置
    xor %bh, %bh
    int $0x10
    mov $25, %cx          # 设置 CX 寄存器为 25
    mov $0x000c, %bx      # 页面 0，属性 0x0c
    mov $msg2, %bp        # 将消息地址加载到 BP 寄存器
    mov $0x1301, %ax      # 写字符串，移动光标
    int $0x10             # 调用 BIOS 中断
    ret

# 保存光标位置
save_cursor_pos:
    mov $INITSEG, %ax     # 这在 bootsect 中已经完成，但...
    mov %ax, %ds
    mov $0x03, %ah        # 读取光标位置
    xor %bh, %bh
    int $0x10             # 将其保存在已知位置，con_init 从 0x90000 获取
    mov %dx, %ds:0        # 将光标位置保存到 0x90000
    ret

# 获取内存大小
get_memory_size:
    mov $0x88, %ah
    int $0x15
    mov %ax, %ds:2        # 将内存大小保存到 0x90002
    ret

# 获取显卡数据
get_video_card_data:
    mov $0x12, %ah
    mov $0x10, %bl
    int $0x10
    mov %ax, %ds:8        # 将显卡数据保存到 0x90008
    mov %bx, %ds:10
    mov %cx, %ds:12
    ret

# 获取硬盘数据
get_hd0_data:
    mov $0x0000, %ax
    mov %ax, %ds
    lds %ds:4*0x41, %si
    mov $INITSEG, %ax
    mov %ax, %es
    mov $0x0080, %di
    mov $0x10, %cx
    rep
    movsb
    ret

# 打印所有信息
print_info:
    call print_cursor_info     # 打印光标信息
    call print_memory_info     # 打印内存信息
    call print_video_card_info # 打印显卡信息
    call print_hd0_info        # 打印硬盘信息
    ret

# 打印光标信息
print_cursor_info:
    mov $INITSEG, %ax
    mov %ax, %ds
    mov $SETUPSEG, %ax
    mov %ax, %es
    mov $0x03, %ah
    xor %bh, %bh
    int $0x10
    mov $11, %cx
    mov $0x0007, %bx      # 页面 0，属性 7（正常）
    mov $cursor_info, %bp
    mov $0x1301, %ax      # 写字符串，移动光标
    int $0x10
    mov %ds:0, %ax
    call print_hex        # 打印光标位置
    call print_nl         # 打印换行
    ret

# 打印内存信息
print_memory_info:
    mov $INITSEG, %ax
    mov %ax, %ds
    mov $SETUPSEG, %ax
    mov %ax, %es
    mov $0x03, %ah
    xor %bh, %bh
    int $0x10
    mov $12, %cx
    mov $0x0007, %bx      # 页面 0，属性 7（正常）
    mov $memory_info, %bp
    mov $0x1301, %ax      # 写字符串，移动光标
    int $0x10
    mov %ds:2, %ax
    call print_hex        # 打印内存大小

    mov $INITSEG, %ax
    mov %ax, %ds
    mov $SETUPSEG, %ax
    mov %ax, %es
    mov $0x03, %ah
    xor %bh, %bh
    int $0x10
    mov $2, %cx
    mov $0x0007, %bx      # 页面 0，属性 7（正常）
    mov $kb, %bp
    mov $0x1301, %ax      # 写字符串，移动光标
    int $0x10
    call print_nl         # 打印换行
    ret

# 打印显卡信息
print_video_card_info:
    mov $INITSEG, %ax
    mov %ax, %ds
    mov $SETUPSEG, %ax
    mov %ax, %es
    mov $0x03, %ah
    xor %bh, %bh
    int $0x10
    mov $24, %cx
    mov $0x0007, %bx      # 页面 0，属性 7（正常）
    mov $vc_info, %bp
    mov $0x1301, %ax      # 写字符串，移动光标
    int $0x10
    mov %ds:10, %ax
    call print_hex        # 打印显卡信息
    call print_nl         # 打印换行
    ret

# 打印硬盘信息
print_hd0_info:
    mov $INITSEG, %ax
    mov %ax, %ds
    mov $SETUPSEG, %ax
    mov %ax, %es
    mov $0x03, %ah
    xor %bh, %bh
    int $0x10
    mov $21, %cx
    mov $0x0007, %bx      # 页面 0，属性 7（正常）
    mov $hd_info, %bp
    mov $0x1301, %ax      # 写字符串，移动光标
    int $0x10
    mov %ds:128, %ax
    call print_hex        # 打印硬盘信息
    call print_nl         # 打印换行

    mov $INITSEG, %ax
    mov %ax, %ds
    mov $SETUPSEG, %ax
    mov %ax, %es
    mov $0x03, %ah
    xor %bh, %bh
    int $0x10
    mov $8, %cx
    mov $0x0007, %bx      # 页面 0，属性 7（正常）
    mov $hd_info1, %bp
    mov $0x1301, %ax      # 写字符串，移动光标
    int $0x10
    mov %ds:130, %ax
    call print_hex        # 打印硬盘信息
    call print_nl         # 打印换行

    mov $INITSEG, %ax
    mov %ax, %ds
    mov $SETUPSEG, %ax
    mov %ax, %es
    mov $0x03, %ah
    xor %bh, %bh
    int $0x10
    mov $8, %cx
    mov $0x0007, %bx      # 页面 0，属性 7（正常）
    mov $hd_info2, %bp
    mov $0x1301, %ax      # 写字符串，移动光标
    int $0x10
    mov %ds:142, %ax
    call print_hex        # 打印硬盘信息
    call print_nl         # 打印换行
    ret

# 无限循环
inf_loop:
    jmp inf_loop

# 以 16 进制方式打印栈顶的 16 位数
print_hex:
    mov $4, %cx         # 4 个十六进制数字
    mov %ax, %dx        # 将 (bp) 所指的值放入 dx 中，如果 bp 是指向栈顶的话
print_digit:
    rol $4, %dx         # 循环以使低 4 比特用上 !! 取 dx 的高 4 比特移到低 4 比特处。
    mov $0xe0f, %ax     # ah = 请求的功能值，al = 半字节 (4 个比特) 掩码。
    and %dl, %al        # 取 dl 的低 4 比特值。
    add $0x30, %al      # 给 al 数字加上十六进制 0x30
    cmp $0x3a, %al
    jl outp             # 是一个不大于十的数字
    add $0x07, %al      # 是 a~f，要多加 7

outp:
    int $0x10
    loop print_digit
    ret

# 打印回车换行
print_nl:
    mov $0xe0d, %ax   # CR
    int $0x10
    mov $0xa, %al     # LF
    int $0x10
    ret

# 启动信息
msg2:
    .byte 13,10
    .ascii "Now we are in SETUP"
    .byte 13,10,13,10

# 光标信息
cursor_info:
    .ascii "Cursor POS:"

# 内存信息
memory_info:
    .ascii "Memory SIZE:"

# KB
kb:
    .ascii "KB"

# 显卡信息
vc_info:
    .ascii "Video Card display mode:"

# 硬盘信息
hd_info:
    .byte 13,10
    .ascii "HD Info"
    .byte 13,10
    .ascii "Cylinders:"

# 硬盘头信息
hd_info1:
    .ascii "Headers:"

# 硬盘扇区信息
hd_info2:
    .ascii "Secotrs:"

.text
endtext:
.data
enddata:
.bss
endbss:
