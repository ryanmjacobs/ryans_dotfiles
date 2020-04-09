/**
 * we.c
 *
 * Waits for all arguments to exist as files, then returns 0.
 * Compile with: cc -std=c89 -pedantic we.c
 *
 * TODO: Use inotify instead.
 *
 * Author: Ryan Jacobs <ryan.mjacobs@gmail.com>
 *   Date: 24 April 2015
 */

#include <stdio.h>
#include <unistd.h>
#include <string.h>

#include <stdlib.h>

char *basename(char *path) {
    char *base = strrchr(path, '/');
    return base ? base+1 : path;
}

int main(int argc, char **argv) {
    if (argc == 1) {
        fprintf(stderr, "Usage: %s <file1> [file2...]\n", basename(argv[0]));
        fprintf(stderr, "When all files exist, return 0.\n");
        return 1;
    }

    while (1) {
        unsigned int i;

        for (i = 1; i < argc; i++) {
            if (!(access(argv[i], F_OK) != -1)) break;
            if (i == argc-1) return 0;
        }

        sleep(1);
    }
}
