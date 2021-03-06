; Program Desription: Assembler implementation of AES Encryption
; Author: Joseph Flinn and Craig Colegrove
; Creation Date: 12/1/15
; Revisions: Yes
; Date: 12/18/15
;

;http://www.adamberent.com/documents/AESbyExample.pdf document describing the algorithm

INCLUDE Irvine32.inc

FILESIZE = 2048 ;buffer size to read in file

.data
; S-Box Lookup Table
sbox	BYTE	063h, 07Ch, 077h, 07Bh, 0F2h, 06Bh, 06Fh, 0C5h, 030h, 001h, 067h, 02Bh, 0FEh, 0D7h, 0ABh, 076h 
		BYTE	0CAh, 082h, 0C9h, 07Dh, 0FAh, 059h, 047h, 0F0h, 0ADh, 0D4h, 0A2h, 0AFh, 09Ch, 0A4h, 072h, 0C0h 
		BYTE	0B7h, 0FDh, 093h, 026h, 036h, 03Fh, 0F7h, 0CCh, 034h, 0A5h, 0E5h, 0F1h, 071h, 0D8h, 031h, 015h 
		BYTE	004h, 0C7h, 023h, 0C3h, 018h, 096h, 005h, 09Ah, 007h, 012h, 080h, 0E2h, 0EBh, 027h, 0B2h, 075h
		BYTE	009h, 083h, 02Ch, 01Ah, 01Bh, 06Eh, 05Ah, 0A0h, 052h, 03Bh, 0D6h, 0B3h, 029h, 0E3h, 02Fh, 084h
		BYTE	053h, 0D1h, 000h, 0EDh, 020h, 0FCh, 0B1h, 05Bh, 06Ah, 0CBh, 0BEh, 039h, 04Ah, 04Ch, 058h, 0CFh
		BYTE	0D0h, 0EFh, 0AAh, 0FBh, 043h, 04Dh, 033h, 085h, 045h, 0F9h, 002h, 07Fh, 050h, 03Ch, 09Fh, 0A8h
		BYTE	051h, 0A3h, 040h, 08Fh, 092h, 09Dh, 038h, 0F5h, 0BCh, 0B6h, 0DAh, 021h, 010h, 0FFh, 0F3h, 0D2h
		BYTE	0CDh, 00Ch, 013h, 0ECh, 05Fh, 097h, 044h, 017h, 0C4h, 0A7h, 07Eh, 03Dh, 064h, 05Dh, 019h, 073h
		BYTE	060h, 081h, 04Fh, 0DCh, 022h, 02Ah, 090h, 088h, 046h, 0EEh, 0B8h, 014h, 0DEh, 05Eh, 00Bh, 0DBh
		BYTE	0E0h, 032h, 03Ah, 00Ah, 049h, 006h, 024h, 05Ch, 0C2h, 0D3h, 0ACh, 062h, 091h, 095h, 0E4h, 079h
		BYTE	0E7h, 0C8h, 037h, 06Dh, 08Dh, 0D5h, 04Eh, 0A9h, 06Ch, 056h, 0F4h, 0EAh, 065h, 07Ah, 0AEh, 008h
		BYTE	0BAh, 078h, 025h, 02Eh, 01Ch, 0A6h, 0B4h, 0C6h, 0E8h, 0DDh, 074h, 01Fh, 04Bh, 0BDh, 08Bh, 08Ah
		BYTE	070h, 03Eh, 0B5h, 066h, 048h, 003h, 0F6h, 00Eh, 061h, 035h, 057h, 0B9h, 086h, 0C1h, 01Dh, 09Eh
		BYTE	0E1h, 0F8h, 098h, 011h, 069h, 0D9h, 08Eh, 094h, 09Bh, 01Eh, 087h, 0E9h, 0CEh, 055h, 028h, 0DFh
		BYTE	08Ch, 0A1h, 089h, 00Dh, 0BFh, 0E6h, 042h, 068h, 041h, 099h, 02Dh, 00Fh, 0B0h, 054h, 0BBh, 016h
