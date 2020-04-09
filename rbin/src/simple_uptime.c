/**
 * @file     simple_uptime.c
 * @version  1.4
 * @brief    Display uptime as: N days, HH:MM:SS.\n
 *           Ex: 1 day, 02:34:56
 *
 * @detail
 *           A fast, simple uptime command for Linux.\n
 *           And, it's 0.001s faster than the default uptime command!
 *
 * @author   Ryan Jacobs <ryan.mjacobs@gmail.com>
 * @date     September 22, 2014
 * @bug      No known bugs.
 */

#include <stdio.h>
#include <sys/sysinfo.h>

int main(void) {
    long int remainder;
    struct sysinfo s_info;
    unsigned int days, hours, minutes, seconds;

    if (sysinfo(&s_info) == -1) {
        perror("error: sysinfo");
        return 1;
    }

    seconds   = s_info.uptime;
    days      = seconds / (60 * 60 * 24);
    remainder = seconds % (60 * 60 * 24);

    hours     = remainder / (60 * 60);
    remainder = remainder % (60 * 60);

    minutes   = remainder / 60;
    seconds   = remainder % 60;

    printf("%u %s, %02u:%02u:%02u\n",
            days, (days == 1 ? "day" : "days"), hours, minutes, seconds);

    return 0;
}
