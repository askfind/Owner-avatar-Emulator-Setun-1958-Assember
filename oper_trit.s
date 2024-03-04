#
# Filename: "oper_trit.s"
#
# Project: Троичная МЦВМ "Сетунь" 1958 года на языке ассемблера RISC-V
#
# Create date: 03.03.2024
# Edit date:   05.03.2023
#
#
# Author:      Vladimir V.
# E-mail:      askfind@ya.ru
#
# GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007
#


# Таб.1 Алфавит троичной симметричной системы счисления
# +--------------------------+-------+-------+-------+
# | Числа                    |  -1   |   0   |   1   |
# +--------------------------+-------+-------+-------+
# | Логика                   | false |  nil  | true  |
# +--------------------------+-------+-------+-------+
# | Логика                   |   f   |   n   |   t   |
# +--------------------------+-------+-------+-------+
# | Символы                  |   -   |	  0   |	  +   |
# +--------------------------+-------+-------+-------+
# | Символы                  |   N   |	  Z   |	  P   |
# +--------------------------+-------+-------+-------+
# | Символы                  |   N   |	  O   |	  P   |
# +--------------------------+-------+-------+-------+
# | Символы                  |   0   |	  i   |	  1   |
# +--------------------------+-------+-------+-------+
# | Символы                  |   v   |	  0   |	  ^   |
# +--------------------------+-------+-------+-------+

#
#   trit = {-1,0,1}  - трит значения трита
#


# Таб.6 Троичное умножение
#       AND
# .-----------------------.
# |     | -1  |  0  |  1  |
# |-----------------------|
# | -1  |  -  |  -  |  -  |
# |-----------------------|
# |  0  |  -  |  0  |  0  |
# |-----------------------|
# |  1  |  -  |  0  |  +  |
# .-----------------------.


 .data
 .align 4
tab_6:
tab_6_1:.byte -1
tab_6_2:.byte -1
tab_6_3:.byte -1
tab_6_4:.byte -1
tab_6_5:.byte  0
tab_6_6:.byte  0
tab_6_7:.byte -1
tab_6_8:.byte  0
tab_6_9:.byte  1

# Операция троичное AND
.macro and_t ($a, $b)	
	li a1,$a	# a1 = a
	li a2,$b 	# a2 = b
	addi a1,a1,1	# i = a+1 
	addi a2,a2,1    # j = b+1	
	li   a3,3	# a3 = 3	
	mul  a4,a1,a3   # a4 = i*3
	add  a3,a2,a4   # ind = j + i*3
	la   a4,tab_6   # a4 = tab_6 
	add  a4,a4,a3   # ind = tab_6 + inds 
	lb   a0,0(a4)   # a0 = tab_6[ind]
.end_macro

# Таб.8 Троичное исключающее или
#       XOR
# .-----------------------.
# |     | -1  |  0  |  1  |
# |-----------------------|
# | -1  |  -  |  0  |  +  |
# |-----------------------|
# |  0  |  0  |  0  |  0  |
# |-----------------------|
# |  1  |  +  |  0  |  -  |
# .-----------------------.

 .data
 .align 4
tab_8:
tab_8_1:.byte -1
tab_8_2:.byte  0
tab_8_3:.byte  1
tab_8_4:.byte  0
tab_8_5:.byte  0
tab_8_6:.byte  0
tab_8_7:.byte  1
tab_8_8:.byte  0
tab_8_9:.byte -1

# Операция троичное XOR
.macro xor_t ($a, $b)	
	li a1,$a	# a1 = a
	li a2,$b 	# a2 = b
	addi a1,a1,1	# i = a+1 
	addi a2,a2,1    # j = b+1	
	li   a3,3	# a3 = 3	
	mul  a4,a1,a3   # a4 = i*3
	add  a3,a2,a4   # ind = j + i*3
	la   a4,tab_8   # a4 = tab_8 
	add  a4,a4,a3   # ind = tab_8 + inds 
	lb   a0,0(a4)   # a0 = tab_8[ind]
