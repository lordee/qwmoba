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
    if (CanCast(self.skill_one_cooldown, self.skill_one_manacost))
    {
        // pop up all units in radius around champ

        // stun them for x seconds
    }
}

void () SkillTwo_Shambler = {
	if (CanCast(self.skill_two_cooldown, self.skill_two_manacost))
    {
        // push back unit hit, stunning them for duration and .1 secs after hitting ground?
    }
}
void () SkillThree_Shambler = {
	/*Alistar tramples the ground around him every 0.5 seconds for 5 seconds, dealing magic damage to all nearby enemies and gaining a Trample stack every time the ability damages at least one enemy champion. Alistar is Ghost ghosted for the duration.*/

    /*At 5 Trample stacks, Alistar's next basic attack deals 35 − 290 (based on level) bonus magic damage and Stun icon stuns his target for 1 second.*/

}
void () SkillFour_Shambler = {
	if (CanCast(self.skill_four_cooldown, self.skill_four_manacost))
    {
        /*reduces all incoming physical and magic damage for the next 7 seconds, cleansing himself of all Stun icon crowd control on cast.*/

    }
}