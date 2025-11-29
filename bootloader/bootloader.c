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
	printf("B: %d", 16);
	
	while(1){
	}

	return 0;
}
