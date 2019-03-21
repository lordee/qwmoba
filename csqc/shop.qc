void BtnShopCategory()
{
    // filter items, draw panel
    Shop_Category = self.type;
}

void ItemPanel_Draw(vector vid_size, vector pos, vector border)
{
    vector size = [20, 20];
    vector itempos = pos;
    // loop through all items, draw icons

    drawpic(itempos, image, size, [1, 1, 1], 1, 0);
    itempos_x = itempos_x + border_x;
    if ((itempos_x + size_x + border_x) > vid_size_x)
    {
        itempos_x = pos_x;
        itempos_y = border_y;
    }
    
    // TODO check for scrolling needed if more items than panelsize
    
}

void ShowShopMenu(vid_size)
{
    // background
    vector pos = vid_size;
    vector size = pos * .5;
    pos = pos * .25;
    drawfill(pos, size, COLOR_PANEL_BG, ALPHA_PANEL_BG, 0);

    // category buttons
    entity btn;
    vector border = [5, 5, 0];
    vector button_size = [40, 20, 0];
    vector btnpos = pos + border;
    float btnID = 1;
    btn = CreateButton("All Items", BtnShopCategory, btnpos, BTN_BG, size, 0, btnID);
    btn.type = BTN_CAT_ALL;

    btnpos_y = btnpos_y + border_y;
    btnID++;
    CreateButton("Movement", BtnShopCategory, btnpos, BTN_BG, size, 0, btnID);
    btn.type = BTN_CAT_MS;

    btnpos_y = btnpos_y + border_y;
    btnID++;
    CreateButton("Attack Speed", BtnShopCategory, btnpos, BTN_BG, size, 0, btnID);
    btn.type = BTN_CAT_AS;

    // draw items on panel
    vector panelpos = pos;
    panelpos = panelpos + border;
    panelpos_x = panelpos_x + button_size_x + border_x;
    
    ItemPanel_Draw(vid_size, panelpos, border);
}