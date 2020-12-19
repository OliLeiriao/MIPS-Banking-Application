# Oliver Leiriao
# 260784495
# COMP 273
# Assignment 4

			.data
bank_array: 		.word 0, 0, 0, 0, 0	# this array holds banking details
bank_history:		.word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

# Printing array stuff:
arr_start: 		.asciiz "["
arr_end: 		.asciiz "]\n"
arr_next: 		.asciiz ", "
str_newl:		.asciiz "\n"
str_dollar:		.asciiz "$"

# Error msg:
error_message:		.asciiz "\nThat is an invalid banking transaction. Please enter a valid one.\n"

# Welcome msg:
welcome_message: 	.asciiz "\n\nWelcome to OLI'S BANK"
command_message:	.asciiz "\nPlease Enter a Command: "

# Current Acc msg:
acc_str:		.asciiz "Current Account Overview: "

# goodbye message upon quitting
quit_message:		.asciiz "\n\tGoodbye.\n"

# Command Line:
current_command:	.space 50
instruction:		.space 10  # Stores chars inputted
acc_arg1:		.space 10  # Stores first inputted number
bal_arg1:		.space 10  # Stores second inputted string

# Commands
quit_command:		.asciiz "QT"
open_cheq_command:	.asciiz "CH"
open_sav_command:	.asciiz "SV"
deposit_command:	.asciiz "DE"
withdraw_command:	.asciiz "WT"
loan_command:		.asciiz "LN"
transfer_command:	.asciiz "TR"
close_command:		.asciiz "CL"
get_balance_command:	.asciiz "BL"
history_command:	.asciiz "QH"

			.text
main:
	# Print Welcome Message
	li $v0, 4
	la $a0, welcome_message
	syscall

command:
	# Print command message
	li $v0, 4
	la $a0, command_message
	syscall
	
	la $s0, current_command # load space to store command line string
	
command_loop:
	jal read		# Read char in
	add $a0, $v0, $0	# load read char as argument to be written
	jal write		# Write char out
	j command_loop		# Loop
	
instruction_check:
	la $a0, current_command
	jal copy_instruction		# instruction will hold the first 2 chars
					# to be compared against all options, otherwise error
	########################################################################
	# CH - OPEN CHEQUING
	########################################################################
	la $a0, instruction		# Load instruction
	la $a1, open_cheq_command	# Load command string
	jal compare_strings
	beq $v0, 1, open_account_c	# If comparison returns 1, matched!
	
	########################################################################
	# SV - OPEN SAVINGS
	########################################################################
	la $a0, instruction		# Load instruction
	la $a1, open_sav_command	# Load command string
	jal compare_strings
	beq $v0, 1, open_account_s	# If comparison returns 1, matched!
	
	########################################################################
	# DE - MAKE DEPOSIT
	########################################################################
	la $a0, instruction		# Load instruction
	la $a1, deposit_command		# Load command string
	jal compare_strings
	beq $v0, 1, deposit		# If comparison returns 1, matched!
	
	########################################################################
	# WT - MAKE WITHDRAWAL
	########################################################################
	la $a0, instruction		# Load instruction
	la $a1, withdraw_command	# Load command string
	jal compare_strings
	beq $v0, 1, withdraw		# If comparison returns 1, matched!
	
	########################################################################
	# LN - TAKE OUT LOAN
	########################################################################
	la $a0, instruction		# Load instruction
	la $a1, loan_command		# Load command string
	jal compare_strings
	beq $v0, 1, get_loan		# If comparison returns 1, matched!
	
	########################################################################
	# TR - TRANSFER
	########################################################################
	la $a0, instruction		# Load instruction
	la $a1, transfer_command	# Load command string
	jal compare_strings
	beq $v0, 1, transfer		# If comparison returns 1, matched!
	
	########################################################################
	# CL - CLOSE ACCOUNT
	########################################################################
	la $a0, instruction		# Load instruction
	la $a1, close_command		# Load command string
	jal compare_strings
	beq $v0, 1, close_acc		# If comparison returns 1, matched!
	
	########################################################################
	# BL - GET ACCOUNT BALANCE
	########################################################################
	la $a0, instruction		# Load instruction
	la $a1, get_balance_command	# Load command string
	jal compare_strings
	beq $v0, 1, get_balance		# If comparison returns 1, matched!
	
	########################################################################
	# QH - GET QUERY HISTORY
	########################################################################
	la $a0, instruction		# Load instruction
	la $a1, history_command		# Load command string
	jal compare_strings
	beq $v0, 1, get_history		# If comparison returns 1, matched!
	
	########################################################################
	# QT - QUIT
	########################################################################
	la $a0, instruction	# Load instruction
	la $a1, quit_command	# Load quit command string
	jal compare_strings
	beq $v0, 1, quit	# If comparison returns 1, matched!
	
	########################################################################
	# ERROR - Invalid Instruction
	########################################################################
	j instruction_error
	
