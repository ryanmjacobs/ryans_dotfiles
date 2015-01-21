/**
 * ryans_dwm_config.h
 *
 * Author: Ryan Jacobs <ryan.mjacobs@gmail.com>
 *       May 18, 2014 -> File creation.
 *      June 01, 2014 -> Put all MPV videos into its own tag.
 *    August 28, 2014 -> Add xkill shortcut (Ctrl-Alt-X).
 * September 09, 2014 -> Add scrot shortcut (Ctrl-Alt-S).
 *  December 03, 2014 -> Re-map the scrot shortcut to the PrintScreen button.
 */

#include <X11/XF86keysym.h> /* For special keys */

/* appearance */
static const char font[]            = "-*-terminus-medium-r-*-*-12-*-*-*-*-*-*-*";
static const char normbordercolor[] = "#444444";
static const char normbgcolor[]     = "#222222";
static const char normfgcolor[]     = "#bbbbbb";
static const char selbordercolor[]  = "#005577";
static const char selbgcolor[]      = "#005577";
static const char selfgcolor[]      = "#eeeeee";
static const unsigned int borderpx  = 1;        /* border pixel of windows */
static const unsigned int snap      = 5;        /* snap pixel */
static const Bool showbar           = True;     /* False means no bar */
static const Bool topbar            = True;     /* False means bottom bar */

/* tagging */
//static const char *tags[] = { "1", "2", "3", "4", "5", "6", "7", "8", "9" };

//                            1,        2,       3,          4,      5,      6,     7,       8,    9
static const char *tags[] = { "School", "Other", "Organize", "Dev.", "Doc.", "MPV", "Pref.", "BG", "DL" };

static const Rule rules[] = {
    /* class      instance    title       tags mask     isfloating   monitor */
    { "Gimp",     NULL,       NULL,       0,            True,        -1 },
    { "Firefox",  NULL,       NULL,       0,            False,       -1 },
    { "mpv",      NULL,       NULL,       1 << 5,       True,        -1 },
};

/* layout(s) */
static const float mfact      = 0.55; /* factor of master area size [0.05..0.95] */
static const int nmaster      = 1;    /* number of clients in master area */
static const Bool resizehints = True; /* True means respect size hints in tiled resizals */

static const Layout layouts[] = {
    /* symbol     arrange function */
    { "[]=",      tile },    /* first entry is default */
    { "><>",      NULL },    /* no layout function means floating behavior */
    { "[M]",      monocle },
};