; S-Box Inverse Lookup Table
sboxinv	BYTE	052h, 009h, 06Ah, 0D5h, 030h, 036h, 0A5h, 038h, 0BFh, 040h, 0A3h, 09Eh, 081h, 0F3h, 0D7h, 0FBh
		BYTE	07Ch, 0E3h, 039h, 082h, 09Bh, 02Fh, 0FFh, 087h, 034h, 08Eh, 043h, 044h, 0C4h, 0DEh, 0E9h, 0CBh
		BYTE	054h, 07Bh, 094h, 032h, 0A6h, 0C2h, 023h, 03Dh, 0EEh, 04Ch, 095h, 00Bh, 042h, 0FAh, 0C3h, 04Eh
		BYTE	008h, 02Eh, 0A1h, 066h, 028h, 0D9h, 024h, 0B2h, 076h, 05Bh, 0A2h, 049h, 06Dh, 08Bh, 0D1h, 025h
		BYTE	072h, 0F8h, 0F6h, 064h, 086h, 068h, 098h, 016h, 0D4h, 0A4h, 05Ch, 0CCh, 05Dh, 065h, 0B6h, 092h
		BYTE	06Ch, 070h, 048h, 050h, 0FDh, 0EDh, 0B9h, 0DAh, 05Eh, 015h, 046h, 057h, 0A7h, 08Dh, 09Dh, 084h
		BYTE	090h, 0D8h, 0ABh, 000h, 08Ch, 0BCh, 0D3h, 00Ah, 0F7h, 0E4h, 058h, 005h, 0B8h, 0B3h, 045h, 006h
		BYTE	0D0h, 02Ch, 01Eh, 08Fh, 0CAh, 03Fh, 00Fh, 002h, 0C1h, 0AFh, 0BDh, 003h, 001h, 013h, 08Ah, 06Bh
		BYTE	03Ah, 091h, 011h, 041h, 04Fh, 067h, 0DCh, 0EAh, 097h, 0F2h, 0CFh, 0CEh, 0F0h, 0B4h, 0E6h, 073h
		BYTE	096h, 0ACh, 074h, 022h, 0E7h, 0ADh, 035h, 085h, 0E2h, 0F9h, 037h, 0E8h, 01Ch, 075h, 0DFh, 06Eh
		BYTE	047h, 0F1h, 01Ah, 071h, 01Dh, 029h, 0C5h, 089h, 06Fh, 0B7h, 062h, 00Eh, 0AAh, 018h, 0BEh, 01Bh
		BYTE	0FCh, 056h, 03Eh, 04Bh, 0C6h, 0D2h, 079h, 020h, 09Ah, 0DBh, 0C0h, 0FEh, 078h, 0CDh, 05Ah, 0F4h
		BYTE	01Fh, 0DDh, 0A8h, 033h, 088h, 007h, 0C7h, 031h, 0B1h, 012h, 010h, 059h, 027h, 080h, 0ECh, 05Fh
		BYTE	060h, 051h, 07Fh, 0A9h, 019h, 0B5h, 04Ah, 00Dh, 02Dh, 0E5h, 07Ah, 09Fh, 093h, 0C9h, 09Ch, 0EFh
		BYTE	0A0h, 0E0h, 03Bh, 04Dh, 0AEh, 02Ah, 0F5h, 0B0h, 0C8h, 0EBh, 0BBh, 03Ch, 083h, 053h, 099h, 061h
		BYTE	017h, 02Bh, 004h, 07Eh, 0BAh, 077h, 0D6h, 026h, 0E1h, 069h, 014h, 063h, 055h, 021h, 00Ch, 07Dh
