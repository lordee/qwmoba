void View_Draw()
{
    //  find all players, draw a health bar above them
    GetSelf();
    print ("self num: ", ftos(self.entnum), "\n");
    entity e;
    e = find(world, classname, "player");
    while (e)
    {
        if (e.entnum != self.entnum)
        {
            print ("e num: ", ftos(e.entnum), "\n");
            float h = e.health;
            float mh = e.max_health;
            vector org = e.origin;
            GetChamp(e.champ_id);
            vector mmax = selfchamp.model_max;
            org_z = org_z + mmax_z;

            vector pos = project(org);
            //makevectors(getviewprop(VF_ANGLES));
            makevectors(getviewprop(VF_ORIGIN));
            float dot = dotproduct((e.origin - self.origin), v_forward);

            //print("e.origin: ", vtos(e.origin), "\n");
            //print("org: ", vtos(self.origin), "\n");

            if (dot > 0);
            {
                Hud_DrawBar(pos, h, mh, [255, 0, 0]);
                //print(ftos(e.health), "\n");
                //print(ftos(dot), "\n");            
            }

        }
        e = find(e, classname, "player");
    }
}