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
    if (Cast(1, self.skill_one_cooldown_time, self.skill_one_manacost))
    {
        // pop up all units in radius around champ
        entity affected = findradius(self.origin, SKILLONE_RANGE_SHAMBLER);

        while (affected)
        {
            if (affected.team_no != self.team_no)
            {
                if (affected.classname == "player" || affected.classname == "creep")
                {
                    // pop up
                    affected.velocity = '0 0 0';
                    affected.velocity_z = 500;

                    // stun 
                    T_ApplyBuff(affected, DEBUFF_STUN_MOVEALLOWED, STUN_SKILLONE_SHAMBLER, SKILLONE_VALUE_UNDEFINED);
                    T_Damage(affected, self, self, self.skill_one_damage);
                }
            }
            affected = affected.chain;
        }
    }
}

void Skill_Two_Shambler_Touch()
{
    // push back unit hit, stunning them for duration and .1 secs after hitting ground?
    if (other)
    {
        if (other.team_no != self.team_no)
        {
            if (other.classname == "player" || other.classname == "creep")
            {
                makevectors(self.angles);
                T_Damage(other, self, self, self.skill_two_damage);
                other.velocity = v_forward * 1000;
                other.velocity_z = 50;
                T_ApplyBuff(other, DEBUFF_STUN_MOVEALLOWED, STUN_SKILLTWO_SHAMBLER, SKILLONE_VALUE_UNDEFINED);
            }
        }
    }
    self.touch = SUB_Null;
}

void () SkillTwo_Shambler = {
	if (Cast(2, self.skill_two_cooldown_time, self.skill_two_manacost))
    {
        // move shambler forward a bunch
        makevectors(self.angles);
        self.velocity = v_forward * 1000;
        if (self.flags & FL_ONGROUND)
        {
            self.velocity_z = 181;
        }

        // if he hits a unit
        self.touch = Skill_Two_Shambler_Touch;
    }
}
void SkillThree_Shambler()
{
    if (Cast(3, self.skill_three_cooldown_time, self.skill_three_manacost))
    {

    }
	/*Alistar tramples the ground around him every 0.5 seconds for 5 seconds, dealing magic damage to all nearby enemies and gaining a Trample stack every time the ability damages at least one enemy champion. Alistar is Ghost ghosted for the duration.*/

    /*At 5 Trample stacks, Alistar's next basic attack deals 35 − 290 (based on level) bonus magic damage and Stun icon stuns his target for 1 second.*/

}
void () SkillFour_Shambler = {
	if (Cast(4, self.skill_four_cooldown_time, self.skill_four_manacost))
    {
        /*reduces all incoming physical and magic damage for the next 7 seconds, cleansing himself of all Stun icon crowd control on cast.*/

    }
}