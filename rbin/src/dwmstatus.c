#define _DEFAULT_SOURCE
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <string.h>
#include <strings.h>
#include <math.h>
#include <time.h>
#include <ctype.h>

#include <sys/time.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <sys/sysinfo.h>

#include <X11/Xlib.h>
#include <libnotify/notify.h>

int dir_exists(const char *directory);
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

void sigint_handler(int sig) {
    exit(1);
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

    va_start(fmtargs, fmt);
    int len = vsnprintf(NULL, 0, fmt, fmtargs);
    va_end(fmtargs);

    char *ret = malloc(++len);
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

int wifi_is_connected(void) {
    return ((access("/usr/bin/amixer", F_OK) != -1) && !system("iwgetid"));
}

char *getwifi(void) {
    FILE *fp;
    char *cmd;
    char perc[1024];
    char essid[1024];

    if (!wifi_is_connected())
        return smprintf("");

    cmd = smprintf("iwgetid -r | head -n1");
    fp = popen(cmd, "r");
    if (fp == NULL) {
        fprintf(stderr, "error: cannot get wifi AP name\n");
        exit(1);
    }
    fgets(essid, sizeof(essid)-1, fp);
    strtok(essid, "\n");
    pclose(fp);
    free(cmd);

    cmd = smprintf("grep wlp /proc/net/wireless | grep wlp | awk '{print $3}' | head -n1");
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

void libnotify_critical(const char *msg) {
    notify_init("dwmstatus.c");
	NotifyNotification *n = notify_notification_new (msg, "", "dialog-critical");
    notify_notification_set_timeout(n, 5000);
    notify_notification_set_urgency(n, NOTIFY_URGENCY_CRITICAL);
	notify_notification_show(n, NULL);
	g_object_unref(G_OBJECT(n));
	notify_uninit();
}

// returns 1 if the directory exists
int dir_exists(const char *directory) {
    DIR *dir = opendir(directory);
    if (dir) {
        closedir(dir);
        return 1;
    }
    return 0;
}

char *getpower(void) {
    return strdup("?");

    // read in data points
    int bat = 0;
    double power_now   = read_int("/sys/class/power_supply/BAT0/power_now");
    double energy_now  = read_int("/sys/class/power_supply/BAT0/energy_now");
    double energy_full = read_int("/sys/class/power_supply/BAT0/energy_full");
    double voltage_now = read_int("/sys/class/power_supply/BAT0/voltage_now");

    // if power draw is 0, then we must be on BAT1
    // (for dual battery systems)
    if (power_now == 0 && dir_exists("/sys/class/power_supply/BAT1")) {
        bat = 1;
        power_now   = read_int("/sys/class/power_supply/BAT1/power_now");
        energy_now  = read_int("/sys/class/power_supply/BAT1/energy_now");
        energy_full = read_int("/sys/class/power_supply/BAT1/energy_full");
        voltage_now = read_int("/sys/class/power_supply/BAT1/voltage_now");
    }

    // percent of battery left
    int perc = (energy_now*1000.0 / voltage_now)*100.0 / (energy_full*1000.0 / voltage_now);

    // hours remaining (either to discharge or to finish charging)
    double hours;
    if (on_ac_power())
        hours = (energy_full-energy_now) / power_now;
    else
        hours = energy_now/power_now;

    printf("enow=%f, pnow=%f, div_h=%f, div_m=%f\n",
            energy_now, power_now,
            energy_now/power_now,
            energy_now/power_now*60);

    // convert time to H:MM
    int minutes = (hours-floor(hours)) * 60;
    char *charge_str = smprintf("%0.0f:%02.0f",
        minutes == 60 ? ceil(hours) : floor(hours),
        minutes == 60 ? 0 : minutes);

    // notify user of low battery
    if (perc < 20)
        libnotify_critical("Warning: Low Battery");

    return smprintf("B%d [%d%][%0.1f W][%s]",
                     bat, perc, power_now/1.0e6, charge_str);
}

char *getvol(void) {
    FILE *fp;
    char buf[1024];

    if (access("/usr/bin/amixer", F_OK) == -1)
        return smprintf("");

    fp = popen("amixer -c1 sget Master | awk -vORS='' '/Mono:/ {print($6$4)}'", "r");

    if (fp == NULL) {
        fprintf(stderr, "error: cannot get volume");
    }

    fgets(buf, sizeof(buf)-1, fp);
    pclose(fp);

    return smprintf("%s", buf);
}

int on_ac_power(void) {
    FILE *fp = fopen("/sys/class/power_supply/AC/online", "r");
    if(fp == NULL) {
        fprintf(stderr, "Error opening /sys/class/power_supply/AC/online.\n");
        return -1;
    }

    int ac_online;
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
    if (!(dpy = XOpenDisplay(NULL))) {
        fprintf(stderr, "dwmstatus: cannot open display.\n");
        return 1;
    }

    signal(SIGINT, sigint_handler);

    while (1) {
        char *load   = loadavg();
        char *uptime = getuptime();
        char *wifi   = getwifi();
        char *vol    = getvol();
        char *time   = getdate("%a %b %d, %Y | %r");

        char *ac    = NULL;
        char *power = NULL;
        char *power_str = "";
        if (dir_exists("/sys/class/power_supply/BAT0")) {
            power = getpower();
            ac    = on_ac_power() ? "AC " : "";
            power_str = smprintf(" | Power: %s%s", ac, power);
        }

        const char *wifi_prefix =
            strlen(wifi)
            ? " | Wifi: "
            : "";

        const char *vol_prefix =
            strlen(vol)
            ? " | Vol: "
            : "";

        char *status = smprintf(
            "Uptime: [%s]%s%s"
            "%s%s%s -- %s",
            uptime,
            wifi_prefix, wifi,
            power_str,
            vol_prefix, vol, time
        );
        puts(status);
        setstatus(status);

        free(uptime);
        free(wifi);
        if (power) {
            free(power);
            free(power_str);
        }
        free(vol);
        free(time);
        free(load);
        free(status);

        sleep(1);
    }

    XCloseDisplay(dpy);

    return 0;
}