;E Lookup Table
etable	BYTE	001h, 003h, 005h, 00Fh, 011h, 033h, 055h, 0FFh, 01Ah, 02Eh, 072h, 096h, 0A1h, 0F8h, 013h, 035h
		BYTE	05Fh, 0E1h, 038h, 048h, 0D8h, 073h, 095h, 0A4h, 0F7h, 002h, 006h, 00Ah, 01Eh, 022h, 066h, 0AAh
		BYTE	0E5h, 034h, 05Ch, 0E4h, 037h, 059h, 0EBh, 026h, 06Ah, 0BEh, 0D9h, 070h, 090h, 0ABh, 0E6h, 031h
		BYTE	053h, 0F5h, 004h, 00Ch, 014h, 03Ch, 044h, 0CCh, 04Fh, 0D1h, 068h, 0B8h, 0D3h, 06Eh, 0B2h, 0CDh
		BYTE	04Ch, 0D4h, 067h, 0A9h, 0E0h, 03Bh, 04Dh, 0D7h, 062h, 0A6h, 0F1h, 008h, 018h, 028h, 078h, 088h
		BYTE	083h, 09Eh, 0B9h, 0D0h, 06Bh, 0BDh, 0DCh, 07Fh, 081h, 098h, 0B3h, 0CEh, 049h, 0DBh, 076h, 09Ah
		BYTE	0B5h, 0C4h, 057h, 0F9h, 010h, 030h, 050h, 0F0h, 00Bh, 01Dh, 027h, 069h, 0BBh, 0D6h, 061h, 0A3h
		BYTE	0FEh, 019h, 02Bh, 07Dh, 087h, 092h, 0ADh, 0ECh, 02Fh, 071h, 093h, 0AEh, 0E9h, 020h, 060h, 0A0h
		BYTE	0FBh, 016h, 03Ah, 04Eh, 0D2h, 06Dh, 0B7h, 0C2h, 05Dh, 0E7h, 032h, 056h, 0FAh, 015h, 03Fh, 041h
		BYTE	0C3h, 05Eh, 0E2h, 03Dh, 047h, 0C9h, 040h, 0C0h, 05Bh, 0EDh, 02Ch, 074h, 09Ch, 0BFh, 0DAh, 075h
		BYTE	09Fh, 0BAh, 0D5h, 064h, 0ACh, 0EFh, 02Ah, 07Eh, 082h, 09Dh, 0BCh, 0DFh, 07Ah, 08Eh, 089h, 080h
		BYTE	09Bh, 0B6h, 0C1h, 058h, 0E8h, 023h, 065h, 0AFh, 0EAh, 025h, 06Fh, 0B1h, 0C8h, 043h, 0C5h, 054h
		BYTE	0FCh, 01Fh, 021h, 063h, 0A5h, 0F4h, 007h, 009h, 01Bh, 02Dh, 077h, 099h, 0B0h, 0CBh, 046h, 0CAh
		BYTE	045h, 0CFh, 04Ah, 0DEh, 079h, 08Bh, 086h, 091h, 0A8h, 0E3h, 03Eh, 042h, 0C6h, 051h, 0F3h, 00Eh
		BYTE	012h, 036h, 05Ah, 0EEh, 029h, 07Bh, 08Dh, 08Ch, 08Fh, 08Ah, 085h, 094h, 0A7h, 0F2h, 00Dh, 017h
		BYTE	039h, 04Bh, 0DDh, 07Ch, 084h, 097h, 0A2h, 0FDh, 01Ch, 024h, 06Ch, 0B4h, 0C7h, 052h, 0F6h, 001h
