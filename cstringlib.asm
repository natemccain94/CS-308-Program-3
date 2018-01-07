; Nate McCain
; Assembly Program 3

.586
.MODEL FLAT

.DATA
tempBinBuf BYTE 255 DUP(?)	; This is used for the binToHexStr and hexStrToBin functions.

; Table for binary strings
zeroBin BYTE "0000",0
oneBin BYTE "0001", 0
twoBin BYTE "0010", 0
threeBin BYTE "0011", 0
fourBin BYTE "0100", 0
fiveBin BYTE "0101", 0
sixBin BYTE "0110", 0
sevenBin BYTE "0111", 0
eightBin BYTE "1000", 0
nineBin BYTE "1001", 0
tenBin BYTE "1010", 0
elevenBin BYTE "1011", 0
twelveBin BYTE "1100", 0
thirteenBin BYTE "1101", 0
fourteenBin BYTE "1110", 0
fifteenBin BYTE "1111", 0

; table for hex characters
zeroHex BYTE "0",0
oneHex BYTE "1", 0
twoHex BYTE "2", 0
threeHex BYTE "3", 0
fourHex BYTE "4", 0
fiveHex BYTE "5", 0
sixHex BYTE "6", 0
sevenHex BYTE "7", 0
eightHex BYTE "8", 0
nineHex BYTE "9", 0
tenHex BYTE "a", 0
elevenHex BYTE "b", 0
twelveHex BYTE "c", 0
thirteenHex BYTE "d", 0
fourteenHex BYTE "e", 0
fifteenHex BYTE "f", 0



.CODE
;**************************************************************************************
; Requirement 1
; void strcopyx(char* a, const char* b, int a_len)
; Copy the string 'b' to 'a' and use "a_len" as an argument to
; prevent buffer overflow.
_strcopyx PROC
	push ebp
	mov ebp, esp
	push esi
	push edi
	push eax
	pushf

	mov eax, [ebp + 16]; holds the buffer length
	mov esi, [ebp + 12]; holds char* b
	mov edi, [ebp + 8]; holds char* a
	cld	; Clear the Directional Flag

whileNotOver:
	cmp eax, 0	; Exit if at the end of the buffer
	je exitCode
	cmp BYTE PTR [esi], 0	; Exit if at the end of char* b
	je exitCode
	movsb	; copy 1B from ESI to EDI and increment both 1B
	dec eax	; decrement the buffer counter
	jmp whileNotOver

exitCode:
	mov BYTE PTR [edi], 0 ; This can make sure that the string will be replaced, not just the substring.
	popf
	pop eax
	pop edi
	pop esi
	pop ebp
	ret

_strcopyx ENDP
;**************************************************************************************
; Requirement 2
; void strncopyx(char* a, const char* b, int b_len, int a_len)
; Copy the string 'b' to 'a.' "b_len" defines the number of characters
; to copy and "a_len" is the argument to prevent buffer overflow.
_strncopyx PROC
	push ebp
	mov ebp, esp
	push eax
	push ebx
	push esi
	push edi
	pushf

	mov edi, [ebp + 8]	; Holds char* a
	mov esi, [ebp + 12]	; Holds char* b
	mov ebx, [ebp + 16]	; Holds int b_len
	mov eax, [ebp + 20]	; Holds int a_len
	cld
	
doTheWork:
	cmp eax, 0	; exit if at the end of the buffer
	je exitCode
	cmp ebx, 0	; exit if finished copying char* b
	je exitCode
	movsb	; Copy 1B of ESI to EDI and increment both
	dec eax	; decrement buffer counter
	dec ebx ; decrement b_len counter
	jmp doTheWork

exitCode:
	mov BYTE PTR [edi], 0 ;This can make sure that the string will be replaced, not just the substring.
	popf
	pop edi
	pop esi
	pop ebx
	pop eax
	pop ebp
	ret

_strncopyx ENDP
;**************************************************************************************
; Requirement 3
; void strcatx(char* a, const char* b, int a_len)
; Concatenate the string 'b' to 'a' and provide "a_len" as an argument
; to prevent buffer overflow.
_strcatx PROC
	push ebp
	mov ebp, esp
	push eax
	push esi
	push edi
	pushf

	mov edi, [ebp + 8]	; Holds char* a
	mov esi, [ebp + 12]	; Holds char* b
	mov eax, [ebp + 16]	; Holds int a_len
	cld
	
