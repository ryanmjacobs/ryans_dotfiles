#define _DEFAULT_SOURCE
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <string.h>
#include <strings.h>
#include <time.h>
#include <ctype.h>

#include <sys/time.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <sys/sysinfo.h>

#include <X11/Xlib.h>

char *smprintf(char *fmt, ...);
char *getdate(char *fmt);
void setstatus(char *str);
char *loadavg(void);

char *getuptime(void);
char *getwifi(void);
char *getpower(void);
char *getvol(void);

int on_ac_power(void);

static Display *dpy;

static volatile int STOP = 0;
void sigint_handler(int sig) {
    STOP = 1;
}

char *smprintf(char *fmt, ...) {
	va_list fmtargs;
	char *ret;
	int len;

	va_start(fmtargs, fmt);
	len = vsnprintf(NULL, 0, fmt, fmtargs);
	va_end(fmtargs);

	ret = malloc(++len);
	if (ret == NULL) {
		perror("malloc");
		exit(1);
	}

	va_start(fmtargs, fmt);
	vsnprintf(ret, len, fmt, fmtargs);
	va_end(fmtargs);

	return ret;
}

char *getuptime(void) {
    long int remainder;
    struct sysinfo s_info;
    unsigned int days, hours, minutes, seconds;

    if (sysinfo(&s_info) == -1) {
        perror("error: sysinfo");
        return NULL;
    }

    seconds   = s_info.uptime;
    days      = seconds / (60 * 60 * 24);
    remainder = seconds % (60 * 60 * 24);

    hours     = remainder / (60 * 60);
    remainder = remainder % (60 * 60);

    minutes   = remainder / 60;
    seconds   = remainder % 60;

    if (days == 1)
        return smprintf("1 day, %02u:%02u:%02u", hours, minutes, seconds);
    else
        return smprintf("%u days, %02u:%02u:%02u", days, hours, minutes, seconds);
}

char *getwifi(void) {
    FILE *fp;
    char *cmd;
    char dev_name[1024];
    char essid[1024];
    char perc[1024];

    fp = popen("iwgetid | head -n1 | cut -d' ' -f1", "r");
    if (fp == NULL) {
        fprintf(stderr, "error: cannot get wifi device name\n");
        exit(1);
    }
    fgets(dev_name, sizeof(dev_name)-1, fp);
    strtok(dev_name, "\n");
    pclose(fp);

    cmd = smprintf("iwgetid -r %s", dev_name);
    fp = popen(cmd, "r");
    if (fp == NULL) {
        fprintf(stderr, "error: cannot get wifi AP name\n");
        exit(1);
    }
    fgets(essid, sizeof(essid)-1, fp);
    strtok(essid, "\n");
    pclose(fp);
    free(cmd);

    /**
     * I have no idea why a newline is represented by -48, -2, or 32.
     * But this works, so I guess I'll keep it.
     */
    switch (essid[0]) {
        case -48:
        case -2:
        case 32:
            return smprintf("OFF");
            break;
    }

    cmd = smprintf("grep %s /proc/net/wireless | cut -d' ' -f5", dev_name);
    fp = popen(cmd, "r");
    if (fp == NULL) {
        fprintf(stderr, "error: cannot get wifi power\n");
        exit(1);
    }
    fgets(perc, sizeof(perc)-1, fp);
    pclose(fp);
    free(cmd);

    strtok(perc, ".\n");

    return smprintf("%s [%s%]", essid, perc);
}

char *getpower(void) {
	FILE *fd;
	int perc, energy_now, energy_full, voltage_now;

	fd = fopen("/sys/class/power_supply/BAT0/energy_now", "r");
	if(fd == NULL) {
		fprintf(stderr, "Error opening energy_now.\n");
		return NULL;
	}
	fscanf(fd, "%d", &energy_now);
	fclose(fd);


	fd = fopen("/sys/class/power_supply/BAT0/energy_full", "r");
	if(fd == NULL) {
		fprintf(stderr, "Error opening energy_full.\n");
		return NULL;
	}
	fscanf(fd, "%d", &energy_full);
	fclose(fd);


	fd = fopen("/sys/class/power_supply/BAT0/voltage_now", "r");
	if(fd == NULL) {
		fprintf(stderr, "Error opening voltage_now.\n");
		return NULL;
	}
	fscanf(fd, "%d", &voltage_now);
	fclose(fd);

	perc = ((float)energy_now * 1000 / (float)voltage_now) * 100 / ((float)energy_full * 1000 / (float)voltage_now);

    if (perc < 20) {
        /* TODO: use libnotify instead */
        system("notify-send -u critical 'Warning: Low Battery!'");
    }

    return smprintf("%d", perc);
}

char *getvol(void) {
    FILE *fp;
    char buf[1024];

    fp = popen("amixer -c0 sget Master | awk -vORS='' '/Mono:/ {print($6$4)}'", "r");

    if (fp == NULL) {
        fprintf(stderr, "error: cannot get volume");
        exit(1);
    }

    fgets(buf, sizeof(buf)-1, fp);

    pclose(fp);

    return smprintf("%s", buf);
}

int on_ac_power(void) {
    int ret = system("on_ac_power");

    return (ret ? 0 : 1);
}

char *getdate(char *fmt) {
	char buf[129];
	time_t tim;
	struct tm *timtm;

	memset(buf, 0, sizeof(buf));
	tim = time(NULL);
	timtm = localtime(&tim);
	if (timtm == NULL) {
		perror("localtime");
		exit(1);
	}

	if (!strftime(buf, sizeof(buf)-1, fmt, timtm)) {
		fprintf(stderr, "strftime == 0\n");
		exit(1);
	}

	return smprintf("%s", buf);
}

void setstatus(char *str) {
	XStoreName(dpy, DefaultRootWindow(dpy), str);
	XSync(dpy, False);
}

char *loadavg(void) {
	double avgs[3];

	if (getloadavg(avgs, 3) < 0) {
		perror("getloadavg");
		exit(1);
	}

	return smprintf("%.2f %.2f %.2f", avgs[0], avgs[1], avgs[2]);
}

int main(void) {
	char *status;
	char *avgs;
	char *time;

    char *power;
    char *uptime;
    char *vol;
    char *wifi;

	if (!(dpy = XOpenDisplay(NULL))) {
		fprintf(stderr, "dwmstatus: cannot open display.\n");
		return 1;
	}

    signal(SIGINT, sigint_handler);

	for (;;sleep(1)) {
        const char *ac;

        if (STOP) break;

        ac     = on_ac_power() ? "AC " : "";
		avgs   = loadavg();
        uptime = getuptime();
        wifi   = getwifi();
        power  = getpower();
        vol    = getvol();
		time   = getdate("%a %b %d, %Y | %r");

		status = smprintf(
            "Uptime: [%s] | Wifi: %s | "
            "Power: %s[%s%] | Vol: %s -- %s",
            uptime, wifi, ac, power, vol, time
        );
        puts(status);
		setstatus(status);

        free(uptime);
        free(wifi);
		free(power);
        free(vol);
		free(time);

		free(avgs);

		free(status);
	}

	XCloseDisplay(dpy);

	return 0;
}
