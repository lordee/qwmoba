float (float team) NumInhibsDown = {
    entity inhib;
    float num;
    inhib = find(world, classname, "item_qwmgoal");

    while (inhib)
    {
        if (inhib.type == STRUCTURE_INHIB)
        {
            if (inhib.deadflag == DEAD_DEAD && inhib.team_no == team)
            {
                num = num + 1;
            }
        }
        inhib = find(inhib, classname, "item_qwmgoal");
    }

    return num;
}

float (float team, float lanenum) InhibDown = {
    entity item;
    item = find(world, classname, "item_qwmgoal");

    while (item)
    {
        if (item.type == STRUCTURE_INHIB)
        {
            if (item.lane == lanenum && item.team_no == team)
            {
                if (item.deadflag == DEAD_DEAD)
                {
                    return TRUE;
                }
                else
                {
                    return FALSE;
                }
            }
        }
        inhib = find(world, classname, "item_qwmgoal");
    }

    return FALSE;
}

// creep spawn
void () WaveThink = {
    self.wave = self.wave + 1;

    float teamcheck, inhibsdown;
    teamcheck = self.team_no == 1 ? 2 : 1;
    inhibsdown = NumInhibsDown(teamcheck);

    // if all inhibitors down, double spawn speed
    float w;
    w = inhibsdown == 3 ? (self.wait / 2) : self.wait;
    
    self.nextthink = time + w;

    entity spawn;
    spawn = find(world, classname, "info_creep_teamspawn");
    while (spawn)
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
                    SpawnCreep(CREEP_MELEE, org);
                    break;
                case 5:
                    org_x = org_x + CREEP_SPAWNOFFSET_X;
                    org_y = org_y - CREEP_SPAWNOFFSET_Y;
                    SpawnCreep(CREEP_MELEE, org);
                    break;
                case 4:
                    org_x = org_x + CREEP_SPAWNOFFSET_X;
                    org_y = org_y + CREEP_SPAWNOFFSET_Y;
                    SpawnCreep(CREEP_MELEE, org);
                    break;
                case 3:
                    SpawnCreep(CREEP_RANGE, org);
                    break;
                case 2:
                    org_y = org_y - CREEP_SPAWNOFFSET_Y;
                    SpawnCreep(CREEP_RANGE, org);
                    break;
                case 1:
                    org_y = org_y + CREEP_SPAWNOFFSET_Y;
                    SpawnCreep(CREEP_RANGE, org);
                    break;
            }
            spawnnum = spawnnum - 1;        
        }
        
        org = spawn.origin;
        org_x = org_x + (CREEP_SPAWNOFFSET_X / 2);
        // if all inhibs down, super minions in each wave
        if (inhibsdown == 3)
        {
            SpawnCreep(CREEP_SUPER, org);
        }
        else if (self.wave % 3 == 0)
        {
            // if inhibitor is down, cannon is super minion
            if (InhibDown(teamcheck, lane))
            {
                SpawnCreep(CREEP_SUPER, org);
            }
            else
            {
                SpawnCreep(CREEP_CANNON, org);
            }               
        }
        spawn = find(spawn, classname, "info_creep_teamspawn");
    }
}

void () info_creep_teamspawn = {
    if ((self.team_no <= 0) || (self.team_no >= 3)) {
        objerror
            ("error: bad team_no associated with info_creep_teamspawn\n");
        remove(self);
        return;
    }
}

void () info_qwmwavemanager = {
    if ((self.team_no <= 0) || (self.team_no >= 3)) {
        objerror
            ("error: bad team_no associated with info_creep_teamspawn\n");
        remove(self);
        return;
    }

    // setup timer
    if (self.wait == 0)
    {
        self.wait = 30;
    }
    self.wave = 0;
    self.nextthink = time + self.wait;
    self.think = WaveThink;
}

// tower, inhibs, base
void () GoalThink = {
    self.nextthink = time + REGEN_TICKTIME;
    
    if (self.deadflag == DEAD_DEAD && self.type != STRUCTURE_INHIB)
    {
        return;
    }

    switch (self.type)
    {
        case STRUCTURE_TOWER:
            // check if any enemy in range, shoot them
            break;
        case STRUCTURE_INHIB:
            if (self.deadflag == DEAD_DEAD)
            {
                if (self.deadtime >= time)
                {
                    self.deadflag = DEAD_NO;
                    self.health = self.max_health;
                    bprint("Team ", ftos(self.team_no), "'s inhibitor has respawned");
                }
                else
                {
                    return;
                }
            }
            break;
    }

    self.health = self.health + self.healthregen;
    self.mana = self.mana + self.manaregen;

    if (self.health > self.max_health)
    {
        self.health = self.max_health;
    }
    if (self.mana > self.max_mana)
    {
        self.mana = self.max_mana;
    }
}

void () item_qwmgoal = {
    if ((self.team_no <= 0) || (self.team_no >= 3)) {
        objerror
            ("error: bad team_no associated with item_qwmgoal\n");
        remove(self);
        return;
    }

    switch (self.type)
    {
        case STRUCTURE_NEXUS:
            self.health = 4000;
            self.healthregion = 10;
            break;
        case STRUCTURE_INHIB:
            self.health = 3000;
            self.healthregion = 10;
            break;
        case STRUCTURE_TOWER:
            self.health = 2000;
            break;
    }
    self.think = GoalThink;
    self.nextthink = time + REGEN_TICKTIME;
}


// player/team spawn
void () info_player_teamspawn = {
    if ((self.team_no <= 0) || (self.team_no >= 3)) {
        objerror
            ("error: bad team_no associated with info_player_teamspawn\n");
        remove(self);
        return;
    }

    switch (self.team_no)
    {
        case 1:
            self.team_str = "teamspawnone"
            break;
        case 2:
            self.team_str = "teamspawntwo"
            break;
    }
}

// shop
info_qwmgoal

// waypoints
info_qwmgoal