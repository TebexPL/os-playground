#ifndef STDIO_H
#define STDIO_H

#include <defines.h>
#include <stdarg.h>

void putchar(char c);

void puts(char *s);

int getchar(void);

int printf(char *fmt, ...);

void printBX(uint8_t v);

#endif
