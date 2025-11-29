
#include <stdio.h>


int printf(char *fmt, ...){
	va_list args;
	va_start(args, fmt);  
	int escaping = 0;
	int justify = 1;
	int sign = 1;
	int hash = 0;
	int padzeros = 0;
	int width = 0;
	int precision = 0;
	int parsingWidth = 0;
	int parsingPrecision = 0;
	do{
		if(escaping){
			switch(escaping){
				case 1: {
					switch(*fmt){
						case '-':
							justify=0;
							break;	
						case '+':
							sign=2;
							break;
						case ' ':
							sign=0;
							break;
						case '#':
							hash=1;
							break;
						case '0':
							padzeros=1;
							break;
						default:
							escaping++;
							break;
					}
					if(escaping==1)
						break;
				case 2:
					if(*fmt >='0' && *fmt <= '9'){
						width=width*10+(*fmt-'0');
						parsingWidth=1;
					}
					else if(*fmt == '.')
						escaping++;
					else if(parsingWidth)
						escaping +=2;
					else if(*fmt == '*')
						width=va_arg(args, int);
					else 
						escaping +=2;
					if(escaping==2 || escaping==3)
						break;
				case 3:
					if(*fmt >='0' && *fmt <= '9'){
						precision=precision*10+(*fmt-'0');
						parsingPrecision=1;
					}
					else if(parsingPrecision){
						escaping++;
					}
					else if(*fmt == '*')
						width=va_arg(args, int);
					else 
						escaping++;
		
					if(escaping==3)
						break;
				case 4:
					switch(*fmt){
						case 'd':{
							
						}
					}
					
				}
			}
		}
		else if(*fmt == '%')
			escaping=1;
		else
			putchar(*fmt);
		
	}
	while(*fmt++ != 0);
	
	puts(fmt);
	va_end(args);
}
