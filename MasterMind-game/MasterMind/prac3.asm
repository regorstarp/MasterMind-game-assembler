.586
.MODEL FLAT, C

; Funcions definides en C
printChar_C PROTO C, value:SDWORD
printChar_C PROTO C, value:SDWORD
clearscreen_C PROTO C
clearArea_C PROTO C, value:SDWORD, value1: SDWORD
printMenu_C PROTO C
gotoxy_C PROTO C, value:SDWORD, value1: SDWORD
getch_C PROTO C
printBoard_C PROTO C, value: DWORD
printMessage_C PROTO C, value: DWORD
printSecretCode_C PROTO C


.data               
MINCOL equ 20
MAXCOL equ 24               
ValidChar DB '0','1','2','3','4','5','6','7','8','9'
teclaSalir DB 0
check_if_repeated DB ?
repeated_yes DB ?
hits_type DB ?
hits_p3 DB ?
.code   
                         


public C Playing, GetSecretCode, GetPlay, CompareSecretPlay
                         

extern C row:SDWORD, col: SDWORD, carac: BYTE, tries: BYTE, hits: BYTE, secret: BYTE, play: BYTE, showChar: SDWORD




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Situar el cursor en una fila i una columna de la pantalla
; en funció de la fila i columna indicats per les variables col i row
; cridant a la funció gotoxy_C.
;
; Variables utilitzades: 
; Cap
; 
; Paràmetres d'entrada : 
; Cap
;    
; Paràmetres de sortida: 
; Cap
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
gotoxy:
   push ebp
   mov  ebp, esp

   push eax
   

   ; Quan cridem la funció gotoxy_C(int row_num, int col_num) des d'assemblador 
   ; els paràmetres s'han de passar per la pila
      
   mov eax,[col]
   push eax
   mov eax,[row]
   push eax
   call gotoxy_C
   pop eax
   pop eax 
   
   pop eax

   mov esp, ebp
   pop ebp
   ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Neteja un espai de la pantalla corresponent a 5 caràcters
; en funció de la fila i columna indicats per les variables col i row
; cridant a la funció gotoxy_C.
;
; Variables utilitzades: 
; Cap
; 
; Paràmetres d'entrada : 
; Cap
;    
; Paràmetres de sortida: 
; Cap
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
clearArea:
   push ebp
   mov  ebp, esp
   ;guardem l'estat dels registres del processador perquÃš
   ;les funcions de C no mantenen l'estat dels registres.
   push eax
   

   ; Quan cridem la funció clearArea_C(int row_num, int col_num) des d'assemblador 
   ; els paràmetres s'han de passar per la pila
   		
   mov eax,[col]
   push eax
   mov eax,[row]
   push eax
   call clearArea_C
   pop eax
   pop eax
   
   pop eax

   mov esp, ebp
   pop ebp
   ret




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Mostrar un caràcter, guardat a la variable carac
; en la pantalla en la posició on està  el cursor,  
; cridant a la funció printChar_C.
; 
; Variables utilitzades: 
; carac : variable on està emmagatzemat el caracter a treure per pantalla
; 
; Paràmetres d'entrada : 
; Cap
;    
; Paràmetres de sortida: 
; Cap
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
printch:
   push ebp
   mov  ebp, esp
   ;guardem l'estat dels registres del processador perqué
   ;les funcions de C no mantenen l'estat dels registres.
   
   push eax
   

   ; Quan cridem la funció³ printch_C(char c) des d'assemblador, 
   ; el paràmetre (carac) s'ha de passar per la pila.
 
   xor eax,eax
   mov  al, [carac]
   push eax 
   call printChar_C
 
  pop eax

   mov esp, ebp
   pop ebp
   ret
   

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Llegir un caràcter de teclat   
; cridant a la funció getch_C
; Verificar que solament es pot introduir valors numerics
; i deixar-lo a la variable carac.
; Si s'introdueix el caracter 'S' o 's' es surt del programa 
;
; Variables utilitzades: 
; carac : Variable on s'emmagatzema el caracter llegit
; ValidChar: vector on s'emmagatzema els valors numerics per comparar amb el 
; teclat introduit
; 
; Paràmetres d'entrada : 
; Cap
;    
; Paràmetres de sortida: 
; El caracter llegit, si és correcte, s'emmagatzema a la variable carac
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
getch:
   push ebp
   mov  ebp, esp
    
   push eax

   call getch_C
   mov [carac],al
   
   pop eax

   mov esp, ebp
   pop ebp
   ret 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; GetCode
