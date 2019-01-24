void () SetupChamp = {
    switch (self.champ)
    {
        case CHAMP_ASHE:
            self.attackdamage = BASEAD_ASHE;
            self.health = BASEHEALTH_ASHE;
            self.speed = BASESPEED_ASHE;
            self.weapon = WEAPON_ASHE;
            self.attackspeed = BASEATTACKSPEED_ASHE;
            self.skillone = SKILLONE_ASHE;
            self.skilltwo = SKILLTWO_ASHE;
            self.skillthree= SKILLTHREE_ASHE;
            self.skillfour = SKILLFOUR_ASHE;
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

void (float cooldown, float manacost) CanCast = {
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
        sprint(self, PRINT_HIGH, "This skill is still on cooldown");
        return FALSE;
    }
}