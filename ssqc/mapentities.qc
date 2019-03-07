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
    entity inhib;
    inhib = find(world, classname, "item_qwmgoal");

    while (inhib)
    {
        if (inhib.type == STRUCTURE_INHIB)
        {
            if (inhib.lane == lanenum && inhib.team_no == team)
            {
                if (inhib.deadflag == DEAD_DEAD)
                {
                    return TRUE;
                }
                else
                {
                    return FALSE;
                }
            }
        }
        inhib = find(inhib, classname, "item_qwmgoal");
    }

    return FALSE;
}

void () info_creep_teamspawn = {
    switch (self.team_no)
    {
        case 1:
            self.team_str = "team1";
            break;
        case 2:
            self.team_str = "team2";
            break;
        default:
            objerror
            ("error: bad team_no associated with info_creep_teamspawn\n");
            remove(self);
            return;
    }
}

// this doesn't need to be an entity
void () info_qwmwavemanager = {
    remove(self);
}

void () s_explode1;
void() TowerMissileTouch =
{
	if (other != self.enemy)
		return;		// don't explode unless it's enemy

    T_Damage (other, self, self.owner, self.attackdamage);	
	
	sound (self, CHAN_WEAPON, "weapons/r_exp3.wav", 1, ATTN_NORM);

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);

	self.velocity = '0 0 0';
	self.touch = SUB_Null;
	setmodel (self, "progs/s_explod.spr");
	self.solid = SOLID_NOT;
	s_explode1 ();
}

void() TowerMissileThink =
{
	local vector	dir, vtemp;
	vtemp = self.enemy.origin + '0 0 10';
	if (self.enemy.health < 1)
	{
		remove(self);
		return;
	}
	dir = normalize(vtemp - self.origin);
    self.velocity = dir * 350;

	self.nextthink = time + 0.2;
	self.think = TowerMissileThink;	
}

void () TowerShoot = {
    local	entity 	missile;
	local	vector	dir;
	local	float	dist, flytime;

	dir = normalize((self.enemy.origin + '0 0 10') - self.origin);
	dist = vlen (self.enemy.origin - self.origin);
	flytime = dist * 0.002;
	if (flytime < 0.1)
		flytime = 0.1;

	self.effects = self.effects | EF_MUZZLEFLASH;
	sound (self, CHAN_WEAPON, "shalrath/attack2.wav", 1, ATTN_NORM);

	missile = spawn ();
	missile.owner = self;

	missile.solid = SOLID_BBOX;
	missile.movetype = MOVETYPE_FLYMISSILE;
	setmodel (missile, "progs/v_spike.mdl");

	setsize (missile, '0 0 0', '0 0 0');		

	missile.origin = self.origin + '0 0 10';
	missile.velocity = dir * 400;
	missile.avelocity = '300 300 300';
	missile.nextthink = flytime + time;
	missile.think = TowerMissileThink;
	missile.enemy = self.enemy;
	missile.touch = TowerMissileTouch;
    missile.attackdamage = self.attackdamage;
    self.attack_finished = time + (1 / self.attackspeed);
}

// tower, inhibs, base
void () GoalThink = {
    self.nextthink = time + REGEN_TICKTIME;
    
    if (self.deadflag == DEAD_DEAD && self.type != STRUCTURE_INHIB)
    {
        return;
    }

    DoRegen(self);

    switch (self.type)
    {
        case STRUCTURE_TOWER:
            // check if any enemy in range, shoot them
            float dist;
            dist = 0;
            if (self.enemy)
            {
                dist = vlen(self.enemy.origin - self.origin);
                if (dist <= STRUCTURE_TOWER_RANGE)
                {
                    if (self.attack_finished <= time)
                    {
                        // shoot target
                        TowerShoot();
                    }
                }
                else
                {
                    self.enemy = world;
                }
            }
            else
            {
                // check for enemy
                // first check for creeps
                entity en, targ;
                float closest;
                closest = 0;
                targ = world;

                en = find(world, classname, "creep");
                while (en)
                {
                    if (en.team_no != self.team_no)
                    {
                        dist = vlen(en.origin- self.origin);
                        if (dist <= STRUCTURE_TOWER_RANGE)
                        {
                            if (closest == 0)
                            {
                                closest = dist;
                                targ = en;
                            }
                            else
                            {
                                // targ priorities (melee over range etc)
                                if (en.type >= targ.type)
                                {
                                    if (dist <= closest)
                                    {
                                        closest = dist;
                                        targ = en;
                                    }
                                }
                            }
                        }
                    }
                    en = find(en, classname, "creep");
                }

                if (targ)
                {
                    self.enemy = targ;
                    return;
                }
                
                // check for champs
                closest = 0;
                dist = 0;
                en = find(world, classname, "player");
                while (en)
                {
                    if (en.team_no != self.team_no)
                    {
                        dist = vlen(en.origin- self.origin);
                        if (dist <= STRUCTURE_TOWER_RANGE)
                        {
                            if (closest == 0)
                            {
                                closest = dist;
                                targ = en;
                            }
                            else
                            {
                                if (dist <= closest)
                                {
                                    closest = dist;
                                    targ = en;
                                }
                            }
                        }
                    }
                    en = find(en, classname, "player");
                }
                self.enemy = targ;
            }
            break;
        case STRUCTURE_INHIB:
            if (self.deadflag == DEAD_DEAD)
            {
                if (self.deadtime >= time)
                {
                    self.deadflag = DEAD_NO;
                    self.health = self.max_health;
                    
                    bprint(PRINT_HIGH, "Team ", ftos(self.team_no), "'s inhibitor has respawned");
                }
                else
                {
                    return;
                }
            }
            break;
    }
}

