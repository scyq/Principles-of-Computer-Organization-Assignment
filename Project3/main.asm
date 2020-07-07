ori $1,$0,0x7f00		# timer
ori $2,$0,0x7f10		# dev_out
ori $3,$0,0x7f20		# dev_in
lw $4,($3)			# get input
sw $4,($2)			# write into dev_out[0], initial value
sw $4,4($2)			# write into dev_out[1], currnet value
ori $5,$0,0x0401		# ready for sr
mtc0 $5,$12			# write 0x0401 to sr
mfc0 $29,$15			# write prid into $29
ori $6,$0,10			# timer counts = 10
sw $6,4($1)			# preset = 10
ori $7,$0,9			# ready for ctrl
sw $7,($1)			# ctrl = 1001
lop: j lop