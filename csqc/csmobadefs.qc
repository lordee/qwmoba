#include "../share/defs.h"
#include "../ssqc/qwmobadefs.qc"

vector vPlayerOrigin;
vector vPlayerOriginOld; // We definitely need this later
vector vPlayerVelocity;
float leveluptime;

.string netname;
.float health;
.float max_health;

// btn fields
.string btn_text;
.string btn_img;
.float btn_flags;
.float btn_no;
.float team_no;
.float champ;

// menu stuff
float mnu_active;
float vid_realwidth;
float vid_realheight;

typedef struct
{
    float x;
    float y;
} MouseStruct;

MouseStruct Mouse;

