# DO AN 2 - KTMT va HN
# Thu vien TIME

.data

mesg_nhap_ngay:
	.asciiz "Nhap ngay DAY: "
mesg_nhap_thang:
	.asciiz "Nhap thang MONTH: "
mesg_nhap_nam:
	.asciiz "Nhap nam YEAR: "
TIME_1:
	.space 512
TIME_2:
	.space 512
TIME:
	.space 512
strTmp:
	.space 512

TIMECV: .space 512


menu_title:
	.asciiz "---Ban hay chon 1 trong cac thao tac duoi day---\n"
option_1:
	.asciiz "1. Xuat chuoi TIME theo dinh dang DD/MM/YYYY\n"
option_2:
	.asciiz "2. Xuat chuoi TIME thanh mot trong cac dinh dang sau\n   A. MM/DD/YYYY\n   B. Month DD, YYYY\n   C. DD Month, YYYY\n"
option_3: 
	.asciiz "3. Cho biet ngay vua nhap la ngay thu may trong tuan:\n"
option_4: 
	.asciiz "4. Kiem tra nam trong chuoi TIME co phai la nam nhuan khong\n"
option_5: 
	.asciiz "5. Cho biet khoang thoi gian giua chuoi TIME_1 va TIME_2\n"
option_6: 
	.asciiz "6. Cho biet 2 nam nhuan gan nhat voi nam trong chuoi TIME\n"
option_7: 
	.asciiz "7. Ket thuc su dung\n"
option_8: 
	.asciiz "========================================="
option_FALSE: 
	.asciiz "\nChon sai. Ket thuc su dung\n"
option_2abc:	
	.asciiz "A. MM/DD/YYYY\nB. Month DD, YYYY\nC. DD Month, YYYY\n"
msg_tieptuc:
	.asciiz "\nTiep tuc ? (Y) : "
msg_dinhdang: .asciiz "Chon dinh dang: "
msg_saiDinhDang: .asciiz "Chon sai dinh dang\n"
content: .asciiz "\n\nHay nhap lua chon cua ban: "
msg_nhapSaiThoiGian:
	.asciiz "Nhap thoi gian khong hop le\nNhap lai: "
# leap year result
ly_result_1: .asciiz "La nam nhuan\n"
ly_result_0: .asciiz "Khong la nam nhuan\n"

#Get time result:
GetTime_Result: 
		.asciiz "Khoang cach giua 2 ngay tren: \n"
# 2 leap year
twoLeapYear_Result:
		.asciiz "2 nam nhuan gan nhat : \n"

# jump table of options
menutable: .word o1, o2, o3, o4, o5, o6, o7, o8

daysOfWeek: .word t2, t3, t4, t5, t6, t7, cn

listMonth: .word m1,m2,m3,m4,m5,m6,m7,m8,m8,m10,m11,m12

monday:    .asciiz "Monday"
tuesday:   .asciiz "Tuesday"
wednesday: .asciiz "Wednesday"
thursday:  .asciiz "Thursday"
friday:    .asciiz "Friday"
saturday:  .asciiz "Saturday"
sunday:    .asciiz "Sunday"


Jan:	   .asciiz "January"
Feb: 	   .asciiz "February"
Mar: 	   .asciiz "March"
Apr: 	   .asciiz "April"
May:	   .asciiz "May"
June:	   .asciiz "June"
July:      .asciiz "July"
Aug:       .asciiz "August"
Sept:      .asciiz "September"
Oct:       .asciiz "October"
Nov:	   .asciiz "November"
Dec:	   .asciiz "December"
	
.text

Main:

nhap_thoi_gian:
	la $a0, TIME_1
	la $a1, strTmp
	jal input
	add $s0, $0, $v0
	add $s1, $0, $v1
	bne $s1, $0, nhap_xong
	addi $v0,$0,4       
	la $a0, msg_nhapSaiThoiGian    
	syscall
	j nhap_thoi_gian
	nhap_xong:
			
hien_thi_nemu:
	# Hien thi menu
	addi $v0,$0,4
	#li $v0, 4
	la $a0, menu_title
	syscall
	
	la $a0, option_1
	syscall
	
	la $a0, option_2
	syscall
	
	la $a0, option_3
	syscall
	
	la $a0, option_4
	syscall
	
	la $a0, option_5
	syscall
	
	la $a0, option_6
	syscall
	
	la $a0, option_7
	syscall

	la $a0, option_8
	syscall

	# Hien thi lenh nhap
	la $a0, content
	syscall
	
	addi $v0,$0,5
	syscall
	slt $t1,$v0,$0
	addi $t2,$0,1
	beq $t1,$t2,falseOption
	addi $t3,$0,9
	slt $t1,$v0,$t3
	beq $t1,$t2,showSwitch

	falseOption:
	la $a0,option_FALSE
	addi $v0, $0, 4	
	syscall
	j main_exit
	# switch - case 
