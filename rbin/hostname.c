#!/usr/bin/c
#include <stdio.h>
#include <unistd.h>

int main(void) {
    char hostname[255];
    gethostname(hostname, sizeof(hostname)/sizeof(char));
    puts(hostname);
    return 0;
}
