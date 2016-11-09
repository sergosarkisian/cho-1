#line 2 "top.c"
#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <stdlib.h>

int mkrecdir(char *fname) {
    char dir[512];
    char *str;
    str = fname;
    while (str = strchr(str, '/')) {
        strncpy(dir, fname, str - fname);
        dir[str - fname] = 0;
        mkdir(dir, S_IRWXU | S_IRWXG | S_IRWXO);
        chmod(dir, S_IRWXU | S_IRWXG | S_IRWXO);
        str++;
    }
}
