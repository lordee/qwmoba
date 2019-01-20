void () ShowLobbyMenu;

void (float menuitem) ShowMenu = {
    if (inmenu == 0)
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