void () item_qwmgoal = {
    switch (self.team_no)
    {
        case 1:
            self.team_str = "team1";
            break;
        case 2:
            self.team_str = "team2";
            break;
        default:
            objerror
            ("error: bad team_no associated with item_qwmgoal\n");
            remove(self);
            return;
    }

    switch (self.type)
    {
        case STRUCTURE_NEXUS:
            precache_model("progs/oldone.mdl");
            self.solid = SOLID_BSP;
	        self.movetype = MOVETYPE_NONE;
            setmodel (self, "progs/oldone.mdl");
	        setsize (self, '-160 -128 -24', '160 128 256');

            self.takedamage = TRUE;
            self.health = STRUCTURE_NEXUS_HEALTH;
            self.max_health = STRUCTURE_NEXUS_HEALTH;
            self.healthregen = STRUCTURE_NEXUS_HEALTH_REGEN;
            self.armorvalue = STRUCTURE_NEXUS_ARMOUR_BASE;
            self.mrvalue = STRUCTURE_NEXUS_MR_BASE;
            self.gold_global = STRUCTURE_NEXUS_GOLD_GLOBAL;
            self.gold_assist = STRUCTURE_NEXUS_GOLD_ASSIST;
            self.gold_kill = STRUCTURE_NEXUS_GOLD_KILL;
            self.think = GoalThink;
            self.nextthink = time + .1;
            break;
        case STRUCTURE_INHIB:
            precache_model ("progs/shambler.mdl");
            self.solid = SOLID_BSP;
	        self.movetype = MOVETYPE_NONE;
            setmodel (self, "progs/shambler.mdl");
	        setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);

            self.health = STRUCTURE_INHIB_HEALTH;
            self.max_health = STRUCTURE_INHIB_HEALTH;
            self.healthregen = STRUCTURE_INHIB_HEALTH_REGEN;
            self.armorvalue = STRUCTURE_INHIB_ARMOUR_BASE;
            self.mrvalue = STRUCTURE_INHIB_MR_BASE;
            self.gold_global = STRUCTURE_INHIB_GOLD_GLOBAL;
            self.gold_assist = STRUCTURE_INHIB_GOLD_ASSIST;
            self.gold_kill = STRUCTURE_INHIB_GOLD_KILL;

            self.think = GoalThink;
            self.nextthink = time + .1;
            break;
        case STRUCTURE_TOWER:
            precache_model("progs/shalrath.mdl");
            precache_model2 ("progs/v_spike.mdl");
            precache_sound2 ("shalrath/attack2.wav");
            self.solid = SOLID_BSP;
            self.movetype = MOVETYPE_NONE;
            setmodel (self, "progs/shalrath.mdl");
            setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);

            switch (self.tower_no)
            {
                case STRUCTURE_TOWER_NEXUS:
                    self.health = STRUCTURE_TOWER_NEXUS_HEALTH;
                    self.max_health = STRUCTURE_TOWER_NEXUS_HEALTH;
                    self.healthregen = STRUCTURE_TOWER_NEXUS_HEALTH_REGEN;
                    self.attackdamage = STRUCTURE_TOWER_NEXUS_AD;
                    self.attackspeed = STRUCTURE_TOWER_NEXUS_ATTACKSPEED;
                    self.armorvalue = STRUCTURE_TOWER_NEXUS_ARMOUR_BASE;
                    self.mrvalue = STRUCTURE_TOWER_NEXUS_MR_BASE;
                    self.gold_global = STRUCTURE_TOWER_NEXUS_GOLD_GLOBAL;
                    self.gold_assist = STRUCTURE_TOWER_NEXUS_GOLD_ASSIST;
                    self.gold_kill = STRUCTURE_TOWER_NEXUS_GOLD_KILL;
                    break;
                case STRUCTURE_TOWER_INHIB:
                    self.health = STRUCTURE_TOWER_INHIB_HEALTH;
                    self.max_health = STRUCTURE_TOWER_INHIB_HEALTH;
                    self.healthregen = STRUCTURE_TOWER_INHIB_HEALTH_REGEN;
                    self.attackdamage = STRUCTURE_TOWER_INHIB_AD;
                    self.attackspeed = STRUCTURE_TOWER_INHIB_ATTACKSPEED;
                    self.armorvalue = STRUCTURE_TOWER_INHIB_ARMOUR_BASE;
                    self.mrvalue = STRUCTURE_TOWER_INHIB_MR_BASE;
                    self.gold_global = STRUCTURE_TOWER_INHIB_GOLD_GLOBAL;
                    self.gold_assist = STRUCTURE_TOWER_INHIB_GOLD_ASSIST;
                    self.gold_kill = STRUCTURE_TOWER_INHIB_GOLD_KILL;
                    break;
                case STRUCTURE_TOWER_INNER:
                    self.health = STRUCTURE_TOWER_INNER_HEALTH;
                    self.max_health = STRUCTURE_TOWER_INNER_HEALTH;
                    self.healthregen = STRUCTURE_TOWER_INNER_HEALTH_REGEN;
                    self.attackdamage = STRUCTURE_TOWER_INNER_AD;
                    self.attackspeed = STRUCTURE_TOWER_INNER_ATTACKSPEED;
                    self.armorvalue = STRUCTURE_TOWER_INNER_ARMOUR_BASE;
                    self.mrvalue = STRUCTURE_TOWER_INNER_MR_BASE;
                    self.gold_global = STRUCTURE_TOWER_INNER_GOLD_GLOBAL;
                    self.gold_assist = STRUCTURE_TOWER_INNER_GOLD_ASSIST;
                    self.gold_kill = STRUCTURE_TOWER_INNER_GOLD_KILL;
                    break;
                case STRUCTURE_TOWER_OUTER:
                    self.health = STRUCTURE_TOWER_OUTER_HEALTH;
                    self.max_health = STRUCTURE_TOWER_OUTER_HEALTH;
                    self.healthregen = STRUCTURE_TOWER_OUTER_HEALTH_REGEN;
                    self.attackdamage = STRUCTURE_TOWER_OUTER_AD;
                    self.attackspeed = STRUCTURE_TOWER_OUTER_ATTACKSPEED;
                    self.armorvalue = STRUCTURE_TOWER_OUTER_ARMOUR_BASE;
                    self.mrvalue = STRUCTURE_TOWER_OUTER_MR_BASE;
                    self.gold_global = STRUCTURE_TOWER_OUTER_GOLD_GLOBAL;
                    self.gold_assist = STRUCTURE_TOWER_OUTER_GOLD_ASSIST;
                    self.gold_kill = STRUCTURE_TOWER_OUTER_GOLD_KILL;
                    break;
            }

            self.think = GoalThink;
            self.nextthink = time + .1;
            break;
        case STRUCTURE_SHOP:
            self.takedamage = FALSE;
            precache_model("progs/tarbaby.mdl");
            self.solid = SOLID_BSP;
	        self.movetype = MOVETYPE_NONE;
            setmodel (self, "progs/tarbaby.mdl");
	        setsize (self, '-16 -16 -24', '16 16 40');
            break;
    }
}


// player/team spawn
void () info_player_teamspawn = {
    switch (self.team_no)
    {
        case 1:
            self.team_str = "teamspawnone";
            break;
        case 2:
            self.team_str = "teamspawntwo";
            break;
        default:
            objerror
            ("error: bad team_no associated with info_player_teamspawn\n");
            remove(self);
            return;
    }
}

// waypoints
//info_qwmgoal

void () info_qwmgoal = {
    switch (self.team_no)
    {
        case 1:
            self.team_str = "team1";
            break;
        case 2:
            self.team_str = "team2";
            break;
        default:
            objerror
            ("error: bad team_no associated with info_qwmgoal\n");
            remove(self);
            return;
    }
}