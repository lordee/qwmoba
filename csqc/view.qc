void View_Draw()
{
    //  find all players, draw a health bar above them
    entity e;
    e = find(world, classname, "player");
    while (e)
    {
        float h = e.health;
        float mh = e.max_health;
        vector org = e.origin;
        org_z = org_z + 30;

        vector pos = project(org);

        Hud_DrawBar(pos, h, mh, [255, 0, 0]);
        e = find(e, classname, "player");
    }
}