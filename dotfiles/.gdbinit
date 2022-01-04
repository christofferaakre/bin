set $64BITS = 1

set confirm off
set verbose off
set prompt \033[31mgdb$ \033[0m

set output-radix 0x10
set input-radix 0x10

# These make gdb never pause in its output
set height 0
set width 0

# Display instructions in Intel format
set disassembly-flavor intel

define 32bits
	set $64BITS = 0
end
document 32bits
Set gdb to work with 32bits binaries
end

define 64bits
	set $64BITS = 1
end
document 64bits
Set gdb to work with 64bits binaries
end

define stack
    info stack
end

define logcmd
  if $argc >= 2
    set logging on
    set logging file $arg0 # <-- does this guy need to be quoted?
    set logging overwrite on
    set logging redirect on
    set $n = 1
    while $n < $argc
      eval "$arg%d", $n
      set $n = $n + 1
    end
    set logging off
  end
end

define reg
   if $argc == 0
       info registers
   end
   set $n = 0
   while $n < $argc
       eval "info registers $arg%d", $n
       set $n = $n + 1
    end
end

# dissaesembly alias
define dis
    if $argc == 0
        disassemble
    end
    if $argc == 1
        disassemble $arg0
    end
    if $argc == 2
        disassemble $arg0 $arg1
    end
    if $argc > 2
        help dis
    end
end
document dis
Disassemble a specified section of memory.
Default is to disassemble the function surrounding the PC (program counter)
of selected frame. With one argument, ADDR1, the function surrounding this
address is dumped. Two arguments are taken as a range of memory to dump.
Usage: dis <ADDR1> <ADDR2>
end

define hook-stop
    disassemble
end

define newline
    printf "\n"
end

define half-banner
    printf "----------------------"
end

define banner
   newline
   half-banner
   printf $arg0
   half-banner
   newline
end


define flags
# OF (overflow) flag
    if (($eflags >> 0xB) & 1)
        printf "O "
        set $_of_flag = 1
    else
        printf "o "
        set $_of_flag = 0
    end
    if (($eflags >> 0xA) & 1)
        printf "D "
    else
        printf "d "
    end
    if (($eflags >> 9) & 1)
        printf "I "
    else
        printf "i "
    end
    if (($eflags >> 8) & 1)
        printf "T "
    else
        printf "t "
    end
# SF (sign) flag
    if (($eflags >> 7) & 1)
        printf "S "
        set $_sf_flag = 1
    else
        printf "s "
        set $_sf_flag = 0
    end
# ZF (zero) flag
    if (($eflags >> 6) & 1)
        printf "Z "
	set $_zf_flag = 1
    else
        printf "z "
	set $_zf_flag = 0
    end
    if (($eflags >> 4) & 1)
        printf "A "
    else
        printf "a "
    end
# PF (parity) flag
    if (($eflags >> 2) & 1)
        printf "P "
	set $_pf_flag = 1
    else
        printf "p "
	set $_pf_flag = 0
    end
# CF (carry) flag
    if ($eflags & 1)
        printf "C "
	set $_cf_flag = 1
    else
        printf "c "
	set $_cf_flag = 0
    end
    printf "\n"
end
document flags
Print flags register.
end

define eflags
    printf "     OF <%d>  DF <%d>  IF <%d>  TF <%d>",\
           (($eflags >> 0xB) & 1), (($eflags >> 0xA) & 1), \
           (($eflags >> 9) & 1), (($eflags >> 8) & 1)
    printf "  SF <%d>  ZF <%d>  AF <%d>  PF <%d>  CF <%d>\n",\
           (($eflags >> 7) & 1), (($eflags >> 6) & 1),\
           (($eflags >> 4) & 1), (($eflags >> 2) & 1), ($eflags & 1)
    printf "     ID <%d>  VIP <%d> VIF <%d> AC <%d>",\
           (($eflags >> 0x15) & 1), (($eflags >> 0x14) & 1), \
           (($eflags >> 0x13) & 1), (($eflags >> 0x12) & 1)
    printf "  VM <%d>  RF <%d>  NT <%d>  IOPL <%d>\n",\
           (($eflags >> 0x11) & 1), (($eflags >> 0x10) & 1),\
           (($eflags >> 0xE) & 1), (($eflags >> 0xC) & 3)
end
document eflags
Print eflags register.
end

# __________hex/ascii dump an address_________
define ascii_char
    if $argc != 1
        help ascii_char
    else
        # thanks elaine :)
        set $_c = *(unsigned char *)($arg0)
        if ($_c < 0x20 || $_c > 0x7E)
            printf "."
        else
            printf "%c", $_c
        end
    end
end
document ascii_char
Print ASCII value of byte at address ADDR.
Print "." if the value is unprintable.
Usage: ascii_char ADDR
end

define hex_quad
    if $argc != 1
        help hex_quad
    else
        printf "%02X %02X %02X %02X %02X %02X %02X %02X", \
               *(unsigned char*)($arg0), *(unsigned char*)($arg0 + 1),     \
               *(unsigned char*)($arg0 + 2), *(unsigned char*)($arg0 + 3), \
               *(unsigned char*)($arg0 + 4), *(unsigned char*)($arg0 + 5), \
               *(unsigned char*)($arg0 + 6), *(unsigned char*)($arg0 + 7)
    end
end
document hex_quad
Print eight hexadecimal bytes starting at address ADDR.
Usage: hex_quad ADDR
end

define hexdump
    if $argc != 1
        help hexdump
    else
        echo \033[1m
        if ($64BITS == 1)
         printf "0x%016lX : ", $arg0
        else
         printf "0x%08X : ", $arg0
        end
        echo \033[0m
        hex_quad $arg0
        echo \033[1m
        printf " - "
        echo \033[0m
        hex_quad $arg0+8
        printf " "
        echo \033[1m
        ascii_char $arg0+0x0
        ascii_char $arg0+0x1
        ascii_char $arg0+0x2
        ascii_char $arg0+0x3
        ascii_char $arg0+0x4
        ascii_char $arg0+0x5
        ascii_char $arg0+0x6
        ascii_char $arg0+0x7
        ascii_char $arg0+0x8
        ascii_char $arg0+0x9
        ascii_char $arg0+0xA
        ascii_char $arg0+0xB
        ascii_char $arg0+0xC
        ascii_char $arg0+0xD
        ascii_char $arg0+0xE
        ascii_char $arg0+0xF
        echo \033[0m
        printf "\n"
    end
end
document hexdump
Display a 16-byte hex/ASCII dump of memory at address ADDR.
Usage: hexdump ADDR
end

# _______________data window__________________
define ddump
    if $argc != 1
        help ddump
    else
        echo \033[34m
        if ($64BITS == 1)
         printf "[0x%04X:0x%016lX]", $ds, $data_addr
        else
         printf "[0x%04X:0x%08X]", $ds, $data_addr
        end
	echo \033[34m
	printf "------------------------"
    printf "-------------------------------"
    if ($64BITS == 1)
     printf "-------------------------------------"
	end

	echo \033[1;34m
	printf "[data]\n"
        echo \033[0m
        set $_count = 0
        while ($_count < $arg0)
            set $_i = ($_count * 0x10)
            hexdump $data_addr+$_i
            set $_count++
        end
    end
end
document ddump
Display NUM lines of hexdump for address in $data_addr global variable.
Usage: ddump NUM
end

define dd
    if $argc != 1
        help dd
    else
        if ((($arg0 >> 0x18) == 0x40) || (($arg0 >> 0x18) == 0x08) || (($arg0 >> 0x18) == 0xBF))
            set $data_addr = $arg0
            ddump 0x10
        else
            printf "Invalid address: %08X\n", $arg0
        end
    end
end
document dd
Display 16 lines of a hex dump of address starting at ADDR.
Usage: dd ADDR
end

define datawin
 if ($64BITS == 1)
    if ((($rsi >> 0x18) == 0x40) || (($rsi >> 0x18) == 0x08) || (($rsi >> 0x18) == 0xBF))
        set $data_addr = $rsi
    else
        if ((($rdi >> 0x18) == 0x40) || (($rdi >> 0x18) == 0x08) || (($rdi >> 0x18) == 0xBF))
            set $data_addr = $rdi
        else
            if ((($rax >> 0x18) == 0x40) || (($rax >> 0x18) == 0x08) || (($rax >> 0x18) == 0xBF))
                set $data_addr = $rax
            else
                set $data_addr = $rsp
            end
        end
    end

 else
    if ((($esi >> 0x18) == 0x40) || (($esi >> 0x18) == 0x08) || (($esi >> 0x18) == 0xBF))
        set $data_addr = $esi
    else
        if ((($edi >> 0x18) == 0x40) || (($edi >> 0x18) == 0x08) || (($edi >> 0x18) == 0xBF))
            set $data_addr = $edi
        else
            if ((($eax >> 0x18) == 0x40) || (($eax >> 0x18) == 0x08) || (($eax >> 0x18) == 0xBF))
                set $data_addr = $eax
            else
                set $data_addr = $esp
            end
        end
    end
 end
    ddump $CONTEXTSIZE_DATA
end
document datawin
Display valid address from one register in data window.
Registers to choose are: esi, edi, eax, or esp.
end

################################
##### ALERT ALERT ALERT ########
################################
# Huge mess going here :) HAHA #
################################
define dumpjump
## grab the first two bytes from the instruction so we can determine the jump instruction
 set $_byte1 = *(unsigned char *)$pc
 set $_byte2 = *(unsigned char *)($pc+1)
## and now check what kind of jump we have (in case it's a jump instruction)
## I changed the flags routine to save the flag into a variable, so we don't need to repeat the process :) (search for "define flags")

## opcode 0x77: JA, JNBE (jump if CF=0 and ZF=0)
## opcode 0x0F87: JNBE, JA
 if ( ($_byte1 == 0x77) || ($_byte1 == 0x0F && $_byte2 == 0x87) )
 	# cf=0 and zf=0
 	if ($_cf_flag == 0 && $_zf_flag == 0)
		echo \033[31m
   		printf "  Jump is taken (c=0 and z=0)"
  	else
	# cf != 0 or zf != 0
   		echo \033[31m
   		printf "  Jump is NOT taken (c!=0 or z!=0)"
  	end
 end

## opcode 0x73: JAE, JNB, JNC (jump if CF=0)
## opcode 0x0F83: JNC, JNB, JAE (jump if CF=0)
 if ( ($_byte1 == 0x73) || ($_byte1 == 0x0F && $_byte2 == 0x83) )
 	# cf=0
 	if ($_cf_flag == 0)
		echo \033[31m
   		printf "  Jump is taken (c=0)"
  	else
	# cf != 0
   		echo \033[31m
   		printf "  Jump is NOT taken (c!=0)"
  	end
 end

## opcode 0x72: JB, JC, JNAE (jump if CF=1)
## opcode 0x0F82: JNAE, JB, JC
 if ( ($_byte1 == 0x72) || ($_byte1 == 0x0F && $_byte2 == 0x82) )
 	# cf=1
 	if ($_cf_flag == 1)
		echo \033[31m
   		printf "  Jump is taken (c=1)"
  	else
	# cf != 1
   		echo \033[31m
   		printf "  Jump is NOT taken (c!=1)"
  	end
 end

## opcode 0x76: JBE, JNA (jump if CF=1 or ZF=1)
## opcode 0x0F86: JBE, JNA
 if ( ($_byte1 == 0x76) || ($_byte1 == 0x0F && $_byte2 == 0x86) )
 	# cf=1 or zf=1
 	if (($_cf_flag == 1) || ($_zf_flag == 1))
		echo \033[31m
   		printf "  Jump is taken (c=1 or z=1)"
  	else
	# cf != 1 or zf != 1
   		echo \033[31m
   		printf "  Jump is NOT taken (c!=1 or z!=1)"
  	end
 end

## opcode 0xE3: JCXZ, JECXZ, JRCXZ (jump if CX=0 or ECX=0 or RCX=0)
 if ($_byte1 == 0xE3)
 	# cx=0 or ecx=0
 	if (($ecx == 0) || ($cx == 0))
		echo \033[31m
   		printf "  Jump is taken (cx=0 or ecx=0)"
  	else
	#
   		echo \033[31m
   		printf "  Jump is NOT taken (cx!=0 or ecx!=0)"
  	end
 end

## opcode 0x74: JE, JZ (jump if ZF=1)
## opcode 0x0F84: JZ, JE, JZ (jump if ZF=1)
 if ( ($_byte1 == 0x74) || ($_byte1 == 0x0F && $_byte2 == 0x84) )
 # ZF = 1
  	if ($_zf_flag == 1)
   		echo \033[31m
   		printf "  Jump is taken (z=1)"
  	else
 # ZF = 0
   		echo \033[31m
   		printf "  Jump is NOT taken (z!=1)"
  	end
 end

## opcode 0x7F: JG, JNLE (jump if ZF=0 and SF=OF)
## opcode 0x0F8F: JNLE, JG (jump if ZF=0 and SF=OF)
 if ( ($_byte1 == 0x7F) || ($_byte1 == 0x0F && $_byte2 == 0x8F) )
 # zf = 0 and sf = of
  	if (($_zf_flag == 0) && ($_sf_flag == $_of_flag))
   		echo \033[31m
   		printf "  Jump is taken (z=0 and s=o)"
  	else
 #
   		echo \033[31m
   		printf "  Jump is NOT taken (z!=0 or s!=o)"
  	end
 end

## opcode 0x7D: JGE, JNL (jump if SF=OF)
## opcode 0x0F8D: JNL, JGE (jump if SF=OF)
 if ( ($_byte1 == 0x7D) || ($_byte1 == 0x0F && $_byte2 == 0x8D) )
 # sf = of
  	if ($_sf_flag == $_of_flag)
   		echo \033[31m
   		printf "  Jump is taken (s=o)"
  	else
 #
   		echo \033[31m
   		printf "  Jump is NOT taken (s!=o)"
  	end
 end

## opcode: 0x7C: JL, JNGE (jump if SF != OF)
## opcode: 0x0F8C: JNGE, JL (jump if SF != OF)
 if ( ($_byte1 == 0x7C) || ($_byte1 == 0x0F && $_byte2 == 0x8C) )
 # sf != of
  	if ($_sf_flag != $_of_flag)
   		echo \033[31m
   		printf "  Jump is taken (s!=o)"
  	else
 #
   		echo \033[31m
   		printf "  Jump is NOT taken (s=o)"
  	end
 end

## opcode 0x7E: JLE, JNG (jump if ZF = 1 or SF != OF)
## opcode 0x0F8E: JNG, JLE (jump if ZF = 1 or SF != OF)
 if ( ($_byte1 == 0x7E) || ($_byte1 == 0x0F && $_byte2 == 0x8E) )
 # zf = 1 or sf != of
  	if (($_zf_flag == 1) || ($_sf_flag != $_of_flag))
   		echo \033[31m
   		printf "  Jump is taken (zf=1 or sf!=of)"
  	else
 #
   		echo \033[31m
   		printf "  Jump is NOT taken (zf!=1 or sf=of)"
  	end
 end

## opcode 0x75: JNE, JNZ (jump if ZF = 0)
## opcode 0x0F85: JNE, JNZ (jump if ZF = 0)
 if ( ($_byte1 == 0x75) || ($_byte1 == 0x0F && $_byte2 == 0x85) )
 # ZF = 0
  	if ($_zf_flag == 0)
   		echo \033[31m
   		printf "  Jump is taken (z=0)"
  	else
 # ZF = 1
   		echo \033[31m
   		printf "  Jump is NOT taken (z!=0)"
  	end
 end

## opcode 0x71: JNO (OF = 0)
## opcode 0x0F81: JNO (OF = 0)
 if ( ($_byte1 == 0x71) || ($_byte1 == 0x0F && $_byte2 == 0x81) )
 # OF = 0
	if ($_of_flag == 0)
   		echo \033[31m
   		printf "  Jump is taken (o=0)"
	else
 # OF != 0
   		echo \033[31m
   		printf "  Jump is NOT taken (o!=0)"
  	end
 end

## opcode 0x7B: JNP, JPO (jump if PF = 0)
## opcode 0x0F8B: JPO (jump if PF = 0)
 if ( ($_byte1 == 0x7B) || ($_byte1 == 0x0F && $_byte2 == 0x8B) )
 # PF = 0
  	if ($_pf_flag == 0)
   		echo \033[31m
   		printf "  Jump is NOT taken (p=0)"
  	else
 # PF != 0
   		echo \033[31m
   		printf "  Jump is taken (p!=0)"
  	end
 end

## opcode 0x79: JNS (jump if SF = 0)
## opcode 0x0F89: JNS (jump if SF = 0)
 if ( ($_byte1 == 0x79) || ($_byte1 == 0x0F && $_byte2 == 0x89) )
 # SF = 0
  	if ($_sf_flag == 0)
   		echo \033[31m
   		printf "  Jump is taken (s=0)"
  	else
 # SF != 0
   		echo \033[31m
   		printf "  Jump is NOT taken (s!=0)"
  	end
 end

## opcode 0x70: JO (jump if OF=1)
## opcode 0x0F80: JO (jump if OF=1)
 if ( ($_byte1 == 0x70) || ($_byte1 == 0x0F && $_byte2 == 0x80) )
 # OF = 1
	if ($_of_flag == 1)
		echo \033[31m
   		printf "  Jump is taken (o=1)"
  	else
 # OF != 1
   		echo \033[31m
   		printf "  Jump is NOT taken (o!=1)"
  	end
 end

## opcode 0x7A: JP, JPE (jump if PF=1)
## opcode 0x0F8A: JP, JPE (jump if PF=1)
 if ( ($_byte1 == 0x7A) || ($_byte1 == 0x0F && $_byte2 == 0x8A) )
 # PF = 1
  	if ($_pf_flag == 1)
   		echo \033[31m
   		printf "  Jump is taken (p=1)"
  	else
 # PF = 0
   		echo \033[31m
   		printf "  Jump is NOT taken (p!=1)"
  	end
 end

## opcode 0x78: JS (jump if SF=1)
## opcode 0x0F88: JS (jump if SF=1)
 if ( ($_byte1 == 0x78) || ($_byte1 == 0x0F && $_byte2 == 0x88) )
 # SF = 1
	if ($_sf_flag == 1)
   		echo \033[31m
   		printf "  Jump is taken (s=1)"
  	else
 # SF != 1
   		echo \033[31m
   		printf "  Jump is NOT taken (s!=1)"
  	end
 end

# end of dumpjump function
end
document dumpjump
Display if conditional jump will be taken or not
end

# _______________eflags commands______________
define cfc
    if ($eflags & 1)
        set $eflags = $eflags&~0x1
    else
        set $eflags = $eflags|0x1
    end
end
document cfc
Change Carry Flag.
end

define cfp
    if (($eflags >> 2) & 1)
        set $eflags = $eflags&~0x4
    else
        set $eflags = $eflags|0x4
    end
end
document cfp
Change Parity Flag.
end

define cfa
    if (($eflags >> 4) & 1)
        set $eflags = $eflags&~0x10
    else
        set $eflags = $eflags|0x10
    end
end
document cfa
Change Auxiliary Carry Flag.
end

define cfz
    if (($eflags >> 6) & 1)
        set $eflags = $eflags&~0x40
    else
        set $eflags = $eflags|0x40
    end
end
document cfz
Change Zero Flag.
end

define cfs
    if (($eflags >> 7) & 1)
        set $eflags = $eflags&~0x80
    else
        set $eflags = $eflags|0x80
    end
end
document cfs
Change Sign Flag.
end

define cft
    if (($eflags >>8) & 1)
        set $eflags = $eflags&~0x100
    else
        set $eflags = $eflags|0x100
    end
end
document cft
Change Trap Flag.
end

define cfi
    if (($eflags >> 9) & 1)
        set $eflags = $eflags&~0x200
    else
        set $eflags = $eflags|0x200
    end
end
document cfi
Change Interrupt Flag.
Only privileged applications (usually the OS kernel) may modify IF.
This only applies to protected mode (real mode code may always modify IF).
end

define cfd
    if (($eflags >>0xA) & 1)
        set $eflags = $eflags&~0x400
    else
        set $eflags = $eflags|0x400
    end
end
document cfd
Change Direction Flag.
end

define cfo
    if (($eflags >> 0xB) & 1)
        set $eflags = $eflags&~0x800
    else
        set $eflags = $eflags|0x800
    end
end
document cfo
Change Overflow Flag.
end

# ____________________patch___________________
define nop
    if ($argc > 2 || $argc == 0)
        help nop
    end

    if ($argc == 1)
    	set *(unsigned char *)$arg0 = 0x90
    else
	set $addr = $arg0
	while ($addr < $arg1)
		set *(unsigned char *)$addr = 0x90
		set $addr = $addr + 1
	end
    end
end
document nop
Usage: nop ADDR1 [ADDR2]
Patch a single byte at address ADDR1, or a series of bytes between ADDR1 and ADDR2 to a NOP (0x90) instruction.

end

define null
    if ( $argc >2 || $argc == 0)
        help null
    end

    if ($argc == 1)
	set *(unsigned char *)$arg0 = 0
    else
	set $addr = $arg0
	while ($addr < $arg1)
	        set *(unsigned char *)$addr = 0
		set $addr = $addr +1
	end
    end
end
document null
Usage: null ADDR1 [ADDR2]
Patch a single byte at address ADDR1 to NULL (0x00), or a series of bytes between ADDR1 and ADDR2.

end

define int3
    if $argc != 1
        help int3
    else
        set *(unsigned char *)$arg0 = 0xCC
    end
end
document int3
Patch byte at address ADDR to an INT3 (0xCC) instruction.
Usage: int3 ADDR
end

# ____________________cflow___________________
define print_insn_type
    if $argc != 1
        help print_insn_type
    else
        if ($arg0 < 0 || $arg0 > 5)
            printf "UNDEFINED/WRONG VALUE"
        end
        if ($arg0 == 0)
            printf "UNKNOWN"
        end
        if ($arg0 == 1)
            printf "JMP"
        end
        if ($arg0 == 2)
            printf "JCC"
        end
        if ($arg0 == 3)
            printf "CALL"
        end
        if ($arg0 == 4)
            printf "RET"
        end
        if ($arg0 == 5)
            printf "INT"
        end
    end
end
document print_insn_type
Print human-readable mnemonic for the instruction type (usually $INSN_TYPE).
Usage: print_insn_type INSN_TYPE_NUMBER
end

define get_insn_type
    if $argc != 1
        help get_insn_type
    else
        set $INSN_TYPE = 0
        set $_byte1 = *(unsigned char *)$arg0
        if ($_byte1 == 0x9A || $_byte1 == 0xE8)
            # "call"
            set $INSN_TYPE = 3
        end
        if ($_byte1 >= 0xE9 && $_byte1 <= 0xEB)
            # "jmp"
            set $INSN_TYPE = 1
        end
        if ($_byte1 >= 0x70 && $_byte1 <= 0x7F)
            # "jcc"
            set $INSN_TYPE = 2
        end
        if ($_byte1 >= 0xE0 && $_byte1 <= 0xE3 )
            # "jcc"
            set $INSN_TYPE = 2
        end
        if ($_byte1 == 0xC2 || $_byte1 == 0xC3 || $_byte1 == 0xCA || \
            $_byte1 == 0xCB || $_byte1 == 0xCF)
            # "ret"
            set $INSN_TYPE = 4
        end
        if ($_byte1 >= 0xCC && $_byte1 <= 0xCE)
            # "int"
            set $INSN_TYPE = 5
        end
        if ($_byte1 == 0x0F )
            # two-byte opcode
            set $_byte2 = *(unsigned char *)($arg0 + 1)
            if ($_byte2 >= 0x80 && $_byte2 <= 0x8F)
                # "jcc"
                set $INSN_TYPE = 2
            end
        end
        if ($_byte1 == 0xFF)
            # opcode extension
            set $_byte2 = *(unsigned char *)($arg0 + 1)
            set $_opext = ($_byte2 & 0x38)
            if ($_opext == 0x10 || $_opext == 0x18)
                # "call"
                set $INSN_TYPE = 3
            end
            if ($_opext == 0x20 || $_opext == 0x28)
                # "jmp"
                set $INSN_TYPE = 1
            end
        end
    end
end
document get_insn_type
Recognize instruction type at address ADDR.
Take address ADDR and set the global $INSN_TYPE variable to
0, 1, 2, 3, 4, 5 if the instruction at that address is
unknown, a jump, a conditional jump, a call, a return, or an interrupt.
Usage: get_insn_type ADDR
end

define step_to_call
    set $_saved_ctx = $SHOW_CONTEXT
    set $SHOW_CONTEXT = 0
    set $SHOW_NEST_INSN = 0

    set logging file /dev/null
    set logging redirect on
    set logging on

    set $_cont = 1
    while ($_cont > 0)
        stepi
        get_insn_type $pc
        if ($INSN_TYPE == 3)
            set $_cont = 0
        end
    end

    set logging off

    if ($_saved_ctx > 0)
        context
    end

    set $SHOW_CONTEXT = $_saved_ctx
    set $SHOW_NEST_INSN = 0

    set logging file ~/gdb.txt
    set logging redirect off
    set logging on

    printf "step_to_call command stopped at:\n  "
    x/i $pc
    printf "\n"
    set logging off

end
document step_to_call
Single step until a call instruction is found.
Stop before the call is taken.
Log is written into the file ~/gdb.txt.
end

define trace_calls

    printf "Tracing...please wait...\n"

    set $_saved_ctx = $SHOW_CONTEXT
    set $SHOW_CONTEXT = 0
    set $SHOW_NEST_INSN = 0
    set $_nest = 1
    set listsize 0

    set logging overwrite on
    set logging file ~/gdb_trace_calls.txt
    set logging on
    set logging off
    set logging overwrite off

    while ($_nest > 0)
        get_insn_type $pc
        # handle nesting
        if ($INSN_TYPE == 3)
            set $_nest = $_nest + 1
        else
            if ($INSN_TYPE == 4)
                set $_nest = $_nest - 1
            end
        end
        # if a call, print it
        if ($INSN_TYPE == 3)
            set logging file ~/gdb_trace_calls.txt
            set logging redirect off
            set logging on

            set $x = $_nest - 2
            while ($x > 0)
                printf "\t"
                set $x = $x - 1
            end
            x/i $pc
        end

        set logging off
        set logging file /dev/null
        set logging redirect on
        set logging on
        stepi
        set logging redirect off
        set logging off
    end

    set $SHOW_CONTEXT = $_saved_ctx
    set $SHOW_NEST_INSN = 0

    printf "Done, check ~/gdb_trace_calls.txt\n"
end
document trace_calls
Create a runtime trace of the calls made by target.
Log overwrites(!) the file ~/gdb_trace_calls.txt.
end

define trace_run

    printf "Tracing...please wait...\n"

    set $_saved_ctx = $SHOW_CONTEXT
    set $SHOW_CONTEXT = 0
    set $SHOW_NEST_INSN = 1
    set logging overwrite on
    set logging file ~/gdb_trace_run.txt
    set logging redirect on
    set logging on
    set $_nest = 1

    while ( $_nest > 0 )

        get_insn_type $pc
        # jmp, jcc, or cll
        if ($INSN_TYPE == 3)
            set $_nest = $_nest + 1
        else
            # ret
            if ($INSN_TYPE == 4)
                set $_nest = $_nest - 1
            end
        end
        stepi
    end

    printf "\n"

    set $SHOW_CONTEXT = $_saved_ctx
    set $SHOW_NEST_INSN = 0
    set logging redirect off
    set logging off

    # clean up trace file
    shell  grep -v ' at ' ~/gdb_trace_run.txt > ~/gdb_trace_run.1
    shell  grep -v ' in ' ~/gdb_trace_run.1 > ~/gdb_trace_run.txt
    shell  rm -f ~/gdb_trace_run.1
    printf "Done, check ~/gdb_trace_run.txt\n"
end
document trace_run
Create a runtime trace of target.
Log overwrites(!) the file ~/gdb_trace_run.txt.
end

# ____________________misc____________________

define dump_hexfile
    dump ihex memory $arg0 $arg1 $arg2
end
document dump_hexfile
Write a range of memory to a file in Intel ihex (hexdump) format.
The range is specified by ADDR1 and ADDR2 addresses.
Usage: dump_hexfile FILENAME ADDR1 ADDR2
end

define dump_binfile
    dump memory $arg0 $arg1 $arg2
end
document dump_binfile
Write a range of memory to a binary file.
The range is specified by ADDR1 and ADDR2 addresses.
Usage: dump_binfile FILENAME ADDR1 ADDR2
end