########################################################################
# Q1.1 OPEN ACCOUNT
########################################################################
open_account:
open_account_c:
	la $a0, current_command # load current command line string
	
	addi $a0, $a0, 3	# Shift past instruction and space to acc #
	
	jal ascii_to_int	# convert acc # to int
	
	la $s1, bank_array
	sw $v0, 0($s1)		# store at word 1
	
	la $a0, current_command # Load current command
	addi $a0, $a0, 3	# increment to first string (acc #)
	jal next_str		# subroutine to read next string --> acc $
	add $a0, $v0, $0	# copy address to subsequent string (acc $)
	jal ascii_to_int	# convert acc $ to int
	
	la $s1, bank_array	
	sw $v0, 8($s1)		# store at word 3
	
	j print_array
	
open_account_s:
	la $a0, current_command # load current command line string
	
	addi $a0, $a0, 3	# Shift past instruction and space to acc #
	
	jal ascii_to_int	# convert acc # to int
	
	la $s1, bank_array
	sw $v0, 4($s1)		# store at word 2
	
	la $a0, current_command # Load current command
	addi $a0, $a0, 3	# increment to first string (acc #)
	jal next_str		# subroutine to read next string --> acc $
	add $a0, $v0, $0	# copy address to subsequent string (acc $)
	jal ascii_to_int	# convert acc $ to int
	
	la $s1, bank_array	
	sw $v0, 12($s1)		# store at word 4
	
	j print_array

########################################################################
# Q1.2 DEPOSIT
########################################################################
deposit:
	la $a0, current_command # load current command line string
	
	addi $a0, $a0, 3	# Shift past instruction and space to acc #
	
	jal ascii_to_int	# convert acc # to int
	
	la $s1, bank_array
	lw $t1, 0($s1)		# load chequing acc #
	lw $t2, 4($s1)		# load savings acc #
	
	beq $t1, $v0, dep_c
	beq $t2, $v0, dep_s
	
	j instruction_error	# If neither Savings nor chequing acc # matches, error thrown
	
dep_c:
	la $a0, current_command # Load current command
	addi $a0, $a0, 3	# increment to first string (acc #)
	jal next_str		# subroutine to read next string --> balance $ to deposit
	add $a0, $v0, $0	# copy address to subsequent string (deposit $)
	jal ascii_to_int	# convert deposit $ to int
	
	lw $t0, 8($s1)		# Load current chequing balance
	add $t0, $t0, $v0	# add deposit amount to chequing balance
	sw $t0, 8($s1)		# update chequing balance in bank array
	
	j print_array
	
dep_s:
	la $a0, current_command # Load current command
	addi $a0, $a0, 3	# increment to first string (acc #)
	jal next_str		# subroutine to read next string --> balance $ to deposit
	add $a0, $v0, $0	# copy address to subsequent string (deposit $)
	jal ascii_to_int	# convert deposit $ to int
	
	lw $t0, 12($s1)		# Load current sav balance
	add $t0, $t0, $v0	# add deposit amount to sav balance
	sw $t0, 12($s1)		# update sav balance in bank array
	
	j print_array
	
########################################################################
# Q1.2 WITHDRAW
########################################################################
withdraw:
	la $a0, current_command # load current command line string
	
	addi $a0, $a0, 3	# Shift past instruction and space to acc #
	
	jal ascii_to_int	# convert acc # to int
	
	la $s1, bank_array
	lw $t1, 0($s1)		# load chequing acc #
	lw $t2, 4($s1)		# load savings acc #
	
	beq $t1, $v0, withdraw_c
	beq $t2, $v0, withdraw_s
	
	j instruction_error	# If neither Savings nor chequing acc # matches, error thrown
	