showSwitch:
	addi $v0, $v0, -1
	sll $v0, $v0, 2
	la $t0, menutable
	add $t0, $t0, $v0
	lw $t0, ($t0)
	jr $t0
	
	o1: #option 1		
		la $a0, TIME_1
		jal printf
		add $a0, $0, 10	
		addi $v0, $0, 11
		syscall
		j tiepTuc
	o2: #option 2
		la $a0,option_2abc
		addi $v0, $0, 4	
		syscall
		la $a0,msg_dinhdang
		addi $v0, $0, 4	
		syscall
		addi $v0,$0,12
		syscall
		add $a1, $0, $v0
		add $a0, $0, 10	
		addi $v0, $0, 11
		syscall
		la $a0, TIME_1
		jal Convert
		beq $v1,$0,wrongChoose
		add $a0, $0, $v0	
		addi $v0, $0, 4	
		syscall
		j tiepTuc
		wrongChoose:
			la $a0,msg_saiDinhDang
			addi $v0, $0, 4	
			syscall
		j tiepTuc
	o3: #option 3
		la $a0, TIME_1
		jal week_day
		add $a0, $v0, $0
		jal print_week_day
		la $a0, ($v0)
		jal printf
		j tiepTuc
		
	o4: #option 4
		la $a0, TIME_1
		jal check_leap_year
		add $a0, $v0, $0
		jal print_result
		j tiepTuc
		
	o5: #option 5
		# get TIME_2
		la $a0, TIME_2
		la $a1, strTmp
		jal input
		add $s0, $0, $v0
		add $s1, $0, $v1
		bne $s1, $0, start_o5
		addi $v0,$0,4       
		la $a0, msg_nhapSaiThoiGian    
		syscall
		j o5
		start_o5:
		addi $v0,$0,4       
		la $a0, GetTime_Result    
		syscall


		la $a0, TIME_1
		la $a1, TIME_2

		
		jal GetTime
		add $a0, $0, $v0	
		addi $v0, $0, 1	
		syscall	
		add $a0, $0, 10	
		addi $v0, $0, 11
		syscall
		j tiepTuc

	
	o6: #option 6 	 Cho biet 2 nam nhuan gan nhat voi nam trong chuoi TIME"
		la $a0, TIME_1
		jal Year
		add $t2,$v0,$0  # t0 = YEAR (TIME_1)
		# LOOP Find the next Leap Year
		findNextLeapYear:
			
			addi $t2,$t2,1 # t2++
			add $t3,$t2,$0

			addi $t0,$0,400  # t1 = t2 %400;
			div $t3, $t0
			mfhi $t1
			beq $t1, $0, exitLoop # if t1==0 => LEAPYEAR , exit loop
	
			addi $t0,$0,4
			div $t3, $t0
			mfhi $t1
			beq $t1, $0, checkDiv
	
			j findNextLeapYear

		checkDiv:
			addi $t0,$0,100
			div $t3, $t0
			mfhi $t1
			bne $t1, $0, exitLoop
			j findNextLeapYear
		exitLoop:
			# the next leap year is t2
		jal check_leap_year
		beq $v0, $0,not_a_LeapYear # YEAR(TIME_1) is not a leap year
					   # YEAR(TIME_1) is a leap year
			addi $t3,$t2,-8  # previous leap year t3= t2-8;
			j printResult
		not_a_LeapYear:
			addi $t3,$t2,-4  # previous leap year t3= t2-4;
		printResult:
			addi $v0,$0,4
			la  $a0, twoLeapYear_Result
			syscall
			add $a0, $0, $t3	# in t3
			addi $v0, $0, 1	# goi lenh in so nguyen
			syscall
			add $a0, $0, 44	
			addi $v0, $0, 11	# in dau ','
			syscall
			add $a0, $0, $t2	# in t2
			addi $v0, $0, 1	# goi lenh in so nguyen
			syscall
			add $a0, $0, 10	
			addi $v0, $0, 11
			syscall	
			j tiepTuc	
	o7: #option 7
			j main_exit
	o8:	
			j main_exit

main_exit:
        addi $v0, $0, 10
        syscall
