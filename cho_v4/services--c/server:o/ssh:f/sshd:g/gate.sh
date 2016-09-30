#!/usr/bin/expect -f
set user  $env(USER) 
set timeout -1 

send_user -- "Server name: "
expect_user -re "(.*)\n"
send_user "\n"
set server $expect_out(1,string)


send_user -- "Login : "
expect_user -re "(.*)\n"
send_user "\n"
set login $expect_out(1,string)

stty -echo
send_user -- "Password: "
expect_user -re "(.*)\n"
send_user "\n"
stty echo
set password $expect_out(1,string)

spawn ssh $login@$server -p 1000 

match_max 100000 
expect {
-re "Are you sure you want to continue connecting (yes/no)?" 
	{ 
		send "yes\r" 
		expect "word:"
		send -- "$password\r"	
	}
-re "word:" {send -- "$password\r"}
}

send -- "\n"
interact 