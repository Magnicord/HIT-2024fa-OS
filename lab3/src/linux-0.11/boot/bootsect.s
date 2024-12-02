.code16

    .global _start, begtext, begdata, begbss, endtext, enddata, endbss
    .text
    begtext:
    .data
    begdata:
    .bss
    begbss:
    .text

    .equ SETUPLEN, 2            # 设置段的扇区数
    .equ BOOTSEG, 0x07c0        # 引导扇区的原始地址
    .equ INITSEG, 0x9000        # 我们将引导程序移动到这里 - 让开位置
    .equ SETUPSEG, 0x9020       # 设置从这里开始

    ljmp $BOOTSEG, $_start   # 远跳转到引导段的 _start 位置

_start:
    mov $BOOTSEG, %ax
    mov %ax, %ds
    mov $INITSEG, %ax
    mov %ax, %es
    mov $256, %cx
    sub %si, %si
    sub %di, %di
    rep
    movsw                       # 从 DS:SI 复制 CX 个字到 ES:DI
    ljmp $INITSEG, $go          # 远跳转到初始化段的 go 位置
go: mov %cs, %ax
    mov %ax, %ds
    mov %ax, %es
# 将堆栈设置在 0x9ff00
    mov %ax, %ss
    mov $0xFF00, %sp

# 将设置段的扇区直接加载到引导块之后
# 注意，'es' 已经设置好了

load_setup:
    mov $0x0000, %dx
    mov $0x0002, %cx
    mov $0x0200, %bx
    .equ AX, 0x0200+SETUPLEN
    mov $AX, %ax
    int $0x13
    jnc ok_load_setup
    mov $0x0000, %dx
    mov $0x0000, %ax
    int $0x13
    jmp load_setup

ok_load_setup:
    # 打印启动信息
    mov $0x03, %ah            # 读取光标位置
    xor %bh, %bh
    int $0x10                 # 调用 BIOS 中断
    mov $30, %cx              # 30 是显示信息的 ASCII 码字符数
    mov $0x000c, %bx          # 修改字体颜色 - 0x000c 为红色
    mov $msg1, %bp
    mov $0x1301, %ax          # 写字符串，移动光标
    int $0x10                 # 调用 BIOS 中断

    ljmp $SETUPSEG, $0

msg1:                                    # 调用 BIOS 中断显示的信息
    .byte 13,10                          # 回车换行
    .ascii "Hongyi Liu is booting..."    # 打印消息
    .byte 13,10,13,10                    # 共 30 个字符

    .org 510                             # 填充到 510 字节

boot_flag:
    .word 0xAA55                         # 引导扇区标志

    .text
    endtext:
    .data
    enddata:
    .bss
    endbss:
