.data
sseg:		.space 		10 			# Save space for 10-byte lookup table

.text 
main:		la     		x10,sseg
		li     		x11,0x03
		sb     		x11,0(x10)
		li     		x11,0x9F
		sb     		x11,1(x10)
		li     		x11,0x25
		sb     		x11,2(x10)
		li     		x11,0x0D
		sb     		x11,3(x10)
		li     		x11,0x99
		sb     		x11,4(x10)
		li     		x11,0x49
		sb     		x11,5(x10)
		li     		x11,0x41
		sb     		x11,6(x10)
		li     		x11,0x1F
		sb     		x11,7(x10)
		li    		x11,0x01
		sb     		x11,8(x10)
		li     		x11,0x09
		sb     		x11,9(x10)


init:		li 		x12,0			# master counter
		lw 		x13,0(x10)		# ones
		li 		x14,0xFF		# tens			
		li 		x15,0xFF		# off SSEG
		li		x16,0			# output anode				
		li 		x20,0x111C0000 		# anode address
		li 		x21,0x110C0000		# cathode address
		li		x22,1			# interrupt stuff
		la 		x6,ISR
		csrrw		x0,mtvec,x6
		csrrw 		x0,mie,x22



aloop:		li		x16,0xF			# turn off anode
		sw		x16,0(x20)
		sw		x13,0(x21)		# put ones into sseg
		li		x16,0xE			# get first anode (1110)
		sw 		x16,0(x20)		# output anode
		call		delay_ff		# delay

		li		x16,0xF 		# turn off anode
		sw		x16,0(x20)
		sw		x14,0(x21)		# same thing with tens
		li		x16,0xD			# next anode (1101)
		sw		x16,0(x20)		# output anode
		call		delay_ff		# delay

		li		x16,0xF 		# turn off anode
		sw		x16,0(x20)
		sw		x15,0(x21)		# we want hundreds to be blank
		li		x16,0xB			# next anode (1011)
		sw		x16,0(x20)		# output anode
		call		delay_ff		# delay


		li		x16,0xF 		# turn off anode
		sw		x16,0(x20)
		sw		x15,0(x21)		# we want thousands to be blank
		li		x16,0x7			# next anode (0111)
		sw		x16,0(x20)		# output anode
		call		delay_ff		# delay
		j 		aloop			# get back

#------------------------------------------------------------
# ISR
#------------------------------------------------------------
ISR:		lw		x13,0(x10)
		lw		x14,1(x10)
		csrrw 		x0,mie,x22
		mret

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