;L Lookup Table
ltable	BYTE	000h, 000h, 019h, 001h, 032h, 002h, 01Ah, 0C6h, 04Bh, 0C7h, 01Bh, 068h, 033h, 0EEh, 0DFh, 003h
		BYTE	064h, 004h, 0E0h, 00Eh, 034h, 08Dh, 081h, 0EFh, 04Ch, 071h, 008h, 0C8h, 0F8h, 069h, 01Ch, 0C1h
		BYTE	07Dh, 0C2h, 01Dh, 0B5h, 0F9h, 0B9h, 027h, 06Ah, 04Dh, 0E4h, 0A6h, 072h, 09Ah, 0C9h, 009h, 078h
		BYTE	065h, 02Fh, 08Ah, 005h, 021h, 00Fh, 0E1h, 024h, 012h, 0F0h, 082h, 045h, 035h, 093h, 0DAh, 08Eh
		BYTE	096h, 08Fh, 0DBh, 0BDh, 036h, 0D0h, 0CEh, 094h, 013h, 05Ch, 0D2h, 0F1h, 040h, 046h, 083h, 038h
		BYTE	066h, 0DDh, 0FDh, 030h, 0BFh, 006h, 08Bh, 062h, 0B3h, 025h, 0E2h, 098h, 022h, 088h, 091h, 010h
		BYTE	07Eh, 06Eh, 048h, 0C3h, 0A3h, 0B6h, 01Eh, 042h, 03Ah, 06Bh, 028h, 054h, 0FAh, 085h, 03Dh, 0BAh
		BYTE	02Bh, 079h, 00Ah, 015h, 09Bh, 09Fh, 05Eh, 0CAh, 04Eh, 0D4h, 0ACh, 0E5h, 0F3h, 073h, 0A7h, 057h
		BYTE	0AFh, 058h, 0A8h, 050h, 0F4h, 0EAh, 0D6h, 074h, 04Fh, 0AEh, 0E9h, 0D5h, 0E7h, 0E6h, 0ADh, 0E8h
		BYTE	02Ch, 0D7h, 075h, 07Ah, 0EBh, 016h, 00Bh, 0F5h, 059h, 0CBh, 05Fh, 0B0h, 09Ch, 0A9h, 051h, 0A0h
		BYTE	07Fh, 00Ch, 0F6h, 06Fh, 017h, 0C4h, 049h, 0ECh, 0D8h, 043h, 01Fh, 02Dh, 0A4h, 076h, 07Bh, 0B7h
		BYTE	0CCh, 0BBh, 03Eh, 05Ah, 0FBh, 060h, 0B1h, 086h, 03Bh, 052h, 0A1h, 06Ch, 0AAh, 055h, 029h, 09Dh
		BYTE	097h, 0B2h, 087h, 090h, 061h, 0BEh, 0DCh, 0FCh, 0BCh, 095h, 0CFh, 0CDh, 037h, 03Fh, 05Bh, 0D1h
		BYTE	053h, 039h, 084h, 03Ch, 041h, 0A2h, 06Dh, 047h, 014h, 02Ah, 09Eh, 05Dh, 056h, 0F2h, 0D3h, 0ABh
		BYTE	044h, 011h, 092h, 0D9h, 023h, 020h, 02Eh, 089h, 0B4h, 07Ch, 0B8h, 026h, 077h, 099h, 0E3h, 0A5h
		BYTE	067h, 04Ah, 0EDh, 0DEh, 0C5h, 031h, 0FEh, 018h, 00Dh, 063h, 08Ch, 080h, 0C0h, 0F7h, 070h, 007h

; Rcon "function" for key expansion
Rcon	DWORD	01000000h, 02000000h, 04000000h, 08000000h, 10000000h, 20000000h, 40000000h, 80000000h, 1B000000h, 36000000h
		DWORD	6c000000h, 0d8000000h, 0ab000000h, 4d000000h, 9a000000h

State BYTE 0fh, 0eh, 0dh, 0ch, 0bh, 0ah, 9h,8h,7h,6h,5h,4h,3h,2h,1h,0h ;what the current pass of the encryption is
temp BYTE 16 DUP(0) ;used in MixCol
matrix BYTE 2,3,1,1 ;used in MixCol
matrixinv BYTE 0eh, 0bh, 0dh, 09h ;used in MixCol
key BYTE 34h, 6ch, 25h,56h, 0ffh, 9ah, 89h, 0d2h, 99h, 0f1h, 4bh, 25h, 50h, 80h, 4fh, 27h ;filled with random values in case their key is < 16 bytes
expKey BYTE 176 DUP(0) ;where the expanded key will go

inbuffer BYTE FILESIZE DUP(0) ;what will be read in
outbuffer BYTE FILESIZE DUP(0) ;what is written out
infile BYTE 256 DUP(0) ;file name to be read in

inmsg BYTE "Enter the file name containing the text: ",0
keymsg BYTE "Enter the key: ",0
filesizemsg BYTE "Enter size of file in bytes: ",0

sizeoffile DWORD ? ;how big the input file is.

menu BYTE "1. Encrypt", 0ah, 0dh, "2. Decrypt", 0ah, 0dh, "3. Exit", 0ah, 0dh, ">> ",0 ;items to put in the menu

