float	enemy_yaw;
float	enemy_vis, enemy_infront, enemy_range;


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

returns 1 if the entity is visible to self, even if not infront ()
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
infront

returns 1 if the entity is in front (in sight) of self
=============
*/
float(entity targ) infront =
{
	local vector	vec;
	local float		dot;
	
	makevectors (self.angles);
	vec = normalize (targ.origin - self.origin);
	dot = vec * v_forward;
	
	if ( dot > 0.3)
	{
		return TRUE;
	}
	return FALSE;
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

/*
=============
ai_run_slide

Strafe sideways, but stay at aproximately the same range
=============
*/
void() ai_run_slide =
{
	dprint("ai_run_slide executed\n");
	local float	ofs;
	
	self.ideal_yaw = enemy_yaw;
	ChangeYaw ();
	if (self.lefty)
		ofs = 90;
	else
		ofs = -90;
	
	if (walkmove (self.ideal_yaw + ofs, movedist))
		return;
		
	self.lefty = 1 - self.lefty;
	
	walkmove (self.ideal_yaw - ofs, movedist);
};

/*
=============
ai_run_melee

Turn and close until within an angle to launch a melee attack
=============
*/
void() ai_run_melee =
{
	dprint("ai_run_melee executed\n");
	self.ideal_yaw = enemy_yaw;
	ChangeYaw ();

	if (FacingIdeal())
	{
		self.th_melee ();
		self.attack_state = AS_STRAIGHT;
	}
};

/*
=============
ai_run_missile

Turn in place until within an angle to launch a missile attack
=============
*/
void() ai_run_missile =
{
	dprint("ai_run_missile executed\n");
	self.ideal_yaw = enemy_yaw;
	ChangeYaw ();
	if (FacingIdeal())
	{
		self.th_missile ();
		self.attack_state = AS_STRAIGHT;
	}
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
ai_walk

The monster is walking it's beat
=============
*/
void(float dist) ai_walk =
{
	dprint("ai_walk executed\n");
	movetogoal (dist);
};

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

float () QWM_TravelledTooFar = {
	float dist;
	dist = vlen(self.attackstartorigin - self.origin);

	if (dist > CREEP_CHASE_DISTANCE)
	{
		return TRUE;
	}
	else
	{
		return FALSE;
	}
}

/*
=============
range

returns the range catagorization of an entity reletive to self
0	melee range, will become hostile even if back is turned
1	visibility and infront, or visibility and show hostile
2	infront and show hostile
3	only triggered by damage
=============
*/
float(entity targ) range =
{
local vector	spot1, spot2;
local float		r;	
	spot1 = self.origin + self.view_ofs;
	spot2 = targ.origin + targ.view_ofs;
	
	r = vlen (spot1 - spot2);
	if (r < 120)
		return RANGE_MELEE;
	if (r < 500)
		return RANGE_NEAR;
	if (r < 1000)
		return RANGE_MID;
	return RANGE_FAR;
};

/*
===========
SoldierCheckAttack

The player is in view, so decide to move or launch an attack
Returns FALSE if movement should continue
============
*/
float() RangeCheckAttack =
{
	local vector	spot1, spot2;	
	local entity	targ;

	targ = self.enemy;
	
// see if any entities are in the way of the shot
	spot1 = self.origin + self.view_ofs;
	spot2 = targ.origin + targ.view_ofs;

	traceline (spot1, spot2, FALSE, self);

	if (trace_inopen && trace_inwater)
		return FALSE;			// sight line crossed contents

	if (trace_ent != targ)
		return FALSE;	// don't have a clear shot
			
	
// missile attack
	if (time < self.attack_finished)
		return FALSE;
		
	if (enemy_range == RANGE_FAR)
		return FALSE;
		
	self.th_missile ();
	self.attack_finished = 1 / CREEP_RANGE_ATTACKSPEED;
	self.lefty = !self.lefty;

	return TRUE;
};

/*
===========
CheckAttack

The player is in view, so decide to move or launch an attack
Returns FALSE if movement should continue
============
*/
void () knight_attack;
float() MeleeCheckAttack =
{
	local vector	spot1, spot2;	
	local entity	targ;

	targ = self.enemy;
	
// see if any entities are in the way of the shot
	spot1 = self.origin + self.view_ofs;
	spot2 = targ.origin + targ.view_ofs;

	traceline (spot1, spot2, FALSE, self);

	if (trace_ent != targ)
		return FALSE;		// don't have a clear shot
			
	if (trace_inopen && trace_inwater)
		return FALSE;			// sight line crossed contents

	if (enemy_range == RANGE_MELEE)
	{	// melee attack
		if (self.th_melee)
		{
			if (self.type == CREEP_MELEE)
				knight_attack();
			else
				self.th_melee ();
			return TRUE;
		}
	}
	
	return FALSE;
};

float() CheckAnyAttack =
{
	if (!enemy_vis)
		return TRUE;

	switch (self.type)
	{
		case CREEP_MELEE:
			return MeleeCheckAttack();
			break;
		case CREEP_RANGE:
			return RangeCheckAttack();
			break;
		case CREEP_CANNON:
			return RangeCheckAttack();
			break;
		case CREEP_SUPER:
			return MeleeCheckAttack();
			break;
		default:
			return FALSE;
	}
};

void(float dist) ai_run =
{
	dprint("ai_run executed\n");
	//self.nextthink = time + 0.2;
	self.nextthink = time + 1;
	movedist = dist;
	// see if the enemy is dead
	eprint(self.enemy);
	if (self.enemy.health <= 0)
	{
		dprint("enemy dead\n");
		self.enemy = world;

		// find a new target within range
        self.enemy = QWM_GetTarget();

		// if enemy in range
		if (self.enemy)
		{
			self.goalentity = self.enemy;
			dprint("got enemy\n");
			self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
			self.attackstartorigin = self.origin;
		}
		else
		{
			// no enemy, move towards waypoint
			dprint("no enemy, move towards waypoint\n");
			// get waypoint
			self.movetarget = QWM_getwaypoint();
			self.goalentity = self.movetarget;
			if (self.movetarget)
			{
				dprint("got a target, walking\n");
				self.th_walk();
			}
			else
			{
				self.th_stand();
			}
			return;
		}
	}

	// if travelled too far since started attacking
	if (QWM_TravelledTooFar())
	{
		// clear enemy
		self.enemy = world;
		self.goalentity = world;
		self.ideal_yaw = vectoyaw(self.movetarget.origin - self.origin);
		return;
	}

// check knowledge of enemy
	enemy_vis = visible(self.enemy);
	if (enemy_vis)
		self.search_time = time + 5;

	enemy_infront = infront(self.enemy);
	enemy_range = range(self.enemy);
	enemy_yaw = vectoyaw(self.enemy.origin - self.origin);

	self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
	
	if (self.attack_state == AS_MISSILE)
	{
//dprint ("ai_run_missile\n");
		ai_run_missile ();
		return;
	}
	if (self.attack_state == AS_MELEE)
	{
		ai_run_melee ();
		return;
	}

	if (CheckAnyAttack ())
		return;					// beginning an attack
		
	if (self.attack_state == AS_SLIDING)
	{
		ai_run_slide ();
		return;
	}
		
// head straight in
	dprint("movetogoal in ai_run");
	movetogoal (dist);		// done in C code...
};

