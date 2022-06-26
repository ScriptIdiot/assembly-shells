#### assembly-shells

Repo of shells built in only assembly :(

##### macOS-Reverse-Shell.asm
macOS reverse shell for intel architecture. 
- Depending on the IP and port utilized this shellcode may be null-byte free. The IP address and port may introduce null-bytes depending on the values. By default the IP address is set to 127.0.0.1 which will result in (01 00 00 7f) introducing null-bytes. The defaul port is 4444 and does not introduce null-bytes.

**How To Compile**
```
nasm -f macho64 macOS-Reverse-Shell.asm
ld -L /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/lib -lSystem macOS-Reverse-Shell.o -o revshell
```

##### macOS-Bind-Shell.asm
macOS bind shell for intel architecture.

##### linux-x64-reverse-shell.asm
linux reverse shell

##### windows-position-independent-shellcode.asm
Windows position independent shellcode 