tiepTuc:
	la $a0,msg_tieptuc
	addi $v0, $0, 4	
	syscall
	addi $v0,$0,12
	syscall
	add $t1,$v0,$0
	add $a0, $0, 10	
	addi $v0, $0, 11
	syscall
	addi $t0,$0,89
	beq $t1,$t0,hien_thi_nemu 
	j main_exit

#Ham nhap ngay thang nam
input:
	addi $sp, $sp, -36
	sw $s0, 32($sp)		# luu tinh hop le chuoi ngay, thang, nam
	sw $ra, 28($sp)		# chua dia chi tra ve
	sw $a0, 24($sp)		# chua dia chi chuoi Date
	sw $a1, 20($sp)	       	# chua dia chi chuoi tam
	
	addi $s0, $0, 0		# kiem soat tinh hop le cua chuoi nhap vao
	
	#nhap chuoi ngay
	la $a0, mesg_nhap_ngay
	jal printf
	
	addi $v0, $0, 8
	lw $a0, 20($sp)
	addi $a1, $0, 512
	syscall
	jal contain_all_digits
	add $s0, $s0, $v0
	
	lw $a0, 20($sp)		
	jal convert_string_int
	sw $v0, 16($sp)	
	
	
	#nhap chuoi thang
	la $a0, mesg_nhap_thang
	jal printf
	
	addi $v0, $0, 8
	lw $a0, 20($sp)
	addi $a1, $0, 512
	syscall
	jal contain_all_digits
	add $s0, $s0, $v0
	
	lw $a0, 20($sp)		
	jal convert_string_int
	sw $v0, 12($sp)	
	
	
	#nhap chuoi nam
	la $a0, mesg_nhap_nam
	jal printf
	
	addi $v0, $0, 8
	lw $a0, 20($sp)
	addi $a1, $0, 512
	syscall
	jal contain_all_digits
	add $s0, $s0, $v0
	
	lw $a0, 20($sp)		
	jal convert_string_int
	sw $v0, 8($sp)
	
	lw $a0, 16($sp)
	lw $a1, 12($sp)
	lw $a2, 8($sp)
	lw $a3, 24($sp)
	jal Date
	
	addi $t0, $0, 3
	bne $s0, $t0, input_False
	
	lw $a0, 24($sp)
	jal logic_check
	beq $v0, $0, input_False
	
	addi $v1, $0, 1
	j input_exit
input_False:
	add $v1, $0, $0
input_exit:
	lw $s0, 32($sp)
	lw $ra, 28($sp)
	lw $a0, 24($sp)
	lw $a1, 20($sp)
	addi $sp, $sp, 36
	
	add $v0, $0, $a0
	jr $ra

##########################################################################
#kiem tra chuoi chi toan chua so
# $a0: chuoi can kiem tra 
# $v0: hop le(1) hay khong hop le(0)

contain_all_digits:
	add $t0, $0, $a0
	addi $v0, $0, 1
contain_all_digits_loop:
	lb $t1, 0($t0)
	beq $t1,$0, contain_all_digits_exit
	addi $t2, $0, 10 
	beq $t1, $t2, contain_all_digits_exit
	slti $t2, $t1, 48
	bne $t2, $0, contain_all_digits_False
	slti $t2, $t1, 58
	beq $t2,$0, contain_all_digits_False
	addi $t0, $t0, 1
	j contain_all_digits_loop	
contain_all_digits_False:
	add $v0, $0, $0
contain_all_digits_exit:
	jr $ra
	
##########################################################################
#chuyen chuoi thanh so
convert_string_int:
	add $v0, $0, $0
	add $t0, $0, $a0
convert_string_int_loop:
	lb $t1, 0($t0)				
	beq $t1, $0, convert_string_int_exit
	addi $t2, $0, 10
	beq $t1, $t2, convert_string_int_exit
	mult $v0, $t2
	mflo $v0		
	addi $t1, $t1, -48	
	add $v0, $v0, $t1	
	add $t0, $t0, 1		
	j convert_string_int_loop
convert_string_int_exit:
	jr $ra		
	

printf:  
	addi $v0, $0, 4  
  	syscall
  	jr $ra
	
	
##########################################################################
# kiem tra nam nhuan

check_leap_year:
	addi $sp, $sp, -8
	sw $ra, 4($sp)
	sw $a0, 0($sp)
	
	jal Year
	add $a0, $v0, $0
	
	addi $t0,$0,400
	div $a0, $t0
	mfhi $t1
	beq $t1, $0, ly_true
	
	addi $t0,$0,4
	div $a0, $t0
	mfhi $t1
	beq $t1, $0, check_div
	
	j ly_false

