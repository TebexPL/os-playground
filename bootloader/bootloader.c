#include <defines.h>
#include <stdio.h>
#include <stdint.h>
typedef struct  __attribute__((packed)){
	uint8_t H;
	union{
		uint8_t S;
		uint8_t C_HI;
	};
	uint8_t C_LO;
}CHS;

typedef struct  __attribute__((packed)) {
	uint8_t bootflag;
	CHS startCHS;
	uint8_t type;
	CHS endCHS;
	uint32_t startLBA;
	uint32_t sizeLBA;
}MBR_Part;

typedef struct __attribute__((packed)){
	uint8_t bootcode[446];
	MBR_Part partition[4];
	uint16_t magic;
}MBR;

int main(){
	MBR *mbr = (MBR*)0x0500;

	printf("|  |START       |   |END         |START    |SIZE\r\n");
	printf("|B |C    H   S  |T  |C    H   S  |LBA      |LBA\r\n");
	printf("----------------------------------------------\r\n");
	for(int i=0; i<4; i++){
		MBR_Part * p = &mbr->partition[i];
		char B = p->bootflag?'*':' ';
		int sC = ((((int)p->startCHS.C_HI)&0xC0)<<2)|p->startCHS.C_LO;
		int sH = p->startCHS.H;
		int sS = p->startCHS.S&0x3F;
		int eC = ((((int)p->endCHS.C_HI)&0xC0)<<2)|p->endCHS.C_LO;
		int eH = p->endCHS.H;
		int eS = p->endCHS.S&0x3F;
		printf("|%c |%-4d %-3d %-2d |%-.2X |%-4d %-3d %-2d |%-8X |%-8X\r\n", B, sC, sH, sS, p->type, eC, eH, eS, p->startLBA, p->sizeLBA);
	}

	
	while(1){
	}

	return 0;
}
