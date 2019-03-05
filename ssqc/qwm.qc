void (entity player, float kill_type, float creep_type) GoldTracker_Update = {
    // kills
    // minions
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
            // if more than 1k reward, only reward 1k and reduce tier
            if (player.kill_tier > 3 && player.consecutive_kills >= 7)
            {
                float gk, nt;
                gk = 600 + (100 * (player.consecutive_kills - 3));
                nt = (gk - 600) / 100;

            }
            

            
            

            // tier resets to 0 when dying whilst being on a positive tier

            player.kill_tier = (player.kill_tier > 0) ? 0 : player.kill_tier;

            player.consecutive_kills = 0;
            player.consecutive_deaths = player.consecutive_deaths + 1;
            break;
            
    }

}

void (entity player) SetGold = {
    if (player.kill_tier > 3)
    {
        float gk;
        gk = 600 + (100 * (player.consecutive_kills - 3));
        gk = (gk > 1000) ? 1000 : gk;

        player.gold_kill = gk;
        player.gold_assist = 150;
    }
    else {
        switch (player.kill_tier)
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