.code


;-----------------------------------------------------
pSwap PROC USES eax ebx ecx edx y:PTR BYTE, x:PTR BYTE
; Swaps two items, even if they're both in memory
; Receives: Two items to be passed in
; Returns: Nothing. It swaps the actual values
;-----------------------------------------------------
	mov edx, y
	mov al, [edx]
	mov ecx, x
	mov bl, [ecx]
	mov [edx], bl
	mov [ecx], al

	ret
pSwap ENDP


;----------------------------------------------------
pSubWord PROC
; Used to expand the key
; Receives: eax, the 4 bytes to lookup
; Returns: eax, the 4 bytes that came from the lookup
;----------------------------------------------------
	push esi
	push ecx
	mov ecx, 4
l2:
	mov edx, 0
	mov dl, al
	mov esi, OFFSET sbox
	add esi, edx
	mov bl, BYTE PTR [esi]
	mov al, bl

	rol eax, 8
	loop l2

	pop ecx
	pop esi

	ret
pSubWord ENDP


;----------------------------------
pShiftRow PROC
; Shifts the State matrix
; Receives: Nothing
; Returns: Nothing. Modifies State.
;----------------------------------
	invoke pSwap, ADDR State[1], ADDR State[5]
	invoke pSwap, ADDR State[5], ADDR State[9]
	invoke pSwap, ADDR State[9], ADDR State[13]

	invoke pSwap, ADDR State[2], ADDR State[10]
	invoke pSwap, ADDR State[6], ADDR State[14]

	invoke pSwap, ADDR State[15], ADDR State[11]
	invoke pSwap, ADDR State[11], ADDR State[7]
	invoke pSwap, ADDR State[7], ADDR State[3]

	 ret
pShiftRow ENDP


;-------------------------------------------------
pMultGalois PROC USES esi ebx edx a:BYTE, b:BYTE
; Does multiplication over the Galois lookup table
; Receives: Nothing
; Returns:  al
;-------------------------------------------------
	.IF (a == 0)
	mov al, 0
	jmp quit
	.ENDIF
	mov eax, 0
	mov esi, OFFSET ltable
	mov al, a
	add esi, eax
	mov bl, BYTE PTR [esi]

	mov dl, bl

	mov eax,0
	mov esi, OFFSET ltable
	mov al, b
	add esi, eax
	mov bl, BYTE PTR [esi]

	mov dh, bl

	adc dl, dh      ; L + L

	mov eax, 0
	mov esi, OFFSET etable
	mov al, dl
	;add esi, eax
	adc esi, eax
	mov al, BYTE PTR [esi]

	quit:
	ret
pMultGalois ENDP


;--------------------------------------------------------------
pMixCol PROC USES eax ebx ecx edx esi edi
; Last step of Encryption round. Call the Galois Multiplication
; Receives: Nothing
; Returns: Nothing. Modifies State.
;--------------------------------------------------------------
	mov eax, 0
	mov ecx, 4
	mov esi, 0
	mov ebx, 0
	mov edi, 0
loop2:
	push ecx
	push edi
	mov ecx, 4
	mov esi, 0
	loop1: 
		invoke pMultGalois, State[edi+0], matrix[0]
		mov dl, al

		invoke pMultGalois, State[edi+1], matrix[1]
		mov dh, al

		invoke pMultGalois, State[edi+2], matrix[2]
		mov bl, al

		invoke pMultGalois, State[edi+3], matrix[3]
		mov bh, al

		xor dl, dh
		xor dl, bl
		xor dl, bh

		mov temp[edi+esi], dl

		invoke pSwap, ADDR matrix[2], ADDR matrix[3]
		invoke pSwap, ADDR matrix[1], ADDR matrix[2]
		invoke pSwap, ADDR matrix[0], ADDR matrix[1]

		inc esi

		dec ecx
		jne loop1
		pop edi
		pop ecx

		add edi, 4
		dec ecx
	jne loop2
	
	mov ecx, 16 ; change back to 16
	mov esi, 0
	L2:
		invoke pSwap, ADDR State[esi], ADDR temp[esi]
		inc esi
		loop L2
	ret
