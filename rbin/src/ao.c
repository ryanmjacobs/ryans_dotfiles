/* vim: set syntax=c cindent: */

const char *help =
"/**"
"\n * ao - set file to append-only"
"\n *"
"\n * This is equivalent to `chattr +a <file>`."
"\n * Use setcap to allow unpermissioned users to run this program."
"\n *"
"\n * $ setcap cap_linux_immutable+ep $(which ao)"
"\n *"
"\n * Note: This is a one-way operation! You will end up"
"\n * with a undeletable file! Unless you have sudo access,"
"\n * this will not be reversable."
"\n *"
"\n * To reset permissions, run `sudo chattr -a <file>`."
"\n */";

#include <err.h>
#include <fcntl.h>
#include <libgen.h>
#include <unistd.h>
#include <linux/fs.h>
#include <sys/ioctl.h>

int main(int argc, char **argv) {
    if (argc != 2) errx(2, "usage: %s <file>\n\n%s\n", basename(argv[0]), help);

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
