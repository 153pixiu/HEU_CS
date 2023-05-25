.data
Prompt: 		.asciiz 	"input An integer which is array's size value >1 : "
Prompt2: 		.asciiz 	"input An integer which you want to find  : "
PromptF: 		.asciiz 	"Not Found   "
PromptLast:   	.asciiz       "input an integer :"
PrintfFormat:	.asciiz 	"The position of the integar is : %d "
.align	 2
PrintfPar1:   .word   PromptF
PrintfPar:		.word	 PrintfFormat
Printf:      		.space       4
PrintfValue:	.space	 1024
             

.text
.global	main


main:
                            ;输入数组长度r1
                            ;调用InputUnsigned函数每次输入一个整数,先将提示字符串输入r1	
                            addi	  r1,r0,Prompt
                            jal	                  InputUnsigned
                            ;将输入的数组长度r1存放在r2和r7中
                            add                  r2,r0,r1    
                            add                  r7,r0,r1   
	            ;输入要查找的数r1
 	            addi  	  r1,r0,Prompt2
                            jal	                  InputUnsigned   
                            ;将输入的要查找的数存放在r9中	
                            add                  r9,r0,r1
	           ;r3指向数组中的起始位置 ,用来遍历数组
                            addi                 r3,r0,0
	           ;r10标记要找的数的下标
                            addi                 r10,r0,1
                            

                            ;循环输入数组的各个值,每次输入后r2减一,
                            
InputArray:         
	          ;当r2中的数为0时输入结束,并调用ProcessPart将r3重新指向数组初始位置
	           beqz                 r2, ProcessPart
	           ; 每次输入后r2减1 
                            subi                 r2,r2,1     
	           ;输入一个数组元素r1       
                            addi                 r1,r0,PromptLast
                            jal                    InputUnsigned
	           ;将r1中的数保存到r3寄存器中      
                           sw                   PrintfValue(r3),r1   
	           ;r3往后移4位,表示指向数组中的下一个位置
                           addi                 r3,r3,4    
  	           beqz                 r2, ProcessPart

                            j                      InputArray
                              

ProcessPart:        addi                 r3,r0,0     
   

 	          ;开始查找   
FindLoop:
                           ;r7为0时,退出查找循环
                            beqz                 r7,ENDT
                           ;分别把当前下标指向的数组元素和要查找的数放进浮点数寄存器
                            lw                r20,PrintfValue(r3) 
	           ;r3往后移4位,表示指向数组中的下一个位置
                            addi                 r3,r3,4
                            sub                 r20,r9,r20
                           ;相等则跳转到END
                            beqz                r20,END
                           ;否则,r7减1,记录下标r10加1
                            subi                 r7,r7,1
                            addi                 r10,r10,1
                           ;重新执行查找过程
                             j                 FindLoop
    
 
ENDT:  
                            addi         r1,r0,PromptF
                            sw           PrintfPar,r1
                            addi	       r14,r0,PrintfPar
                            trap	    5
                            j                     over;程序结束
    
END:
                            sw            Printf,r10
                            addi         r14,r0,PrintfPar
                            trap         5
                            j                 over
   
over:	           trap	 0	