pMixCol ENDP


;-----------------------------------------------------------------------
pEK PROC a:BYTE
; Gives 4 bytes of the expanded key
; a will be either 1 or 4
; Receives: esi, the index
; Returns: eax, a DWORD containing the last 4 bytes of the expanded key.
;-----------------------------------------------------------------------
	mov eax, esi
	movzx ebx, a
	sub eax, ebx
	mov edx, 4
	mul edx
	mov edx, eax

	mov eax, DWORD PTR expKey[edx] ; This works, but it is in little endian

	mov bx, ax
	shr eax, 16

	mov dl, bl
	mov bl, ah
	mov ah, dl

	mov dl, al
	mov al, bh
	mov bh, dl

	shl eax, 16
	add eax, ebx

	ret
pEK ENDP


;--------------------------
pAddExpKey PROC
; Adds the Expanded Key
; Receives: eax
; Returns: Nothing
;--------------------------
	push ecx
	mov ecx, 4
	rol eax, 8      ; gets the "first value"
	L16:
		mov expKey[edi], al
		rol eax, 8

		inc edi
		loop L16

	pop ecx

	ret
pAddExpKey ENDP


;---------------------------------------
pExpandKey PROC
; Expands the key into 176 bytes
; Receives: Nothing
; Returns: Nothing.
;---------------------------------------
	mov ecx, 16
	mov edi, 0

	;This is the K(0), K(4), K(8), K(12)
	l5:
		mov al, key[edi]
		mov expkey[edi], al
		inc edi
		loop l5

	mov esi, 4	
	mov ecx, 10		

	l3:
		; Round # is stored in esi
		invoke pEK, 1					  
		rol eax, 8 
		invoke pSubWord

		mov edx, esi
		shr edx, 2           ; divide by 4
		dec edx

		mov ebx, 0
		imul edx, 4
		mov ebx, Rcon[edx]

		xor eax, ebx
		push eax

		invoke pEK, 4
		mov ebx, eax
		pop eax

		xor eax, ebx

		inc esi
		invoke pAddExpKey

		push ecx
		mov ecx, 3

		l32:
			invoke pEK, 1
			push eax
			invoke pEK, 4
			mov ebx, eax
			pop eax
			xor eax, ebx
			invoke pAddExpKey

			inc esi
			loop l32
	
		pop ecx
	
		dec ecx
		jne l3

	ret
pExpandKey ENDP


;-------------------------------------------------
pAddRoundKey PROC
; XORs part of State with part of the expanded key
; Receives: edi, the index of the expanded key
; Returns: Nothing. Modifies State
;-------------------------------------------------
	pushad
	mov ecx, 16
	mov esi, 0
	L1:
		mov al, expKey[edi]
		xor State[esi], al 
	
		inc edi
		inc esi
		loop L1

	popad
	ret
pAddRoundKey ENDP


;---------------------------------------
pByteSub PROC
; Changes State to its sbox lookup value
; Receives: Nothing
; Returns: Nothing. Modifies State
;---------------------------------------
	pushad
	mov ecx, 16

	L2:
		mov eax, 0
		mov al, State[ecx-1]; lower nibble
		mov esi, OFFSET sbox
		add esi, eax
		mov bl, BYTE PTR [esi]
		mov State[ecx-1], bl
		loop L2

	popad

	ret
pByteSub ENDP


;-------------------------------------------
pByteSubInv PROC
; Inverse of pByteSub using the inverse sbox
; Receives: Nothing
; Returns: Nothing. Modifies State
;-------------------------------------------
	pushad
	mov ecx, 16

	L2:
		mov eax, 0

		mov al, State[ecx-1]; lower nibble
		mov esi, OFFSET sboxinv
		add esi, eax
		mov bl, BYTE PTR [esi]
		mov State[ecx-1], bl

		loop L2

	popad


	ret
pByteSubInv ENDP