.end_macro

# Таб.7 Троичное или
#       OR
# .-----------------------.
# |     | -1  |  0  |  1  |
# |-----------------------|
# | -1  |  -  |  0  |  +  |
# |-----------------------|
# |  0  |  0  |  0  |  +  |
# |-----------------------|
# |  1  |  +  |  +  |  +  |
# .-----------------------.
#   X OR Y = MAX(X,Y)

 .data
 .align 4
tab_7:
tab_7_1:.byte -1
tab_7_2:.byte  0
tab_7_3:.byte  1
tab_7_4:.byte  0
tab_7_5:.byte  0
tab_7_6:.byte  1
tab_7_7:.byte  1
tab_7_8:.byte  1
tab_7_9:.byte  1

# Операция троичное OR
.macro or_t ($a, $b)	
	li a1,$a	# a1 = a
	li a2,$b 	# a2 = b
	addi a1,a1,1	# i = a+1 
	addi a2,a2,1    # j = b+1	
	li   a3,3	# a3 = 3	
	mul  a4,a1,a3   # a4 = i*3
	add  a3,a2,a4   # ind = j + i*3
	la   a4,tab_7   # a4 = tab_7 
	add  a4,a4,a3   # ind = tab_7 + inds 
	lb   a0,0(a4)   # a0 = tab_7[ind]	
.end_macro

# Таб.5 Троичное отрицание
#       NOT
# .-----------.
# |  -  |  +  |
# |-----------|
# |  0  |  0  |
# |-----------|
# |  +  |  -  |
# .-----------.

#  - [ ] исправить вывод в 9-ном виде.
# Операция троичное NOT
.macro not_t ($a)
	li a0,$a	
	bgtz a0, m_m	# +1 -> -1 
	bltz a0, m_p	# -1 -> +1 
	mv a0,zero	#  0 ->  0
	j m_end
m_m:	li a0,-1
	j m_end
m_p:	li a0, 1
m_end:	
.end_macro


# Таб.2 Полусумматор тритов
# .------------------------.
# |     | -1  |  0  |  1   |
# |------------------------|
# | -1  | -+  |  -  |  0   |
# |------------------------|
# |  0  | -1  |  0  |  1   |
# |------------------------|
# |  1  |  0  |  1  |  +-  |
# .------------------------.

 .data
 .align 4
tab_2:
tab_2_1:.byte  1
tab_2_2:.byte -1
tab_2_3:.byte  0
tab_2_4:.byte -1
tab_2_5:.byte  0
tab_2_6:.byte  1
tab_2_7:.byte  0
tab_2_8:.byte  1
tab_2_9:.byte -1

# Полусумматор тритов
.macro sum_half_t ($a, $b)	
	li a1,$a	# a1 = a
	li a2,$b 	# a2 = b
	addi a1,a1,1	# i = a+1 
	addi a2,a2,1    # j = b+1	
	li   a3,3	# a3 = 3	
	mul  a4,a1,a3   # a4 = i*3
	add  a3,a2,a4   # ind = j + i*3
	la   a4,tab_2   # a4 = tab_2 
	add  a4,a4,a3   # ind = tab_2 + inds 
	lb   a0,0(a4)   # a0 = tab_2[ind]
.end_macro


# Таб.3 Таблица полного сумматора тритов
# .-----------------------------------------.
# | Перенос из n-1   -1  -1  -1   1   1   1 |
# | 1-е слагаемое    -1  -1  -1   1   1   1 |
# | 2-е слагаемое    -1   0   1  -1   0   1 |
# | Сумма             0   1  -1   1  -1   0 |
# | Перенос в n+1    -1  -1   0   0   1   1 |
# .-----------------------------------------.

# Полный смматор тритов
.macro sum_t ($a, $b)	
	nop
.end_macro
