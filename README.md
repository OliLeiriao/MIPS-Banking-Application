# MIPS Banking Application
# Built with the MARS MIPS Simulator
# By: Oliver L
# Fall 2020

# Created with the MARS MIPS Simulator: http://courses.missouristate.edu/kenvollmar/mars/
# For a class on computer systems, emphasizing register/memory exchange, arrays manipulation, MMIO, and ASCII value conversions. 
# Spent a lot of time on this, and so I thought I would share.

#################
# Functionality:
#################
#    * Open chequing and savings accounts with unique acc ID # (max 6 digits), and initial balances (NOTE: balances exceeding $1M start to get weird).
#    * Deposit balances into accounts.
#    * Withdraw from accounts (a 5% fee is charged when withdrawing from Savings accounts)
#    * Take out a loan (total account balances must be > $10,000 to qualify for a loan)
#    * Transfer balances between accounts (Transfers without a destination acc # are used for loan paybacks)
#    * Close accounts (balances will be transferred to other account type, else payoff outstanding loan balances, and residual closed balances are lost.
#    * After each command execution, the current bank summary is printed out in the format: [CH_ACC#, SAV_ACC#, CH_$BAL, SV_$BAL, LOAN_$BAL].
#    * Although the current bank summary is output after each command, there is a command that will output a desired account's current balance.
#    * A history of the previous 5 account transactions can also be outputted.
#    * The application ends running with the 'Quit' command.
    
    
################# 
# Startup:
#################
#    - Initial startup will require compiling code in the MARS simulator. 
#    - Open the KEYBOARD AND DISPLAY MMIO SIMULATOR (which can be found under /tools/). Be sure to "CONNECT TO MIPS" after compiling BUT BEFORE the running program.
#    - Once code is compiled and MMIO Simulator is connected, run the application.
#    - Output will appear in the standard I/O, however input should be made into the MMIO Simulator keyboard input field.

#################
# COMMANDS:
#################
#   NOTE: All commands must be formatted with spaces between arguments. (Ex. CH 12345 1000) Commands are executed upon an ENTER keypress.
#         Incorrectly formatted commands will result in an error message.
#   
#   QT                       ---> Quits program
#   CH (Acc#) ($Bal)         ---> Opens a chequing account, with the specified ID #, and with the specified starting Balance
#   SV (Acc#) ($Bal)         ---> Opens a savings account, with the specified ID #, and with the specified starting Balance
#   DE (Acc#) ($Bal)         ---> Deposits balance into specified account. If account DNE, throws error.
#   WT (Acc#) ($Bal)         ---> Withdraws balance from specified account. If account DNE, throws error. If withdrawn from savings, a 5% fee is also deducted.
#   LN ($Bal)                ---> Takes out a loan of the specified amount. Total sum of balances must exceed $10,000 to qualify for a loan.
#   TR (Acc#) (Acc#) ($Bal)  ---> Transfers balance from first acc specified to second. If no second acc# isn't specified, balance is deducted from loan.
#   CL (Acc#)                ---> Closes specified account. Balance is shifted to other account, if it exists, else pays off outstanding debt, otherwise is lost.
#   BL (Acc#)                ---> Prints out current bank balance of specified account. If account DNE, throws error.
#   QH (#[1-5])              ---> Prints out account history of last specified number of transactions (max 5). Ex. QH 3 prints out the last 3 transaction summaries.
#
########################################################################################
########################################################################################
########################################################################################
