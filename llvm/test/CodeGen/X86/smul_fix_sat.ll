; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-linux | FileCheck %s --check-prefix=X64
; RUN: llc < %s -mtriple=i686 -mattr=cmov | FileCheck %s --check-prefix=X86

declare  i4  @llvm.smul.fix.sat.i4   (i4,  i4, i32)
declare  i32 @llvm.smul.fix.sat.i32  (i32, i32, i32)
declare  i64 @llvm.smul.fix.sat.i64  (i64, i64, i32)
declare  <4 x i32> @llvm.smul.fix.sat.v4i32(<4 x i32>, <4 x i32>, i32)

define i32 @func(i32 %x, i32 %y) nounwind {
; X64-LABEL: func:
; X64:       # %bb.0:
; X64-NEXT:    movslq %esi, %rax
; X64-NEXT:    movslq %edi, %rcx
; X64-NEXT:    imulq %rax, %rcx
; X64-NEXT:    movq %rcx, %rax
; X64-NEXT:    shrq $32, %rax
; X64-NEXT:    shrdl $2, %eax, %ecx
; X64-NEXT:    cmpl $1, %eax
; X64-NEXT:    movl $2147483647, %edx # imm = 0x7FFFFFFF
; X64-NEXT:    cmovlel %ecx, %edx
; X64-NEXT:    cmpl $-2, %eax
; X64-NEXT:    movl $-2147483648, %eax # imm = 0x80000000
; X64-NEXT:    cmovgel %edx, %eax
; X64-NEXT:    retq
;
; X86-LABEL: func:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    imull {{[0-9]+}}(%esp)
; X86-NEXT:    shrdl $2, %edx, %eax
; X86-NEXT:    cmpl $1, %edx
; X86-NEXT:    movl $2147483647, %ecx # imm = 0x7FFFFFFF
; X86-NEXT:    cmovgl %ecx, %eax
; X86-NEXT:    cmpl $-2, %edx
; X86-NEXT:    movl $-2147483648, %ecx # imm = 0x80000000
; X86-NEXT:    cmovll %ecx, %eax
; X86-NEXT:    retl
  %tmp = call i32 @llvm.smul.fix.sat.i32(i32 %x, i32 %y, i32 2)
  ret i32 %tmp
}

define i64 @func2(i64 %x, i64 %y) nounwind {
; X64-LABEL: func2:
; X64:       # %bb.0:
; X64-NEXT:    movq %rdi, %rax
; X64-NEXT:    imulq %rsi
; X64-NEXT:    shrdq $2, %rdx, %rax
; X64-NEXT:    cmpq $1, %rdx
; X64-NEXT:    movabsq $9223372036854775807, %rcx # imm = 0x7FFFFFFFFFFFFFFF
; X64-NEXT:    cmovgq %rcx, %rax
; X64-NEXT:    cmpq $-2, %rdx
; X64-NEXT:    movabsq $-9223372036854775808, %rcx # imm = 0x8000000000000000
; X64-NEXT:    cmovlq %rcx, %rax
; X64-NEXT:    retq
;
; X86-LABEL: func2:
; X86:       # %bb.0:
; X86-NEXT:    pushl %ebp
; X86-NEXT:    pushl %ebx
; X86-NEXT:    pushl %edi
; X86-NEXT:    pushl %esi
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %esi
; X86-NEXT:    movl %ecx, %eax
; X86-NEXT:    mull %esi
; X86-NEXT:    movl %edx, %edi
; X86-NEXT:    movl %eax, %ebx
; X86-NEXT:    movl %ecx, %eax
; X86-NEXT:    mull {{[0-9]+}}(%esp)
; X86-NEXT:    movl %eax, %ecx
; X86-NEXT:    movl %edx, %ebp
; X86-NEXT:    addl %ebx, %ebp
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    adcl $0, %edi
; X86-NEXT:    imull %esi
; X86-NEXT:    movl %edx, %esi
; X86-NEXT:    movl %eax, %ebx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    mull {{[0-9]+}}(%esp)
; X86-NEXT:    addl %ebp, %eax
; X86-NEXT:    adcl %edi, %edx
; X86-NEXT:    adcl $0, %esi
; X86-NEXT:    addl %ebx, %edx
; X86-NEXT:    adcl $0, %esi
; X86-NEXT:    movl %edx, %edi
; X86-NEXT:    subl {{[0-9]+}}(%esp), %edi
; X86-NEXT:    movl %esi, %ebx
; X86-NEXT:    sbbl $0, %ebx
; X86-NEXT:    cmpl $0, {{[0-9]+}}(%esp)
; X86-NEXT:    cmovnsl %esi, %ebx
; X86-NEXT:    cmovnsl %edx, %edi
; X86-NEXT:    movl %edi, %ebp
; X86-NEXT:    subl {{[0-9]+}}(%esp), %ebp
; X86-NEXT:    movl %ebx, %esi
; X86-NEXT:    sbbl $0, %esi
; X86-NEXT:    cmpl $0, {{[0-9]+}}(%esp)
; X86-NEXT:    cmovnsl %ebx, %esi
; X86-NEXT:    cmovnsl %edi, %ebp
; X86-NEXT:    testl %esi, %esi
; X86-NEXT:    setg %bl
; X86-NEXT:    sete %bh
; X86-NEXT:    cmpl $1, %ebp
; X86-NEXT:    seta %dl
; X86-NEXT:    andb %bh, %dl
; X86-NEXT:    orb %bl, %dl
; X86-NEXT:    shrdl $2, %eax, %ecx
; X86-NEXT:    shrdl $2, %ebp, %eax
; X86-NEXT:    testb %dl, %dl
; X86-NEXT:    movl $2147483647, %edi # imm = 0x7FFFFFFF
; X86-NEXT:    cmovel %eax, %edi
; X86-NEXT:    movl $-1, %eax
; X86-NEXT:    cmovnel %eax, %ecx
; X86-NEXT:    cmpl $-1, %esi
; X86-NEXT:    setl %al
; X86-NEXT:    sete %dl
; X86-NEXT:    cmpl $-2, %ebp
; X86-NEXT:    setb %ah
; X86-NEXT:    andb %dl, %ah
; X86-NEXT:    xorl %edx, %edx
; X86-NEXT:    orb %al, %ah
; X86-NEXT:    cmovnel %edx, %ecx
; X86-NEXT:    movl $-2147483648, %edx # imm = 0x80000000
; X86-NEXT:    cmovel %edi, %edx
; X86-NEXT:    movl %ecx, %eax
; X86-NEXT:    popl %esi
; X86-NEXT:    popl %edi
; X86-NEXT:    popl %ebx
; X86-NEXT:    popl %ebp
; X86-NEXT:    retl
  %tmp = call i64 @llvm.smul.fix.sat.i64(i64 %x, i64 %y, i32 2)
  ret i64 %tmp
}