getToEndOfA:
	cmp eax, 0	; exit if at the end of the buffer
	je exitCode
	cmp BYTE PTR [edi], 0	; begin to put char* b on the end of char* a
	je bConcatToA
	add edi, 1	; increment edi
	dec eax ; decrement the buffer counter
	jmp getToEndOfA

bConcatToA:
	cmp eax, 0 ; exit if at the end of the buffer
	je exitCode
	cmp BYTE PTR [esi], 0	; exit if at the null char of char* b is reached
	je exitCode
	movsb	; put 1B from ESI to EDI
	dec eax
	jmp bConcatToA

exitCode:
	mov BYTE PTR [edi], 0
	popf
	pop edi
	pop esi
	pop eax
	pop ebp
	ret

_strcatx ENDP
;**************************************************************************************
; Requirement 4
; void binToHexStr(unsigned char* binbuf, int binbuf_len, char* strbuf, int strbuf_len)
; This procedure will input a binary buffer and produce a hex string in "strbuf."
_binToHexStr PROC
	push ebp
	mov ebp, esp
	push eax
	push ebx
	push ecx
	push edx
	push esi
	push edi
	pushf

	mov esi, [ebp + 8]		; holds unsigned char* binbuf
	mov eax, [ebp + 12]		; holds int binbuf_len
	lea edi, tempBinBuf		; the empty string meant to be in a sequence.
	cld
	mov edx, 0				; count of how many sequences there are

outerCounter:
; Find how many times 4 goes into binbuf_len
	cmp eax, 4
	jl endOfCounting
	inc edx
	sub eax, 4
	jmp outerCounter

endOfCounting:
	cmp eax, 0
	je storeSequenceCountInEAX	; jump here if the number of digits in char* binbuf is divisible by 4
	jmp addExtraCharactersSetup ; jump here if the number of digits in char* binbuf is not divisible by 4

storeSequenceCountInEAX:
; Make eax hold the number of sequences of 4 digits in char* binbuf
	mov eax, edx
	jmp doNotAddExtraCharactersTwo

addExtraCharactersSetup:
; eax = 4 - eax
	mov ecx, eax
	mov eax, 4
	sub eax, ecx
	jmp addExtraCharacters

addExtraCharacters:
; add as many extra characters into temp as needed to make the number of digits in binbuf to be divisible by 4
	cmp eax, 0
	je doNotAddExtraCharactersOne
	mov BYTE PTR [edi], '0'
	inc edi
	dec eax
	jmp addExtraCharacters

doNotAddExtraCharactersOne:
; Move the count for the number of sequences of 4 digits from edx to eax
	inc edx
	mov eax, edx	
	jmp doNotAddExtraCharactersTwo

doNotAddExtraCharactersTwo:
; Begin to move char* binbuf into temp
; Remember that temp is in edi.
; edx holds the number of sequences of 4 digits
	cmp edx, 0
	je almostEndOfFirstParse
	movsd
	dec edx
	jmp doNotAddExtraCharactersTwo

almostEndOfFirstParse:
	mov BYTE PTR [edi], 0	; Make sure the last char of tempBinBuf is the null char
	jmp endOfFirstParse

endOfFirstParse:
; ESI holds tempBinBuf, which has the Binary String that is divisible by 4.
; eax holds the # of sequences to check
; ebx holds strbuf_len 
; edx holds strbuf
; edi will be used for comparators
	mov edx, [ebp + 16]
	mov ebx, [ebp + 20]
	lea esi, tempBinBuf
	jmp conversionFunction

conversionFunction:
	cmp eax, 0 ; exit if at the end of the sequences of 4 binary digits
	je exitCode
	cmp ebx, 0	; exit if at the end of the str buffer
	je exitCode