;---------------------------------
pShiftRowInv PROC
; Other direction of pShiftRow
; Receives: Nothing
; Returns: Nothing. Modifies State
;---------------------------------
	invoke pSwap, ADDR State[9], ADDR State[13]
	invoke pSwap, ADDR State[5], ADDR State[9]
	invoke pSwap, ADDR State[1], ADDR State[5]

	invoke pSwap, ADDR State[2], ADDR State[10]
	invoke pSwap, ADDR State[6], ADDR State[14]

	invoke pSwap, ADDR State[7], ADDR State[3]
	invoke pSwap, ADDR State[11], ADDR State[7]
	invoke pSwap, ADDR State[11], ADDR State[15]

	 ret
pShiftRowInv ENDP


;-------------------------------------------
pMixColInv PROC USES eax ebx ecx edx esi edi
; Opposite of pMixCol
; Receives: Nothing
; Returns: Nothing. Modifies State
;-------------------------------------------
	mov eax, 0

	mov ecx, 4
	mov esi, 0
	mov ebx, 0
	mov edi, 0
	loop2:
		push ecx
		push edi
		mov ecx, 4
		mov esi, 0

		loop1: 
			invoke pMultGalois, State[edi+0], matrixinv[0]
			mov dl, al

			invoke pMultGalois, State[edi+1], matrixinv[1]
			mov dh, al

			invoke pMultGalois, State[edi+2], matrixinv[2]
			mov bl, al

			invoke pMultGalois, State[edi+3], matrixinv[3]
			mov bh, al

			xor dl, dh
			xor dl, bl
			xor dl, bh

			mov temp[edi+esi], dl

			;this will be mShiftMatrix
			invoke pSwap, ADDR matrixinv[2], ADDR matrixinv[3]
			invoke pSwap, ADDR matrixinv[1], ADDR matrixinv[2]
			invoke pSwap, ADDR matrixinv[0], ADDR matrixinv[1]



			;invoke pSwap, ADDR State[1], ADDR State[2]

			inc esi

			dec ecx
			jne loop1
		pop edi
		pop ecx

		add edi, 4
		dec ecx
		jne loop2
	
	mov ecx, 16 ; change back to 16
	mov esi, 0
	L2:
		invoke pSwap, ADDR State[esi], ADDR temp[esi]
		inc esi
		loop L2

	ret
pMixColInv ENDP


;------------------------------------------------------------
pEncryptBlock PROC USES ecx esi blockAdd:DWORD
; Encrypts a block of 16 bytes
; blockAdd is the memory address of the starting index of the 
;    the block that is currently being encrypted
; Receives: Nothing
; Returns: Nothing. Modifies State
;------------------------------------------------------------
	 
	; loop and move the blockAdd value into State
	mov ecx, 16
	mov esi, 0
	l5690:
		mov edi, esi
		add edi, blockAdd
		mov al, [edi]
		mov State[esi], al
	
		inc esi
		loop l5690

	mov edi, 0
	invoke pAddRoundKey

	mov ecx, 9
	mov esi, 1
	l8902:
		invoke pByteSub
		invoke pShiftRow
		invoke pMixCol

		mov edi, esi
		imul edi, 16
		invoke pAddRoundKey

		inc esi
		loop l8902


	invoke pByteSub
	invoke pShiftRow
	mov edi, 160
	invoke pAddRoundKey

	ret
pEncryptBlock ENDP


;------------------------------------------------------------
pDecryptBlock PROC blockAdd:DWORD
; Decrypts a block of 16 bytes
; blockAdd is the memory address of the starting index of the 
;    the block that is currently being encrypted
; Receives: Nothing
; Returns: Nothing. Modifies State
;------------------------------------------------------------
	mov ecx, 16
	mov esi, 0
	l7437:
		mov edi, esi
		add edi, blockAdd
		mov al, [edi]
		mov State[esi], al
	
		inc esi
		loop l7437

	mov edi, 160
	invoke pAddRoundKey


	mov ecx, 9
	l2163:
		invoke pShiftRowInv
		invoke pByteSubInv
		
		mov edi, ecx
		imul edi, 16
		invoke pAddRoundKey

		invoke pMixColInv

		loop l2163

	invoke pShiftRowInv
	invoke pByteSubInv
	mov edi, 0
	invoke pAddRoundKey

	ret
