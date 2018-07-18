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

int read_int(const char *fname);
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

int read_int(const char *fname) {
    int x;
    FILE *fp = fopen(fname, "r");

    if (fp == NULL) {
        perror("fopen");
        return -1;
    }

    fscanf(fp, "%d", &x);
    fclose(fp);

    return x;
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
    char perc[1024];
    char essid[1024];
    char dev_name[1024] = "wlp3s0";

    /* old code to figure out interface name
    fp = popen("iwgetid | head -n1 | cut -d' ' -f1", "r");
    if (fp == NULL) {
        fprintf(stderr, "error: cannot get wifi device name\n");
        exit(1);
    }
    fgets(dev_name, sizeof(dev_name)-1, fp);
    strtok(dev_name, "\n");
    pclose(fp);
    */

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
     * If the first character of the ESSID is not ASCII-printable,
     * then we probably aren't connected...
     */
    if (strlen(essid) == 0 || essid[0] < 32 || essid[0] >= 127)
        return smprintf("OFF");

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
    // read in data points
    double power_now   = read_int("/sys/class/power_supply/BAT0/power_now");
    double energy_now  = read_int("/sys/class/power_supply/BAT0/energy_now");
    double energy_full = read_int("/sys/class/power_supply/BAT0/energy_full");
    double voltage_now = read_int("/sys/class/power_supply/BAT0/voltage_now");

    // percent of battery left
    int perc = (energy_now*1000.0 / voltage_now)*100.0 / (energy_full*1000.0 / voltage_now);

    // hours remaining (either to discharge or to finish charging)
    double hours;
    if (on_ac_power())
        hours = (energy_full-energy_now) / power_now;
    else
        hours = energy_now/power_now;

    /**
     * Only notify user of low battery if the percentage
     * is under 20% for 10 samples in a row.
     * TODO: use libnotify instead of system()
     */
    static int bat_samples = 0;
    if (perc < 20) {
        if (++bat_samples >= 10)
            system("notify-send -u critical 'Warning: Low Battery!'");
    } else {
        bat_samples = 0;
    }

    return smprintf("[%d%][%0.1f W][%0.2f hours]", perc, power_now/1.0e6, hours);
}

char *getvol(void) {
    FILE *fp;
    char buf[1024];

    fp = popen("amixer -c1 sget Master | awk -vORS='' '/Mono:/ {print($6$4)}'", "r");

    if (fp == NULL) {
        fprintf(stderr, "error: cannot get volume");
        exit(1);
    }

    fgets(buf, sizeof(buf)-1, fp);

    pclose(fp);

    return smprintf("%s", buf);
}

int on_ac_power(void) {
    FILE *fp;
    int ac_online;

    // get power (wattage)
    fp = fopen("/sys/class/power_supply/AC/online", "r");
    if(fp == NULL) {
        fprintf(stderr, "Error opening /sys/class/power_supply/AC/online.\n");
        return -1;
    }
    fscanf(fp, "%d", &ac_online);
    fclose(fp);

    return (ac_online ? 1 : 0);
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
    char *load;
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

  //for (;;sleep(1)) {
    {
        const char *ac;

      //if (STOP) break;

        ac     = on_ac_power() ? "AC " : "";
        load   = loadavg();
        uptime = getuptime();
        wifi   = getwifi();
        power  = getpower();
        vol    = getvol();
        time   = getdate("%a %b %d, %Y | %r");

        status = smprintf(
            "Uptime: [%s] | Wifi: %s | "
            "Power: %s%s | Vol: %s -- %s",
            uptime, wifi, ac, power, vol, time
        );
        puts(status);
        setstatus(status);

        free(uptime);
        free(wifi);
        free(power);
        free(vol);
        free(time);

        free(load);

        free(status);
    }

    XCloseDisplay(dpy);

    return 0;
}