withdraw_c:
	la $a0, current_command # Load current command
	addi $a0, $a0, 3	# increment to first string (acc #)
	jal next_str		# subroutine to read next string 
	add $a0, $v0, $0	# copy address to subsequent string (deposit $)
	jal ascii_to_int	# convert deposit $ to int
	
	lw $t0, 8($s1)		# Load current chequing balance
	
	# CASE: Withdraw amount > balance => error:
	slt $t1, $t0, $v0
	beq $t1, 1, instruction_error
	
	sub $t0, $t0, $v0	# subtract withdraw amount from chequing balance
	sw $t0, 8($s1)		# update chequing balance in bank array
	
	j print_array
	
withdraw_s:
	la $a0, current_command # Load current command
	addi $a0, $a0, 3	# increment to first string (acc #)
	jal next_str		# subroutine to read next string 
	add $a0, $v0, $0	# copy address to subsequent string (deposit $)
	jal ascii_to_int	# convert deposit $ to int
	
	lw $t0, 12($s1)		# Load current savings balance
	
	# CASE: Withdraw amount > balance => error:
	slt $t1, $t0, $v0
	beq $t1, 1, instruction_error
	
	# ASSUMPTION: 5% fee is rounded down to nearest int
	li $t2, 20		# $t2 = 20, since 5% == /20
	div $t3, $v0, $t2	# withdraw $ / 20 = 5% withdraw fee, stored in $t3
	
	# CASE: Withdraw amount + withdraw fee > balance => error:
	add $t4, $v0, $t3
	slt $t1, $t0, $t4
	beq $t1, 1, instruction_error
	
	sub $t0, $t0, $v0	# subtract withdraw amount from sav balance
	sub $t0, $t0, $t3	# subtract withdraw fee
	sw $t0, 12($s1)		# update saving balance in bank array
	
	j print_array

########################################################################
# Q1.2 GET LOAN
########################################################################
get_loan:
	la $s1, bank_array
	lw $t1, 8($s1)		# load chequing acc $
	lw $t2, 12($s1)		# load savings acc $
	add $s2, $t1, $t2	# TOTAL BALANCE stored in $s2
	
	li $t3, 10000
	slt $t4, $s2, $t3
	beq $t4, 1, instruction_error	# if Total balance < 10,000, error
	
	la $a0, current_command # load current command line string
	addi $a0, $a0, 3	# Shift past instruction and space to acc #
	jal ascii_to_int	# convert acc # to int
	add $t5, $v0, $0	# save loan $ to $t5
	
	# $v0 now holds loan amount
	
	li $t3, 2
	div $s2, $s2, $t3	# Total Balance/2 
	
	slt $t4, $s2, $t5	# if Total balance/2 < loan $, error
	beq $t4, 1, instruction_error
	
	# Since loan has passed tests, add it to bank array:
	sw $t5, 16($s1)
	
	j print_array
	
########################################################################
# Q1.2 TRANSFER FUNDS
########################################################################
transfer:
	la $a0, current_command # Load current command
	addi $a0, $a0, 3	# increment to first string (acc #)
	jal ascii_to_int	# convert deposit $ to int
	
	la $s1, bank_array
	lw $t1, 0($s1)		# load chequing acc #
	lw $t2, 4($s1)		# load savings acc #
	
	seq $t3, $t1, $v0	# If first entry matches chequing acc #
	beq $t3, 1, transfer_c	# transfer from chequing
	
	seq $t3, $t2, $v0	# If first entry matches savings acc #
	beq $t3, 1, transfer_s	# transfer from savings
	
	j instruction_error	# Else, error

transfer_c:
	la $a0, current_command # Load current command
	addi $a0, $a0, 3	# increment to first string (acc #)
	jal next_str		# subroutine to read next string 
	add $a0, $v0, $0	# copy address to subsequent string (deposit $)
	jal ascii_to_int	# convert deposit $ to int
	
	la $s1, bank_array
	lw $t1, 4($s1)		# load savings acc #
	
	beq $t1, $v0, transfer_c_s	# if second input was savings acc #, transfer to savings
	
	# Else, loan payback:
	lw $t1, 8($s1)		# load chequing balance
	slt $t0, $t1, $v0	# if payback amount exceeds account balance
	beq $t0, 1, instruction_error
	
	sub $t1, $t1, $v0	# Chequing Balance = Cheq Bal - Payed $
	sw $t1, 8($s1)
	
	lw $t2, 16($s1)		# load loan balance
	sub $t2, $t2, $v0	# Loan Balance = Loan Balance - payed $
	sw $t2, 16($s1)		# Store update loan balance	
	
	j print_array
	
