lw $8,($3)		# $8 <- dev_in
lw $9,($2)		# $9 <- dev_out[0]
beq $8,$9,equ
sw $8,($2)		# write into dev_out[0], initial value
sw $8,4($2)		# write into dev_out[1], current value
beq $0,$0,exit		
equ: lw $10,4($2)	# $10 <- dev_out[1]
addiu $10,$10,1		# plus one
sw $10,4($2)		# write into dev_out[1]
exit: ori $11,$0,10
sw $11,4($1)		# rewrite timer.preset
ori $12,$0,9		# ready for ctrl in timer
sw $12,($1)		# restart timer count
eret