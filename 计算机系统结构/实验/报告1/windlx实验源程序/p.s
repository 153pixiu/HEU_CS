;.data标识下面的数据放在数据区中
.data				
;.asciiz表示在存储区中顺序存放列出的字符串，字符串自动加0结束
Prompt:			.asciiz 	"input An integer which is a four-digit number : "
;PromptLast:   	.asciiz       "input an integer :"
PrintfFormat1:		.asciiz 	"This is a palindrome number! "
PrintfFormat2:		.asciiz 	"This is not a palindrome number! "
PrintfFormat:	.asciiz 	"Number : %d "

.align	 2
;.word在存储器中顺序存放列出的字
PrintfPar:	.word	 PrintfFormat
Printf:      .space       8
PrintfValue:	.space	 1024
;.text标识下面的代码存放在代码区中
.text
;.global使带有.global的标识可以被全局访问
.global	main

main:

            addi	 				 r1,r0,Prompt   ;将Prompt字符串首地址放入r1寄存器中
            jal	                 InputUnsigned      ;跳转向InputUnsigned标识的指令地址，调用input子函数读取一个四位数
            add                  r2,r0,r1           ;将input函数读取的数放入寄存器中
            add                  r6,r0,r1
            addi                  r3,r0,0           ;r3寄存器中数清0
            addi                  r7,r0,0            ;r7寄存器中数清0
            addi                  r8,r0,10          ;立即数10写入r8

;求r6中的四位数逆序对应的新四位数，存在r7中，如：1234->4321
Loop:
            ;循环内 使r6=原r6/10,r7=原r7*10+原r6%10
            beqz                 r6,check           ;r6中所存数为0则跳转向check所标识的指令地址
            ;使r7=原r7*10,r9=原r6/10,r10=原r6%10
            divu                   r9,r6,r8         ;r6寄存器中的数除以r8寄存器中的数放到r9寄存器中
            mult                   r10,r9,r8        ;r9寄存器中的数乘以r8寄存器中的数放到r10中
            mult                   r7,r7,r8         ;r7寄存器中的数乘以r8寄存器中的数放到r7中
            sub                    r6,r6,r10        ;将r6和r10的差送入r10
            ;使r6=原r6/10,r7=原r7*10+原r6%10
            add                    r6,r0,r9
            add                    r7,r7,r10
            j                     Loop

;判断是不是回文数，即r2和r7是否相等
check:
            sub                    r2,r2,r7         ;将r2和r7的差送入r2
            beqz                 r2,output1         ;r2中所存数为0则跳转向output1所标识的指令地址
            j                     output2

;输出结果
output1:              
            addi         r1,r0,PrintfFormat1
            sw           PrintfPar,r1
            addi	                 	r14,r0,PrintfPar
            trap	    5                           ;调用中断，格式化为标准输出
            j                     over
output2:    
            addi         r1,r0,PrintfFormat2
            sw           PrintfPar,r1          
            addi	                 	r14,r0,PrintfPar
            trap	    5                           ;调用中断，格式化为标准输出
            j                     over              

over:	           
trap	 0                                          ;调用系统中断，0表示程序执行结束