check_div:
	addi $t0,$0,100
	div $a0, $t0
	mfhi $t1
	bne $t1, $0, ly_true
	j ly_false

ly_true: 
	addi $v0,$0,1
	j ly_exit
	
ly_false:
	addi $v0,$0,0

ly_exit:	
	lw $ra, 4($sp)
	lw $a0, 0($sp)
	addi $sp, $sp, 8
	
	jr $ra


print_result:
	addi $sp, $sp, -8
	sw $v0, 4($sp)
	sw $a0, 0($sp)
	
	beq $a0, 1, print_result_1
	j print_result_0

print_result_1:
	addi $v0,$0,4
	la $a0, ly_result_1
	syscall 
	
	lw $v0, 4($sp)
	lw $a0, 0($sp)
	addi $sp, $sp, 8
	
	jr $ra
	
print_result_0:
	addi $v0,$0,4
	la $a0, ly_result_0
	syscall 
	
	lw $v0, 4($sp)
	lw $a0, 0($sp)
	addi $sp, $sp, 8
	
	jr $ra
	
#########################################################################


# int Day(char* TIME)
# $a0 : dia chi chuoi
Day: 
	add $v0, $0, $0 # result
	
	add $t0, $0,$0  # var t0 = 0 ;

	# convert Time[0], Time[1] to int 
	
	addi $t1, $0,10  # var t1=10; 

	# t0 = Time[0] -'0'
	lb $t0,0($a0)
	addi $t0,$t0,-48

	#result += t0
	add $v0, $v0,$t0
	
	# t0 = Time[1] -'0'
	lb $t0,1($a0)
	addi $t0,$t0,-48

	# v0 = v0 *10
	mult $v0, $t1
	mflo $v0
	#result += t0
	add $v0, $v0,$t0


	jr $ra
#### End of function int Day(char *TIME)


# int Month(char* TIME)
# $a0 : dia chi chuoi
Month:
	add $v0, $0, $0 # result
	
	add $t0, $0,$0  # var t0 = 0 ;

	# convert Time[3], Time[4] to int 
	
	addi $t1, $0,10  # var t1=10; 

	# t0 = Time[3] -'0'
	lb $t0,3($a0)
	addi $t0,$t0,-48
	#result += t0
	add $v0, $v0,$t0
	
	# t0 = Time[4] -'0'
	lb $t0,4($a0)
	addi $t0,$t0,-48


	# v0 = v0 *10
	mult $v0, $t1
	mflo $v0
	#result += t0
	add $v0, $v0,$t0


	jr $ra

#### End of function int Month(char *TIME)

# int Year(char* TIME)
# $a0 : dia chi chuoi
Year:
	add $v0, $0, $0 # result
	
	add $t0, $0,$0  # var t0 = 0 ;

	# convert Time[6], Time[7],Time[8], Time[9] to int 
	
	addi $t1, $0,10  # var t1=10; 

	# t0 = Time[6] -'0'
	lb $t0,6($a0)
	addi $t0,$t0,-48

	# v0 = t0 *10
	mult $v0, $t1
	mflo $v0
	#result += t0
	add $v0, $v0,$t0

	# t0 = Time[7] -'0'
	lb $t0,7($a0)
	addi $t0,$t0,-48

	# v0 = v0 *10
	mult $v0, $t1
	mflo $v0
	#result += t0
	add $v0, $v0,$t0

	# t0 = Time[8] -'0'
	lb $t0,8($a0)
	addi $t0,$t0,-48

	# t0 = t0 *10
	mult $v0, $t1
	mflo $v0
	#result += t0
	add $v0, $v0,$t0
	# t0 = Time[9] -'0'
	lb $t0,9($a0)
	addi $t0,$t0,-48
	
	# t0 = t0 *10
	mult $v0, $t1
	mflo $v0
	#result += t0
	add $v0, $v0,$t0 #final result
	
	jr $ra

#### End of function int Year(char *TIME)


# int isAfter (char *TIME1, char *TIME2) : To decide TIME has YEAR after
# return -1  if TIME1 before TIME2,  1 if TIME1 after TIME2 , 0 if TIME1 and TIME2 is the same YEAR
# $a0 : TIME_1
# $a1 : TIME_2
isAfter:
	# save to stack
	addi $sp, $sp, -40
	sw $ra, 36($sp)
	sw $a0, 32($sp)
	sw $a1, 28($sp)
 
	# save TIME_1
	lw $a0, 32($sp)

	jal Year
	sw $v0, 24($sp)


	jal Month
	sw $v0, 20($sp)


	jal Day
	sw $v0, 16($sp)


	# save TIME_2
	lw $a0, 28($sp)
	jal Year
	sw $v0, 12($sp)


	jal Month
	sw $v0, 8($sp)


	jal Day
	sw $v0, 4($sp)

	


	#Start Compare
	addi $v0, $0, 0		# base result

	#Compare YEAR
	lw $t1,24($sp)
	lw $t2,12($sp)
	
	# if YEAR1 != YEAR2
	bne $t1,$t2,L1		
 	# if YEAR1 = YEAR2
	j exitIsAfter 		

