void () ShowLobbyMenu;

void (vector boxpos, vector boxsize, string boxpic, string boxtext, vector boxrgb, float boxalpha) spawnbox =
{
	drawpic(boxpos, boxpic, boxsize, boxrgb, boxalpha);
	drawstring(boxpos + '10 12 0', boxtext, '8 8 0', boxrgb, 1, 0);
};

void (float menuitem) ShowMenu = {

    if (mnu_active == 0 && vid_realwidth != 0)
    {
        mnu_active = 1;
        switch (menuitem)
        {
            case MNU_LOBBY:
                ShowLobbyMenu();
            break;
            default:
        }
    }
}

void () ClearMenu = {
    setcursormode(FALSE);
    entity button;
	
	// Remove all buttons
	button = find(world, classname, "gui_button");
	while (button)
	{
		remove(button);
		button = find(button, classname, "gui_button");
	}
}

void () RenderMenu = {
    entity button;
    float boxno;

    button = find(world, classname, "gui_button");
	while (button)
	{
		boxno = button.btn_no;

		/*if (mouse_box == boxno) {
			CSQC_GUI_MouseOverButton( button.btn_img, button.origin, button.size, button.btn_text );
			if (menu_selected) {
				CSQC_GUI_ButtonClick( button );
			}
		}
		else {
			if (mouse_slot == boxno && edit_button != world) {
				CheckArea( button );
			}

			if (button.btn_flags & MENUFLAG_DISABLED)
				spawnbox(button.origin, button.size, button.btn_img, button.btn_text, '.4 .4 .4', .2);
			else*/
				spawnbox(button.origin, button.size, button.btn_img, button.btn_text, '1 1 1', .2);

		//}
			
		button = find(button, classname, "gui_button");
	}
}

entity (float btnID) GetButton = {
    entity button;
    button = find(world, classname, "gui_button");
    while (button)
    {
        if (button.btn_no == btnID || button == world) {
            return button;
        }
        
        button = find(button, classname, "gui_button");
    }
}

void () TestCall = {
    localcmd("say testcall","\n");
}

void (string button_text, void () btnMethod, vector button_spawnpos, string button_image, vector button_size, float button_flags) CreateButton =
{
   local entity newbutton;
   global_btn_no++;
   
   newbutton = spawn();
   newbutton.classname = "gui_button";
   newbutton.origin = button_spawnpos;
   newbutton.size = button_size;
   newbutton.btn_img = button_image;
   newbutton.btn_text = button_text;
   newbutton.btn_flags = button_flags;
   newbutton.btn_no = global_btn_no;
   newbutton.think = btnMethod;
}

float () MouseOnButton = {
    float boxval;
    entity button;
    boxval = 0;

    button = find(world, classname, "gui_button");
    while (button)
    {
        if (Mouse.y >= button.origin_y && Mouse.y <= button.origin_y+button.size_y) {
            if (Mouse.x >= button.origin_x && Mouse.x <= button.origin_x+button.size_x) {
                boxval = button.btn_no;
                break;
            }
        }
            
        button = find(button, classname, "gui_button");
    }

    return boxval;
}

void () MouseClick = {
    float btnid;
    entity btn;
    btnid = MouseOnButton();
    if (btnid > 0)
    {
        btn = GetButton(btnid);
        btn.nextthink = 1;
    }
}

