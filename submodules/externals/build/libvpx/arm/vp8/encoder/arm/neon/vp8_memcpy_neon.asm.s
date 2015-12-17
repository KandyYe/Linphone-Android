@ This file was created from a .asm file
@  using the ads2gas.pl script.
	.equ DO1STROUNDING, 0
@
@  Copyright (c) 2010 The WebM project authors. All Rights Reserved.
@
@  Use of this source code is governed by a BSD-style license
@  that can be found in the LICENSE file in the root of the source
@  tree. An additional intellectual property rights grant can be found
@  in the file PATENTS.  All contributing project authors may
@  be found in the AUTHORS file in the root of the source tree.
@


    .global vp8_memcpy_partial_neon 
	.type vp8_memcpy_partial_neon, function

   .arm
   .eabi_attribute 24, 1 @Tag_ABI_align_needed
   .eabi_attribute 25, 1 @Tag_ABI_align_preserved

.text
.p2align 2
@=========================================
@this is not a full memcpy function!!!
@void vp8_memcpy_partial_neon(unsigned char *dst_ptr, unsigned char *src_ptr,
@                             int sz);
_vp8_memcpy_partial_neon:
	vp8_memcpy_partial_neon: @ PROC
    @pld                [r1]                        ;preload pred data
    @pld                [r1, #128]
    @pld                [r1, #256]
    @pld                [r1, #384]

    mov             r12, r2, lsr #8                 @copy 256 bytes data at one time

memcpy_neon_loop:
    vld1.8          {q0, q1}, [r1]!                 @load src data
    subs            r12, r12, #1
    vld1.8          {q2, q3}, [r1]!
    vst1.8          {q0, q1}, [r0]!                 @copy to dst_ptr
    vld1.8          {q4, q5}, [r1]!
    vst1.8          {q2, q3}, [r0]!
    vld1.8          {q6, q7}, [r1]!
    vst1.8          {q4, q5}, [r0]!
    vld1.8          {q8, q9}, [r1]!
    vst1.8          {q6, q7}, [r0]!
    vld1.8          {q10, q11}, [r1]!
    vst1.8          {q8, q9}, [r0]!
    vld1.8          {q12, q13}, [r1]!
    vst1.8          {q10, q11}, [r0]!
    vld1.8          {q14, q15}, [r1]!
    vst1.8          {q12, q13}, [r0]!
    vst1.8          {q14, q15}, [r0]!

    @pld                [r1]                        ;preload pred data -- need to adjust for real device
    @pld                [r1, #128]
    @pld                [r1, #256]
    @pld                [r1, #384]

    bne             memcpy_neon_loop

    ands            r3, r2, #0xff                   @extra copy
    beq             done_copy_neon_loop

extra_copy_neon_loop:
    vld1.8          {q0}, [r1]!                 @load src data
    subs            r3, r3, #16
    vst1.8          {q0}, [r0]!
    bne             extra_copy_neon_loop

done_copy_neon_loop:
    bx              lr
	.size vp8_memcpy_partial_neon, .-vp8_memcpy_partial_neon    @ ENDP

	.section	.note.GNU-stack,"",%progbits