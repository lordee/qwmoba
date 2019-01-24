void (entity targ, float cat, float type, float value) T_ApplyBuff;

void () AsheAttackTouch = {
    if (other == self.owner)
		return;

	if (self.voided) {
		return;
	}
	self.voided = 1;

	if (other.solid == SOLID_TRIGGER)
		return; // trigger field, do nothing

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}
	
// hit something that bleeds
	if (other.takedamage)
	{
		spawn_touchblood (self.owner.attackdamage);
		other.deathtype = "asheattack";
		T_Damage (other, self, self.owner, self.owner.attackdamage);

		// if targ is slowed by ashe already, add a stack
        if (other.classname == "player" || other.classname == "creep")
        {
            entity buff;
            float slowed;
            slowed = 0;

            buff = find(world, classname, "buff");
            while (buff)
            {
                if (buff.owner == other && buff.bufftype == MSSLOW_ASHE)
                {
                    // apply frost stack to ashe
                    self.owner.stacks = self.owner.stacks + 1;
                    slowed = 1;
                    break;
                }
                buff = find(world, classname, "buff");
            }	

            if (slowed == 0)
            {
                // apply a slow for ashe attacks
                T_ApplyBuff(other, DEBUFF_MSSLOW, MSSLOW_ASHE, AASLOW_VALUE_ASHE);
            }
        }
	}
	else
	{
		WriteByte (MSG_MULTICAST, SVC_TEMPENTITY);
		WriteByte (MSG_MULTICAST, TE_SPIKE);
		WriteCoord (MSG_MULTICAST, self.origin_x);
		WriteCoord (MSG_MULTICAST, self.origin_y);
		WriteCoord (MSG_MULTICAST, self.origin_z);
		multicast (self.origin, MULTICAST_PHS);
	}

	remove(self);
}

void () AsheAttack = {
	msg_entity = self;
	WriteByte (MSG_ONE, SVC_SMALLKICK);

	newmis = spawn ();
	newmis.voided = 0;
	newmis.owner = self;
	newmis.movetype = MOVETYPE_BOUNCE;
	newmis.solid = SOLID_BBOX;
	newmis.classname = "asheattack";
		
	makevectors (self.v_angle);

	if (self.v_angle_x)
    {
		newmis.velocity = v_forward*1000 + v_up * 200 + crandom()*v_right*10 + crandom()*v_up*10;
    }
	else
	{
		newmis.velocity = aim(self, 10000);
		newmis.velocity = newmis.velocity * 1000;
		newmis.velocity_z = 200;
	}

	newmis.angles = vectoangles(newmis.velocity);
	
	newmis.touch = AsheAttackTouch;
	newmis.nextthink = time + 6;
	newmis.think = SUB_Remove;

    entity buff;
    buff = find(world, classname, "buff");

    sound (self, CHAN_WEAPON, "weapons/grenade.wav", 1, ATTN_NORM);
	setmodel (newmis, "progs/spike.mdl");

    while (buff)
    {
        if (buff.owner == self && buff.buffcategory == AASPEED_ASHE)
        {
            sound (self, CHAN_WEAPON, "weapons/spike2.wav", 1, ATTN_NORM);
	        setmodel (newmis, "progs/missile.mdl");
            break;
        }
        buff = find(world, classname, "buff");
    }
    
	setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);
	setorigin (newmis, self.origin);
}


void () SkillOne_Ashe = {
    sprint(self, PRINT_HIGH, "trying to cast skill one\n");
    if (CanCast(self.skillonecooldown, self.skillonemanacost))
    {
         // do checks for frost stacks
        float s;
        s = self.stacks;

        // if five frost stacks then allow cast
        if (s >= 5)
        {
            self.mana = self.mana - self.skillonemanacost;
            // show cast clientside
            // buff attack speed
            T_ApplyBuff(self, BUFF_AASPEED, AASPEED_ASHE, AASPEED_VALUE_ASHE);
            self.skillonecooldown = time + SKILLONE_COOLDOWN_ASHE;
        }
        else
        {
            sprint(self, PRINT_HIGH, "You need 5 frost stacks on a target before you can cast this\n");
        }
    }
}