transfer_c_s:
	la $a0, current_command # Load current command
	addi $a0, $a0, 3	# increment to first string (acc #)
	jal next_str		# subroutine to read next string
	add $a0, $v0, $0	# copy address to subsequent string (deposit $)
	jal next_str		
	add $a0, $v0, $0
	jal ascii_to_int	# convert deposit $ to int
	
	la $s1, bank_array
	lw $t1, 8($s1)		# load chequing acc $
	lw $t2, 12($s1)		# load savings acc $
	
	sub $t1, $t1, $v0	# Cheq bal = cheq bal - transfer $
	sw $t1, 8($s1)		# update cheq balance
	
	add $t2, $t2, $v0	# Sav bal = sav bal + transfer $
	sw $t2, 12($s1)		# update sav balance
	
	j print_array
	
transfer_s:
	la $a0, current_command # Load current command
	addi $a0, $a0, 3	# increment to first string (acc #)
	jal next_str		# subroutine to read next string 
	add $a0, $v0, $0	# copy address to subsequent string (deposit $)
	jal ascii_to_int	# convert deposit $ to int
	
	la $s1, bank_array
	lw $t1, 0($s1)		# load cheq acc #
	
	beq $t1, $v0, transfer_s_c	# if second input was savings acc #, transfer to cheq
	
	# Else, loan payback:
	lw $t1, 12($s1)		# load savings balance
	slt $t0, $t1, $v0	# if payback amount exceeds account balance
	beq $t0, 1, instruction_error
	
	sub $t1, $t1, $v0	# sav Balance = sav Bal - Payed $
	sw $t1, 12($s1)
	
	lw $t2, 16($s1)		# load loan balance
	sub $t2, $t2, $v0	# Loan Balance = Loan Balance - payed $
	sw $t2, 16($s1)		# Store update loan balance	
	
	j print_array
	
transfer_s_c:
	la $a0, current_command # Load current command
	addi $a0, $a0, 3	# increment to first string (acc #)
	jal next_str		# subroutine to read next string
	add $a0, $v0, $0	# copy address to subsequent string (deposit $)
	jal next_str		
	add $a0, $v0, $0
	jal ascii_to_int	# convert deposit $ to int
	
	la $s1, bank_array
	lw $t1, 8($s1)		# load chequing acc $
	lw $t2, 12($s1)		# load savings acc $
	
	sub $t2, $t2, $v0	# Sav bal = sav bal - transfer $
	sw $t2, 12($s1)		# update sav balance
	
	add $t1, $t1, $v0	# Cheq bal = cheq bal + transfer $
	sw $t1, 8($s1)		# update cheq balance
	
	j print_array		

########################################################################
# Q1.2 CLOSE ACCOUNT
########################################################################
close_acc:
	la $a0, current_command # Load current command
	addi $a0, $a0, 3	# increment to first string (acc #)
	jal ascii_to_int	# convert deposit $ to int
	
	la $s1, bank_array
	lw $t1, 0($s1)		# load chequing acc #
	lw $t2, 4($s1)		# load savings acc #
	
	beq $t1, $v0, close_c
	beq $t2, $v0, close_s
	
	j instruction_error
	
close_c:
	beq $t2, 0, close_loan_c # if savings acc # = 0, funds go to pay off debt
	lw $t3, 8($s1)		# Load Cheq $
	lw $t4, 12($s1)		# Load Sav $
	
	add $t4, $t4, $t3	# Sav $ = Sav $ + Cheq $
	sw $t4, 12($s1)		# store updated savings balance
	
	sw $0, 8($s1)		# clear chequing balance
	sw $0, 0($s1)		# clear chequing acc #
	
	j close_done
	
