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

    if (other.team_no == self.owner.team_no)
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
                buff = find(buff, classname, "buff");
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
    newmis.effects = EF_BLUE;
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

    sound (self, CHAN_WEAPON, "weapons/grenade.wav", 1, ATTN_NORM);
	setmodel (newmis, "progs/ashearrow.mdl");

    entity buff;
    buff = find(world, classname, "buff");
    while (buff)
    {
        if (buff.owner == self && buff.buffcategory == AASPEED_SKILLONE_ASHE)
        {
            sound (self, CHAN_WEAPON, "weapons/spike2.wav", 1, ATTN_NORM);
	        setmodel (newmis, "progs/ashearrowbuff.mdl");
            break;
        }
        buff = find(buff, classname, "buff");
    }
    
	setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);
	setorigin (newmis, self.origin);
}


void () SkillOne_Ashe = {
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
            T_ApplyBuff(self, BUFF_AASPEED, AASPEED_SKILLONE_ASHE, SKILLONE_VALUE_ASHE);
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
                buff = find(buff, classname, "buff");
            }	

            if (slowed == 0)
            {
                T_ApplyBuff(other, DEBUFF_MSSLOW, MSSLOW_SKILLTWO_ASHE, SKILLTWO_VALUE_ASHE);
                T_ApplyBuff(other, DEBUFF_MSSLOW, MSSLOW_ASHE, 0); // for frost stacks
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
            mis.effects = EF_BLUE;
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

            mis.angles = vectoangles(mis.velocity);
            mis.touch = AsheSkillTwoTouch;
            mis.nextthink = time + 6;
            mis.think = SUB_Remove;
            
            setmodel (mis, "progs/ashearrow.mdl");
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

void () AsheSkillFourTouch = {
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

    if (other.classname == "player" && other.takedamage)
    {
        spawn_touchblood (self.owner.skillfourdamage);
		other.deathtype = "asheskillfour";
		
        // apply stun in radius
        T_ApplyBuff(other, DEBUFF_STUN, STUN_SKILLFOUR_ASHE, SKILLFOUR_VALUE_ASHE);
        T_Damage (other, self, self.owner, self.owner.skilltwodamage);
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

void () SkillFour_Ashe = {
	if (CanCast(self.skillfourcooldown, self.skillfourmanacost))
    {
        self.mana = self.mana - self.skillfourmanacost;
        self.skillfourcooldown = time + SKILLFOUR_COOLDOWN_ASHE;
            
        newmis = spawn ();
        newmis.voided = 0;
        newmis.owner = self;
        newmis.movetype = MOVETYPE_FLYMISSILE;
        newmis.solid = SOLID_BBOX;
        newmis.effects = EF_BLUE;
        newmis.classname = "asheskillfour";
        makevectors (self.v_angle);

        newmis.velocity = aim(self, 1000);
        newmis.velocity = newmis.velocity * 1000;
        newmis.angles = vectoangles(newmis.velocity);

        newmis.touch = AsheSkillFourTouch;
        newmis.nextthink = time + 60;
        newmis.think = SUB_Remove;
        
        setmodel (newmis, "progs/asheultimate.mdl");
        setsize (newmis, '0 0 0', '0 0 0');             
        setorigin (newmis, self.origin + v_forward*8 + '0 0 16');

        sound (self, CHAN_WEAPON, "weapons/grenade.wav", 1, ATTN_NORM);
    }
}