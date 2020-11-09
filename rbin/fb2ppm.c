#!/usr/bin/c

#include <stdio.h>
#include <stdlib.h>

#define LEN 33177600

int main(int argc, char **argv) {
    if (argc != 3) {
        fputs("usage: fb2ppm <input.rgba> <output.ppm>\n", stderr);
        return 1;
    }

    FILE *fi = fopen(argv[1], "rb");
    FILE *fo = fopen(argv[2], "wb");

    unsigned char *rgba = malloc(LEN);
    fread(rgba, 1, LEN, fi);
    fclose(fi);

    // ppm rgb header
    unsigned char *header = "P6\n3840 2160\n255\n";
    fprintf(fo, header);

    for (unsigned i = 0; i < LEN; i+=4) {
        unsigned char r = rgba[i + 0];
        unsigned char g = rgba[i + 1];
        unsigned char b = rgba[i + 2];
        unsigned char a = rgba[i + 3];
        fwrite(&r, 1, 1, fo);
        fwrite(&g, 1, 1, fo);
        fwrite(&b, 1, 1, fo);
    }
    fclose(fo);

    return 0;
}