; Each of the following sets of 4 instructions tries to match the current ESI section to a string in our data section.
; When a match is found, the program jumps to the branch that puts the necessary hex string values into hexStr.
	lea edi, zeroBin
	cmpsd 
	je addZero
	sub esi, 4

	lea edi, oneBin
	cmpsd
	je addOne
	sub esi, 4

	lea edi, twoBin
	cmpsd
	je addTwo
	sub esi, 4

	lea edi, threeBin
	cmpsd
	je addThree
	sub esi, 4

	lea edi, fourBin
	cmpsd
	je addFour
	sub esi, 4

	lea edi, fiveBin
	cmpsd
	je addFive
	sub esi, 4

	lea edi, sixBin
	cmpsd
	je addSix
	sub esi, 4

	lea edi, sevenBin
	cmpsd
	je addSeven
	sub esi, 4

	lea edi, eightBin
	cmpsd
	je addEight
	sub esi, 4

	lea edi, nineBin
	cmpsd
	je addNine
	sub esi, 4

	lea edi, tenBin
	cmpsd
	je addA
	sub esi, 4

	lea edi, elevenBin
	cmpsd
	je addB
	sub esi, 4

	lea edi, twelveBin
	cmpsd
	je addC
	sub esi, 4

	lea edi, thirteenBin
	cmpsd
	je addD
	sub esi, 4

	lea edi, fourteenBin
	cmpsd
	je addE
	jmp addF

; The following branches put the matching binary sequence into hex form in hexStr.
addZero:
	dec eax
	dec ebx
	mov BYTE PTR [edx], '0'
	inc edx
	jmp conversionFunction
addOne:
	dec eax
	dec ebx
	mov BYTE PTR [edx], '1'
	inc edx
	jmp conversionFunction
addTwo:
	dec eax
	dec ebx
	mov BYTE PTR [edx], '2'
	inc edx
	jmp conversionFunction
addThree:
	dec eax
	dec ebx
	mov BYTE PTR [edx], '3'
	inc edx
	jmp conversionFunction
addFour:
	dec eax
	dec ebx
	mov BYTE PTR [edx], '4'
	inc edx
	jmp conversionFunction
addFive:
	dec eax
	dec ebx
	mov BYTE PTR [edx], '5'
	inc edx
	jmp conversionFunction
addSix:
	dec eax
	dec ebx
	mov BYTE PTR [edx], '6'
	inc edx
	jmp conversionFunction
addSeven:
	dec eax
	dec ebx
	mov BYTE PTR [edx], '7'
	inc edx
	jmp conversionFunction
addEight:
	dec eax
	dec ebx
	mov BYTE PTR [edx], '8'
	inc edx
	jmp conversionFunction
addNine:
	dec eax
	dec ebx
	mov BYTE PTR [edx], '9'
	inc edx
	jmp conversionFunction
addA:
	dec eax
	dec ebx
	mov BYTE PTR [edx], 'a'
	inc edx
	jmp conversionFunction
addB:
	dec eax
	dec ebx
	mov BYTE PTR [edx], 'b'
	inc edx
	jmp conversionFunction
addC:
	dec eax
	dec ebx
	mov BYTE PTR [edx], 'c'
	inc edx
	jmp conversionFunction
addD:
	dec eax
	dec ebx
	mov BYTE PTR [edx], 'd'
	inc edx
	jmp conversionFunction
addE:
	dec eax
	dec ebx
	mov BYTE PTR [edx], 'e'
	inc edx
	jmp conversionFunction
addF:
	dec eax
	dec ebx
	mov BYTE PTR [edx], 'f'
	inc edx
	jmp conversionFunction

exitCode:
	mov BYTE PTR [edx], 0	; Give strbuf a null char at the end
	popf
	pop edi
	pop esi
	pop edx
	pop ecx
	pop ebx
	pop eax
	pop ebp
	ret
_binToHexStr ENDP
;**************************************************************************************
; Requirement 5
; void hexStrToBin(char* hexStr, unsigned char* binbuf, int binbuf_len)
; This procedure will input a hex string and produce a binary buffer.
_hexStrToBin PROC
	push ebp
	mov ebp, esp
	push eax
	push edx
	push esi
	push edi
	pushf

	mov esi, [ebp + 8]	; esi holds hexStr
	mov edx, [ebp + 12]	; edx holds binbuf
	mov eax, [ebp + 16]	; eax holds binbuf_len
	cld
	jmp matchThePattern

