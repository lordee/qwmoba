void () SkillOne_Ashe;
void () SkillTwo_Ashe;
void () SkillThree_Ashe;
void () SkillFour_Ashe;

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
            self.healthlastregen = time;
        }

        if (time >= self.manalastregen)
        {
            self.mana = self.mana + self.manaregen;
            if (self.mana > self.max_mana)
            {
                self.mana = self.max_mana;
            }
            self.manalastregen = time;
        }
    }
}

void () SetupChamp = {
    self.regentick = time + REGEN_TICKTIME;
    switch (self.champ)
    {
        case CHAMP_ASHE:
            self.attackdamage = BASEAD_ASHE;
            self.health = BASEHEALTH_ASHE;
            self.max_health = BASEHEALTH_ASHE;
            self.healthregen = BASEHEALTH_REGEN_ASHE; // per second
            self.mana = BASEMANA_ASHE;
            self.max_mana = BASEMANA_ASHE;
            self.manaregen = BASEMANA_REGEN_ASHE;
            self.speed = BASESPEED_ASHE;
            self.weapon = WEAPON_ASHE;
            self.attackspeed = BASEATTACKSPEED_ASHE;
            self.skillone = SKILLONE_ASHE;
            self.skillonemanacost = SKILLONE_MANACOST_ASHE;
            self.skillonecooldown = SKILLONE_COOLDOWN_ASHE;
            self.skillonedamage = SKILLONE_DAMAGE_ASHE;
            self.skilltwo = SKILLTWO_ASHE;
            self.skilltwomanacost = SKILLTWO_MANACOST_ASHE;
            self.skilltwocooldown = SKILLTWO_COOLDOWN_ASHE;
            self.skilltwodamage = SKILLTWO_DAMAGE_ASHE;
            self.skillthree = SKILLTHREE_ASHE;
            self.skillthreemanacost = SKILLTHREE_MANACOST_ASHE;
            self.skillthreecooldown = SKILLTHREE_COOLDOWN_ASHE;
            self.skillthreedamage = SKILLTHREE_DAMAGE_ASHE;
            self.skillfour = SKILLFOUR_ASHE;
            self.skillfourmanacost = SKILLFOUR_MANACOST_ASHE;
            self.skillfourcooldown = SKILLFOUR_COOLDOWN_ASHE;
            self.skillfourdamage = SKILLFOUR_DAMAGE_ASHE;
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
    sprint(self, PRINT_HIGH, "skill is now active: ", ftos(s), "\n");
    self.activeskill = s;
}

void (float skill) UseSkill = {
    switch (skill)
    {
        case SKILLONE_ASHE:
            SkillOne_Ashe();
        break;
        case SKILLTWO_ASHE:
            SkillTwo_Ashe();
        break;
        case SKILLTHREE_ASHE:
            SkillThree_Ashe();
        break;
        case SKILLFOUR_ASHE:
            SkillFour_Ashe();
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
        sprint(self, PRINT_HIGH, "This skill is on cooldown\n");
        return FALSE;
    }
}

void (entity player) UpdateStats = {

    float attdamage, attspeed, msspeed, hth, mna, lvl;
    lvl = player.level;
    
    switch (player.champ)
    {
        case CHAMP_ASHE:
            // base char
            attdamage = BASEAD_ASHE;
            attspeed = BASEATTACKSPEED_ASHE;
            msspeed = BASESPEED_ASHE;
            hth = BASEHEALTH_ASHE;
            mna = BASEMANA_ASHE;

            // char levels
            attdamage = attdamage + (GROWTH_AD_ASHE * lvl);
            attspeed = attspeed * (100 + ((GROWTH_AS_ASHE * lvl) / 100));
            hth = hth + (GROWTH_HEALTH_ASHE * lvl);
            mna = mna + (GROWTH_MANA_ASHE * lvl);
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

float (entity player) CalcTotalEXP = {
    // better way to do this?
    float exp;
    exp = player.experience;

    if (player.level >= 2)
        exp = exp + EXP_LEVELTWO;
    if (player.level >= 3)
        exp = exp + EXP_LEVELTHREE;
    if (player.level >= 4)
        exp = exp + EXP_LEVELFOUR;
    if (player.level >= 5)
        exp = exp + EXP_LEVELFIVE;
    if (player.level >= 6)
        exp = exp + EXP_LEVELSIX;
    if (player.level >= 7)
        exp = exp + EXP_LEVELSEVEN;
    if (player.level >= 8)
        exp = exp + EXP_LEVELEIGHT;
    if (player.level >= 9)
        exp = exp + EXP_LEVELNINE;
    if (player.level >= 10)
        exp = exp + EXP_LEVELTEN;
    if (player.level >= 11)
        exp = exp + EXP_LEVELELEVEN;
    if (player.level >= 12)
        exp = exp + EXP_LEVELTWELVE;
    if (player.level >= 13)
        exp = exp + EXP_LEVELTHIRTEEN;
    if (player.level >= 14)
        exp = exp + EXP_LEVELFOURTEEN;
    if (player.level >= 15)
        exp = exp + EXP_LEVELFIFTEEN;
    if (player.level >= 16)
        exp = exp + EXP_LEVELSIXTEEN;
    if (player.level >= 17)
        exp = exp + EXP_LEVELSEVENTEEN;
    if (player.level >= 18)
        exp = exp + EXP_LEVELEIGHTEEN;
    
    return exp;
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
            if (killtype == KILLTYPE_ASSIST)
            {
                // share exp with all assisters
                exp = exp / numparticipants;
            }
            break;
        case "item_qwmgoal":

            break;
        default:
    }
    
    exp = player.experience + exp;

    float bar; 

    if (player.level == 1)
        bar = EXP_LEVELTWO;
    else if (player.level == 2)
        bar = EXP_LEVELTHREE;
    else if (player.level == 3)
        bar = EXP_LEVELFOUR;
    else if (player.level == 4)
        bar = EXP_LEVELFIVE;
    else if (player.level == 5)
        bar = EXP_LEVELSIX;
    else if (player.level == 6)
        bar = EXP_LEVELSEVEN;
    else if (player.level == 7)
        bar = EXP_LEVELEIGHT;
    else if (player.level == 8)
        bar = EXP_LEVELNINE;
    else if (player.level == 9)
        bar = EXP_LEVELTEN;
    else if (player.level == 10)
        bar = EXP_LEVELELEVEN;
    else if (player.level == 11)
        bar = EXP_LEVELTWELVE;
    else if (player.level == 12)
        bar = EXP_LEVELTHIRTEEN;
    else if (player.level == 13)
        bar = EXP_LEVELFOURTEEN;
    else if (player.level == 14)
        bar = EXP_LEVELFIFTEEN;
    else if (player.level == 15)
        bar = EXP_LEVELSIXTEEN;
    else if (player.level == 16)
        bar = EXP_LEVELSEVENTEEN;
    else if (player.level == 17)
        bar = EXP_LEVELEIGHTEEN;

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