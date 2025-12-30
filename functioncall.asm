# s7 = y
#s3 = result of simple
main: 
addi a0,zero,5
addi a1,zero,4
addi a2,zero,3
addi a3,zero,2
jal simple
addi s7,a0,0
j end
simple:
add t0,a0,a1
add t1,a2,a3
sub t2,t0,t1
add a0,t2,zero
jr ra
end:
