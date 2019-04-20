void (entity targ, float cat, float type, float value) T_ApplyBuff;

void ShamblerAttack()
{
    GetChamp(self.champ_id);
    sound (self, CHAN_VOICE, selfchamp.sound_aashoot, 1, ATTN_NORM);

    // TODO change to shambler claws
    /*if (random() <= 0.5)
        sham_swingr1();
    else 
        sham_swingl1();*/

    vector source;
    source = self.origin + MODEL_VIEWOFFSET_SHAMBLER; // just a guess really...
    traceline (source, source + v_forward*64, FALSE, self);
	if (trace_fraction == 1.0)
		return;
	
	vector org = trace_endpos - v_forward*4;

	if (trace_ent.takedamage)
	{
		trace_ent.axhitme = 1;
		//SpawnBlood (org, '0 0 0', floor(self.attackdamage/10));
        SpawnMeatSpray (org, self.attackdamage * v_right);
		T_Damage (trace_ent, self, self, self.attackdamage);
        sound (self, CHAN_VOICE, selfchamp.sound_aahit, 1, ATTN_NORM);
	}
	else
	{	// hit wall
        // TODO change sound
		sound (self, CHAN_WEAPON, selfchamp.sound_aahitwall, 1, ATTN_NORM);
		WriteByte (MSG_MULTICAST, SVC_TEMPENTITY);
		WriteByte (MSG_MULTICAST, TE_GUNSHOT);
		WriteByte (MSG_MULTICAST, 3);
		WriteCoord (MSG_MULTICAST, org_x);
		WriteCoord (MSG_MULTICAST, org_y);
		WriteCoord (MSG_MULTICAST, org_z);
		multicast (org, MULTICAST_PVS);
	}
}

void () SkillOne_Shambler = {
    if (CanCast(self.skill_one_cooldown, self.skill_one_manacost))
    {
         // do checks for frost stacks
        float s;
        s = self.stacks;

        // if five frost stacks then allow cast
        if (s >= 5)
        {
            self.mana = self.mana - self.skill_one_manacost;
            // show cast clientside
            // buff attack speed
            T_ApplyBuff(self, BUFF_AASPEED_PERC, AASPEED_SKILLONE_FROSTARCHER, SKILLONE_VALUE_FROSTARCHER);
            self.skill_one_cooldown = time + SKILLONE_COOLDOWN_FROSTARCHER;
        }
        else
        {
            sprint(self, PRINT_HIGH, "You need 5 frost stacks on a target before you can cast this\n");
        }
    }
}

void () SkillTwo_Shambler = {
	if (CanCast(self.skill_two_cooldown, self.skill_two_manacost))
    {
        self.mana = self.mana - self.skill_two_manacost;
        self.skill_two_cooldown = time + SKILLTWO_COOLDOWN_FROSTARCHER;

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
            mis.classname = "frostarcherskilltwo";
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
            mis.touch = FrostArcherSkillTwoTouch;
            mis.nextthink = time + 6;
            mis.think = SUB_Remove;
            
            setmodel (mis, "progs/champions/frostarcher/frostarcherarrow.mdl");
            setsize (mis, VEC_ORIGIN, VEC_ORIGIN);
            setorigin (mis, self.origin);
            num = num - 1;
        }

        sound (self, CHAN_WEAPON, "weapons/grenade.wav", 1, ATTN_NORM);
    }
}
void () SkillThree_Shambler = {
	sprint(self, PRINT_HIGH, "Not implemented\n");
}
void () SkillFour_Shambler = {
	if (CanCast(self.skill_four_cooldown, self.skill_four_manacost))
    {
        self.mana = self.mana - self.skill_four_manacost;
        self.skill_four_cooldown = time + SKILLFOUR_COOLDOWN_FROSTARCHER;
            
        newmis = spawn ();
        newmis.voided = 0;
        newmis.owner = self;
        newmis.movetype = MOVETYPE_FLYMISSILE;
        newmis.solid = SOLID_BBOX;
        newmis.effects = EF_BLUE;
        newmis.classname = "frostarcherskillfour";
        makevectors (self.v_angle);

        newmis.velocity = aim(self, 1000);
        newmis.velocity = newmis.velocity * 1000;
        newmis.angles = vectoangles(newmis.velocity);

        newmis.touch = FrostArcherSkillFourTouch;
        newmis.nextthink = time + 60;
        newmis.think = SUB_Remove;
        
        setmodel (newmis, "progs/champions/frostarcher/frostarcherultimate.mdl");
        setsize (newmis, '0 0 0', '0 0 0');             
        setorigin (newmis, self.origin + v_forward*8 + '0 0 16');

        sound (self, CHAN_WEAPON, "weapons/grenade.wav", 1, ATTN_NORM);
    }
}