define i4 @func3(i4 %x, i4 %y) nounwind {
; X64-LABEL: func3:
; X64:       # %bb.0:
; X64-NEXT:    shlb $4, %sil
; X64-NEXT:    sarb $4, %sil
; X64-NEXT:    shlb $4, %dil
; X64-NEXT:    movsbl %dil, %eax
; X64-NEXT:    movsbl %sil, %ecx
; X64-NEXT:    imull %eax, %ecx
; X64-NEXT:    movl %ecx, %eax
; X64-NEXT:    shrb $2, %al
; X64-NEXT:    shrl $8, %ecx
; X64-NEXT:    movl %ecx, %edx
; X64-NEXT:    shlb $6, %dl
; X64-NEXT:    orb %al, %dl
; X64-NEXT:    movzbl %dl, %eax
; X64-NEXT:    cmpb $1, %cl
; X64-NEXT:    movl $127, %edx
; X64-NEXT:    cmovlel %eax, %edx
; X64-NEXT:    cmpb $-2, %cl
; X64-NEXT:    movl $128, %eax
; X64-NEXT:    cmovgel %edx, %eax
; X64-NEXT:    sarb $4, %al
; X64-NEXT:    # kill: def $al killed $al killed $eax
; X64-NEXT:    retq
;
; X86-LABEL: func3:
; X86:       # %bb.0:
; X86-NEXT:    movb {{[0-9]+}}(%esp), %al
; X86-NEXT:    shlb $4, %al
; X86-NEXT:    sarb $4, %al
; X86-NEXT:    movb {{[0-9]+}}(%esp), %cl
; X86-NEXT:    shlb $4, %cl
; X86-NEXT:    movsbl %cl, %ecx
; X86-NEXT:    movsbl %al, %eax
; X86-NEXT:    imull %ecx, %eax
; X86-NEXT:    movb %ah, %cl
; X86-NEXT:    shlb $6, %cl
; X86-NEXT:    shrb $2, %al
; X86-NEXT:    orb %cl, %al
; X86-NEXT:    movzbl %al, %ecx
; X86-NEXT:    cmpb $1, %ah
; X86-NEXT:    movl $127, %edx
; X86-NEXT:    cmovlel %ecx, %edx
; X86-NEXT:    cmpb $-2, %ah
; X86-NEXT:    movl $128, %eax
; X86-NEXT:    cmovgel %edx, %eax
; X86-NEXT:    sarb $4, %al
; X86-NEXT:    # kill: def $al killed $al killed $eax
; X86-NEXT:    retl
  %tmp = call i4 @llvm.smul.fix.sat.i4(i4 %x, i4 %y, i32 2)
  ret i4 %tmp
}

