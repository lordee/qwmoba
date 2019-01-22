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



entity (float btnID) GetButton = {
    entity button;
    button = find(world, classname, "gui_button");
    while (button)
    {
        if (button.btn_no == btnID) {
            return button;
        }
        
        button = find(button, classname, "gui_button");
    }
}

entity (string button_text, void () btnMethod, vector button_spawnpos, string button_image, vector button_size, float button_flags, float btnID) CreateButton =
{
   entity newbutton;
   
   newbutton = spawn();
   newbutton.classname = "gui_button";
   newbutton.origin = button_spawnpos;
   newbutton.size = button_size;
   newbutton.btn_img = button_image;
   newbutton.btn_text = button_text;
   newbutton.btn_flags = button_flags;
   newbutton.btn_no = btnID;
   newbutton.think = btnMethod;

   return newbutton;
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

void () RenderMenu = {
    entity button;
    float btnID;

    float highlight;
    highlight = MouseOnButton();

    button = find(world, classname, "gui_button");
	while (button)
	{
		btnID = button.btn_no;

        if (btnID == highlight)
        {
            spawnbox(button.origin, button.size, button.btn_img, button.btn_text, '1 1 1', .4);
        }
        else
        {
            spawnbox(button.origin, button.size, button.btn_img, button.btn_text, '1 1 1', .2);
        }
			
		button = find(button, classname, "gui_button");
	}
}