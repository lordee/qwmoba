

void () CreepThink = {
    // if have a target that is alive
    if (self.enemy)
    {
        if (self.enemy.deadflag == DEAD_NO)
        {
            // if target out of range
            if (OutOfRange(self, self.enemy))
            {
                // if travelled too far since started attacking
                if (TravelledTooFar(self))
                {
                    // clear enemy
                    self.enemy = world;
                    self.ideal_yaw = vectoyaw(self.movetarget.origin - self.origin);
                    self.th_run();
                }
                else
                {
                    self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
                    self.th_run();
                }
            }
            else
            {
                // otherwise attack    
                CreepAttack(self);
            }       
        }
        else
        {
            self.enemy = world;
        }
    }
    else
    {
        // if not attacking anything
        // if enemy player, creep, building in range, target it (closest first)    
        if (FindTarget(self))
        {
            self.enemy = GetTarget(self);
            self.attackstartorigin = self.origin;
        }
        else
        {
            // otherwise move towards waypoint    
            self.ideal_yaw = vectoyaw(self.movetarget.origin - self.origin);
            self.th_run();
        }
    }

    self.nextthink = time + .5;
}

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

            creep.solid = SOLID_SLIDEBOX;
            creep.movetype = MOVETYPE_STEP;

            setmodel (creep, "progs/knight.mdl");

            setsize (creep, '-16 -16 -24', '16 16 40');
            creep.health = CREEP_MELEE_BASEHEALTH;

            creep.th_stand = knight_stand1;
            creep.th_walk = knight_walk1;
            creep.th_run = knight_run1;
            creep.th_melee = knight_atk1;
            creep.th_pain = knight_pain;
            creep.th_die = knight_die;
            
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
            
            creep.solid = SOLID_SLIDEBOX;
            creep.movetype = MOVETYPE_STEP;

            setmodel (creep, "progs/enforcer.mdl");

            setsize (creep, '-16 -16 -24', '16 16 40');
            creep.health = CREEP_RANGE_BASEHEALTH;

            creep.th_stand = enf_stand1;
            creep.th_walk = enf_walk1;
            creep.th_run = enf_run1;
            creep.th_pain = enf_pain;
            creep.th_die = enf_die;
            creep.th_missile = enf_atk1;
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
            creep.th_walk = ogre_walk1;
            creep.th_run = ogre_run1;
            creep.th_die = ogre_die;
            creep.th_melee = ogre_melee;
            creep.th_missile = ogre_nail1;
            creep.th_pain = ogre_pain;            
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
            creep.th_walk = hknight_walk1;
            creep.th_run = hknight_run1;
            creep.th_melee = hknight_melee;
            creep.th_missile = hknight_magicc1;
            creep.th_pain = hknight_pain;
            creep.th_die = hknight_die;
            
            break;
    }

    setorigin(creep, org);
    self.takedamage = DAMAGE_AIM;
    self.nextthink = time + 0.5;
	self.think = CreepThink;
}