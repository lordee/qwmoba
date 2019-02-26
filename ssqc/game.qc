void () GameThink = {
    // gold
    entity p;
    p = find(world, "classname", "player");
    while (p)
    {
        p.gold = p.gold + 1;
        
        if (p.deadflag == DEAD_DEAD)
        {
            p.respawntime = p.respawntime - 1;
            if (p.respawntime == 0)
            {
                oldself = self;
                self = p;
                PutClientInServer();
                self = oldself;
            }
        }

        p = find(p, "classname", "player");
    }

    self.nextthink = time + 1;
}

void () WaveThink = {
    self.wave = self.wave + 1;
    dprint("wave think going for wave: ", ftos(self.wave));

    float teamcheck, inhibsdown;
    teamcheck = 2;

    while(teamcheck > 0)
    {
        inhibsdown = NumInhibsDown(teamcheck);

        // if all inhibitors down, double spawn speed
        float w;
        w = inhibsdown == 3 ? (self.wait / 2) : self.wait;
        self.nextthink = time + w;

        entity spawn;
        spawn = find(world, classname, "info_creep_teamspawn");
        while (spawn)
        {
            if (spawn.team_no == teamcheck)
            {
                // every wave has 3 melee, 3 range
                float spawnnum, lanenum;
                vector org;
                spawnnum = 6;
                lanenum = spawn.lane;
                
                while (spawnnum > 0)
                {   
                    org = spawn.origin;
                    switch (spawnnum)
                    {
                        case 6:
                            org_x = org_x + CREEP_SPAWNOFFSET_X;
                            SpawnCreep(CREEP_MELEE, org, lanenum, teamcheck);
                            break;
                        /*case 5:
                            org_x = org_x + CREEP_SPAWNOFFSET_X;
                            org_y = org_y - CREEP_SPAWNOFFSET_Y;
                            SpawnCreep(CREEP_MELEE, org, lanenum);
                            break;
                        case 4:
                            org_x = org_x + CREEP_SPAWNOFFSET_X;
                            org_y = org_y + CREEP_SPAWNOFFSET_Y;
                            SpawnCreep(CREEP_MELEE, org, lanenum);
                            break;*/
                        /*case 3:
                            SpawnCreep(CREEP_RANGE, org, lanenum);
                            break;
                        case 2:
                            org_y = org_y - CREEP_SPAWNOFFSET_Y;
                            SpawnCreep(CREEP_RANGE, org, lanenum);
                            break;
                        case 1:
                            org_y = org_y + CREEP_SPAWNOFFSET_Y;
                            SpawnCreep(CREEP_RANGE, org, lanenum);
                            break;*/
                        default:
                    }
                    spawnnum = spawnnum - 1;        
                }
                
                org = spawn.origin;
                org_x = org_x + (CREEP_SPAWNOFFSET_X / 2);
                // if all inhibs down, super minions in each wave
                /*if (inhibsdown == 3)
                {
                    SpawnCreep(CREEP_SUPER, org, lanenum);
                }
                else if (self.wave % 3 == 0)
                {
                    // if inhibitor is down, cannon is super minion
                    if (InhibDown(teamcheck, lanenum))
                    {
                        SpawnCreep(CREEP_SUPER, org, lanenum);
                    }
                    else
                    {
                        SpawnCreep(CREEP_CANNON, org, lanenum);
                    }               
                }*/
            }
            spawn = find(spawn, classname, "info_creep_teamspawn");
        }

        teamcheck = teamcheck - 1;
    }    
}

void () StartGame = {
    bprint(PRINT_HIGH, "GAME IS STARTING\n");
    // respawn champs
    entity p;
    p = find(world, "classname", "player");
    while (p)
    {
        oldself = self;
        self = p;
        PutClientInServer();
        self = oldself;
        p = find(p, "classname", "player");
    }
    // start game timer
    self.cnt2 = 0;
    self.think = GameThink
    self.nextthink = time + 1;

    // other timers (wave manager etc?)
    entity wm;
    wm = spawn();
    wm.owner = world;
    wm.classname = "wavemanager";
    wm.think = WaveThink;
    wm.wait = 30;
    wm.nextthink = time + wm.wait;
}

void () LobbyThink = {
    // check all players selected champs
    entity p;
    p = find(world, "classname", "player");
    if (p)
    {
        while (p)
        {
            // not everyone has a champ yet
            if (!p.champ)
            {
                self.nextthink = time + 1;
                return;
            }
            // not everyone is ready
            if (!p.ready)
            {
                self.nextthink = time + 1;
                return;
            }
            p = find(p, "classname", "player");
        }
    }
    else // there are no players
    {
        self.nextthink = time + 1;
        return;
    }
    
    // champs are selected, everyone is /ready
    // countdown start of game
    if (te.cnt2 > 0)
    {
        bprint(PRINT_HIGH, "\s[\s", ftos(te.cnt2), "\s]\s second");
        if (te.cnt2 > 1)
        {
            bprint(PRINT_HIGH, "s");
        }
        bprint(PRINT_HIGH, "remaining\n");

        te.cnt2 = te.cnt2 - 1;
        self.nextthink = time + 1;
        return;
    }
    
    // we got this far, start the game
    StartGame();
}



