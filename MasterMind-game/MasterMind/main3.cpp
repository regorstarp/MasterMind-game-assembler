#include <stdio.h>
#include <conio.h>

#include <iostream>
#include <iomanip>
#include<stdlib.h>
#include<time.h>
#include<windows.h>
#include "globals.h"

//using namespace std;

extern "C" {
	// Subrutines en ASM
	void CompareSecretPlay();
	void Playing();
	void GetSecretCode();
	void GetPlay();

	
	void printChar_C(char c);
	int clearscreen_C();
	int clearArea_C(int row_num, int col_num);
	int printMenu_C();
	int gotoxy_C(int row_num, int col_num);
	char getch_C();
	int printBoard_C(int tries);
	int printTries_C();
	int printMessage_C(int msg);
	int printSecretCode_C();
}



//Posicions pantalla
#define PRINT_COLUMN_1 20
#define PRINT_COLUMN_2 58
#define ROW_HEADER 3


//Missatges
#define CLEAR_MESSAGE 0
#define WINNER 1
#define LOOSER 2


int row=0;			//fila de la pantalla
int col=0;   		//columna actual de la pantalla
int rowMessage;    	//fila per imprimir els missatges

char secret[5];    	//Vector amb la combinació secreta
char hits[5];      	//Encerts, 1 byte: part alta  (bits 7..4) encerts a lloc, 
					//                 part baixa (bits 3..0) encerts fora de lloc
char play[5];      	//Vector amb la jugada
char tries=9;       	//nombre d'intents que queden
int showChar=0;		//0: per indicar que es mostri un *, 1: per indicar que es mostri un caràcter
char carac;






//Mostrar un caràcter
//showChar:	0: mostrar * (quan estem introduint la combinació secreta), 
//			1: mostrar el caràcter rebut com a paràmetre
//Quan cridem aquesta funció des d'assemblador el paràmetre s'ha de passar a traves de la pila.
void printChar_C(char c){
	if (showChar==0) putchar('*');
	else putchar(c);
}


//Esborrar la pantalla
int clearscreen_C(){
   	system("CLS");
    return 0;
}


int migotoxy(int x, int y) { //USHORT x,USHORT y) {
   COORD cp = {y,x};
   SetConsoleCursorPosition(GetStdHandle(STD_OUTPUT_HANDLE), cp);
   return 0;
 }

//Situar el cursor en una fila i columna de la pantalla
//Quan cridem aquesta funció des d'assemblador els paràmetres (row_num) i (col_num) s'ha de passar a través de la pila
int gotoxy_C(int row_num, int col_num){
    //printf("\x1B[%d;%dH",row_num,col_num);
	migotoxy(row_num, col_num);
    return 0;
}



//Situar el cursor a la fila i columna indicades per row_num i col_num. 
//Esborrar una area de 5 caràcters de pantalla
//i deixar el cursor a la posició inicial.
//Quan cridem aquesta funció des d'assemblador els paràmetres (row_num) i (col_num) s'ha de passar a través de la pila
int clearArea_C(int row_num, int col_num){
    gotoxy_C(row_num,col_num);
    printf("     ");
    gotoxy_C(row_num,col_num);
    
    return 0;
}


//Imprimir el menú del joc
int printMenu_C(){
		
	clearscreen_C();
    gotoxy_C(1,1);
    printf("______________________________________________________________________________\n");
    printf("|                                                                             |\n");
    printf("|                               MENU MASTERMIND                               |\n");
    printf("|_____________________________________________________________________________|\n");
    printf("|                                                                             |\n");
    printf("|                               1. GetSecret                                  |\n");
    printf("|                               2. GetPlay                                    |\n");
    printf("|                               3. CompareSecretPlay                          |\n");
    printf("|                               4. Playing                                    |\n");
    printf("|                               0. Exit                                       |\n");
    printf("|_____________________________________________________________________________|\n");
    printf("|                                                                             |\n");
    printf("|                               OPTION:                                       |\n");
    printf("|_____________________________________________________________________________|\n"); 
    
    return 0;
}