/* key definitions */
#define MODKEY Mod1Mask
#define TAGKEYS(KEY,TAG) \
    { MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
    { MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
    { MODKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
    { MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

/* commands */
static const char *dmenucmd[]        = { "dmenu_run", "-fn", font, "-nb", normbgcolor,
                                         "-nf", normfgcolor, "-sb", selbgcolor, "-sf",
                                         selfgcolor, NULL };
static const char *termcmd[]         = { "xterm", NULL };
static const char *volume_down[]     = { "amixer", "-q", "set", "Master", "2%-", "unmute", NULL };
static const char *volume_up[]       = { "amixer", "-q", "set", "Master", "2%+", "unmute", NULL };
static const char *mute[]            = { "amixer", "-q", "set", "Master", "toggle", NULL };
static const char *brightness_up[]   = { "/usr/bin/xbacklight", "-inc", "20", NULL };
static const char *brightness_down[] = { "/usr/bin/xbacklight", "-dec", "20", NULL };
static const char *xkill[]           = { "xkill", NULL };
static const char *scrot[]           = { "scrot", "scrot.png", NULL };

static Key keys[] = {
    /* modifier                     key        function        argument */

    /* Ryan's Shortcuts */
    { 0,                            XK_F10,    spawn,          {.v = volume_up } },
    { 0,                            XK_F9,     spawn,          {.v = volume_down } },
    { 0,                            XK_F8,     spawn,          {.v = mute } },
    { 0,                            XK_F7,     spawn,          {.v = brightness_up } },
    { 0,                            XK_F6,     spawn,          {.v = brightness_down } },
    { 0,                            XK_Print,  spawn,          {.v = scrot } },
    { ControlMask|MODKEY,           XK_s,      spawn,          {.v = scrot } },
    { ControlMask|MODKEY,           XK_x,      spawn,          {.v = xkill } },
    { ControlMask|MODKEY,           XK_t,      spawn,          {.v = termcmd } },

    /* Builtin Shortcuts */
    { MODKEY,                       XK_p,      spawn,          {.v = dmenucmd } },
    { MODKEY|ShiftMask,             XK_Return, spawn,          {.v = termcmd } },
    { ControlMask|ShiftMask,        XK_Return, spawn,          {.v = termcmd } },
    { MODKEY,                       XK_b,      togglebar,      {0} },
    { MODKEY,                       XK_j,      focusstack,     {.i = +1 } },
    { MODKEY,                       XK_k,      focusstack,     {.i = -1 } },
    { MODKEY,                       XK_i,      incnmaster,     {.i = +1 } },
    { MODKEY,                       XK_d,      incnmaster,     {.i = -1 } },
    { MODKEY,                       XK_h,      setmfact,       {.f = -0.05} },
    { MODKEY,                       XK_l,      setmfact,       {.f = +0.05} },
    { MODKEY,                       XK_Return, zoom,           {0} },
    { MODKEY,                       XK_Tab,    view,           {0} },
    { MODKEY|ShiftMask,             XK_c,      killclient,     {0} },
    { MODKEY,                       XK_t,      setlayout,      {.v = &layouts[0]} },
    { MODKEY,                       XK_f,      setlayout,      {.v = &layouts[1]} },
    { MODKEY,                       XK_m,      setlayout,      {.v = &layouts[2]} },
    { MODKEY,                       XK_space,  setlayout,      {0} },
    { MODKEY|ShiftMask,             XK_space,  togglefloating, {0} },
    { MODKEY,                       XK_0,      view,           {.ui = ~0 } },
    { MODKEY|ShiftMask,             XK_0,      tag,            {.ui = ~0 } },
    { MODKEY,                       XK_comma,  focusmon,       {.i = -1 } },
    { MODKEY,                       XK_period, focusmon,       {.i = +1 } },
    { MODKEY|ShiftMask,             XK_comma,  tagmon,         {.i = -1 } },
    { MODKEY|ShiftMask,             XK_period, tagmon,         {.i = +1 } },
    TAGKEYS(                        XK_1,                      0)
    TAGKEYS(                        XK_2,                      1)
    TAGKEYS(                        XK_3,                      2)
    TAGKEYS(                        XK_4,                      3)
    TAGKEYS(                        XK_5,                      4)
    TAGKEYS(                        XK_6,                      5)
    TAGKEYS(                        XK_7,                      6)
    TAGKEYS(                        XK_8,                      7)
    TAGKEYS(                        XK_9,                      8)
    { MODKEY|ShiftMask,             XK_q,      quit,           {0} },
};

/* button definitions */
/* click can be ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static Button buttons[] = {
    /* click                event mask      button          function        argument */
    { ClkLtSymbol,          0,              Button1,        setlayout,      {0} },
    { ClkLtSymbol,          0,              Button3,        setlayout,      {.v = &layouts[2]} },
    { ClkWinTitle,          0,              Button2,        zoom,           {0} },
    { ClkStatusText,        0,              Button2,        spawn,          {.v = termcmd } },
    { ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },
    { ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
    { ClkClientWin,         MODKEY,         Button3,        resizemouse,    {0} },
    { ClkTagBar,            0,              Button1,        view,           {0} },
    { ClkTagBar,            0,              Button3,        toggleview,     {0} },
    { ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
    { ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
};

