void () SkillOne_FrostArcher;
void () SkillTwo_FrostArcher;
void () SkillThree_FrostArcher;
void () SkillFour_FrostArcher;

void (entity e) DoRegen = {
    if (e.deadflag == DEAD_NO)
    {
        if (time >= e.healthlastregen)
        {
            e.health = e.health + e.healthregen;
            if (self.health > self.max_health)
            {
                self.health = self.max_health;
            }
            self.healthlastregen = time + self.regentick;
        }

        if (time >= self.manalastregen)
        {
            self.mana = self.mana + self.manaregen;
            if (self.mana > self.max_mana)
            {
                self.mana = self.max_mana;
            }
            self.manalastregen = time + self.regentick;
        }
    }
}

void () SetupChamp = {
    self.regentick = time + REGEN_TICKTIME;
    switch (self.champ)
    {
        case CHAMP_FROSTARCHER:
            self.attackdamage = BASEAD_FROSTARCHER;
            self.health = BASEHEALTH_FROSTARCHER;
            self.max_health = BASEHEALTH_FROSTARCHER;
            self.healthregen = BASEHEALTH_REGEN_FROSTARCHER; // per second
            self.mana = BASEMANA_FROSTARCHER;
            self.max_mana = BASEMANA_FROSTARCHER;
            self.manaregen = BASEMANA_REGEN_FROSTARCHER;
            self.speed = BASESPEED_FROSTARCHER;
            self.weapon = WEAPON_FROSTARCHER;
            self.attackspeed = BASEATTACKSPEED_FROSTARCHER;
            self.skillone = SKILLONE_FROSTARCHER;
            self.skillonemanacost = SKILLONE_MANACOST_FROSTARCHER;
            self.skillonecooldown = 0;
            self.skillonedamage = SKILLONE_DAMAGE_FROSTARCHER;
            self.skilltwo = SKILLTWO_FROSTARCHER;
            self.skilltwomanacost = SKILLTWO_MANACOST_FROSTARCHER;
            self.skilltwocooldown = 0;
            self.skilltwodamage = SKILLTWO_DAMAGE_FROSTARCHER;
            self.skillthree = SKILLTHREE_FROSTARCHER;
            self.skillthreemanacost = SKILLTHREE_MANACOST_FROSTARCHER;
            self.skillthreecooldown = 0;
            self.skillthreedamage = SKILLTHREE_DAMAGE_FROSTARCHER;
            self.skillfour = SKILLFOUR_FROSTARCHER;
            self.skillfourmanacost = SKILLFOUR_MANACOST_FROSTARCHER;
            self.skillfourcooldown = 0;
            self.skillfourdamage = SKILLFOUR_DAMAGE_FROSTARCHER;
        break;
    }
}

void () ChangeSkill = {
    float s;
    s = self.activeskill;
    switch (self.impulse)
    {
        case SKILLONE:
            s = self.skillone;
            break;
        case SKILLTWO:
            s = self.skilltwo;
            break;
        case SKILLTHREE:
            s = self.skillthree;
            break;
        case SKILLFOUR:
            s = self.skillfour;
            break;
    }

    // do checks??

    // switch to skill
    self.activeskill = s;
}

void (float skill) UseSkill = {
    switch (skill)
    {
        case SKILLONE_FROSTARCHER:
            SkillOne_FrostArcher();
        break;
        case SKILLTWO_FROSTARCHER:
            SkillTwo_FrostArcher();
        break;
        case SKILLTHREE_FROSTARCHER:
            SkillThree_FrostArcher();
        break;
        case SKILLFOUR_FROSTARCHER:
            SkillFour_FrostArcher();
        break;
    }   
}

float (float cooldown, float manacost) CanCast = {
    if (cooldown <= time)
    {
        // take off mana
        if (self.mana >= manacost)
        {
           return TRUE;
        }
        else
        {
            sprint(self, PRINT_HIGH, "Not enough mana\n");
            return FALSE;
        }
    }
    else
    {
        return FALSE;
    }
}

