void (float menuitem) ShowMenu;
void () RenderMenu;

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
    inmenu = 0;
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
};