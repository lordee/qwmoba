void () ShowLobbyMenu = {
    local vector men;                  // position of the first menu button
    local vector but_size;               // size of all the buttons
    local string buttonback;            // Button image

    but_size = '160 35 0';
    men_x = (vid_realheight*0.5) - (but_size_x*0.5);      // first button will be displayed in the dead center of the horizontal area
    men_y = vid_realheight*0.2;                     // first button will be displayed 20% of the vertical value from the top of the screen
    buttonback = "progs/csqc/csqcguiback.tga";

    CreateButton( "Fire!",             "+attack\n;testmenu",                             men, buttonback, but_size, 0); men_y+=but_size_y;
}