#include "../share/defs.h"
#include "../ssqc/qwmobadefs.qc"

vector vPlayerOrigin;
vector vPlayerOriginOld; // We definitely need this later
vector vPlayerVelocity;
float leveluptime;
vector COLOR_PANEL_BG = [128, 128, 128];
float ALPHA_PANEL_BG = .2;
float Shop_Category;
vector glob_vid_size;

.string netname;
.float health;
.float max_health;

// btn fields
.string btn_text;
.string btn_img;
.float btn_flags;
.float btn_no;
.float team_no;
.float champ_id;

// menu stuff
float mnu_active;

typedef struct
{
    float x;
    float y;
} MouseStruct;

MouseStruct Mouse;