close_s:
	beq $t1, 0, close_loan_s # if chequing acc # = 0, funds go to pay off debt
	lw $t3, 8($s1)		# Load Cheq $
	lw $t4, 12($s1)		# Load Sav $
	
	add $t3, $t3, $t4	# Cheq $ = Cheq $ + Sav $
	sw $t3, 8($s1)		# store updated savings balance
	
	sw $0, 12($s1)		# clear sav balance
	sw $0, 4($s1)		# clear sav acc #
	
	j close_done

close_loan_c:
	lw $t3, 8($s1)		# Load cheq $
	lw $t4, 16($s1)		# Load loan Balance $
	beq $t4, 0, close_done	# IF loan bal is $0, lose the balance
	slt $t5, $t4, $t3	# If Loan balance < acc balance
	beq $t5, 1, close_clear_c
	
	sub $t4, $t4, $t3	# loan balance = loan bal - cheq balance
	sw $t4, 16($s1)
	
	sw $0, 0($s1)		# reset cheq acc #
	sw $0, 8($s1)		# reset cheq acc $
	
	j close_done
	
close_loan_s:
	lw $t3, 12($s1)		# Load sav $
	lw $t4, 16($s1)		# Load loan Balance $
	slt $t5, $t4, $t3	# If Loan balance < acc balance
	beq $t5, 1, close_clear_s
	
	sub $t4, $t4, $t3	# loan balance = loan bal - sav balance
	sw $t4, 16($s1)
	
	sw $0, 4($s1)		# reset sav acc #
	sw $0, 12($s1)		# reset sav acc $
	
	j close_done
	
close_clear_c:
	sw $0, 16($s1)		# wipe debt
	sw $0, 0($s1)		# reset cheq acc #
	sw $0, 8($s1)		# reset cheq acc $
	j close_done

close_clear_s:
	sw $0, 16($s1)		# wipe debt
	sw $0, 4($s1)		# reset sav acc #
	sw $0, 12($s1)		# reset sav acc $
	j close_done
	
close_done:
	j print_array
	
########################################################################
# Q1.3 GET BALANCE
########################################################################
get_balance:
	la $a0, current_command # Load current command
	addi $a0, $a0, 3	# increment to first string (acc #)
	jal ascii_to_int	# convert deposit $ to int
	
	la $s1, bank_array
	lw $t1, 0($s1)		# load chequing acc #
	lw $t2, 4($s1)		# load savings acc #
	
	beq $t1, $v0, get_bal_c
	beq $t2, $v0, get_bal_s
	
	j instruction_error
	
get_bal_c:
	lw $t3, 8($s1)		# load acc balance
	
	li $v0, 4
	la $a0, str_newl
	syscall
	
	li $v0, 4
	la $a0, str_newl
	syscall
	
	li $v0, 4		# print "$"
	la $a0, str_dollar
	syscall
	
	li $v0, 1		# print balance
	add $a0, $t3, $0	# Load balance into a0
	syscall
	
	j print_array

get_bal_s:
	lw $t3, 12($s1)		# load acc balance
	
	li $v0, 4
	la $a0, str_newl
	syscall
	
	li $v0, 4
	la $a0, str_newl
	syscall
	
	li $v0, 4		# print "$"
	la $a0, str_dollar
	syscall
	
	li $v0, 1
	add $a0, $t3, $0	# Load balance into a0
	syscall
	
	j print_array
	
########################################################################
# Q1.3 GET HISTORY
########################################################################
get_history:
	li $v0, 4
	la $a0, str_newl
	syscall
	
	la $a0, current_command # Load current command
	addi $a0, $a0, 3	# increment to first string (acc #)
	jal ascii_to_int	# convert deposit $ to int
	
	li $t0, 5
	
	slt $t1, $t0, $v0	# If input > 5, error
	beq $t1, 1, instruction_error
	
	la $s0, bank_history
	
	li $t0, 0		# Initialize counter
	add $s1, $v0, $0	# Save desire number of line to $s1
	

get_history_line_l:
	beq $t0, $s1, get_history_done
	
	li $v0, 4		# Prints "["
	la $a0, arr_start
	syscall
	
	li $t9, 0		# Initialize counter
	