L1:	slt $t3, $t1,$t2	 # t1 < t2 ? 
	beq $t3,$0, L2  	# if t1 > t2
	addi $v0, $0,-1		# if t1< t2  => result = -1
	j exitIsAfter

L2:	addi $v0,$0,1		# t1 > t2 => result = 1
	j exitIsAfter


exitIsAfter:
	lw $ra, 36($sp)
	lw $a0, 32($sp)
	lw $a1, 28($sp)
	addi $sp, $sp, 40
	jr $ra

# End of function int isAfter (char *TIME1, char *TIME2)


# int GetTime(char* TIME_1, char* TIME_2)
# $a0 : TIME_1
# $a1: TIME_2

GetTime:
	# save to stack
	addi $sp, $sp, -44
	sw $ra, 32($sp)
	sw $a0, 40($sp)
	sw $a1, 36($sp)

 	# Make sure TIME1 is always after TIME2
	jal isAfter

	add $t1,$v0,$0
	
	beq $t1,$0,SameYEAR

	slt $t2,$t1,$0 		# t2 =  t1 < 0 ? 
	beq $t2,$0,Time1_IsAfter		# t2 == 0  => TIME1 is After TIME2
						# Time2 is after time1
	sw $a1,28($sp)
	sw $a0,24($sp)
	j exitChoseAfter
	
SameYEAR:
	add $v0,$0,$0
	j exitGetTime


Time1_IsAfter:
	sw $a0,28($sp)
	sw $a1,24($sp)
	j exitChoseAfter

exitChoseAfter:

	# save TIME_1
	lw $a0, 28($sp)

	jal Year
	sw $v0, 20($sp)


	jal Month
	sw $v0, 16($sp)


	jal Day
	sw $v0, 12($sp)


	# save TIME_2
	lw $a0, 24($sp)
	jal Year
	sw $v0, 8($sp)


	jal Month
	sw $v0, 4($sp)


	jal Day
	sw $v0, 0($sp)

#
#	add $a0, $0, $v0	
#	addi $v0, $0, 1	
#	syscall
#	add $a0, $0, 10	
#	addi $v0, $0, 11	
#	syscall
#	lw $a0,24($sp)
#

	######################## CODE C ####################################

	# int d1 = Day1, d2 = Day2, m1 =Month1, m2 = Month2, y1 =Year1, y2= Year2
	# int result = y1- y2;
	# if(m1 < m2){ result--;}
	# else {
	#	if(d1 < d2 ) result --;
	# }
	# return result;

	############# MIPS ################

	# Get the different YEAR
	lw $t1,20($sp)
	lw $t2,8($sp)
	sub $v0,$t1,$t2
	
	# Get the different MONTH
	lw $t1,16($sp)
	lw $t2,4($sp)

	slt $t3,$t1,$t2			# t3 = t1 < t2 ? 
	beq $t3,$0,differentDay		# t3 == 0 ?  => t1 >= t2

	addi $v0,$v0, -1
	
	j exitGetTime
	
differentDay:
	bne $t1,$t2,exitGetTime  # if t1 > t2 => exit
	# else t1 == t2
	lw $t1,12($sp)
	lw $t2,0($sp)

	slt $t3,$t1,$t2  # t1 < t2 ? 
	beq $t3,$0,exitGetTime # if (t1 >= t2)
	addi $v0,$v0, -1       # else t1 < t2
exitGetTime:
	lw $ra, 32($sp)
	lw $a0, 40($sp)
	lw $a1, 36($sp)
	addi $sp, $sp, 40
	jr $ra



#######################################
# char* Weekday(char* TIME)

