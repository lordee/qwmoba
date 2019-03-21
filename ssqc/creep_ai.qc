float	enemy_vis, enemy_range;

void(float dist) ai_forward =
{
	walkmove (self.angles_y, dist);
};

/*
============
FacingIdeal

============
*/
float() FacingIdeal =
{
	local	float	delta;
	
	delta = anglemod(self.angles_y - self.ideal_yaw);
	if (delta > 45 && delta < 315)
		return FALSE;
	return TRUE;
};

/*
=============
visible

returns 1 if the entity is visible to self
=============
*/
float (entity targ) visible =
{
	local vector	spot1, spot2;
	
	spot1 = self.origin + self.view_ofs;
	spot2 = targ.origin + targ.view_ofs;
	traceline (spot1, spot2, TRUE, self);	// see through other monsters
	
	if (trace_inopen && trace_inwater)
		return FALSE;			// sight line crossed contents

	if (trace_fraction == 1)
		return TRUE;
	return FALSE;
};

/*
=============
ai_turn

don't move, but turn towards ideal_yaw
=============
*/
entity () QWM_GetTarget;
void() ai_turn =
{
	if (QWM_GetTarget())
		return;
	
	ChangeYaw ();
};

/*
=============
ai_stand

The monster is staying in one place for a while
=============
*/
void() ai_stand =
{

};

/*
=============
ai_face

Stay facing the enemy
=============
*/
void() ai_face =
{
	self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
	ChangeYaw ();
};

/*
=============
ai_charge

The monster is in a melee attack, so get as close as possible to .enemy
=============
*/

void(float d) ai_charge =
{
	ai_face ();	
	movetogoal (d);		// done in C code...
};

/*
=============
ai_melee

=============
*/
void() ai_melee =
{
	local vector	delta;

	if (!self.enemy)
		return;		// removed before stroke
		
	delta = self.enemy.origin - self.origin;

	if (vlen(delta) > CREEP_MELEE_RANGE)
		return;
		
	T_Damage (self.enemy, self, self, self.attackdamage);
};

void() ai_charge_side =
{
	local	vector	dtemp;
	local	float	heading;
	
// aim to the left of the enemy for a flyby

	self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
	ChangeYaw ();

	makevectors (self.angles);
	dtemp = self.enemy.origin - 30*v_right;
	heading = vectoyaw(dtemp - self.origin);
	
	walkmove(heading, 20);
};

void() ai_melee_side =
{
	local vector	delta;

	if (!self.enemy)
		return;		// removed before stroke
		
	ai_charge_side();
	
	delta = self.enemy.origin - self.origin;

	if (vlen(delta) > 60)
		return;
	if (!CanDamage (self.enemy, self))
		return;

	T_Damage (self.enemy, self, self, self.attackdamage);
};

entity () QWM_GetTarget = {
    // if within certain range, target closest
    entity targ, closest;
    string search;
    float dist, closedist;
    search = self.team_no == 1 ? "team2" : "team1";
    targ = find(world, team_str, search);
    closest = targ;
    closedist = targ ? vlen(targ.origin - self.origin) : 0;
    
    while (targ)
    {
        // if targ is player, building, creep
        if (targ.classname == "player" || targ.classname == "creep"
         || targ.classname == "item_qwmgoal")
        {
            dist = vlen(targ.origin - self.origin);
            closedist = (closedist > dist) ? dist : closedist;
        }

        targ = find(targ, team_str, search);
    }

    // now test if it's within aggression range
    if (closedist <= CREEP_AGRO_RANGE)
    {
        return closest;
    }
    else
    {
        return world;
    }
}

/*
=============
ai_run

The monster has an enemy it is trying to kill
=============
*/

