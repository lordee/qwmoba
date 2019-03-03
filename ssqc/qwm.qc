void (entity player, float kill_type, float creep_type) GoldTracker_Update = {
    
    entity gt;
    gt = find(world, classname, "gold_tracker");

    while (gt)
    {
        if (gt.owner == player)
        {
            // kills
            // minions
            switch (kill_type)
            {
                case GT_CHAMPKILL:
                    gt.consecutive_deaths = 0;
                    gt.consecutive_kills = gt.consecutive_kills + 1;
                    // tier resets to 0 when on a neg tier
                    gt.level = (gt.level < 0) ? 0 : gt.level;
                    break;
                case GT_CHAMPASSIST:
                    // if level < 0 then go up a level
                    gt.level = (gt.level < 0) ? gt.level + 1 : gt.level;
                    break;
                case GT_MINIONKILL:
                    float mkg;
                    mkg = 0;
                    switch (creep_type)
                    {
                        case CREEP_MELEE:
                            mkg = CREEP_MELEE_GOLD;
                            break;
                        case CREEP_RANGE:
                            mkg = CREEP_RANGE_GOLD;
                            break;
                        case CREEP_CANNON:
                            mkg = CREEP_CANNON_GOLD;
                            break;
                        case CREEP_SUPER:
                            mkg = CREEP_SUPER_GOLD;
                            break;
                    }
                    gt.gold_minion = gt.gold_minion + mkg;

                    if (gt.gold_minion >= 1000)
                    {
                        gt.gold_minion = gt.gold_minion - 1000;
                        // if negative tier, go up 1 tier for 1k gold from minions
                        gt.level = (gt.level < 0) ? (gt.level + 1) : 0;
                    }
                    break;
                case GT_SELFDEATH:
                    gt.consecutive_kills = 0;
                    gt.consecutive_deaths = gt.consecutive_deaths + 1;
                    // tier resets to 0 when dying whilst being on a positive tier
                    gt.level = (gt.level > 0) ? 0 : gt.level;

                    break;
                    
            }


        }
        gt = find(gt, classname, "gold_tracker");
    }
    
    

}

void (entity player) SetGold = {
    entity gt;

    gt = find(world, classname, "gold_tracker");
    while (gt)
    {
        if (gt.owner == player)
        {
            if (gt.level > 3)
            {
                float gk;
                gk = 600 + (100 * (player.consecutive_kills - 3));
                gk = (gk > 1000) ? 1000 : gk;

                player.gold_kill = gk;
                player.gold_assist = 150;
            }
            else {
                switch (gt.level)
                {
                    case 3:
                        player.gold_kill = 600;
                        player.gold_assist = 150;
                        break;
                    case 2:
                        player.gold_kill = 450;
                        player.gold_assist = 150;
                        break;
                    case 1:
                        player.gold_kill = 300;
                        player.gold_assist = 150;
                        break;
                    case 0:
                        player.gold_kill = 300;
                        player.gold_assist = 150;
                        break;
                    case -1:
                        player.gold_kill = 274;
                        player.gold_assist = 137;
                        break;
                    case -2:
                        player.gold_kill = 220;
                        player.gold_assist = 110;
                        break;
                    case -3:
                        player.gold_kill = 176;
                        player.gold_assist = 88;
                        break;
                    case -4:
                        player.gold_kill = 140;
                        player.gold_assist = 70;
                        break;
                    case -5:
                        player.gold_kill = 112;
                        player.gold_assist = 56;
                        break;
                    case -6:
                        player.gold_kill = 100;
                        player.gold_assist = 50;
                        break;
                }
            }
        }
        gt = find(gt, classname, "gold_tracker");
    }
}

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