matchThePattern:
	cmp BYTE PTR [esi], 0	; We are finished if we reach the null character
	je exitCode
	cmp eax, 0				; We are finished if we reach the end of the buffer
	je exitCode
; The following sets of 4 instructions try to match the character in the current location of hexStr.
; When a match is found, the program jumps to the corresponding branch that stores the binary version of the hex character.
	lea edi, zeroHex
	cmpsb
	je addZeroBin
	dec esi
	
	lea edi, oneHex
	cmpsb
	je addOneBin
	dec esi

	lea edi, twoHex
	cmpsb
	je addTwoBin
	dec esi

	lea edi, threeHex
	cmpsb
	je addThreeBin
	dec esi

	lea edi, fourHex
	cmpsb
	je addFourBin
	dec esi

	lea edi, fiveHex
	cmpsb
	je addFiveBin
	dec esi

	lea edi, sixHex
	cmpsb
	je addSixBin
	dec esi

	lea edi, sevenHex
	cmpsb
	je addSevenBin
	dec esi

	lea edi, eightHex
	cmpsb
	je addEightBin
	dec esi

	lea edi, nineHex
	cmpsb
	je addNineBin
	dec esi

	lea edi, tenHex
	cmpsb
	je addTenBin
	dec esi

	lea edi, elevenHex
	cmpsb
	je addElevenBin
	dec esi

	lea edi, twelveHex
	cmpsb
	je addTwelveBin
	dec esi

	lea edi, thirteenHex
	cmpsb
	je addThirteenBin
	dec esi

	lea edi, fourteenHex
	cmpsb
	je addFourteenBin
	jmp addFifteenBin

; These are the branches that put the binary representation of the current hex character into binbuf.
addZeroBin:
	sub eax, 4
	mov DWORD PTR [edx], "0000"
	add edx, 4
	jmp matchThePattern

addOneBin:
	sub eax, 4
	mov DWORD PTR [edx], "0001"
	add edx, 4
	jmp matchThePattern

addTwoBin:
	sub eax, 4
	mov DWORD PTR [edx], "0010"
	add edx, 4
	jmp matchThePattern

addThreeBin:
	sub eax, 4
	mov DWORD PTR [edx], "0011"
	add edx, 4
	jmp matchThePattern

addFourBin:
	sub eax, 4
	mov DWORD PTR [edx], "0100"
	add edx, 4
	jmp matchThePattern

addFiveBin:
	sub eax, 4
	mov DWORD PTR [edx], "0101"
	add edx, 4
	jmp matchThePattern

addSixBin:
	sub eax, 4
	mov DWORD PTR [edx], "0110"
	add edx, 4
	jmp matchThePattern

addSevenBin:
	sub eax, 4
	mov DWORD PTR [edx], "0111"
	add edx, 4
	jmp matchThePattern

addEightBin:
	sub eax, 4
	mov DWORD PTR [edx], "1000"
	add edx, 4
	jmp matchThePattern

addNineBin:
	sub eax, 4
	mov DWORD PTR [edx], "1001"
	add edx, 4
	jmp matchThePattern

addTenBin:
	sub eax, 4
	mov DWORD PTR [edx], "1010"
	add edx, 4
	jmp matchThePattern

addElevenBin:
	sub eax, 4
	mov DWORD PTR [edx], "1011"
	add edx, 4
	jmp matchThePattern

addTwelveBin:
	sub eax, 4
	mov DWORD PTR [edx], "1100"
	add edx, 4
	jmp matchThePattern

addThirteenBin:
	sub eax, 4
	mov DWORD PTR [edx], "1101"
	add edx, 4
	jmp matchThePattern

addFourteenBin:
	sub eax, 4
	mov DWORD PTR [edx], "1110"
	add edx, 4
	jmp matchThePattern

addFifteenBin:
	sub eax, 4
	mov DWORD PTR [edx], "1111"
	add edx, 4
	jmp matchThePattern

exitCode:
	mov BYTE PTR [edx], 0	; Make sure that binbuf ends with a null character.
	popf
	pop edi
	pop esi
	pop edx
	pop eax
	pop ebp
	ret

_hexStrToBin ENDP
;**************************************************************************************

END