get_history_print_l:
	beq $t9, 5, get_history_done_line
				# Loop
	li $v0, 1		# Print int
	lw $a0, ($s0)		# load current element
	syscall
	
	li $v0, 4		# Prints ", "
	la $a0, arr_next
	syscall
	
	addi $t9, $t9, 1	# Increment counter ++
	addi $s0, $s0, 4	# Iterate to next word in array
	
	j get_history_print_l	# Loops
	
get_history_done_line:
	li $v0, 4		# Prints "]"
	la $a0, arr_end
	syscall
	
	addi $t0, $t0, 1
	
	j get_history_line_l
	
get_history_done:

	li $v0, 4
	la $a0, str_newl
	syscall
	
	j command
	

########################################################################
# Q1.4 QUIT
########################################################################
quit:
	li $v0, 4		# Print goodbye message
	la $a0, quit_message
	syscall
	
	li $v0,10		# End program
	syscall

########################################################################
########################################################################
########################################################################
########################################################################
########################################################################
########################################################################
########################################################################

# Case for error detected
instruction_error:
	li $v0, 4
	la $a0, error_message
	syscall
	
	j command	# Loop back to receive command
	

########################################################################
########################################################################
	
# Log current bank history into 5x5 array * UPDATES AFTER EVERY COMMAND EXCEPT QUERIES *
log_history:
	# bank_history is a 5x5 array
	# OFFSETS: 0  4  8  12 16
	# 	   20 24 28 32 36
	# 	   40 44 48 52 56
	#	   60 64 68 72 76
	# 	   80 84 88 92 96
	
	la $s0, bank_history
	
	add $s0, $s0, 60	# shift to second last row
	li $t9, 0		# Initialize counter
log_history_l:
	addi $t9, $t9, 1	# increment counter ++
	beq $t9, 5, log_history_done
	
	lw $t0, 0($s0)		# Load element [i,0]
	lw $t1, 4($s0)		# Load element [i,1]
	lw $t2, 8($s0)		# Load element [i,2]
	lw $t3, 12($s0)		# Load element [i,3]
	lw $t4, 16($s0)		# Load element [i,4]
	
	sw $t0, 20($s0)		# Store element at [i+1,0]
	sw $t1, 24($s0)		# Store element at [i+1,1]
	sw $t2, 28($s0)		# Store element at [i+1,2]
	sw $t3, 32($s0)		# Store element at [i+1,3]
	sw $t4, 36($s0)		# Store element at [i+1,4]
	
	sub $s0, $s0, 20	# shift to next row down, loop
	j log_history_l
	
log_history_done:
	# Finally, store most previous bank_array into first row
	la $s0, bank_history
	la $s1, bank_array
	
	lw $t0, 0($s1)		
	lw $t1, 4($s1)		
	lw $t2, 8($s1)		
	lw $t3, 12($s1)		
	lw $t4, 16($s1)		
	
	sw $t0, 0($s0)		
	sw $t1, 4($s0)		
	sw $t2, 8($s0)		
	sw $t3, 12($s0)		
	sw $t4, 16($s0)		
	
	j command
	
###############################################
###############################################
###############################################

	  # OTHER SUBROUTINES #

###############################################
###############################################	
# NEXT STRING AFTER SPACE
###############################################
###############################################
next_str:
	# $a0 contains address of current string, ending in space
	add $t1, $a0, $0	# copy string's address	
	lb $t0, ($t1)		# Load character from string
next_str_l:
	beq $t0, ' ', next_str_done	# if space is reached, return string
	addi $t1, $t1, 1	# iterate to next address
	lb $t0, ($t1)		# load next char
	j next_str_l
next_str_done: 
	# returns pointer to next space in memory, skips space
	add $v0, $t1, $0
	addi $v0, $v0, 1	# Skips space position
	jr $ra
	
###############################################
###############################################
###############################################

###############################################
###############################################
# COPY INSTRUCTION
###############################################
###############################################
copy_instruction:
	# a0 contains current command string address
	# need to copy first 2 chars to instruction space in memory
	la $t0, instruction
	li $t1, 0		# Initialize counter = 0
copy_instruction_l:
	beq $t1, 2, copy_instruction_done	# once 2 chars have been copied, done
	lb $t2, 0($a0)		# Load first char
	sb $t2, 0($t0)		# store second char in instruction memory
	
	addi $a0, $a0, 1	# increment command line ++
	addi $t0, $t0, 1	# increment instruction ++
	addi $t1, $t1, 1	# increment counter ++
	
	j copy_instruction_l

