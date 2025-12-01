
#include <defines.h>
#include <stdarg.h>
#include <stddef.h>
#include <stdio.h>

int printf(char *fmt, ...){
    va_list args;
    va_start(args, fmt);
    while((*fmt) != 0){
        if(*fmt == '%'){
            int justify = 1;
            int signFlag = 0;
            int spaceFlag = 0;
            int alternative = 0;
            char padding = ' ';

            fmt++;
            if(*fmt == '%'){
                putchar('%');
                continue;
            }

            while(*fmt == '-' ||
                   *fmt == '+' ||
                   *fmt == ' ' ||
                   *fmt == '#' ||
                   *fmt == '0'){
                switch(*fmt){
                case '-':
                    justify=0;
                    break;
                case '+':
                    signFlag = 1;
                    break;
                case ' ':
                    spaceFlag = 1;
                    break;
                case '#':
                    alternative = 1;
                    break;
                case '0':
                    padding = '0';
                    break;
                }
                fmt++;
            }
            if(justify==0)
                padding=' ';
            int width = 0;
            if(*fmt == '*'){
                width = va_arg(args, int);
                fmt++;
            }
            else{
                while(*fmt>='0' && *fmt<='9'){
                    width=width*10+(*fmt-'0');
                    fmt++;
                }
            }
            int precision = 1;
            int precisionSet=0;
            if(*fmt == '.'){
                padding=' ';
                precision=0;
                precisionSet=1;
                fmt++;
                if(*fmt == '*'){
                    precision = va_arg(args, int);
                    fmt++;
                }
                else{
                    while(*fmt>='0' && *fmt<='9'){
                        precision=precision*10+(*fmt-'0');
                        fmt++;
                    }
                }
            }
            int size = 0;
            switch(*fmt){
            case 'h':
                if(*(fmt+1)=='h'){
                    size=1;
                    fmt++;
                }
                else
                    size=2;
                break;
            case 'l':
                if(*(fmt+1)=='l'){
                    size=4;
                    fmt++;
                }
                else
                    size=3;
                break;
            case 'j':
                size=5;
                break;
            case 'z':
                size=6;
                break;
            case 't':
                size=7;
                break;
            case 'L':
                size=8;
                break;
            default:
                fmt--;
                break;
            }
            fmt++;
            int type = 0;
            switch(*fmt){
            case 'd':
            case 'i':
                type = 1;
                break;
            case 'u':
                type = 2;
                break;
            case 'o':
                type = 3;
                break;
            case 'x':
                type = 4;
                break;
            case 'X':
                type = 5;
                break;
            case 'c':
                padding = ' ';
                type = 6;
                break;
            case 's':
                padding = ' ';
                type = 7;
                break;
            case 'p':
                type = 8;
                break;
            }
            fmt++;
            intmax_t svalue=0;
            uintmax_t uvalue=0;
            char *sptr=NULL;
            wchar_t *wsptr=NULL;


            int length =0;
            if(type==0)
                continue;
            else if(type==8){
                uvalue = (uintmax_t)va_arg(args, void *);
                if(uvalue == 0){
                    sptr = (char *)"(nil)";
                    char *tmp = sptr;
                    while(*tmp++ != 0)
                        length++;
                    type=7;
                    if(precisionSet)
                        precision=length;
                }
                else{
                    uintmax_t tmp = uvalue;
                    while(tmp!=0){
                        tmp=tmp>>4;
                        length++;
                    }
                    alternative=1;
                }
            }
            else if(type == 7){
                if(size<3){
                    sptr = va_arg(args, char *);
                    char *tmp = sptr;
                    while(*tmp++ != 0)
                        length++;
                }
                else{
                    wsptr = va_arg(args, wchar_t *);
                    wchar_t *tmp = wsptr;
                    while(*tmp++ != 0)
                        length++;
                }
            }
            else if(type == 6){
                if(size<3)
                    svalue = (signed char)va_arg(args, int);
                else
                    svalue = (wchar_t)va_arg(args, int);
                if(svalue>255)
                    svalue = '?';
                length=1;
                precision=1;
            }
            else if(type==1){
                switch(size){
                case 0:
                    svalue = va_arg(args, signed int);
                    break;
                case 1:
                    svalue = (signed char)va_arg(args, signed int);
                    break;
                case 2:
                    svalue = (signed short int)va_arg(args, signed int);
                    break;
                case 3:
                    svalue = va_arg(args, signed long int);
                    break;
                case 4:
                    svalue = va_arg(args, signed long long int);
                    break;
                case 5:
                    svalue = va_arg(args, intmax_t);
                    break;
                case 6:
                    svalue = va_arg(args, size_t);
                    break;
                case 7:
                    svalue = va_arg(args, ptrdiff_t);
                    break;
                case 8:
                    svalue = va_arg(args, intmax_t);
                    break;
                }
                intmax_t tmp = svalue;
                if(tmp==0){
                    if(precision==0)
                        length=0;
                    else
                        length=1;
                }
                else{
                    while(tmp!=0){
                        tmp/=10;
                        length++;
                    }
                }


            }
            else if(type>1 && type<6){
                switch(size){
                case 0:
                    uvalue = va_arg(args, unsigned int);
                    break;
                case 1:
                    uvalue = (unsigned char)va_arg(args, unsigned int);
                    break;
                case 2:
                    uvalue = (unsigned short int)va_arg(args, unsigned int);
                    break;
                case 3:
                    uvalue = va_arg(args, unsigned long int);
                    break;
                case 4:
                    uvalue = va_arg(args, unsigned long long int);
                    break;
                case 5:
                    uvalue = va_arg(args, uintmax_t);
                    break;
                case 6:
                    uvalue = va_arg(args, size_t);
                    break;
                case 7:
                    uvalue = va_arg(args, ptrdiff_t);
                    break;
                case 8:
                    uvalue = va_arg(args, uintmax_t);
                    break;
                }
                uintmax_t tmp = uvalue;
                switch(type){
                case 2:
                    if(tmp==0){
                        if(precision==0)
                            length=0;
                        else
                            length=1;
                    }
                    else{
                        while(tmp!=0){
                            tmp/=10;
                            length++;
                        }
                    }

                    break;
                case 3:
                    if(tmp==0){
                        if(precision==0)
                            length=0;
                        else
                            length=1;
                    }
                    else{
                    while(tmp!=0){
                        tmp=tmp>>3;
                        length++;
                    }
                    }
                    break;
                case 4:
                case 5:
                    if(tmp==0){
                        if(precision==0)
                            length=0;
                        else
                            length=1;
                    }
                    else{
                        while(tmp!=0){
                            tmp=tmp>>4;
                            length++;
                        }
                    }
                    break;
                }

            }

            int totalLength = width>length?width:length;
            totalLength = totalLength>precision?totalLength:precision;
            int precLength = ((precision-length)>0)?(precision-length):0;
            int paddLength = (totalLength-(precLength+length))>0?(totalLength-(precLength+length)):0;
            if((type==1 || type==8) && (signFlag || svalue<0 || spaceFlag)){
                paddLength--;
                if(justify==1 && padding=='0'){
                    if(svalue<0)
                        putchar('-');
                    else if(signFlag)
                        putchar('+');
                    else if(spaceFlag)
                        putchar(' ');
                }

            }
            if((type==4 || type == 5 || type==8) && alternative){
                paddLength-=2;
                if(justify==1 && padding=='0'){
                    putchar('0');
                    if(type == 4 || type==8)
                        putchar('x');
                    else
                        putchar('X');
                }

            }
            if(justify==1){

                for(int i =0; i<paddLength; i++)
                    putchar(padding);
            }

            int div=1;
            switch(type){
            case 1:
                if(!(justify==1 && padding=='0')){
                    if(svalue<0)
                        putchar('-');
                    else if(signFlag)
                        putchar('+');
                    else if(spaceFlag)
                        putchar(' ');
                }
                if(length>0){
                    for(int i =0; i<precLength; i++)
                        putchar('0');
                    for(int i=0; i<length-1;i++)
                        div=div*10;
                    while(div!=0){
                        intmax_t c=(svalue/div);
                        if(c<0)
                            c=-c;
                        putchar(c+'0');
                        svalue = svalue%div;
                        div/=10;
                    }
                }

                break;
            case 2:
                if(length>0){
                    for(int i =0; i<precLength; i++)
                        putchar('0');
                    for(int i=0; i<length-1;i++)
                        div=div*10;
                    while(div!=0){
                        putchar((uvalue/div)+'0');
                        uvalue = uvalue%div;
                        div/=10;
                    }
                }
                break;
            case 3:
                if(length>0){
                    for(int i =0; i<precLength; i++)
                        putchar('0');
                    div=3*length;
                    while(div!=0){
                        putchar(((uvalue>>(div-3))&0x7)+'0');
                        div=div-3;
                    }
                }
                break;
            case 4:
            case 5:
            case 8:
                if(!(justify==1 && padding=='0')){
                    if(type==8){
                        if(svalue<0)
                            putchar('-');
                        else if(signFlag)
                            putchar('+');
                        else if(spaceFlag)
                            putchar(' ');
                    }
                    if(alternative){
                        putchar('0');
                        if(type == 4 || type ==8)
                            putchar('x');
                        else
                            putchar('X');
                    }
                }
                if(length>0){
                    for(int i =0; i<precLength; i++)
                        putchar('0');
                    div=4*length;
                    while(div!=0){
                        char c =((uvalue>>(div-4))&0xF);
                        if(c<0x0A)
                            c+='0';
                        else if(type==4 || type ==8)
                            c+=0x57;
                        else
                            c+=0x37;
                        putchar(c);
                        div=div-4;
                    }
                }
                break;
            case 6:
                putchar(svalue);
                break;
            case 7:
                int l=precisionSet?precision:length;
                l=l>length?length:l;
                int pad = 0;
                if(precisionSet)
                    pad = width-(l+paddLength);
                if(justify==1)
                    for(int i=0; i<pad; i++)
                        putchar(' ');
                if(size<3){
                    for(int i=0; i<l; i++)
                        putchar(sptr[i]);
                }
                else{
                    for(int i=0; i<l; i++)
                        putchar(wsptr[i]<256?wsptr[i]:'?');
                }
                if(justify==0)
                    for(int i=0; i<pad; i++)
                        putchar(' ');
                break;

            }
            if(justify==0){
                for(int i =0; i<paddLength; i++)
                    putchar(padding);
            }



        }
        else
            putchar(*fmt++);
    }
    va_end(args);
    return 0;
}



