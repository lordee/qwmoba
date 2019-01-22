#include "../share/defs.h"

// btn fields
.string btn_text;
.string btn_img;
.float btn_flags;
.float btn_no;

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