void () AsheSkillTwoTouch = {
    if (other == self.owner)
		return;

	if (self.voided) {
		return;
	}
	self.voided = 1;

	if (other.solid == SOLID_TRIGGER)
		return; // trigger field, do nothing

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}

// hit something that bleeds
	if (other.takedamage)
	{
		spawn_touchblood (self.owner.skilltwodamage);
		other.deathtype = "asheskilltwo";
		
		// if this has already hit, don't damage/slow
        if (other.classname == "player" || other.classname == "creep")
        {
            entity buff;
            float slowed;
            slowed = 0;

            buff = find(world, classname, "buff");
            while (buff)
            {
                if (buff.owner == other && buff.bufftype == MSSLOW_SKILLTWO_ASHE)
                {
                    slowed = 1;
                    break;
                }
                buff = find(world, classname, "buff");
            }	

            if (slowed == 0)
            {
                T_ApplyBuff(other, DEBUFF_MSSLOW, MSSLOW_SKILLTWO_ASHE, MSSLOW_SKILLTWO_VALUE_ASHE);
                T_Damage (other, self, self.owner, self.owner.skilltwodamage);
            }
        }
        else
        {
            T_Damage (other, self, self.owner, self.owner.skilltwodamage);
        }
	}
	else
	{
		WriteByte (MSG_MULTICAST, SVC_TEMPENTITY);
		WriteByte (MSG_MULTICAST, TE_SPIKE);
		WriteCoord (MSG_MULTICAST, self.origin_x);
		WriteCoord (MSG_MULTICAST, self.origin_y);
		WriteCoord (MSG_MULTICAST, self.origin_z);
		multicast (self.origin, MULTICAST_PHS);
	}

	remove(self);
}

void () SkillTwo_Ashe = {
    sprint(self, PRINT_HIGH, "trying to cast skill two\n");
	if (CanCast(self.skilltwocooldown, self.skilltwomanacost))
    {
        self.mana = self.mana - self.skilltwomanacost;
        self.skilltwocooldown = time + SKILLTWO_COOLDOWN_ASHE;

        float num, ang;
        num = 11;
        ang = floor(1800 / num);

        while (num > 0)
        {
            entity mis;
            mis = spawn ();
            mis.voided = 0;
            mis.owner = self;
            mis.movetype = MOVETYPE_BOUNCE;
            mis.solid = SOLID_BBOX;
            mis.classname = "asheskilltwo";
            makevectors (self.v_angle);

            if (self.v_angle_x)
            {
                if (num < 6)
                {
                    mis.velocity = v_forward*1000 + v_up * 200 + (v_right * (num * ang) * -1) + crandom()*v_up*10;
                }
                else if (num > 6)
                {
                    mis.velocity = v_forward*1000 + v_up * 200 + v_right * ((num - 6) * ang) + crandom()*v_up*10;
                }
                else
                {
                    mis.velocity = v_forward*1000 + v_up * 200 + crandom()*v_right*10 + crandom()*v_up*10;
                }
            }
            else
            {
                mis.velocity = aim(self, 10000);
                mis.velocity = newmis.velocity * 1000;
                mis.velocity_z = 200;
            }

            mis.angles = vectoangles(newmis.velocity);
            mis.touch = AsheSkillTwoTouch;
            mis.nextthink = time + 6;
            mis.think = SUB_Remove;
            
            setmodel (mis, "progs/spike.mdl");
            setsize (mis, VEC_ORIGIN, VEC_ORIGIN);
            setorigin (mis, self.origin);
            num = num - 1;
        }

        sound (self, CHAN_WEAPON, "weapons/grenade.wav", 1, ATTN_NORM);
    }
}
void () SkillThree_Ashe = {
	sprint(self, PRINT_HIGH, "Not implemented\n");
}
void () SkillFour_Ashe = {
	sprint(self, PRINT_HIGH, "Not implemented\n");
}