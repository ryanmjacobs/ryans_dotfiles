#!/usr/bin/c -O2 -Wall -Wextra --
#include <stdio.h>
#include <assert.h>
#include <string.h>
#include <stdlib.h>

#include <pwd.h>
#include <unistd.h>
#include <sys/types.h>

char *create_prefix(int argc, char **argv);
void print_valid_terms(char *prefix);

int main(int argc, char **argv) {
    // usage: ./helper play.sh <search term goes here>
    if (argc <= 2) return 1;

    char *prefix = create_prefix(argc, argv);
    print_valid_terms(prefix);

    return 0;
}

char *create_prefix(int argc, char **argv) {
    char *prefix = NULL;
    for (int i = 2; i < argc; i++) {
        size_t prefix_len = prefix ? strlen(prefix) : 0;
        prefix = realloc(prefix, prefix_len + strlen(argv[i]) + 2);
        if (prefix_len) prefix[strlen(prefix)] = ' ';
        strcat(prefix, argv[i]);
    }
    return prefix;
}

const char *home_dir(void) {
    struct passwd *pw = getpwuid(getuid());
    return pw->pw_dir;
}

FILE *open_lookup_file(void) {
    // open lookup.txt file in $HOME/.ytc
    char *path = strdup(home_dir());
    path = realloc(path, strlen(path) + 256);
    strcat(path, "/.ytc/lookup.txt");
    FILE *fp = fopen(path, "r");
    free(path);
    assert(fp);
    return fp;
}

void print_valid_terms(char *prefix) {
    FILE *fp = open_lookup_file();

    char buf[256];
    while (fgets(buf, 256, fp)) {
        // chomp the md5sum away
        char *term = buf;
        while (*term++ != ' ') continue;

        if (!strncmp(prefix, term, strlen(prefix)))
            fputs(term, stdout);
    }

    fclose(fp);
}