; Llegir una combinació que guardarem en un vector de 5
; posicions.
; Primer netejar l'espai on es llegeix la combinació amb espais
; en blanc, cridant la subrutina clearArea.
; In icialitzar a zeros el vector.
; Llegir la combinació secreta (5 dígits) cridant a 
; subrutina getch i emmagatzemar -la al vector corresponent
; Cada cop que s'introdueix un caràcter per teclat, comprova:
; - Si s'ha pitjat la S o s es
; surt de l a su brutina, posant la variable 'teclaSalir ' a 1.
; - Si el caràcter està entre '0' i 9', sinó no
; l'accepta, no mostra cap missatge i continua llegint.
;
; Variables utilitzades:
; teclaSalir : Indica si s'ha premut la tecla S o s
;
; Paràmetres d'entrada :
; ebx: Adreça del vector on s'ha d'emmagatzemar la combinació
; llegida (secret o play)
;
; Paràmetres de sortida:
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

GetCode:
		push ebp
		mov  ebp, esp

		
		   
		mov esp, ebp
		pop ebp
		
		ret



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; GetSecretCode
; Llegir la combinació secreta.
; Posar showChar=0, per a indicar que Printch no mostri els
; caràcters llegits i mostri *.
; Llegir la
; combinació secreta (5 dígits) cridant a
; subrutina GetCode .
;
; Variables utilitzades:
; showChar: 0: mostrar un * per als caràcters llegits (llegim
; secret)
;
; Paràmetres d'entrada :
; Cap
;
; Paràmetres de sortida:
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
GetSecretCode:
		push ebp
		mov  ebp, esp
		
		
			
		mov esp, ebp
		pop ebp
		ret
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; GetPlay
; Llegir una jugada.
; Posar showChar=1, per a indicar que Printch mostri els
; caràcters llegits.
; Llegir la jugada (5 dígits) cridant a la subrutina GetCode.
;
; Variables utilitzades:
; showChar: 1: mostrar els caràcters llegits (llegim play)
;
; Paràmetres d'entrada :
; Cap
;
; Paràmetres de sortida:
; Cap
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

GetPlay:
		push ebp
		mov  ebp, esp
		

		

		mov esp, ebp
		pop ebp
		ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; PrintHits
; Mostra els encerts a lloc i fora de lloc.
; Mostra els encerts a lloc, mostrant una 'X' quan s’encerta tant el ; numero i la posició. Però aquesta ‘X’ no s’ha de posar en la
; posició correcta.
; Mostra els encerts fora de lloc, mostrant una 'O'.
; Si hi ha un encert a lloc del mateix dígit, no es mostra
; l'encert fora de lloc.
; Si el mateix dígit apareix a la jugada més d'un cop, sols es
; mostra un encert fora de lloc
; Per mostrar les X's i les O's cridar la subrutina printch
;
; Variables utilitzades:
; hits: Variable de 5 char. Cada posició identifica si hi ha
; hagut encert a lloc (1), fora de lloc (2)
; o no (0)
;
; Paràmetres d'entrada :
; Cap
;
; Paràmetres de sortida: ; Cap
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PrintHits:
        push ebp
        mov  ebp, esp

		


		mov esp, ebp
		pop ebp
		ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; CompareSecretPlay
; Compara la combinació secreta amb jugada, guardant
; a la variable hits (5 chars) els encerts a lloc, fora lloc i desencerts
; Per fer la comparació cal el següent:
; Per cada element del vector secret compara l'element que
; estem tractant de secret amb l'element play que ocupa
; la mateixa posició per saber si és un encert a lloc,
; Si és un encert a lloc posem 1 la posició corresponent
; de hits i si es un encert fora lloc posar -hi un 2 . (es pot implementar d'altres formes).
; Situar el cursor a la fila ( row) i columna 58 ) correctes de
; la pantalla cridant subrutina gotoxy, passant fila i
; columna
; indicades per row i col mitjançant esi i edi.
; Mostrar els encerts a la pantalla cridant subrutina
; PrintHits.
;
; Variables utilitzades:
; secret : vector amb la combinació secreta
; play : vector amb la darrera jugada.
; hits : vector que identifica els encerts a lloc
; showChar: 1: mostrar el caràcter llegit
;
; Paràmetres d'entrada :
; Cap
;
; Paràmetres de sortida:
; Cap
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

CompareSecretPlay:
		push ebp
		mov  ebp, esp
		
		
		mov esp, ebp
		pop ebp
		ret
		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Mostrar els intents que queden
