void (float menuitem) ShowMenu;
void () RenderMenu;
void () MouseClick;

void() CSQC_Parse_Event = {
    float first = readbyte(); 
    float second = readbyte();
    switch (first)
    {
        case MNU_LOBBY:
            // open menu
            ShowMenu(MNU_LOBBY);
        break;
        default:
    }
}

void(float apilevel, string enginename, float engineversion) CSQC_Init = {
    mnu_active = 0;
}

void(float width, float height, float menushown) CSQC_UpdateView =
{
    clearscene();
	setviewprop(VF_DRAWENGINESBAR, 1);
	setviewprop(VF_DRAWCROSSHAIR, 1);

	vid_realwidth = width;
    vid_realheight = height;
    
    addentities((intermission?0:MASK_VIEWMODEL)|MASK_ENGINE);

    renderscene();
    //Hud_Draw([width, height]);
    RenderMenu();
}

float(float evtype, float scanx, float chary, float devid) CSQC_InputEvent = {
    if (mnu_active)
    {
        switch (evtype)
        {
            case IE_KEYUP:
                switch (scanx)
                {
                    case K_MOUSE1:
                        // work out if on a button
                        MouseClick();
                        break;
                }
                break;
            case IE_KEYDOWN:
                switch (scanx)
                {
                    case K_MOUSE1:
                        // work out if on a button
                        return TRUE;
                        break;
                }
                break;
            case IE_MOUSEDELTA:
                //print("in mousedelta", "\n");
                return TRUE;
            case IE_MOUSEABS:
                //print ("in mouseabs", "\n");
                Mouse.x = scanx;
                Mouse.y = chary;
                return TRUE;
            default:
        }
    }
    return FALSE;
}