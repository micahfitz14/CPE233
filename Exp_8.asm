.data
sseg:		.space 		10 			# Save space for 10-byte lookup table

.text 
main:		la     		x10,sseg		# addr of LUT
		li     		x11,0x03
		sb     		x11,0(x10)		# 0
		li     		x11,0x9F
		sb     		x11,1(x10)		# 1
		li     		x11,0x25
		sb     		x11,2(x10)		# 2
		li     		x11,0x0D
		sb     		x11,3(x10)		# 3
		li     		x11,0x99
		sb     		x11,4(x10)		# 4
		li     		x11,0x49
		sb     		x11,5(x10)		# 5
		li     		x11,0x41
		sb     		x11,6(x10)		# 6
		li     		x11,0x1F
		sb     		x11,7(x10)		# 7
		li    		x11,0x01
		sb     		x11,8(x10)		# 8
		li     		x11,0x09
		sb     		x11,9(x10)		# 9


init:		li 		x12,0			# master counter binary
		li		x18,0			# master counter ones
		li		x19,0			# master counter tens
		lb 		x13,0(x10)		# ssegs ones
		li		x14,0xFF		# ssegs tens			
		li 		x15,0xFF		# off SSEG
		li		x16,0			# output anode
		li		x17,0x32		# master counter cap 49		
		li 		x20,0x111C0000 		# anode address
		li 		x21,0x110C0000		# cathode address
		li		x22,1			# interrupt stuff
		la 		x6,ISR
		csrrw		x0,mtvec,x6
		csrrw 		x0,mie,x22


aloop:		
		la     		x10,sseg		# re-load LUT addr
		li		x16,0xF			# turn off anode
		sw		x16,0(x20)
		add		x10,x10,x18		# calculate LUT offset from BCD ones
		lb		x13,0(x10)		# load ones value from LUT
		sw		x13,0(x21)		# output ones to its seg
		li		x16,0xE			# get first anode (1110)
		sw 		x16,0(x20)		# output anode
#		call		delay_ff		# delay

		la     		x10,sseg		# re-load LUT addr
		li		x16,0xF 		# turn off anode
		sw		x16,0(x20)
		add		x10,x10,x19		# calculate LUT offset from BCD tens
		lb		x14,0(x10)		# load tens value from LUT
		sw		x14,0(x21)		# output tens to its seg
		li		x16,0xD			# next anode (1101)
		sw		x16,0(x20)		# output anode
#		call		delay_ff		# delay

		li		x16,0xF 		# turn off anode
		sw		x16,0(x20)
		sw		x15,0(x21)		# we want hundreds to be blank
		li		x16,0xB			# next anode (1011)
		sw		x16,0(x20)		# output anode
#		call		delay_ff		# delay

		li		x16,0xF 		# turn off anode
		sw		x16,0(x20)
		sw		x15,0(x21)		# we want thousands to be blank
		li		x16,0x7			# next anode (0111)
		sw		x16,0(x20)		# output anode
#		call		delay_ff		# delay
		j 		aloop			# get back

#------------------------------------------------------------
# ISR
#------------------------------------------------------------
ISR:		addi		x12,x12,1
		call		binary_to_BCD

		beq		x12,x17,RST
		
		
FINISH:		csrrw 		x0,mie,x22
		mret

RST:		mv 		x12, x0
		mv 		x18, x0
		mv		x19, x0
		j		FINISH
#------------------------------------------------------------ 
# Subroutine: delay_ff
#
# Delays for a count of FF. Unknown how long that is but it 
# is plenty of time for display multiplexing
#
# tweaked registers: x31
#------------------------------------------------------------
delay_ff:	li 		x31,0xFF		# load count
loop:		beq 		x31,x0,done		# leave if done
		addi 		x31,x31,-1		# decrement count
		j 		loop			# rinse, repeat
		
done: 		ret 					# leave it all behind

#--------------------------------------------------------------
# Subroutine: binary to BCD
#
# This subroutine takes the binary value in x12 and converts it 
# into a BCD value stored with 1s place in x18 and the 10s place
# in x19. x12 is unchanged. 
#
# tweaked registers: x18, x19
#--------------------------------------------------------------
binary_to_BCD: 
store: 			addi sp, sp, -8
			sw x10, 0(sp)
			sw x15, 4(sp)

init1:			mv x18, x12
			li x10, 10
			

bloop:			slt  x15, x18, x10
			bnez x15, restore
			addi x18, x18, -10
			addi x19, x19, 1

restore:		lw x10, 0(sp)
			lw x15, 4(sp)
			addi sp, sp, 8
			ret
#-------------------------------------------------------------
