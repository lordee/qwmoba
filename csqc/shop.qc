entity (string button_text, void () btnMethod, vector button_spawnpos, string button_image, vector button_size, float button_flags, float btnID) CreateButton;

void BtnShopCategory()
{
    // filter items, draw panel
    Shop_Category = self.type;
}

void ItemPanel_Draw(vector pos, vector panelsize, vector border)
{
    vector size = [20, 20];
    vector itempos = pos;

    int xitemsmax = floor((panelsize_x - border_x) / (size_x + border_x));
    int yitemsmax = floor((panelsize_y - border_y) / (size_y + border_y));
    // loop through all items, draw icons
    int xcount = 1;
    int ycount = 1;
    // not sure if necessary speedwise
    float ilength = Items.length;
    for (int i = 0; i < ilength; i = i + 1)
    {
        if (xcount > xitemsmax)
        {
            // go to beginning of next row
            itempos = pos;
            itempos_y = itempos_y + ((size_y + border_y) * ycount);
            ycount = ycount + 1;
            xcount = 1;
        }
        else
        {
            itempos_x = itempos_x + size_x + border_x;
        }
        IT_Base item = spawn(IT_Base, item_id: i);
        drawpic(itempos, item.icon, size, [1, 1, 1], 1, 0);
        item.Destruct();
        xcount = xcount + 1;
    }
    
    // TODO check for scrolling needed if more items than panelsize    
}

void ShowShopMenu(vector vid_size)
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
    panelpos = panelpos_x + button_size_x;
    vector panelsize = size;
    panelsize_x = panelsize_x - button_size_x;
    
    ItemPanel_Draw(panelpos, panelsize, border);
}