void () SetupChamp = {
    switch (self.champ)
    {
        case CHAMP_ASHE:
            self.attackdamage = ASHE_BASEAD;
            self.health = ASHE_BASEHEALTH;
            self.speed = ASHE_BASESPEED;
            self.weapon = ASHE_WEAPON;
            self.attackspeed = ASHE_BASEATTACKSPEED;
            self.skillone = ASHE_SKILLONE;
            self.skilltwo = ASHE_SKILLTWO;
            self.skillthree= ASHE_SKILLTHREE;
            self.skillfour = ASHE_SKILLFOUR;
        break;
    }
}