
void (entity player) SetGold = {
    float gk;
    gk = 0;
    if (player.kill_tier > 3)
    {
        gk = 600 + (100 * (player.consecutive_kills - 3));
        player.gold_assist = 150;
    }
    else 
    {
        switch (player.kill_tier)
        {
            case 3:
                gk = 600;
                player.gold_assist = 150;
                break;
            case 2:
                gk = 450;
                player.gold_assist = 150;
                break;
            case 1:
                gk = 300;
                player.gold_assist = 150;
                break;
            case 0:
                gk = 300;
                player.gold_assist = 150;
                break;
            case -1:
                gk = 274;
                player.gold_assist = 137;
                break;
            case -2:
                gk = 220;
                player.gold_assist = 110;
                break;
            case -3:
                gk = 176;
                player.gold_assist = 88;
                break;
            case -4:
                gk = 140;
                player.gold_assist = 70;
                break;
            case -5:
                gk = 112;
                player.gold_assist = 56;
                break;
            case -6:
                gk = 100;
                player.gold_assist = 50;
                break;
        }
    }

    gk = gk + player.gold_extra;

    // max reward is only ever 1k
    if (gk > 1000)
    {
        player.gold_kill = 1000;
        player.gold_extra = (gk - 1000);
    }
    else
    {
        player.gold_kill = gk;
        player.gold_extra = 0;
    }
}

void (entity player, float kill_type, float creep_type) KillTier_Update = {
    switch (kill_type)
    {
        case KT_CHAMPKILL:
            player.consecutive_deaths = 0;
            player.consecutive_kills = player.consecutive_kills + 1;
            // tier resets to 0 when on a neg tier
            player.kill_tier = (player.kill_tier < 0) ? 0 : player.kill_tier;
            break;
        case KT_CHAMPASSIST:
            // if level < 0 then go up a level
            player.kill_tier = (player.kill_tier < 0) ? player.kill_tier + 1 : player.kill_tier;
            break;
        case KT_MINIONKILL:
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
            player.gold_minion = player.gold_minion + mkg;

            if (player.gold_minion >= 1000)
            {
                player.gold_minion = player.gold_minion - 1000;
                // if negative tier, go up 1 tier for 1k gold from minions
                player.kill_tier = (player.kill_tier < 0) ? (player.kill_tier + 1) : 0;
            }
            break;
        case KT_SELFDEATH:
            // tier resets to 0 when dying whilst being on a positive tier
            player.kill_tier = (player.kill_tier > 0) ? 0 : player.kill_tier;
            player.consecutive_kills = 0;
            player.consecutive_deaths = player.consecutive_deaths + 1;
            break;       
    }
    SetGold(player);
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
    if (attacker.classname == "player")
    {
        attacker.gold = attacker.gold + targ.gold_kill;
        switch (targ.classname)
        {
            case "player":
                KillTier_Update(attacker, KT_CHAMPKILL, CREEP_NONE);
                break;
            case "creep":
                KillTier_Update(attacker, KT_MINIONKILL, targ.type);
                break;
            default:
        }
        
    }

    entity p;
    p = find(world, classname, "player");
    while (p)
    {
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
                // they got kill gold
                at = find(at, classname, "assist_tracker");
                continue;
            }

            at.enemy.gold = at.enemy.gold + targ.gold_assist;
            if (at.owner.classname == "player")
            {
                KillTier_Update(at.enemy, KT_CHAMPASSIST, CREEP_NONE);
            }
        }
        at = find (at, classname, "assist_tracker");
    }
}