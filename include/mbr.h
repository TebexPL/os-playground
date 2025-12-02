#ifndef MBR_H
#define MBR_H

#include <stdint.h>


typedef struct  __attribute__((packed)){
	uint8_t H;
	struct __attribute((packed)){
		uint8_t S :6;
		uint8_t C_HI :2;
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
}MBR_entry;

typedef struct __attribute__((packed)){
	uint8_t bootcode[446];
	MBR_entry partition[4];
	uint16_t magic;
}MBR;

#endif
