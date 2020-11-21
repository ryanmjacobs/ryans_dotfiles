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

#include <time.h>
#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <stdlib.h>

char *basename(char *path) {
    char *base = strrchr(path, '/');
    return base ? base+1 : path;
}

// return a buffer with a datetime string
// make sure to free() it after printing
char *datetime(void) {
    char *buf = malloc(128);
    time_t now = time (0);
    strftime (buf, 100, "%Y-%m-%d %H:%M:%S.000", localtime (&now));
    return buf;
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
            if (!(access(argv[i], F_OK) != -1)) {
                char *dt = datetime();
                fprintf(stderr, "%s: file does not exist: %s\n", dt, argv[1]);
                free(dt);
                break;
            }
            if (i == argc-1) return 0;
        }

        sleep(1);
    }
}
