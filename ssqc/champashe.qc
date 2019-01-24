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
        if (other.classname = "player" || other.classname = "creep")
        {
            entity buff;

            buff = find(world, classname, "buff");
            while (buff)
            {
                if (buff.owner == other && buff.buff == AASLOW_ASHE)
                {
                    // apply frost stack to ashe
                    self.owner.stacks = self.owner.stacks + 1;
                    break;
                }
                buff = find(world, classname, "buff");
            }	

            // apply a slow for ashe attacks
            T_ApplyBuff(other, DEBUFF_SLOW, AASLOW_ASHE, AASLOW_VALUE_ASHE);
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
	sound (self, CHAN_WEAPON, "weapons/grenade.wav", 1, ATTN_NORM);

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
		newmis.velocity = v_forward*1000 + v_up * 200 + crandom()*v_right*10 + crandom()*v_up*10;
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

	setmodel (newmis, "progs/spike.mdl");
	setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);             
	setorigin (newmis, self.origin);
}


void () SkillOne_Ashe = {
	// do checks for frost stacks
	float s;
	s = self.stacks;

	// if five frost stacks then allow cast
	if (s >= 5)
	{
		// take off mana
        if (self.mana >= self.skillonemanacost)
        {
            self.mana = self.mana - self.skillonemanacost;
            // show cast clientside
            // change model of attack
            // buff attack speed
            T_ApplyBuff(self, BUFF_AASPEED, AASPEED_ASHE, AASPEED_VALUE_ASHE);
        }
        else
        {
            sprint(self, PRINT_HIGH, "Not enough mana\n");
        }
	}
	else
	{
		sprint(self, PRINT_HIGH, "You need 5 frost stacks on a target before you can cast this\n");
	}
}
void () SkillTwo_Ashe = {
	
}
void () SkillThree_Ashe = {
	
}
void () SkillFour_Ashe = {
	
}