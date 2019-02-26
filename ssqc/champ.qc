void () SkillOne_Ashe;
void () SkillTwo_Ashe;
void () SkillThree_Ashe;
void () SkillFour_Ashe;

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

    float attdamage, attspeed, msspeed;
    // base char
    switch (player.champ)
    {
        case CHAMP_ASHE:
            attdamage = BASEAD_ASHE;
            attspeed = BASEATTACKSPEED_ASHE;
            msspeed = BASESPEED_ASHE;
            break;
    }

    // char levels

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

    player.attackspeed = attspeed;
    player.speed = msspeed;
}