copy_instruction_done:
	jr $ra

###############################################
###############################################
# ASCII TO INT CONVERTER
###############################################
###############################################
ascii_to_int:
	# $a0 contains address to string to be converted
	add $v0, $0, $0		# Sum = 0
	addi $t0, $0, 10 	# Use to 10 to multiply base
	
	lb $t1, 0($a0)		#load byte from $a0
	beq $t1, $0, ascii_done # null byte = end of string
	
ascii_loop:
	addi $t1, $t1, -48	# string # - 48 = int equivalent
	
	add $v0, $v0, $t1	# add to sum
	
	addi $a0, $a0, 1	#increment to next char in string ++
	lb $t1, 0($a0)		# load next char
	beq $t1,$0, ascii_done  # null byte = end of string
	beq $t1, ' ', ascii_done # space = end of string
	beq $t1, '\n', ascii_done # CR = end of string 
	
	mul $v0, $v0, $t0	# multiply x10 to fix base
	
	j ascii_loop

ascii_done:
	jr $ra	

###############################################
###############################################
###############################################


###############################################
###############################################
# PRINT BANK ARRAY
###############################################
###############################################
print_array:
	li $v0, 4
	la $a0, str_newl
	syscall
	
	li $v0, 4
	la $a0, str_newl
	syscall
	
	li $v0, 4
	la $a0, acc_str
	syscall
	
	la $t0, bank_array
	addi $t1, $0, 0		# $t1 counts to 4 (for each cell in bankarray)
	
	li $v0, 4		# Prints "["
	la $a0, arr_start
	syscall
	
print_arr_l:			# Loop
	li $v0, 1		# Print int
	lw $a0, ($t0)		# load current element
	syscall
	
	beq $t1, 4, print_arr_done
	
	li $v0, 4		# Prints ", "
	la $a0, arr_next
	syscall
	
	addi $t1, $t1, 1	# Iterate counter
	addi $t0, $t0, 4	# Iterate to next word in array
	
	j print_arr_l		# Loops
	
print_arr_done:
	li $v0, 4		# Prints "]"
	la $a0, arr_end
	syscall
	
	j log_history
	
###############################################
###############################################
###############################################

###############################################
# COMPARE 2 STRINGS
###############################################
# $a0 contains address of first string, $a1 contains address to second string
compare_strings:
	li $v0, 0		# Returns 1 if strings are equal, 0 elsewise
compare_strings_l:
	lb $t0, ($a0)		# Load char from first string
	lb $t1, ($a1)		# Load char from second string
	add $a0, $a0, 1		# Increment to next char in fist string
	add $a1, $a1, 1		# Increment to next char in second string
	
	bne $t0, $t1, compare_strings_false	# if they are ever not equal, return 0
	beqz $t0, compare_strings_true	# if End of string is reached, return true
	
	j compare_strings_l
	
compare_strings_false:
	jr $ra	# returns 0
	
compare_strings_true:
	li $v0, 1
	jr $ra	# returns 1

###############################################
###############################################


###############################################
###############################################
# MMIO INTERACTION
###############################################
###############################################

# SUBROUTINES FOR MMIO INTERACTION
read:
	# Read Input
	lui $t0, 0xffff		# Load signal address 0xffff0000
read_ready:
	lw $t1, 0($t0)		# Load word from signal address
	andi $t1, $t1, 0x0001	# Control bit
	beqz $t1, read_ready	# Check Ready bit
	lw $v0, 4($t0)		# Load contents at subsequent address
	sb $v0, 0($s0)		# store current char in command line memory
	
	beq $v0, 0xa, instruction_check # If CR is read, begin instruction check
	addi $s0, $s0, 1	# increment to next space in command line memory
	jr $ra
	
write:
	# Write Input
	lui $t0, 0xffff		# Load signal address 0xffff0000
write_ready:
	lw $t1, 8($t0)		# Load word from signal address
	andi $t1, $t1, 0x0001	# Control bit
	beqz $t1, write_ready	# Check Ready bit
	sw $a0, 12($t0)		# Store contents at subsequent address
	
	li $v0, 11		# Print char to normal MMIO
	syscall
	
	jr $ra

###############################################
###############################################
