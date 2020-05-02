/* vim: set syntax=c cindent: */

/**
 * ao - set file to append-only
 *
 * This is equivalent to `chattr +a <File>`, but
 * we use setcap to allow all users to do this.
 *
 * Note: This is a one-way operation! You will end up
 * with a undeletable file! Unless you have sudo access,
 * this will not be reversable.
 *
 * $ setcap cap_linux_immutable+ep $(which ao)
 */

#include <err.h>
#include <fcntl.h>
#include <libgen.h>
#include <unistd.h>
#include <linux/fs.h>
#include <sys/ioctl.h>

int main(int argc, char **argv) {
    if (argc != 2) errx(2, "usage: %s <file>", basename(argv[0]));

    // Open/Create file
    int fd = open(argv[1], O_CREAT, 0660);
    if (fd == -1) err(1, "open");

    // Read attributes
    int attr;
    if (ioctl(fd, FS_IOC_GETFLAGS, &attr) == -1) err(1, "ioctl");

    // Set append-only attribute
    int mask = (attr | FS_APPEND_FL);
    if (ioctl(fd, FS_IOC_SETFLAGS, &mask) == -1) err(1, "ioctl");

    close(fd);
    return 0;
}
