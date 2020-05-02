/* vim: set syntax=c cindent: */

/**
 * ao - set file to append-only
 *
 * This is equivalent to `chattr +a <file>`.
 * Use setcap to allow unpermissioned users to run this program.
 *
 * $ setcap cap_linux_immutable+ep $(which ao)
 *
 * Note: This is a one-way operation! You will end up
 * with a undeletable file! Unless you have sudo access,
 * this will not be reversable.
 *
 * To reset permissions, run `sudo chattr -a <file>`.
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
