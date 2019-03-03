void (entity targ, entity attacker) GoldReward = {
    float dist;
    dist = 0;
    
    // kill gold
    if (attacker.classname != "player")
    {
        // if enemy wasn't a player, find last person to hit them and make them the killer
        attacker = targ.enemy;
    }
    attacker.gold = attacker.gold + targ.gold_kill;

    entity p;
    p = find(world, classname, "player");

    while (p)
    {
        if (p == attacker && targ.gold_kill > 0)
        {
            p = find(p, classname, "player");
            continue;
        }

        // global gold
        if (p.team_no == attacker.team_no)
        {
            p.gold = p.gold + targ.gold_global;

            // local gold
            /*dist = vlen(p.origin, targ.origin);
            if (dist <= RANGE_LOCAL)
            {
                p.gold = p.gold + targ.gold_local;
            }*/
        }
        
        p = find(p, classname, "player");
    }

    // assist tracker
    entity at;
    at = find(world, classname, "assist_tracker");
    while (at)
    {
        if (at.owner == targ)
        {
            if (at.enemy == attacker)
            {
                at = find(at, classname, "assist_tracker");
                continue;
            }

            at.enemy.gold = at.enemy.gold + targ.gold_assist;
        }
        at = find (at, classname, "assist_tracker");
    }
}