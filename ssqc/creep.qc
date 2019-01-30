
void () QWM_CreepAttack = {
    switch (self.attack_state)
    {
        case AS_MELEE:
            ai_run_melee();
            break;
        case AS_MISSILE:
            ai_run_missile();
            break;
    }
}

void (float t, vector org) SpawnCreep = {
    entity creep;
    creep = spawn();
    creep.type = t;

    switch (t)
    {
        case CREEP_MELEE:
            precache_model ("progs/knight.mdl");
            precache_model ("progs/h_knight.mdl");

            precache_sound ("knight/kdeath.wav");
            precache_sound ("knight/khurt.wav");
            precache_sound ("knight/ksight.wav");
            precache_sound ("knight/sword1.wav");
            precache_sound ("knight/sword2.wav");
            precache_sound ("knight/idle.wav");

            creep.solid = SOLID_SLIDEBOX;
            creep.movetype = MOVETYPE_STEP;

            setmodel (creep, "progs/knight.mdl");

            setsize (creep, '-16 -16 -24', '16 16 40');
            creep.health = CREEP_MELEE_BASEHEALTH;
            creep.th_stand = knight_stand1;
            creep.th_walk = SUB_Null;
            creep.th_run = knight_run1;
            creep.th_melee = knight_atk1;
            creep.th_pain = SUB_Null_pain;
            creep.th_die = knight_die;
            creep.attack_state = AS_MELEE;            
            break;
        case CREEP_RANGE:
            precache_model2 ("progs/enforcer.mdl");
            precache_model2 ("progs/h_mega.mdl");
            precache_model2 ("progs/laser.mdl");

            precache_sound2 ("enforcer/death1.wav");
            precache_sound2 ("enforcer/enfire.wav");
            precache_sound2 ("enforcer/enfstop.wav");
            precache_sound2 ("enforcer/idle1.wav");
            precache_sound2 ("enforcer/pain1.wav");
            precache_sound2 ("enforcer/pain2.wav");
            precache_sound2 ("enforcer/sight1.wav");
            precache_sound2 ("enforcer/sight2.wav");
            precache_sound2 ("enforcer/sight3.wav");
            precache_sound2 ("enforcer/sight4.wav");
            
            creep.solid = SOLID_SLIDEBOX;
            creep.movetype = MOVETYPE_STEP;

            setmodel (creep, "progs/enforcer.mdl");

            setsize (creep, '-16 -16 -24', '16 16 40');
            creep.health = CREEP_RANGE_BASEHEALTH;
            creep.th_stand = enf_stand1;
            creep.th_walk = SUB_Null;
            creep.th_run = enf_run1;
            creep.th_pain = SUB_Null_pain;
            creep.th_die = enf_die;
            creep.th_missile = enf_atk1;
            creep.attack_state = AS_MISSILE;
            break;
        case CREEP_CANNON:
            precache_model ("progs/ogre.mdl");
            precache_model ("progs/h_ogre.mdl");
            precache_model ("progs/grenade.mdl");

            precache_sound ("ogre/ogdrag.wav");
            precache_sound ("ogre/ogdth.wav");
            precache_sound ("ogre/ogidle.wav");
            precache_sound ("ogre/ogidle2.wav");
            precache_sound ("ogre/ogpain1.wav");
            precache_sound ("ogre/ogsawatk.wav");
            precache_sound ("ogre/ogwake.wav");

            creep.solid = SOLID_SLIDEBOX;
            creep.movetype = MOVETYPE_STEP;

            setmodel (creep, "progs/ogre.mdl");

            setsize (creep, VEC_HULL2_MIN, VEC_HULL2_MAX);
            creep.health = CREEP_CANNON_BASEHEALTH;
            creep.th_stand = ogre_stand1;
            creep.th_walk = SUB_Null;
            creep.th_run = ogre_run1;
            creep.th_die = ogre_die;
            creep.th_melee = SUB_Null;
            creep.th_missile = ogre_nail1;
            creep.th_pain = SUB_Null_pain;            
            creep.attack_state = AS_MISSILE;
            break;
        case CREEP_SUPER:
            precache_model2 ("progs/hknight.mdl");
            precache_model2 ("progs/k_spike.mdl");
            precache_model2 ("progs/h_hellkn.mdl");

            
            precache_sound2 ("hknight/attack1.wav");
            precache_sound2 ("hknight/death1.wav");
            precache_sound2 ("hknight/pain1.wav");
            precache_sound2 ("hknight/sight1.wav");
            precache_sound ("hknight/hit.wav");		// used by C code, so don't sound2
            precache_sound2 ("hknight/slash1.wav");
            precache_sound2 ("hknight/idle.wav");
            precache_sound2 ("hknight/grunt.wav");

            precache_sound ("knight/sword1.wav");
            precache_sound ("knight/sword2.wav");
            
            creep.solid = SOLID_SLIDEBOX;
            creep.movetype = MOVETYPE_STEP;

            setmodel (creep, "progs/hknight.mdl");

            setsize (creep, '-16 -16 -24', '16 16 40');
            creep.health = CREEP_SUPER_BASEHEALTH;
            creep.th_stand = hknight_stand1;
            creep.th_walk = SUB_Null;
            creep.th_run = hknight_run1;
            creep.th_melee = hknight_melee;
            creep.th_missile = hknight_magicc1;
            creep.th_pain = hknight_pain;
            creep.th_die = hknight_die;
            creep.attack_state = AS_MELEE;
    }

    setorigin(creep, org);
    creep.takedamage = DAMAGE_AIM;
    creep.nextthink = time + 0.5;
	creep.think = creep.th_run;
    creep.classname = "creep";
}