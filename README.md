Reverse Shell
1) Execute Socket
2) Connect with socket from (1), ip and port here
3) dup2 to redirect stdin, stdout and stderr
4) execve to run shell

Bind Shell
1) Execute Socket
2) Bind addr with socket from (1), ip and port here
3) Listen the socket
4) Accept connection
5) dup2 to redirect stdin, stdout and stderr
6) execve to run shell


### assembly-shells

Repo of shells written in only assembly :(

#### macOS-Reverse-Shell.asm
macOS reverse shell for intel architecture. 
- Depending on the IP and port utilized this shellcode may be null-byte free. The IP address and port may introduce null-bytes depending on the values. By default the IP address is set to 127.0.0.1 which will result in (01 00 00 7f) introducing null-bytes. The default port is 4444 and does not introduce null-bytes.

##### How To Compile
```
$ nasm -f macho64 macOS-Reverse-Shell.asm
$ ld -L /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/lib -lSystem macOS-Reverse-Shell.o -o revshell
```

#### macOS-Bind-Shell.asm
Null-byte free macOS bind shell for intel architecture.
- Default IP = 127.0.0.1, Default Port = 4444

##### How To Compile
```
$ nasm -f macho64 macOS-Bind-Shell.asm
$ ld -L /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/lib -lSystem macOS-Bind-Shell.o -o bindshell
```

#### linux-x64-reverse-shell.asm
linux reverse shell
