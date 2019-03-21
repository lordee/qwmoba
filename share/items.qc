int Items[4] = {
    IT_NONE,
    IT_BOOTS_BASE,
    IT_BOOTS_SPEED,
    IT_BOOTS_AASPEED
}

string ItemsIcons[4] = {
    "progs/gfx/hud/items/it_none.png",
    "progs/gfx/hud/items/it_boots_base.png",
    "progs/gfx/hud/items/it_boots_speed.png",
    "progs/gfx/hud/items/it_boots_aaspeed.png"
}

class IT_Base
{
    string icon;
    
    void IT_Base();
}

void IT_Base :: IT_Base ()
{
    icon = "progs/gfx/hud/items/it_none.png";
}

class IT_Boots : IT_Base ()
{
    float movement_speed_base;
    float buff_flags;
    void IT_Boots();
}

void IT_Boots :: IT_Boots ()
{
    icon = "progs/gfx/hud/items/it_boots_base.png";
    movement_speed_base = 25;
    buff_flags |= IT_MOVEMENT_SPEED_BASE;
}

class IT_Boots_Speed : IT_Boots ()
{
    void IT_Boots_Speed();
}

void IT_Boots_Speed :: IT_Boots_Speed ()
{
    icon = "progs/gfx/hud/items/it_boots_speed.png";
    movement_speed_base = 35;
}

class IT_Boots_AASpeed : IT_Boots ()
{
    float attack_speed;
    void IT_Boots_AASpeed();
}

void IT_Boots_AASpeed :: IT_Boots_AASpeed ()
{
    attack_speed_perc = 25;
    icon = "progs/gfx/hud/items/it_boots_aaspeed.png";
    buff_flags |= IT_ATTACK_SPEED_PERC;
}