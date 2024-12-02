	.code16

	.global _start, begtext, begdata, begbss, endtext, enddata, endbss
	.text
	begtext:
	.data
	begdata:
	.bss
	begbss:
	.text

	.equ SETUPLEN, 2			# nr of setup-sectors
	.equ BOOTSEG, 0x07c0		# original address of boot-sector
	.equ INITSEG, 0x9000		# we move boot here - out of the way
	.equ SETUPSEG, 0x9020		# setup starts here

	ljmp    $BOOTSEG, $_start
_start:
	mov	$BOOTSEG, %ax
	mov	%ax, %ds
	mov	$INITSEG, %ax
	mov	%ax, %es
	mov	$256, %cx
	sub	%si, %si
	sub	%di, %di
	rep
	movsw
	ljmp	$INITSEG, $go
go:	mov	%cs, %ax
	mov	%ax, %ds
	mov	%ax, %es
# put stack at 0x9ff00.
	mov	%ax, %ss
	mov	$0xFF00, %sp		# arbitrary value >>512

# load the setup-sectors directly after the bootblock.
# Note that 'es' is already set up.

load_setup:
	mov	$0x0000, %dx		# drive 0, head 0
	mov	$0x0002, %cx		# sector 2, track 0
	mov	$0x0200, %bx		# address = 512, in INITSEG
	.equ    AX, 0x0200+SETUPLEN
	mov     $AX, %ax		# service 2, nr of sectors
	int	$0x13			# read it
	jnc	ok_load_setup		# ok - continue
	mov	$0x0000, %dx
	mov	$0x0000, %ax		# reset the diskette
	int	$0x13
	jmp	load_setup

ok_load_setup:
	# Print some inane message
	mov	$0x03, %ah			# read cursor pos
	xor	%bh, %bh
	int	$0x10

	mov	$30, %cx
	mov	$0x000c, %bx		# page 0, attribute 0x0c
	#lea	msg1, %bp
	mov     $msg1, %bp
	mov	$0x1301, %ax		# write string, move cursor
	int	$0x10

	ljmp	$SETUPSEG, $0

msg1:
	.byte 13,10
	.ascii "Hongyi Liu is booting..."
	.byte 13,10,13,10

	.org 510

boot_flag:
	.word 0xAA55

	.text
	endtext:
	.data
	enddata:
	.bss
	endbss:
