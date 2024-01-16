#!/usr/bin/env python
#
# Script based off example on http://pexpect.readthedocs.io/en/stable/api/pxssh.html
#
# push ssh key to esxi 6.7 host

from pexpect import pxssh
import pexpect
import getpass

key_pub = " "

try:
    s = pxssh.pxssh()

    # prompt for hostname, username and password
    hostname = input('hostname: ')
    username = "root"
    password = getpass.getpass('password: ')


    print("Connecting to " +hostname+ "...") 
    s.login(hostname, username, password)

    # append authorized_keys file with public key
    print("appending authorized_keys file with public key to " +hostname+ "...") 
    append_authkey_cmd = ( "echo "+key_pub+" >> /etc/ssh/keys-root/authorized_keys" )
    
    s.sendline( append_authkey_cmd )
    s.prompt()
    print((s.before))

    # cat authorize_keys files
    cat_authkey_cmd = ( "cat /etc/ssh/keys-root/authorized_keys" )

    s.sendline( cat_authkey_cmd )
    s.prompt()
    print((s.before))
   
    # logout 
    s.logout()

except pxssh.ExceptionPxssh as e:
    print("pxssh failed on login.")
    print(e)

