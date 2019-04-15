class IT_Base {};
IT_Base Items[4];

int iItems[4] = {
    IT_NONE,
    IT_BOOTS_BASE,
    IT_BOOTS_SPEED,
    IT_BOOTS_AASPEED
};

class IT_Base
{
    int components[5];
    int item_id;
    string icon;
    string display_text;
    float movement_speed_base;
    float attack_speed_perc;
    float buff_flags;
    float selected;
    

    void() IT_Base;
    virtual void() Destruct;
};

void IT_Base :: IT_Base (void)
{
    self.classname = "item";

    switch (item_id)
    {
        case IT_NONE:
            icon = "progs/gfx/hud/items/it_none.png";
            display_text = "none";
            break;
        case IT_BOOTS_BASE:
            icon = "progs/gfx/hud/items/it_boots_base.png";
            display_text = "boots";
            movement_speed_base = 25;
            buff_flags = BUFF_MS_BASE;
            break;
        case IT_BOOTS_SPEED:
            icon = "progs/gfx/hud/items/it_boots_speed.png";
            display_text = "boots of speed";
            movement_speed_base = 35;
            buff_flags = BUFF_RESIST_SLOW | BUFF_MS_BASE;
            components[0] = IT_BOOTS_BASE;
            break;
        case IT_BOOTS_AASPEED:
            icon = "progs/gfx/hud/items/it_boots_aaspeed.png";
            display_text = "boots of attack speed";
            movement_speed_base = 25;
            attack_speed_perc = 25;
            buff_flags = BUFF_AASPEED_PERC | BUFF_MS_BASE;
            components[0] = IT_BOOTS_BASE;
            break;
        default:
    }
}

void IT_Base :: Destruct (void)
{
    remove(this);
};