; Situar el cursor a la fila 3, columna 58 cridant la subrutina gotoxy, 
; passant fila i columna mitjançant les variables row i col
; Mostra el valor de la variable tries cridant a la subrutina
; printch, 
; passant el caràcter associat als intents com a paràmetre a traves de
; la variable carac.
; Per obtenir el caràcter associat als intents, codi ASCII del número,
; cal sumar al valor numèric dels intents, tries, el valor decimal 48.
;
; Variables utilitzades:	
; tries: nombre d'intents que queden
; row: Variable que indcia la fila
; col: Variable que indica la columna
; carac : Variable que ha de contenir el caracter a treure per pantalla
;
; Paràmetres d'entrada : 
; Cap
;    
; Paràmetres de sortida: 
; Cap
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PrintTries:
		push ebp
		mov  ebp, esp

		

		mov esp, ebp
		pop ebp
		ret



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; CheckRepeated
; Comprovar si el caràcter entrat és un caràcter que ja ha
; estat introduït
;
; Variables utilitzades:
; secret: per comprovar si el caràcter ha estat introduït abans
;
; Paràmetres d'entrada :
; esi: Posició(índex) del vector secret en la que volem
; introduir el nou caràcter
; al: Caràcter que hem introduït i volem comprovar
;
; Paràmetres de sortida:
; ah=1, indica que el caràcter ja ha estat introduït
; prèviament.
; ah=0, indica que el caràcter no ha estat introduït

; prèviament.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
CheckRepeated:
		push ebp
		mov  ebp, esp

		

		mov esp, ebp
		pop ebp
		ret



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Subrutina principal del joc
; Aquesta subrutina es dóna feta. NO la modifiqueu.
; Llegeix la combinació secreta
; A continuació es llegeix una jugada, compara la jugada amb la combinació 
; secreta per a determinar i mostrar els encerts, repetir el procés mentre no 
; s'encerta la jugada, i mentre queden intents.

;
; Pseudo codi:
; Inicialitzar fila i columna, row=3 i col=20
; Llegir combinació secreta (cridar la subrutina GetSecretCode)
;   row=6 (fila inicial de les jugades)
;   repeat
;      col=20 (columna inicial de les jugades)
;      llegir jugada en la fila de pantalla on estem 
;        (cridar la subrutina GetPlay)
;         comparar jugada amb la combinació secreta i mostra encerts.
;         (cridar la subrutina CompareSecretPlay)
;         if encerts a lloc = 5 sortir.
;         else 
;            incrementar la fila, row.
;            decrementar intents, tries.
;            mostrar intents que queden (cridar la subrutina PrintTries)
;         end_else
;      if intents=0, sortir.
;   end_repeat
; sortir:
; mostrar missatge de sortida que correspongui (cridar la funció printMessage_C)
; mostrar la combinació secreta (cridar la funció printSecretCode_C).
; S'acaba el joc.
;
; Variables utilitzades:	
; row   : fila de pantalla on es llegeix la jugada i es mostren els encerts
; col   : columna inicial de les jugades
; hits  : vector que identifica els encerts a lloc
; tries : nombre d'intents que queden.
;
; Paràmetres d'entrada : 
; Cap
;    
; Paràmetres de sortida: 
; Cap
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Playing:
		push ebp
		mov  ebp, esp
		
		push esi
		push edi
		
		mov [row], 3
		mov [col], 20
		call GetSecretCode		;llegir la combinaciÃ³ secreta a la fila 3, columna 20 de pantalla.
		cmp teclaSalir,1
		je P_Salir
		mov  [row], 6		;fila inicial de les jugades
	P_NewPlay:
		mov  [col], 20		;columna inicial de la jugada
		call GetPlay
		cmp teclaSalir,1
		je P_Salir
	P_compareplay:
		call CompareSecretPlay		;comprovar els encerts
		

		mov esi,0
		mov al, 0
	next_suma:
	    cmp [hits+esi], 1
		;add al, [hits+esi]
		jne P_IndexInc
		inc al			
P_IndexInc:
	;next_suma:
		;add al, [hits+esi]			;
		inc esi			;desplacem 4 bits a la dreta per deixar nomÃ©s els encerts a lloc
		cmp esi, 5			;hi ha 5 encerts a lloc?
		jl next_suma
		
		cmp al, 5
		je P_winner
		inc [row]			;incrementar la fila per passar a la segÃŒent jugada
		dec [tries]		;decrementar el nombre d'intents que queden
		call PrintTries 		;mostrar intents que queden
		cmp [tries], 0 		;s'han esgotat els intents?
		jg P_NewPlay
	P_looser:
		mov edi, 2			;s'han esgotat els intents, codi de sortida=2, hem perdut el joc
		jmp P_endPlaying
	P_winner:
		mov edi, 1		 	;combinaciÃ³ encertada, codi de sortida=1, hem guanyat el joc 
		jmp P_endPlaying
	P_escPressed:
		mov edi, 6			;codi de sortida=6, hem premut ESC
	P_endPlaying:	
		push edi
		call printMessage_C 		;imprimir missatge de sortida segon el codi de sortida: edi
		pop edi
		call printSecretCode_C		;imprimir combinaciÃ³ secreta

P_Salir:		
		pop edi
		pop esi
		
		mov esp, ebp
		pop ebp
		ret

END