week_day:
	addi $sp, $sp, -28
	sw $s0, 24($sp)
	sw $s1, 20($sp)
	sw $ra, 16($sp)
	sw $a0, 12($sp)

	jal Day 
	add $t0, $v0, $0
	sw $t0,8($sp)

	jal Month 
	add $t1, $v0, $0
	sw $t1,4($sp)

	jal Year 
	add $t2, $v0, $0
	sw $t2,0($sp)

	# a = (14 - month) / 12
	addi $t3,$0, 14
	lw $t1,4($sp)
	sub $s0, $t3, $t1
	
	addi $t3,$0, 12
	
	div $s0, $t3
	mflo $s0
	

	# b = year + 4800 - a
	add $s1, $0, $0
	addi $s1, $t2, 4800
	sub $s1, $s1, $s0


	###################3
	# s0 = 12*(s0)

	addi $t3,$0,12
	mult $s0, $t3
	mflo $s0
	
	# s0 = t1+s0-3
	add $s0, $s0, $t1
	addi $s0, $s0, -3
	
	# s0= 153 * s0 
	addi $t3,$0,153
	mult $s0, $t3
	mflo $s0
	#s0 = s0 +2
	addi $s0, $s0, 2
	#s0 = s0/5
	addi $t3,$0,5
	div $s0, $t3
	mflo $s0
	# v0 = s0 + Day
	lw $t0,8($sp)
	add $v0, $t0, $s0
	
	addi $t3,$0,365
	mult $s1, $t3
	mflo $t3
	
	add $v0, $v0, $t3
	
	
	addi $t3,$0,4
	div $s1, $t3
	mflo $t3
	
	add $v0, $v0, $t3
	
	
	addi $t3,$0,100
	div $s1, $t3
	mflo $t3
	
	sub $v0, $v0, $t3
	
	
	addi $t3,$0,400
	div $s1, $t3
	mflo $t3
	
	add $v0, $v0, $t3
	
	
	addi $v0, $v0, -32045
	
	addi $t3,$0,7
	div $v0, $t3
	mfhi $v0



	lw $s0, 24($sp)
	lw $s1, 20($sp)
	lw $ra, 16($sp)
	lw $a0, 12($sp)
	addi $sp, $sp, 28
	
	jr $ra
	
				
								
print_week_day:	
	sll $a0, $a0, 2
	la $t0, daysOfWeek
	add $t0, $t0, $a0
	lw $t0, ($t0)
	jr $t0

	# print result day of week
	t2:
		la $v0, monday
		jr $ra
		
	t3:
		la $v0, tuesday
		jr $ra
		
	t4:
		la $v0, wednesday
		jr $ra
		
	t5:
		la $v0, thursday
		jr $ra
		
	t6:
		la $v0, friday
		jr $ra
		
	t7:
		la $v0, saturday
		jr $ra
		
	cn:
		la $v0, sunday
		jr $ra

#####################################################
# char* Convert(char* TIME, char type)
# $a0: char* TIME
# $a1 : choose
# $v0 : char *newFormat
Convert:
	addi $sp, $sp, -20
	sw $ra, 16($sp)
	sw $a0, 12($sp)

	la $a2,strTmp
	# if (choose == 'A' ) = > Type A
	# if (choose == 'B' ) => Type B
	# if (choose == 'C' ) => Type C
	addi $t1, $0, 65	
	beq $a1, $t1, convertToTypeA
	addi $t1, $t1, 1
	beq $a1, $t1, convertToTypeB
	addi $t1, $t1, 1
	beq $a1, $t1, convertToTypeC
	addi $v1,$0,0
	j convertExit

convertToTypeA:
	addi $v1,$0,1
	# convert DD/MM/YYYY to MM/DD/YYYY

	# temp[0]=TIME[3]
	# temp[1]=TIME[4]
	# temp[3]=TIME[0]
	# temp[4]=TIME[1]

	lb $t1,0($a0)
	sb $t1,3($a2)

	lb $t1,1($a0)
	sb $t1,4($a2)

	lb $t1,3($a0)
	sb $t1,0($a2)

	lb $t1,4($a0)
	sb $t1,1($a2)
 ###########################
	lb $t1,2($a0)
	sb $t1,2($a2)

	addi $t2, $0, 5
	addi $t3, $0, 11
	## loop copy time[6] - > time[10]
LoopCvA:
	add $t0, $t2, $a0
	lb $t0, ($t0)
	add $t1, $t2, $a2
	sb $t0,($t1)
	addi $t2,$t2,1
	bne $t2,$t3, LoopCvA

	j convertExit

convertToTypeB:
	#         0123456789              
	# convert DD/MM/YYYY to  Month DD, YYYY
	addi $v1,$0,1
	jal Month
	add $s0,$0,$v0

	jal getMonthString
	sw $v0,4($sp)
	
	# Copy string from $v0 to $a2
	addi $t2, $0, 0

	lw $a0,4($sp)
	## loop copy string[0] - > string[leng-1]
