void (float type, vector org) SpawnCreep = {
    entity creep;

    switch (type)
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

            self.solid = SOLID_SLIDEBOX;
            self.movetype = MOVETYPE_STEP;

            setmodel (self, "progs/knight.mdl");

            setsize (self, '-16 -16 -24', '16 16 40');
            self.health = CREEP_MELEE_BASEHEALTH;

            self.th_stand = knight_stand1;
            self.th_walk = knight_walk1;
            self.th_run = knight_run1;
            self.th_melee = knight_atk1;
            self.th_pain = knight_pain;
            self.th_die = knight_die;
            
            walkmonster_start ();
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
            
            self.solid = SOLID_SLIDEBOX;
            self.movetype = MOVETYPE_STEP;

            setmodel (self, "progs/enforcer.mdl");

            setsize (self, '-16 -16 -24', '16 16 40');
            self.health = CREEP_RANGE_BASEHEALTH;

            self.th_stand = enf_stand1;
            self.th_walk = enf_walk1;
            self.th_run = enf_run1;
            self.th_pain = enf_pain;
            self.th_die = enf_die;
            self.th_missile = enf_atk1;

            walkmonster_start();
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

            self.solid = SOLID_SLIDEBOX;
            self.movetype = MOVETYPE_STEP;

            setmodel (self, "progs/ogre.mdl");

            setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);
            self.health = CREEP_CANNON_BASEHEALTH;

            self.th_stand = ogre_stand1;
            self.th_walk = ogre_walk1;
            self.th_run = ogre_run1;
            self.th_die = ogre_die;
            self.th_melee = ogre_melee;
            self.th_missile = ogre_nail1;
            self.th_pain = ogre_pain;
            
            walkmonster_start();
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
            
            self.solid = SOLID_SLIDEBOX;
            self.movetype = MOVETYPE_STEP;

            setmodel (self, "progs/hknight.mdl");

            setsize (self, '-16 -16 -24', '16 16 40');
            self.health = CREEP_SUPER_BASEHEALTH;

            self.th_stand = hknight_stand1;
            self.th_walk = hknight_walk1;
            self.th_run = hknight_run1;
            self.th_melee = hknight_melee;
            self.th_missile = hknight_magicc1;
            self.th_pain = hknight_pain;
            self.th_die = hknight_die;
            
            walkmonster_start ();
            break;
    }
}