entity (string button_text, void () btnMethod, vector button_spawnpos, string button_image, vector button_size, float button_flags, float btnID) CreateButton;

// TODO finish buying mechanics etc

void BtnShop()
{
    // filter items, draw panel
    switch (self.type)
    {
        case BTN_SHOP_BUY:
            // change to tracking info on item ents
            entity player = findfloat(world, entnum, player_localentnum); 
            IT_Base item_ent = (IT_Base)find(world, classname, "item");
            while (item_ent)
            {
                if (item_ent.selected)
                {
                    if (item_ent.gold <= player.gold)
                    {
                        // TODO serverbuy send/rec
                        sendevent("BuyItem", "f", item_ent.item_id);
                    }
                }
                item_ent = (IT_Base)find(item_ent, classname, "item");
            }
            break;
        case BTN_SHOP_CAT_ALL:
        case BTN_SHOP_CAT_MS:
        case BTN_SHOP_CAT_AS:
            Shop_Category = self.type;
    }
}

void ItemPanel_Draw(vector pos, vector panelsize, vector border)
{
    vector size = [20, 20];
    vector itempos = pos;

    float xitemsmax = floor((panelsize_x - border_x) / (size_x + border_x));
    float yitemsmax = floor((panelsize_y - border_y) / (size_y + border_y));
    // loop through all items, draw icons
    float xcount = 1;
    float ycount = 1;
    // not sure if necessary speedwise
    float ilength = Items.length;
    for (float i = 0; i < ilength; i++)
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

void Menu_Show_Shop(vector vid_size, float can_shop)
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
    btn = CreateButton("All Items", BtnShop, btnpos, BTN_BG, size, BTNFLAGS_ACTIVE, btnID);
    btn.type = BTN_SHOP_CAT_ALL;

    btnpos_y = btnpos_y + border_y;
    btnID++;
    btn = CreateButton("Movement", BtnShop, btnpos, BTN_BG, size, BTNFLAGS_ACTIVE, btnID);
    btn.type = BTN_SHOP_CAT_MS;

    btnpos_y = btnpos_y + border_y;
    btnID++;
    btn = CreateButton("Attack Speed", BtnShop, btnpos, BTN_BG, size, BTNFLAGS_ACTIVE, btnID);
    btn.type = BTN_SHOP_CAT_AS;

    // draw items on panel
    vector panelpos = pos;
    panelpos = panelpos_x + button_size_x;
    vector panelsize = size;
    panelsize_x = panelsize_x - button_size_x;
    
    ItemPanel_Draw(panelpos, panelsize, border);

    // TODO just do dodge placement for POC
    btnpos = size;
    btnpos_y = btnpos_y - border_y;
    btnpos_x = btnpos_x + border_x;

    string btnbg = can_shop ? BTN_BG : BTN_BG_DISABLED;
    float active = can_shop ? BTNFLAGS_ACTIVE : BTNFLAGS_INACTIVE;
    btn = CreateButton("BUY", BtnShop, btnpos, btnbg, size, active, btnID);
    btn.type = BTN_SHOP_BUY;

    
}