LoopCvB:
	add $t0, $t2, $a0
	lb $t0, ($t0)
	beq $t0,$0, exitLoopCvB
	add $t1, $t2, $a2
	sb $t0,($t1)
	addi $t2,$t2,1
	#bne $t2,$t3, 
	j LoopCvB ## StringResult = "Month"
exitLoopCvB:	
	# t2 = lenth ($a2)
	# add 'Space'
	add $t1, $t2, $a2 
	addi $t0,$0,32
	sb $t0,($t1)
	addi $t2,$t2,1
	# add 'D'
	lw $a0,12($sp)
	add $t1, $t2, $a2
	lb $t0,0($a0)
	sb $t0,($t1)
	addi $t2,$t2,1	
	# add 'D'
	add $t1, $t2, $a2
	lb $t0,1($a0)
	sb $t0,($t1)
	addi $t2,$t2,1	
	# add ','
	add $t1, $t2, $a2
	addi $t0,$0,44
	sb $t0,($t1)
	addi $t2,$t2,1
	# add 'Space'
	add $t1, $t2, $a2
	addi $t0,$0,32
	sb $t0,($t1)
	addi $t2,$t2,1

	#appent TIME[6]-> TIME[10]
	lw $a0,12($sp) 

	addi $t4,$0,6
LoopCvB2:
	add $t5, $t4, $a0
	lb $t6,0($t5)
	beq $t6,$0, convertExit
	add $t1, $t2, $a2
	sb $t6,0($t1)
	addi $t2,$t2,1
	addi $t4,$t4,1

	j LoopCvB2 

	j convertExit


convertToTypeC:
	#         0123456789              
	# convert DD/MM/YYYY to  DD Month, YYYY
	addi $v1,$0,1
	# Add DD to result

	lb $t1,0($a0)
	sb $t1,0($a2)
	lb $t1,1($a0)
	sb $t1,1($a2)

	# Add 'Space' to result

	addi $t2,$0,2
	add $t1, $t2, $a2 
	addi $t0,$0,32
	sb $t0,($t1)
	addi $t2,$t2,1

	# Find String 'Month' to result
	jal Month
	add $s0,$0,$v0

	jal getMonthString
	sw $v0,4($sp)
	
	# Append from $v0 to $a2

	lw $a0,4($sp)
	# t2 = length of result
	# t4 = 0
	addi $t4,$0,0
LoopCvC:
	add $t5, $t4, $a0
	lb $t6,0($t5)
	beq $t6,$0, exitLoopCvC
	add $t1, $t2, $a2
	sb $t6,0($t1)
	addi $t2,$t2,1
	addi $t4,$t4,1

	j LoopCvC 
exitLoopCvC:
	# add ','
	add $t1, $t2, $a2
	addi $t0,$0,44
	sb $t0,($t1)
	addi $t2,$t2,1
	# add 'Space'
	add $t1, $t2, $a2
	addi $t0,$0,32
	sb $t0,($t1)
	addi $t2,$t2,1

	### copy to result : TIme[6] => Time[10]
	lw $a0,12($sp) 
	addi $t3, $0,11
	addi $t4,$0,6
	j LoopCvB2
convertExit:

	lw $ra, 16($sp)
	lw $a0, 12($sp)
	addi $sp, $sp, 20
	add $v0,$0,$a2
	jr $ra


###############################################
#char *getMonthString ( int month)
# $s0 : int month
# $v0 : month in string
getMonthString:

	# switch - case 
	addi $s0, $s0, -1
	sll $s0, $s0, 2
	la $t0, listMonth
	add $t0, $t0, $s0
	lw $t0, ($t0)
	jr $t0

m1:	
	la $v0,Jan

	j getMonthString_exit
m2:	
	la $v0,Feb

	j getMonthString_exit
m3:	
	la $v0,Mar

	j getMonthString_exit

m4:	
	la $v0,Apr

	j getMonthString_exit

m5:	
	la $v0,May
	j getMonthString_exit

m6:	
	la $v0,June

	j getMonthString_exit

m7:	
	la $v0,July
	j getMonthString_exit

m8:	
	la $v0,Aug
	j getMonthString_exit

m9:	
	la $v0,Sept
	j getMonthString_exit

m10:	
	la $v0,Oct
	j getMonthString_exit

m11:	
	la $v0,Nov
	j getMonthString_exit

m12:	
	la $v0,Dec

getMonthString_exit:

	jr $ra

#########################################################
# char* Date (int day, int month, int year, char* TIME)
#########################################################