pDecryptBlock ENDP

;------------------------------------------------
pFileI PROC
; Reads from a file, filling inbuffer
; Receives: Nothing
; Returns: Nothing. Fills inbuffer
;------------------------------------------------
	mov edx, OFFSET infile
	call OpenInputFile
	mov edi, eax                ; filehandle 
	mov edx, OFFSET inbuffer
	mov ecx, sizeoffile
	call ReadFromFile
	mov eax, edi
	call CloseFile

	ret
pFileI ENDP

;----------------------------------------------------
pFileO PROC
; Outputs the encrypted/decrypted text to a file
; Receives: Nothing
; Returns: Nothing. Modifies outbuffer
;----------------------------------------------------
	mov edx, OFFSET infile
	call CreateOutputFile

	; filehandle is in eax
	mov edi, eax

	mov edx, OFFSET outbuffer
	mov ecx, sizeoffile
	call WriteToFile

	mov eax, edi
	call CloseFile

	ret
pFileO ENDP


;----------------------------------------------------
pEncrypt PROC
; Encrypts the file. Makes file size divisible by 16.
; Receives: Nothing
; Returns: Nothing
;----------------------------------------------------
	invoke pExpandKey
	invoke pFileI

	mov ecx, sizeoffile
	shr ecx, 4         ; divide by 16
	mov edx, sizeoffile
	and edx, 00000000000000000000000000001111b
	.IF (edx != 0)
		inc ecx
	.ENDIF

	mov edx, ecx
	imul edx, 16
	mov sizeoffile, edx

	mov esi, 0
	l8257: 
		mov eax, esi
		imul eax, 16
		push eax
		invoke pEncryptBlock, ADDR inbuffer[eax]
		pop eax

		push ecx
		push esi

		mov ecx, 16
		mov esi, 0
		l90:
			push eax
			invoke pSwap, ADDR State[esi], ADDR outbuffer[eax]
			pop eax

			inc esi
			inc eax
			loop l90

		pop esi
		pop ecx
		inc esi
		loop l8257


		; Read out to the file
		invoke pFileO

	ret
pEncrypt ENDP


;----------------------------------------------------
pDecrypt PROC
; Decrypts the file. Takes the new file size
; Receives: Nothing
; Returns: Nothing
;----------------------------------------------------
	invoke pExpandKey
	invoke pFileI

	mov ecx, sizeoffile
	shr ecx, 4         ; divide by 16
	inc ecx

	mov esi, 0
	l91: 
		push ecx
		mov eax, esi
		imul eax, 16
		push eax
		push esi
		invoke pDecryptBlock, ADDR inbuffer[eax]
		pop esi
		pop eax

		push ecx
		push esi

		mov ecx, 16
		mov esi, 0
		l87:
			push eax
			invoke pSwap, ADDR State[esi], ADDR outbuffer[eax]
			pop eax

			inc esi
			inc eax
			loop l87

		pop esi
		pop ecx
		inc esi
		pop ecx
		loop l91

		invoke pFileO

	ret
pDecrypt ENDP


;----------------------------------------------------
pMenu PROC
; The UI for the console
; Receives: Nothing
; Returns: Nothing
;----------------------------------------------------

	l75:
		mov edx, OFFSET menu
		call WriteString
		call ReadInt
		push eax

		.IF eax != 1 && eax != 2
			exit
		.ENDIF

		mov edx, OFFSET inmsg
		call WriteString
		mov edx, OFFSET infile
		mov ecx, 256
		call ReadString

		mov edx, OFFSET keymsg
		call WriteString
		mov edx, OFFSET key
		mov ecx, 16
		call ReadString

		mov edx, OFFSET filesizemsg
		call WriteString
		call Readint
		mov sizeoffile, eax


		pop eax
		.IF eax == 1
			invoke pEncrypt
		.ELSEIF eax == 2
			invoke pDecrypt
		.ENDIF

		call clrscr
		jmp l75
	ret
pMENU ENDP


main PROC
	invoke pMenu

	exit
main ENDP
END main