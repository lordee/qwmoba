void () SkillOne_FrostArcher;
void () SkillTwo_FrostArcher;
void () SkillThree_FrostArcher;
void () SkillFour_FrostArcher;

typedef struct {
    float champ_id;
    float basead;
    float basehealth;
    float basehealth_regen;
    float basemana;
    float basemana_regen;
    float basespeed;
    float weapon;
    float baseattackspeed;
    float skill_one;
    float skill_one_manacost;
    float skill_one_cooldown;
    float skill_one_damage;
    float skill_two;
    float skill_two_manacost;
    float skill_two_cooldown;
    float skill_two_damage;
    float skill_three;
    float skill_three_manacost;
    float skill_three_cooldown;
    float skill_three_damage;
    float skill_four;
    float skill_four_manacost;
    float skill_four_cooldown;
    float skill_four_damage;
} Champion_t;

// item id, components
Champion_t Champions[2] = {
    {
        CHAMP_FROSTARCHER, 
        BASEAD_FROSTARCHER,
        BASEHEALTH_FROSTARCHER,
        BASEHEALTH_REGEN_FROSTARCHER,
        BASEMANA_FROSTARCHER,
        BASEMANA_REGEN_FROSTARCHER,
        BASESPEED_FROSTARCHER,
        WEAPON_FROSTARCHER,
        BASEATTACKSPEED_FROSTARCHER,
        SKILLONE_FROSTARCHER,
        SKILLONE_MANACOST_FROSTARCHER,
        SKILLONE_COOLDOWN_FROSTARCHER,
        SKILLONE_DAMAGE_FROSTARCHER,
        SKILLTWO_FROSTARCHER,
        SKILLTWO_MANACOST_FROSTARCHER,
        SKILLTWO_COOLDOWN_FROSTARCHER,
        SKILLTWO_DAMAGE_FROSTARCHER,
        SKILLTHREE_FROSTARCHER,
        SKILLTHREE_MANACOST_FROSTARCHER,
        SKILLTHREE_COOLDOWN_FROSTARCHER,
        SKILLTHREE_DAMAGE_FROSTARCHER,
        SKILLFOUR_FROSTARCHER,
        SKILLFOUR_MANACOST_FROSTARCHER,
        SKILLFOUR_COOLDOWN_FROSTARCHER,
        SKILLFOUR_DAMAGE_FROSTARCHER
    },
    {
        CHAMP_SHAMBLER, 
        BASEAD_SHAMBLER,
        BASEHEALTH_SHAMBLER,
        BASEHEALTH_REGEN_SHAMBLER,
        BASEMANA_SHAMBLER,
        BASEMANA_REGEN_SHAMBLER,
        BASESPEED_SHAMBLER,
        WEAPON_SHAMBLER,
        BASEATTACKSPEED_SHAMBLER,
        SKILLONE_SHAMBLER,
        SKILLONE_MANACOST_SHAMBLER,
        SKILLONE_COOLDOWN_SHAMBLER,
        SKILLONE_DAMAGE_SHAMBLER,
        SKILLTWO_SHAMBLER,
        SKILLTWO_MANACOST_SHAMBLER,
        SKILLTWO_COOLDOWN_SHAMBLER,
        SKILLTWO_DAMAGE_SHAMBLER,
        SKILLTHREE_SHAMBLER,
        SKILLTHREE_MANACOST_SHAMBLER,
        SKILLTHREE_COOLDOWN_SHAMBLER,
        SKILLTHREE_DAMAGE_SHAMBLER,
        SKILLFOUR_SHAMBLER,
        SKILLFOUR_MANACOST_SHAMBLER,
        SKILLFOUR_COOLDOWN_SHAMBLER,
        SKILLFOUR_DAMAGE_SHAMBLER
    }
};

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

Champion_t GetChamp(float id)
{
    for (float i = 0; i < Champions.length; i++)
    {
        if (Champions[i].champ_id == id)
        {
            Champion_t champ = Champions[i];
            return champ;
        }
    }
}

void () SetupChamp = {
    self.regentick = time + REGEN_TICKTIME;
    if (self.champ_id)
    {
        Champion_t champ = GetChamp(self.champ_id);

        self.attackdamage = champ.basead;
        self.health = champ.basehealth;
        self.max_health = champ.basehealth;
        self.healthregen = champ.basehealth_regen; // per second
        self.mana = champ.basemana;
        self.max_mana = champ.basemana;
        self.manaregen = champ.basemana_regen;
        self.speed = champ.basespeed;
        self.weapon = champ.weapon;
        self.attackspeed = champ.baseattackspeed;
        self.skill_one = champ.skill_one;
        self.skill_one_manacost = champ.skill_one_manacost;
        self.skill_one_cooldown = 0;
        self.skill_one_damage = champ.skill_one_damage;
        self.skill_two = champ.skill_two;
        self.skill_two_manacost = champ.skill_two_manacost;
        self.skill_two_cooldown = 0;
        self.skill_two_damage = champ.skill_two_damage;
        self.skill_three = champ.skill_three;
        self.skill_three_manacost = champ.skill_three_manacost;
        self.skill_three_cooldown = 0;
        self.skill_three_damage = champ.skill_three_damage;
        self.skill_four = champ.skill_four;
        self.skill_four_manacost = champ.skill_four_manacost;
        self.skill_four_cooldown = 0;
        self.skill_four_damage = champ.skill_four_damage;
    }
}

void () ChangeSkill = {
    float s;
    s = self.skill_selected;
    switch (self.impulse)
    {
        case SKILLONE:
            s = self.skill_one;
            break;
        case SKILLTWO:
            s = self.skill_two;
            break;
        case SKILLTHREE:
            s = self.skill_three;
            break;
        case SKILLFOUR:
            s = self.skill_four;
            break;
    }

    // do checks??

    // switch to skill
    self.skill_selected = s;
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
    
    switch (player.champ_id)
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
            case BUFF_AASPEED_PERC:
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