Date:
	add $t1 , $0, 10
	div $a0, $t1
	mflo $t2
	mfhi $t3
	addi $t2, $t2, 48
	addi $t3, $t3, 48
	
	sb $t2, 0($a3)
	addi $a3, $a3, 1
	sb $t3, 0($a3)
	addi $a3, $a3, 1
	addi $t2, $0, 47
	sb $t2, 0($a3)
	addi $a3, $a3, 1
	
	div $a1, $t1
	mflo $t2
	mfhi $t3
	addi $t2, $t2, 48
	addi $t3, $t3, 48
	
	sb $t2, 0($a3)
	addi $a3, $a3, 1
	sb $t3, 0($a3)
	addi $a3, $a3, 1
	addi $t2, $0, 47
	sb $t2, 0($a3)
	addi $a3, $a3, 1
	
	addi $t4, $0, 1000
DateWhile: 
	slt $t5, $0, $t4
	beq $t5, $0, DateExit
	div $a2, $t4
	mflo $t2
	mfhi $a2
	addi $t2, $t2, 48
	sb $t2, 0($a3)
	addi $a3, $a3, 1
	addi $t5, $0, 10
	div $t4, $t5
	mflo $t4
	j DateWhile
DateExit: 
	sb $0, 0($a3)
	addi $a3, $a3, -10
	add $v0, $0, $a3
	jr $ra
	
##################################################
# bool logic_check(char* TIME)
#Kiem tra chuoi nhap vao co hop le logic 
##################################################
logic_check:
	addi $sp, $sp, -12
	sw $ra, 8($sp)
	#Check year >=1900
	jal Year
	add $t1,$0,$v0
	addi $t2,$0,1900
	slt $t3,$t1,$t2
	bne $t3,$0,logic_check_False
	# Check thang >= 1 va <= 12
	jal Month
	add $t1, $0, $v0
	addi $t2, $0, 1
	slt $t0, $t1, $t2
	bne $t0, $0, logic_check_False
	addi $t2, $0, 12
	slt $t0, $t2, $t1
	bne $t0, $0, logic_check_False
	sw $t1, 4($sp)
	
	# kiem tra ngay phu hop voi thang 
	jal Day
	add $t4, $0, $v0
	lw $t1, 4($sp)
	
	addi $t3, $0, 1			
	beq $t1, $t3, logic_check_31
	addi $t3, $0, 2		
	beq $t1, $t3, logic_check_month_2
	addi $t3, $0, 3
	beq $t1, $t3, logic_check_31
	addi $t3, $0, 4
	beq $t1, $t3, logic_check_30
	addi $t3, $0, 5
	beq $t1, $t3, logic_check_31
	addi $t3, $0, 6
	beq $t1, $t3, logic_check_30
	addi $t3, $0, 7
	beq $t1, $t3, logic_check_31
	addi $t3, $0, 8
	beq $t1, $t3, logic_check_31
	addi $t3, $0, 9
	beq $t1, $t3, logic_check_30
	addi $t3, $0, 10
	beq $t1, $t3, logic_check_31
	addi $t3, $0, 11
	beq $t1, $t3, logic_check_30
	addi $t3, $0, 12
	beq $t1, $t3, logic_check_31

logic_check_month_2:
	addi $t2, $0, 1
	slt $t0, $t4, $t2
	bne $t0, $0, logic_check_False
	addi $t2, $0, 29
	slt $t0, $t2, $t4
	bne $t0, $0, logic_check_False
	
	sw $t4, 0($sp)
	jal check_leap_year
	add $t5, $0, $v0
	lw $t4, 0($sp)
	
	addi $t2, $0, 29
	beq $t4, $t2, logic_check_month_2_leapYear
	j logic_check_True
logic_check_month_2_leapYear:
	beq $t5, $0, logic_check_False
	j logic_check_True	
logic_check_31:
	addi $t2, $0, 1
	slt $t0, $t4, $t2
	bne $t0, $0, logic_check_False
	addi $t2, $0, 31
	slt $t0, $t2, $t4
	bne $t0, $0, logic_check_False
	j logic_check_True
logic_check_30:
	addi $t2, $0, 1
	slt $t0, $t4, $t2
	bne $t0, $0, logic_check_False
	addi $t2, $0, 30
	slt $t0, $t2, $t4
	bne $t0, $0, logic_check_False
	
logic_check_True:
	addi $v0, $0, 1
	j logic_check_exit
logic_check_False:
	addi $v0, $0, 0
logic_check_exit:
	lw $ra, 8($sp)
	addi $sp, $sp , 12
	jr $ra
	

	

	
