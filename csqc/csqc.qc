void (float menuitem) ShowMenu;
void () Menu_Draw;
void () Messages_Draw;
void () MouseClick;

void() CSQC_Parse_Event = {
    float first = readbyte(); 
    switch (first)
    {
        case MNU_OPEN:
            float second = readbyte();
            ShowMenu(second);
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
    Menu_Draw();
    Messages_Draw();
}