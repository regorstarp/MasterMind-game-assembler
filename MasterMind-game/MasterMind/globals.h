extern "C" int row;
extern "C" int col;
extern "C" char secret[5];    	//Vector amb la combinació secreta
extern "C" char hits[5];      	//Encerts, 1 byte: part alta  (bits 7..4) encerts a lloc, 
				//                 part baixa (bits 3..0) encerts fora de lloc
extern "C" char play[5];      	//Vector amb la jugada
extern "C" char tries;       	//nombre d'intents que queden
extern "C" int showChar;		//0: per indicar que es mostri un *, 1: per indicar que es mostri un caràcter
																//per a la combinació secreta i per a les jugades
extern "C" char carac;
