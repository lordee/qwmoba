void (float menuitem) ShowMenu;
void () Menu_Draw;
void () Messages_Draw;
void () MouseClick;
void (float pid, float send_event, float event_val) UpdatePlayer;
void (float pid, float send_event, string event_val) UpdatePlayerS;

void() CSQC_Parse_Event = {
    float first = readbyte(); 
    float second, third;
    string thirdS;
    switch (first)
    {
        case SE_MNU_OPEN:
            second = readbyte();
            ShowMenu(second);
            break;
        case SE_READY:
            second = readbyte(); // id
            third = readbyte(); // readyval
            UpdatePlayer(second, SE_READY, third);
            break;
        case SE_CHAMP:
            second = readbyte(); // id
            third = readbyte(); // champ val
            UpdatePlayer(second, SE_CHAMP, third);
            break;
        case SE_NETNAME:
            second = readbyte();
            thirdS = readstring();
            UpdatePlayerS(second, SE_NETNAME, thirdS);
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