entity () QWM_getwaypoint = {
	entity wp, closest;
	float dist, closedist, wpnum;
	closest = world;
	
	// if we have a waypoint, if it's near, get next
	if (self.movetarget)
	{
		dist = vlen(self.movetarget.origin - self.origin);

		if (dist <= 100)
		{
			wpnum = self.movetarget.chainnum + 1;
			wp = find(world, classname, "info_qwmgoal");
			while (wp)
			{
				if (wp.team_no == self.team_no)
				{
					if (wp.lane == self.lane)
					{
						if (wp.chainnum == wpnum)
						{
							closest = wp;
						}
					}
				}
				wp = find(wp, classname, "info_qwmgoal");
			}
		}
	}
	else
	{
		// if no waypoint, find closest	
		wp = find(world, classname, "info_qwmgoal");
		closest = wp;
		closedist = wp ? vlen(wp.origin - self.origin) : 0;
		while (wp)
		{
			if (wp.team_no == self.team_no)
			{
				if (wp.lane == self.lane)
				{
					dist = vlen(wp.origin - self.origin);
					if (dist < closedist)
					{
						closest = wp;
						closedist = dist;
					} 
				}
			}
			
			wp = find(wp, classname, "info_qwmgoal");
		}
	}

	return closest;
}

void ClearEnemy() 
{
    self.enemy = world;
    self.goalentity = world;
    if (self.movetarget)
        self.ideal_yaw = vectoyaw(self.movetarget.origin - self.origin);
}

void GetAttackRange() 
{
    switch (self.type)
    {
        case CREEP_MELEE:
        case CREEP_SUPER:
            return CREEP_MELEE_ATTACK_RANGE;
        case CREEP_RANGE:
        case CREEP_CANNON:
            return CREEP_RANGE_ATTACK_RANGE;
            break;
    }
}

void(float dist) ai_run =
{
	self.nextthink = time + 0.2;
	//self.nextthink = time + 1;
	movedist = dist;
	// see if the enemy is dead
	if (self.enemy.health <= 0)
	{
		self.enemy = world;

		// find a new target within range
        self.enemy = QWM_GetTarget();

		// if enemy in range
		if (self.enemy)
		{
			self.goalentity = self.enemy;
			self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
			self.attackstartorigin = self.origin;
		}
		else
		{
			// no enemy, move towards waypoint
			// get waypoint
			self.movetarget = QWM_getwaypoint();
			self.goalentity = self.movetarget;
			if (!self.movetarget)
			{
				self.th_stand();
                return;
			}
		}
	}

	// if have an enemy
    if (self.enemy)
    {
        // if travelled too far since started attacking
        float dist;
        dist = vlen(self.attackstartorigin - self.origin);

        if (dist > CREEP_CHASE_DISTANCE)
        {
            // clear enemy
            ClearEnemy();
            return;
        }

        // check knowledge of enemy
        enemy_vis = visible(self.enemy);
        self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);

        // if enemy is visible
        if (enemy_vis)
        {
            // turn to enemy
            ChangeYaw();

             // if we're facing ideal angle
            if (FacingIdeal())
            {
                // if can attack again
                if (self.attack_finished <= time)
                {
                    // if we're in correct range
                    float enemy_range = vlen(self.enemy.origin, self.origin);
                    float self_range = GetAttackRange();

                    if (enemy_range <= self_range)
                    {
                        // let's check if we're blocked
                        vector	spot1, spot2;	
                        
                        // see if any entities are in the way of the shot
                        spot1 = self.origin + self.view_ofs;
                        spot2 = self.enemy.origin + self.enemy.view_ofs;
                        traceline (spot1, spot2, FALSE, self);

                        // has a clear shot
                        if (trace_ent == self.enemy)
                        {
                            switch (self.type)
                            {
                                case CREEP_MELEE:
                                    knight_attack();
                                    break;
                                case CREEP_SUPER:
                                    self.th_melee ();
                                    break;
                                case CREEP_RANGE:
                                case CREEP_CANNON:
                                    self.th_missile();
                                    self.attack_finished = 1 / CREEP_RANGE_ATTACKSPEED;
                                    self.lefty = !self.lefty;
                                    break;
                            }
                            return; // took a shot, return with no movement
                        }
                    }
                }
            }
        }
        else
        {
            // enemy not visible, lose agro
            ClearEnemy();
        }

        // last of all, move towards enemy or waypoint
        movetogoal (dist);  
    }
};