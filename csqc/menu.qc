void () ShowLobbyMenu;

void (vector boxpos, vector boxsize, string boxpic, string boxtext, vector boxrgb, float boxalpha) spawnbox =
{
	drawpic(boxpos, boxpic, boxsize, boxrgb, boxalpha);
	drawstring(boxpos + '10 12 0', boxtext, '8 8 0', boxrgb, 1, 0);
};

void (float menuitem) ShowMenu = {

    if (inmenu == 0 && vid_realwidth != 0)
    {
        inmenu = 1;
        switch (menuitem)
        {
            case MNU_LOBBY:
                ShowLobbyMenu();
            break;
            default:
        }
    }

}

void () RenderMenu = {
    entity button;
    float boxno;

    button = find(world, classname, "gui_button");
	while (button)
	{
		boxno = button.bt_no;

		/*if (mouse_box == boxno) {
			CSQC_GUI_MouseOverButton( button.bt_img, button.origin, button.size, button.bt_text );
			if (menu_selected) {
				CSQC_GUI_ButtonClick( button );
			}
		}
		else {
			if (mouse_slot == boxno && edit_button != world) {
				CheckArea( button );
			}

			if (button.bt_flags & MENUFLAG_DISABLED)
				spawnbox(button.origin, button.size, button.bt_img, button.bt_text, '.4 .4 .4', .2);
			else*/
				spawnbox(button.origin, button.size, button.bt_img, button.bt_text, '1 1 1', .2);

		//}
			
		button = find(button, classname, "gui_button");
	}
}

void (string button_text, string button_cmd, vector button_spawnpos, string button_image, vector button_size, float button_flags) CreateButton =
{
   local entity newbutton;
   global_bt_no++;
   
   newbutton = spawn();
   newbutton.classname = "gui_button";
   newbutton.origin = button_spawnpos;
   newbutton.size = button_size;
   newbutton.bt_img = button_image;
   newbutton.bt_text = button_text;
   newbutton.bt_cmd = button_cmd;
   newbutton.bt_flags = button_flags;
   newbutton.bt_no = global_bt_no;
}