void (entity player) UpdateStats = {

    float attdamage, attspeed, msspeed, hth, mna, lvl;
    lvl = player.level;
    
    switch (player.champ)
    {
        case CHAMP_FROSTARCHER:
            // base char
            attdamage = BASEAD_FROSTARCHER;
            attspeed = BASEATTACKSPEED_FROSTARCHER;
            msspeed = BASESPEED_FROSTARCHER;
            hth = BASEHEALTH_FROSTARCHER;
            mna = BASEMANA_FROSTARCHER;

            // char levels
            attdamage = attdamage + (GROWTH_AD_FROSTARCHER * lvl);
            attspeed = attspeed * ((100 + (GROWTH_AS_FROSTARCHER * lvl)) / 100);
            hth = hth + (GROWTH_HEALTH_FROSTARCHER * lvl);
            mna = mna + (GROWTH_MANA_FROSTARCHER * lvl);
            break;
    }

    // items

    // buffs
    entity buff;
    float val;

    buff = find(world, classname, "buff");
    while (buff)
    {
        val = buff.buffvalue;
        switch (buff.buffcategory)
        {
            case DEBUFF_MSSLOW:
                msspeed = msspeed * ((100 - val) / 100);
                break;
            case BUFF_AASPEED:
                attspeed = attspeed * ((100 + val) / 100);
                break;
        }
        buff = find(buff, classname, "buff");
    }

    float h, m, mh, mm;
    h = player.health;
    m = player.mana;
    mh = player.max_health;
    mm = player.max_mana;

    player.attackspeed = attspeed;
    player.speed = msspeed;
    player.health = h + (hth - mh);
    player.max_health = hth;
    player.mana = m + (mna - mm);
    player.max_mana = mna;
}

void (entity player, entity targ, float killtype, float numparticipants) ApplyExperience = {

    float exp, currexp;
    currexp = player.experience;
    exp = 0;
    switch (targ.classname)
    {
        case "creep":
            switch (targ.type)
            {
                case CREEP_MELEE:
                    exp = CREEP_MELEE_EXP;
                    break;
                case CREEP_RANGE:
                    exp = CREEP_RANGE_EXP;
                    break;
                case CREEP_CANNON:
                    exp = CREEP_CANNON_EXP;
                    break;
                case CREEP_SUPER:
                    exp = CREEP_SUPER_EXP;
                    break;
            }
            
            if (numparticipants > 1)
            {
                exp = exp * 1.304;
                exp = exp / numparticipants;
            }           
            break;
        case "player":
            exp = 140 * targ.level;
            if (killtype == KT_CHAMPASSIST)
            {
                // share exp with all assisters
                exp = exp / numparticipants;
            }
            else if (killtype == KT_CHAMPKILL)
            {
                entity at;
                at = find(world, classname, "assist_tracker");
                while (at)
                {
                    if (at.owner == targ)
                    {
                        if (at.enemy != player)
                        {
                            ApplyExperience(at.enemy, targ, KT_CHAMPASSIST, at.owner.assist_count);
                        }
                    }
                    at = find(at, classname, "assist_tracker");
                }
            }
            break;
        case "item_qwmgoal":
            switch (targ.type)
            {
                case STRUCTURE_INHIB:
                        exp = STRUCTURE_INHIB_EXP;
                    break;
                case STRUCTURE_TOWER:
                        exp = STRUCTURE_TOWER_EXP;
                    break;
            }
            break;
        default:
    }
    
    exp = player.experience + exp;

    float bar = GetExpBar(player.level);

    if (exp >= bar)
    {
        float lvl;
        lvl = player.level;

        player.level = lvl + 1;
        player.experience = exp - bar;

        // TODO fancy graphics
        // TODO tell client
    }
    else
    {
        player.experience = exp;
    }
}