//Llegir una tecla sense espera i sense mostrar-la per pantalla
char getch_C(){
    char c;   

	HANDLE hStdin = GetStdHandle(STD_INPUT_HANDLE);
	DWORD mode;
    mode &= ~ENABLE_ECHO_INPUT;
    SetConsoleMode(hStdin, mode );
	c=getchar();
    return c;
}


//Imprimir el tauler de joc
int printBoard_C(){
	int i;
	
	clearscreen_C();
    gotoxy_C(1,1);
    printf("______________________________________________________________________________\n");
    printf("|                                                                             |\n");
    printf("|   Secret Code :                                 Tries : %d                   |\n",tries);
    printf("|_____________________________________________________________________________|\n");
    printf("|                                                                             |\n");
    for (i=0;i<tries;i++){
		printf("|    Play %d      :                                Hits  :                     |\n",i+1);
	}
    printf("|_____________________________________________________________________________|\n");
    printf("|                                                                             |\n");
    printf("|                                                                             |\n");
    printf("|_____________________________________________________________________________|\n"); 
    
    return 0;
}


//Imprimir els intents que queden (tries) per encertar la combinació secreta
int printTries_C(){
	gotoxy_C(ROW_HEADER,PRINT_COLUMN_2);
	printf("%d",tries);
	return 0;
}


//Imprimir un missatge segons el codi indicat a la variable msg rebut com a paràmetre.
//Quan cridem aquesta funció des d'assemblador el paràmetre s'ha de passar a través de la pila.
int printMessage_C(int msg){
    gotoxy_C(rowMessage,PRINT_COLUMN_1);
    switch(msg){
		break;
		case CLEAR_MESSAGE: //netejar àrea missatges
			printf("                                        ");
		break;
		case WINNER:
			printf("                YOU WIN!                ");
		break;
		case LOOSER:
			printf("               YOU LOOSE!               ");
		break;
    }
    return 0;
}


//Mostrar la combinació secreta que tenim al vector secret per pantalla
int printSecretCode_C(){
    int i;
    gotoxy_C(ROW_HEADER,PRINT_COLUMN_1);
    
    for (i=0;i<5;i++){
		printf("%c", secret[i]);
    }
    return 0;
}


int main(void){   
 
	int op=1;      
    
    tries=9;							//Definir el nombre d'intents disponibles 
    rowMessage=tries+8;					//Fila on es mostraran els missatges    
	
    while (op!='0') {
		printMenu_C();					//Mostrar menú
		gotoxy_C(13,40);				//Situar el cursor
		op=getch_C();					//Llegir una opció
		switch(op){
			case '1':					//llegir combinació secreta
				tries=9;				//Definir el nombre d'intents disponibles 
				printBoard_C();			//Mostrar el tauler 
				row=3;           		//Fila inicial de la secreta
				col=20;
				GetSecretCode();		//Llegir combinació secreta
				printSecretCode_C();		//Mostrar la combinació secreta
				gotoxy_C(rowMessage+2,33);	//Situar el cursor a sota del tauler
				printf("Press any key ");
				getch_C();			//Esperar que es premi una tecla
			break;
			case '2': 					//llegir una jugada
				tries=9;				//Definir el nombre d'intents disponibles 
				printBoard_C(); 
				row=6;           		//Fila inicial de les jugades
				col=20;
				GetPlay();				//Llegir la jugada
				gotoxy_C(rowMessage+2,33);
				printf("Press any key ");
				getch_C();
			break;
			case '3': 				//comprovar encerts  
				tries=9;			//Definir el nombre d'intents disponibles 
				printBoard_C();  
				row=6;
				CompareSecretPlay();		//Comparar la combinació secreta amb la jugada
				gotoxy_C(rowMessage+2,33);
				printf("Press any key ");
				getch_C();
			break;
			case '4': 				//joc complet  
				tries=9;			//Definir el nombre d'intents disponibles 
				printBoard_C();     
				Playing();			//Jugar
				gotoxy_C(rowMessage+2,33);
				printf("Press any key ");
				getch_C();
			break;	
		}
	}
    
    gotoxy_C(19,1);						//Situar el cursor a la fila 19
    return 0;
}
