void BtnShopCategory()
{
    // filter items, draw panel
}

void ShowShopMenu()
{
    // background
    vector pos = [vid_realwidth, vid_realheight, 0];
    vector size = pos * .5;
    pos = pos * .25;
    drawfill(pos, size, COLOR_PANEL_BG, ALPHA_PANEL_BG, 0);

    

    // category buttons
    vector border = [5, 5, 0];
    vector button_size = [40, 20, 0];
    vector btnpos = pos + border;
    float btnID = 1;
    CreateButton("All Items", BtnShopCategory, btnpos, BTN_BG, size, 0, btnID);
    
    btnpos_y = btnpos_y + border_y;
    btnID++;
    CreateButton("Movement", BtnShopCategory, btnpos, BTN_BG, size, 0, btnID);


    // draw items on panel
    
}