define <4 x i32> @vec(<4 x i32> %x, <4 x i32> %y) nounwind {
; X64-LABEL: vec:
; X64:       # %bb.0:
; X64-NEXT:    pshufd {{.*#+}} xmm2 = xmm1[3,1,2,3]
; X64-NEXT:    movd %xmm2, %eax
; X64-NEXT:    cltq
; X64-NEXT:    pshufd {{.*#+}} xmm2 = xmm0[3,1,2,3]
; X64-NEXT:    movd %xmm2, %ecx
; X64-NEXT:    movslq %ecx, %rdx
; X64-NEXT:    imulq %rax, %rdx
; X64-NEXT:    movq %rdx, %rcx
; X64-NEXT:    shrq $32, %rcx
; X64-NEXT:    shrdl $2, %ecx, %edx
; X64-NEXT:    cmpl $1, %ecx
; X64-NEXT:    movl $2147483647, %eax # imm = 0x7FFFFFFF
; X64-NEXT:    cmovgl %eax, %edx
; X64-NEXT:    cmpl $-2, %ecx
; X64-NEXT:    movl $-2147483648, %ecx # imm = 0x80000000
; X64-NEXT:    cmovll %ecx, %edx
; X64-NEXT:    movd %edx, %xmm2
; X64-NEXT:    pshufd {{.*#+}} xmm3 = xmm1[2,3,2,3]
; X64-NEXT:    movd %xmm3, %edx
; X64-NEXT:    movslq %edx, %rdx
; X64-NEXT:    pshufd {{.*#+}} xmm3 = xmm0[2,3,2,3]
; X64-NEXT:    movd %xmm3, %esi
; X64-NEXT:    movslq %esi, %rsi
; X64-NEXT:    imulq %rdx, %rsi
; X64-NEXT:    movq %rsi, %rdx
; X64-NEXT:    shrq $32, %rdx
; X64-NEXT:    shrdl $2, %edx, %esi
; X64-NEXT:    cmpl $1, %edx
; X64-NEXT:    cmovgl %eax, %esi
; X64-NEXT:    cmpl $-2, %edx
; X64-NEXT:    cmovll %ecx, %esi
; X64-NEXT:    movd %esi, %xmm3
; X64-NEXT:    punpckldq {{.*#+}} xmm3 = xmm3[0],xmm2[0],xmm3[1],xmm2[1]
; X64-NEXT:    movd %xmm1, %edx
; X64-NEXT:    movslq %edx, %rdx
; X64-NEXT:    movd %xmm0, %esi
; X64-NEXT:    movslq %esi, %rsi
; X64-NEXT:    imulq %rdx, %rsi
; X64-NEXT:    movq %rsi, %rdx
; X64-NEXT:    shrq $32, %rdx
; X64-NEXT:    shrdl $2, %edx, %esi
; X64-NEXT:    cmpl $1, %edx
; X64-NEXT:    cmovgl %eax, %esi
; X64-NEXT:    cmpl $-2, %edx
; X64-NEXT:    cmovll %ecx, %esi
; X64-NEXT:    movd %esi, %xmm2
; X64-NEXT:    pshufd {{.*#+}} xmm1 = xmm1[1,1,2,3]
; X64-NEXT:    movd %xmm1, %edx
; X64-NEXT:    movslq %edx, %rdx
; X64-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[1,1,2,3]
; X64-NEXT:    movd %xmm0, %esi
; X64-NEXT:    movslq %esi, %rsi
; X64-NEXT:    imulq %rdx, %rsi
; X64-NEXT:    movq %rsi, %rdx
; X64-NEXT:    shrq $32, %rdx
; X64-NEXT:    shrdl $2, %edx, %esi
; X64-NEXT:    cmpl $1, %edx
; X64-NEXT:    cmovgl %eax, %esi
; X64-NEXT:    cmpl $-2, %edx
; X64-NEXT:    cmovll %ecx, %esi
; X64-NEXT:    movd %esi, %xmm0
; X64-NEXT:    punpckldq {{.*#+}} xmm2 = xmm2[0],xmm0[0],xmm2[1],xmm0[1]
; X64-NEXT:    punpcklqdq {{.*#+}} xmm2 = xmm2[0],xmm3[0]
; X64-NEXT:    movdqa %xmm2, %xmm0
; X64-NEXT:    retq
;
; X86-LABEL: vec:
; X86:       # %bb.0:
; X86-NEXT:    pushl %ebp
; X86-NEXT:    pushl %ebx
; X86-NEXT:    pushl %edi
; X86-NEXT:    pushl %esi
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ebx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edi
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    imull {{[0-9]+}}(%esp)
; X86-NEXT:    movl %eax, %ecx
; X86-NEXT:    shrdl $2, %edx, %ecx
; X86-NEXT:    cmpl $1, %edx
; X86-NEXT:    movl $2147483647, %ebp # imm = 0x7FFFFFFF
; X86-NEXT:    cmovgl %ebp, %ecx
; X86-NEXT:    cmpl $-2, %edx
; X86-NEXT:    movl $-2147483648, %esi # imm = 0x80000000
; X86-NEXT:    cmovll %esi, %ecx
; X86-NEXT:    movl %edi, %eax
; X86-NEXT:    imull {{[0-9]+}}(%esp)
; X86-NEXT:    movl %eax, %edi
; X86-NEXT:    shrdl $2, %edx, %edi
; X86-NEXT:    cmpl $1, %edx
; X86-NEXT:    cmovgl %ebp, %edi
; X86-NEXT:    cmpl $-2, %edx
; X86-NEXT:    cmovll %esi, %edi
; X86-NEXT:    movl %ebx, %eax
; X86-NEXT:    imull {{[0-9]+}}(%esp)
; X86-NEXT:    movl %eax, %ebx
; X86-NEXT:    shrdl $2, %edx, %ebx
; X86-NEXT:    cmpl $1, %edx
; X86-NEXT:    cmovgl %ebp, %ebx
; X86-NEXT:    cmpl $-2, %edx
; X86-NEXT:    cmovll %esi, %ebx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    imull {{[0-9]+}}(%esp)
; X86-NEXT:    shrdl $2, %edx, %eax
; X86-NEXT:    cmpl $1, %edx
; X86-NEXT:    cmovgl %ebp, %eax
; X86-NEXT:    cmpl $-2, %edx
; X86-NEXT:    cmovll %esi, %eax
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X86-NEXT:    movl %eax, 12(%edx)
; X86-NEXT:    movl %ebx, 8(%edx)
; X86-NEXT:    movl %edi, 4(%edx)
; X86-NEXT:    movl %ecx, (%edx)
; X86-NEXT:    movl %edx, %eax
; X86-NEXT:    popl %esi
; X86-NEXT:    popl %edi
; X86-NEXT:    popl %ebx
; X86-NEXT:    popl %ebp
; X86-NEXT:    retl $4
  %tmp = call <4 x i32> @llvm.smul.fix.sat.v4i32(<4 x i32> %x, <4 x i32> %y, i32 2)
  ret <4 x i32> %tmp
}

; These result in regular integer multiplication
define i32 @func4(i32 %x, i32 %y) nounwind {
; X64-LABEL: func4:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %ecx
; X64-NEXT:    imull %esi, %ecx
; X64-NEXT:    xorl %eax, %eax
; X64-NEXT:    testl %ecx, %ecx
; X64-NEXT:    setns %al
; X64-NEXT:    addl $2147483647, %eax # imm = 0x7FFFFFFF
; X64-NEXT:    imull %esi, %edi
; X64-NEXT:    cmovnol %edi, %eax
; X64-NEXT:    retq
;
; X86-LABEL: func4:
; X86:       # %bb.0:
; X86-NEXT:    pushl %esi
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X86-NEXT:    movl %eax, %esi
; X86-NEXT:    imull %edx, %esi
; X86-NEXT:    xorl %ecx, %ecx
; X86-NEXT:    testl %esi, %esi
; X86-NEXT:    setns %cl
; X86-NEXT:    addl $2147483647, %ecx # imm = 0x7FFFFFFF
; X86-NEXT:    imull %edx, %eax
; X86-NEXT:    cmovol %ecx, %eax
; X86-NEXT:    popl %esi
; X86-NEXT:    retl
  %tmp = call i32 @llvm.smul.fix.sat.i32(i32 %x, i32 %y, i32 0)
  ret i32 %tmp
}

define i64 @func5(i64 %x, i64 %y) {
; X64-LABEL: func5:
; X64:       # %bb.0:
; X64-NEXT:    movq %rdi, %rax
; X64-NEXT:    imulq %rsi, %rax
; X64-NEXT:    xorl %ecx, %ecx
; X64-NEXT:    testq %rax, %rax
; X64-NEXT:    setns %cl
; X64-NEXT:    movabsq $9223372036854775807, %rax # imm = 0x7FFFFFFFFFFFFFFF
; X64-NEXT:    addq %rcx, %rax
; X64-NEXT:    imulq %rsi, %rdi
; X64-NEXT:    cmovnoq %rdi, %rax
; X64-NEXT:    retq
;
; X86-LABEL: func5:
; X86:       # %bb.0:
; X86-NEXT:    pushl %edi
; X86-NEXT:    .cfi_def_cfa_offset 8
; X86-NEXT:    pushl %esi
; X86-NEXT:    .cfi_def_cfa_offset 12
; X86-NEXT:    pushl %eax
; X86-NEXT:    .cfi_def_cfa_offset 16
; X86-NEXT:    .cfi_offset %esi, -12
; X86-NEXT:    .cfi_offset %edi, -8
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %esi
; X86-NEXT:    movl $0, (%esp)
; X86-NEXT:    movl %esp, %edi
; X86-NEXT:    pushl %edi
; X86-NEXT:    .cfi_adjust_cfa_offset 4
; X86-NEXT:    pushl %esi
; X86-NEXT:    .cfi_adjust_cfa_offset 4
; X86-NEXT:    pushl %edx
; X86-NEXT:    .cfi_adjust_cfa_offset 4
; X86-NEXT:    pushl %ecx
; X86-NEXT:    .cfi_adjust_cfa_offset 4
; X86-NEXT:    pushl %eax
; X86-NEXT:    .cfi_adjust_cfa_offset 4
; X86-NEXT:    calll __mulodi4
; X86-NEXT:    addl $20, %esp
; X86-NEXT:    .cfi_adjust_cfa_offset -20
; X86-NEXT:    xorl %ecx, %ecx
; X86-NEXT:    testl %edx, %edx
; X86-NEXT:    setns %cl
; X86-NEXT:    addl $2147483647, %ecx # imm = 0x7FFFFFFF
; X86-NEXT:    movl %edx, %esi
; X86-NEXT:    sarl $31, %esi
; X86-NEXT:    cmpl $0, (%esp)
; X86-NEXT:    cmovnel %esi, %eax
; X86-NEXT:    cmovnel %ecx, %edx
; X86-NEXT:    addl $4, %esp
; X86-NEXT:    .cfi_def_cfa_offset 12
; X86-NEXT:    popl %esi
; X86-NEXT:    .cfi_def_cfa_offset 8
; X86-NEXT:    popl %edi
; X86-NEXT:    .cfi_def_cfa_offset 4
; X86-NEXT:    retl
  %tmp = call i64 @llvm.smul.fix.sat.i64(i64 %x, i64 %y, i32 0)
  ret i64 %tmp
}

define i4 @func6(i4 %x, i4 %y) nounwind {
; X64-LABEL: func6:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    shlb $4, %sil
; X64-NEXT:    sarb $4, %sil
; X64-NEXT:    shlb $4, %al
; X64-NEXT:    # kill: def $al killed $al killed $eax
; X64-NEXT:    imulb %sil
; X64-NEXT:    seto %cl
; X64-NEXT:    xorl %edx, %edx
; X64-NEXT:    testb %al, %al
; X64-NEXT:    setns %dl
; X64-NEXT:    addl $127, %edx
; X64-NEXT:    movzbl %al, %eax
; X64-NEXT:    testb %cl, %cl
; X64-NEXT:    cmovnel %edx, %eax
; X64-NEXT:    sarb $4, %al
; X64-NEXT:    # kill: def $al killed $al killed $eax
; X64-NEXT:    retq
;
; X86-LABEL: func6:
; X86:       # %bb.0:
; X86-NEXT:    movb {{[0-9]+}}(%esp), %cl
; X86-NEXT:    shlb $4, %cl
; X86-NEXT:    sarb $4, %cl
; X86-NEXT:    movb {{[0-9]+}}(%esp), %al
; X86-NEXT:    shlb $4, %al
; X86-NEXT:    imulb %cl
; X86-NEXT:    seto %dl
; X86-NEXT:    xorl %ecx, %ecx
; X86-NEXT:    testb %al, %al
; X86-NEXT:    setns %cl
; X86-NEXT:    addl $127, %ecx
; X86-NEXT:    movzbl %al, %eax
; X86-NEXT:    testb %dl, %dl
; X86-NEXT:    cmovnel %ecx, %eax
; X86-NEXT:    sarb $4, %al
; X86-NEXT:    # kill: def $al killed $al killed $eax
; X86-NEXT:    retl
  %tmp = call i4 @llvm.smul.fix.sat.i4(i4 %x, i4 %y, i32 0)
  ret i4 %tmp
}

define <4 x i32> @vec2(<4 x i32> %x, <4 x i32> %y) nounwind {
; X64-LABEL: vec2:
; X64:       # %bb.0:
; X64-NEXT:    pshufd {{.*#+}} xmm2 = xmm1[1,1,2,3]
; X64-NEXT:    movd %xmm2, %ecx
; X64-NEXT:    pshufd {{.*#+}} xmm2 = xmm0[1,1,2,3]
; X64-NEXT:    movd %xmm2, %r8d
; X64-NEXT:    movl %r8d, %edx
; X64-NEXT:    imull %ecx, %edx
; X64-NEXT:    xorl %esi, %esi
; X64-NEXT:    testl %edx, %edx
; X64-NEXT:    setns %sil
; X64-NEXT:    addl $2147483647, %esi # imm = 0x7FFFFFFF
; X64-NEXT:    imull %ecx, %r8d
; X64-NEXT:    cmovol %esi, %r8d
; X64-NEXT:    movd %xmm1, %edx
; X64-NEXT:    movd %xmm0, %ecx
; X64-NEXT:    movl %ecx, %esi
; X64-NEXT:    imull %edx, %esi
; X64-NEXT:    xorl %edi, %edi
; X64-NEXT:    testl %esi, %esi
; X64-NEXT:    setns %dil
; X64-NEXT:    addl $2147483647, %edi # imm = 0x7FFFFFFF
; X64-NEXT:    imull %edx, %ecx
; X64-NEXT:    cmovol %edi, %ecx
; X64-NEXT:    pshufd {{.*#+}} xmm2 = xmm1[2,3,2,3]
; X64-NEXT:    movd %xmm2, %edx
; X64-NEXT:    pshufd {{.*#+}} xmm2 = xmm0[2,3,2,3]
; X64-NEXT:    movd %xmm2, %esi
; X64-NEXT:    movl %esi, %edi
; X64-NEXT:    imull %edx, %edi
; X64-NEXT:    xorl %eax, %eax
; X64-NEXT:    testl %edi, %edi
; X64-NEXT:    setns %al
; X64-NEXT:    addl $2147483647, %eax # imm = 0x7FFFFFFF
; X64-NEXT:    imull %edx, %esi
; X64-NEXT:    cmovol %eax, %esi
; X64-NEXT:    pshufd {{.*#+}} xmm1 = xmm1[3,1,2,3]
; X64-NEXT:    movd %xmm1, %r9d
; X64-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[3,1,2,3]
; X64-NEXT:    movd %xmm0, %edx
; X64-NEXT:    movl %edx, %edi
; X64-NEXT:    imull %r9d, %edi
; X64-NEXT:    xorl %eax, %eax
; X64-NEXT:    testl %edi, %edi
; X64-NEXT:    setns %al
; X64-NEXT:    addl $2147483647, %eax # imm = 0x7FFFFFFF
; X64-NEXT:    imull %r9d, %edx
; X64-NEXT:    cmovol %eax, %edx
; X64-NEXT:    movd %edx, %xmm0
; X64-NEXT:    movd %esi, %xmm1
; X64-NEXT:    punpckldq {{.*#+}} xmm1 = xmm1[0],xmm0[0],xmm1[1],xmm0[1]
; X64-NEXT:    movd %ecx, %xmm0
; X64-NEXT:    movd %r8d, %xmm2
; X64-NEXT:    punpckldq {{.*#+}} xmm0 = xmm0[0],xmm2[0],xmm0[1],xmm2[1]
; X64-NEXT:    punpcklqdq {{.*#+}} xmm0 = xmm0[0],xmm1[0]
; X64-NEXT:    retq
;
; X86-LABEL: vec2:
; X86:       # %bb.0:
; X86-NEXT:    pushl %ebp
; X86-NEXT:    pushl %ebx
; X86-NEXT:    pushl %edi
; X86-NEXT:    pushl %esi
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X86-NEXT:    movl %ecx, %esi
; X86-NEXT:    imull %edx, %esi
; X86-NEXT:    xorl %eax, %eax
; X86-NEXT:    testl %esi, %esi
; X86-NEXT:    setns %al
; X86-NEXT:    addl $2147483647, %eax # imm = 0x7FFFFFFF
; X86-NEXT:    imull %edx, %ecx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X86-NEXT:    cmovol %eax, %ecx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %esi
; X86-NEXT:    movl %edx, %edi
; X86-NEXT:    imull %esi, %edi
; X86-NEXT:    xorl %eax, %eax
; X86-NEXT:    testl %edi, %edi
; X86-NEXT:    setns %al
; X86-NEXT:    addl $2147483647, %eax # imm = 0x7FFFFFFF
; X86-NEXT:    imull %esi, %edx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %esi
; X86-NEXT:    cmovol %eax, %edx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edi
; X86-NEXT:    movl %esi, %ebx
; X86-NEXT:    imull %edi, %ebx
; X86-NEXT:    xorl %eax, %eax
; X86-NEXT:    testl %ebx, %ebx
; X86-NEXT:    setns %al
; X86-NEXT:    addl $2147483647, %eax # imm = 0x7FFFFFFF
; X86-NEXT:    imull %edi, %esi
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edi
; X86-NEXT:    cmovol %eax, %esi
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movl %edi, %ebp
; X86-NEXT:    imull %eax, %ebp
; X86-NEXT:    xorl %ebx, %ebx
; X86-NEXT:    testl %ebp, %ebp
; X86-NEXT:    setns %bl
; X86-NEXT:    addl $2147483647, %ebx # imm = 0x7FFFFFFF
; X86-NEXT:    imull %eax, %edi
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    cmovol %ebx, %edi
; X86-NEXT:    movl %ecx, 12(%eax)
; X86-NEXT:    movl %edx, 8(%eax)
; X86-NEXT:    movl %esi, 4(%eax)
; X86-NEXT:    movl %edi, (%eax)
; X86-NEXT:    popl %esi
; X86-NEXT:    popl %edi
; X86-NEXT:    popl %ebx
; X86-NEXT:    popl %ebp
; X86-NEXT:    retl $4
  %tmp = call <4 x i32> @llvm.smul.fix.sat.v4i32(<4 x i32> %x, <4 x i32> %y, i32 0)
  ret <4 x i32> %tmp
}

define i64 @func7(i64 %x, i64 %y) nounwind {
; X64-LABEL: func7:
; X64:       # %bb.0:
; X64-NEXT:    movq %rdi, %rax
; X64-NEXT:    imulq %rsi
; X64-NEXT:    shrdq $32, %rdx, %rax
; X64-NEXT:    cmpq $2147483647, %rdx # imm = 0x7FFFFFFF
; X64-NEXT:    movabsq $9223372036854775807, %rcx # imm = 0x7FFFFFFFFFFFFFFF
; X64-NEXT:    cmovgq %rcx, %rax
; X64-NEXT:    cmpq $-2147483648, %rdx # imm = 0x80000000
; X64-NEXT:    movabsq $-9223372036854775808, %rcx # imm = 0x8000000000000000
; X64-NEXT:    cmovlq %rcx, %rax
; X64-NEXT:    retq
;
; X86-LABEL: func7:
; X86:       # %bb.0:
; X86-NEXT:    pushl %ebp
; X86-NEXT:    pushl %ebx
; X86-NEXT:    pushl %edi
; X86-NEXT:    pushl %esi
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %esi
; X86-NEXT:    movl %ecx, %eax
; X86-NEXT:    mull {{[0-9]+}}(%esp)
; X86-NEXT:    movl %edx, %edi
; X86-NEXT:    movl %eax, %ebx
; X86-NEXT:    movl %ecx, %eax
; X86-NEXT:    mull {{[0-9]+}}(%esp)
; X86-NEXT:    addl %edx, %ebx
; X86-NEXT:    adcl $0, %edi
; X86-NEXT:    movl %esi, %eax
; X86-NEXT:    imull {{[0-9]+}}(%esp)
; X86-NEXT:    movl %edx, %ebp
; X86-NEXT:    movl %eax, %ecx
; X86-NEXT:    movl %esi, %eax
; X86-NEXT:    mull {{[0-9]+}}(%esp)
; X86-NEXT:    addl %ebx, %eax
; X86-NEXT:    adcl %edi, %edx
; X86-NEXT:    adcl $0, %ebp
; X86-NEXT:    addl %ecx, %edx
; X86-NEXT:    adcl $0, %ebp
; X86-NEXT:    movl %edx, %ecx
; X86-NEXT:    subl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    movl %ebp, %esi
; X86-NEXT:    sbbl $0, %esi
; X86-NEXT:    cmpl $0, {{[0-9]+}}(%esp)
; X86-NEXT:    cmovnsl %ebp, %esi
; X86-NEXT:    cmovnsl %edx, %ecx
; X86-NEXT:    movl %ecx, %edx
; X86-NEXT:    subl {{[0-9]+}}(%esp), %edx
; X86-NEXT:    movl %esi, %edi
; X86-NEXT:    sbbl $0, %edi
; X86-NEXT:    cmpl $0, {{[0-9]+}}(%esp)
; X86-NEXT:    cmovnsl %esi, %edi
; X86-NEXT:    cmovnsl %ecx, %edx
; X86-NEXT:    testl %edx, %edx
; X86-NEXT:    setns %cl
; X86-NEXT:    sets %ch
; X86-NEXT:    testl %edi, %edi
; X86-NEXT:    setg %bl
; X86-NEXT:    sete %bh
; X86-NEXT:    andb %ch, %bh
; X86-NEXT:    orb %bl, %bh
; X86-NEXT:    movl $2147483647, %esi # imm = 0x7FFFFFFF
; X86-NEXT:    cmovnel %esi, %edx
; X86-NEXT:    movl $-1, %esi
; X86-NEXT:    cmovnel %esi, %eax
; X86-NEXT:    cmpl $-1, %edi
; X86-NEXT:    setl %ch
; X86-NEXT:    sete %bl
; X86-NEXT:    andb %cl, %bl
; X86-NEXT:    xorl %esi, %esi
; X86-NEXT:    orb %ch, %bl
; X86-NEXT:    cmovnel %esi, %eax
; X86-NEXT:    movl $-2147483648, %ecx # imm = 0x80000000
; X86-NEXT:    cmovnel %ecx, %edx
; X86-NEXT:    popl %esi
; X86-NEXT:    popl %edi
; X86-NEXT:    popl %ebx
; X86-NEXT:    popl %ebp
; X86-NEXT:    retl
  %tmp = call i64 @llvm.smul.fix.sat.i64(i64 %x, i64 %y, i32 32)
  ret i64 %tmp
}

define i64 @func8(i64 %x, i64 %y) nounwind {
; X64-LABEL: func8:
; X64:       # %bb.0:
; X64-NEXT:    movq %rdi, %rax
; X64-NEXT:    imulq %rsi
; X64-NEXT:    shrdq $63, %rdx, %rax
; X64-NEXT:    movabsq $4611686018427387903, %rcx # imm = 0x3FFFFFFFFFFFFFFF
; X64-NEXT:    cmpq %rcx, %rdx
; X64-NEXT:    movabsq $9223372036854775807, %rcx # imm = 0x7FFFFFFFFFFFFFFF
; X64-NEXT:    cmovgq %rcx, %rax
; X64-NEXT:    movabsq $-4611686018427387904, %rcx # imm = 0xC000000000000000
; X64-NEXT:    cmpq %rcx, %rdx
; X64-NEXT:    movabsq $-9223372036854775808, %rcx # imm = 0x8000000000000000
; X64-NEXT:    cmovlq %rcx, %rax
; X64-NEXT:    retq
;
; X86-LABEL: func8:
; X86:       # %bb.0:
; X86-NEXT:    pushl %ebp
; X86-NEXT:    pushl %ebx
; X86-NEXT:    pushl %edi
; X86-NEXT:    pushl %esi
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %esi
; X86-NEXT:    movl %ecx, %eax
; X86-NEXT:    mull {{[0-9]+}}(%esp)
; X86-NEXT:    movl %edx, %edi
; X86-NEXT:    movl %eax, %ebx
; X86-NEXT:    movl %ecx, %eax
; X86-NEXT:    mull {{[0-9]+}}(%esp)
; X86-NEXT:    addl %edx, %ebx
; X86-NEXT:    adcl $0, %edi
; X86-NEXT:    movl %esi, %eax
; X86-NEXT:    imull {{[0-9]+}}(%esp)
; X86-NEXT:    movl %edx, %ebp
; X86-NEXT:    movl %eax, %ecx
; X86-NEXT:    movl %esi, %eax
; X86-NEXT:    mull {{[0-9]+}}(%esp)
; X86-NEXT:    addl %ebx, %eax
; X86-NEXT:    adcl %edi, %edx
; X86-NEXT:    adcl $0, %ebp
; X86-NEXT:    addl %ecx, %edx
; X86-NEXT:    adcl $0, %ebp
; X86-NEXT:    movl %edx, %ecx
; X86-NEXT:    subl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    movl %ebp, %esi
; X86-NEXT:    sbbl $0, %esi
; X86-NEXT:    cmpl $0, {{[0-9]+}}(%esp)
; X86-NEXT:    cmovnsl %ebp, %esi
; X86-NEXT:    cmovnsl %edx, %ecx
; X86-NEXT:    movl %ecx, %edx
; X86-NEXT:    subl {{[0-9]+}}(%esp), %edx
; X86-NEXT:    movl %esi, %edi
; X86-NEXT:    sbbl $0, %edi
; X86-NEXT:    cmpl $0, {{[0-9]+}}(%esp)
; X86-NEXT:    cmovnsl %esi, %edi
; X86-NEXT:    cmovnsl %ecx, %edx
; X86-NEXT:    shrdl $31, %edx, %eax
; X86-NEXT:    shrdl $31, %edi, %edx
; X86-NEXT:    cmpl $1073741823, %edi # imm = 0x3FFFFFFF
; X86-NEXT:    movl $2147483647, %ecx # imm = 0x7FFFFFFF
; X86-NEXT:    cmovgl %ecx, %edx
; X86-NEXT:    movl $-1, %ecx
; X86-NEXT:    cmovgl %ecx, %eax
; X86-NEXT:    xorl %ecx, %ecx
; X86-NEXT:    cmpl $-1073741824, %edi # imm = 0xC0000000
; X86-NEXT:    cmovll %ecx, %eax
; X86-NEXT:    movl $-2147483648, %ecx # imm = 0x80000000
; X86-NEXT:    cmovll %ecx, %edx
; X86-NEXT:    popl %esi
; X86-NEXT:    popl %edi
; X86-NEXT:    popl %ebx
; X86-NEXT:    popl %ebp
; X86-NEXT:    retl
  %tmp = call i64 @llvm.smul.fix.sat.i64(i64 %x, i64 %y, i32 63)
  ret i64 %tmp
}
