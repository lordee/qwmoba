//============================================================================
//			VARS NOT REFERENCED BY C CODE
//============================================================================

#ifndef VER
#define VER "unknown"
#endif

#ifndef REV
#define REV "unk"
#endif

//
// constants
//

#define FALSE		0
#define TRUE		1

// edict.flags
#define FL_FLY		1
#define FL_SWIM		2
#define FL_CLIENT	8 	// set for all client edicts
#define FL_INWATER	16 	// for enter / leave water splash
#define FL_MONSTER	32
#define FL_GODMODE	64 	// player cheat
#define FL_NOTARGET	128 	// player cheat
#define FL_ITEM		256 	// extra wide size for bonus items
#define FL_ONGROUND	512 	// standing on something
#define FL_PARTIALGROUND	1024 	// not all corners are valid
#define FL_WATERJUMP	2048 	// player jumping out of water
#define FL_JUMPRELEASED	4096 	// for jump debouncing

// edict.movetype values
#define MOVETYPE_NONE			0 	// never moves
//#define MOVETYPE_ANGLENOCLIP	1
//#define MOVETYPE_ANGLECLIP	2
#define MOVETYPE_WALK			3 	// players only
#define MOVETYPE_STEP			4 	// discrete, not real time unless fall
#define MOVETYPE_FLY			5
#define MOVETYPE_TOSS			6 	// gravity
#define MOVETYPE_PUSH			7 	// no clip to world, push and crush
#define MOVETYPE_NOCLIP			8
#define MOVETYPE_FLYMISSILE		9 	// fly with extra size against monsters
#define MOVETYPE_BOUNCE			10
#define MOVETYPE_BOUNCEMISSILE		11 	// bounce with extra size

// edict.solid values
#define SOLID_NOT	0 	// no interaction with other objects
#define SOLID_TRIGGER	1 	// touch on edge, but not blocking
#define SOLID_BBOX	2 	// touch on edge, block
#define SOLID_SLIDEBOX	3 	// touch on edge, but not an onground
#define SOLID_BSP	4 	// bsp clip, touch on edge, block

// range values
#define RANGE_MELEE	0
#define RANGE_NEAR	1
#define RANGE_MID	2
#define RANGE_FAR	3

// deadflag values
#define DEAD_NO			0
#define DEAD_DYING		1
#define DEAD_DEAD		2
#define DEAD_RESPAWNABLE	3

// takedamage values
#define DAMAGE_NO	0
#define DAMAGE_YES	1
#define DAMAGE_AIM	2

// items
#define IT_AXE			4096
#define IT_SHOTGUN		1
#define IT_SUPER_SHOTGUN	2
#define IT_NAILGUN		4
#define IT_SUPER_NAILGUN	8
#define IT_GRENADE_LAUNCHER	16
#define IT_ROCKET_LAUNCHER	32
#define IT_LIGHTNING		64
#define IT_EXTRA_WEAPON		128

#define IT_SHELLS	256
#define IT_NAILS	512
#define IT_ROCKETS	1024
#define IT_CELLS	2048

#define IT_ARMOR1	8192
#define IT_ARMOR2	16384
#define IT_ARMOR3	32768
#define IT_SUPERHEALTH	65536

#define IT_KEY1	131072
#define IT_KEY2	262144

#define IT_INVISIBILITY		524288
#define IT_INVULNERABILITY	1048576
#define IT_SUIT			2097152
#define IT_QUAD			4194304
#define IT_HOOK			8388608

// point content values
#define CONTENT_EMPTY	-1
#define CONTENT_SOLID	-2
#define CONTENT_WATER	-3
#define CONTENT_SLIME	-4
#define CONTENT_LAVA	-5
#define CONTENT_SKY	-6

#define STATE_TOP	0
#define STATE_BOTTOM	1
#define STATE_UP	2
#define STATE_DOWN	3

#define VEC_ORIGIN	'0 0 0'
#define VEC_HULL_MIN	'-16 -16 -24'
#define VEC_HULL_MAX	'16 16 32'

#define VEC_HULL2_MIN	'-32 -32 -24'
#define VEC_HULL2_MAX	'32 32 64'

// protocol bytes
#define SVC_TEMPENTITY		23
#define SVC_KILLEDMONSTER	27
#define SVC_FOUNDSECRET		28
#define SVC_INTERMISSION	30
#define SVC_FINALE		31
#define SVC_CDTRACK		32
#define SVC_SELLSCREEN		33

#define SVC_SMALLKICK		34
#define SVC_BIGKICK		35
#define SVC_UPDATEPING		36
#define SVC_UPDATETIME		37
#define SVC_MUZZLEFLASH		39
#define SVC_UPDATEUSERINFO	40
#define SVC_PLAYERINFO		42
#define SVC_PACKETENTITIES	47
#define SVC_DELTAPACKETENTITIES	48
#define SVC_SETINFO		51
#define SVC_UPDATEPL		53

#define TE_SPIKE		0
#define TE_SUPERSPIKE		1
#define TE_GUNSHOT		2
#define TE_EXPLOSION		3
#define TE_TAREXPLOSION		4
#define TE_LIGHTNING1		5
#define TE_LIGHTNING2		6
#define TE_WIZSPIKE		7
#define TE_KNIGHTSPIKE		8
#define TE_LIGHTNING3		9
#define TE_LAVASPLASH		10
#define TE_TELEPORT		11
#define TE_BLOOD        	12
#define TE_LIGHTNINGBLOOD	13

// sound channels
// channel 0 never willingly overrides
// other channels (1-7) allways override a playing sound on that channel
#define CHAN_AUTO	0
#define CHAN_WEAPON	1
#define CHAN_VOICE	2
#define CHAN_ITEM	3
#define CHAN_BODY	4
#define CHAN_NO_PHS_ADD	8

#define ATTN_NONE	0
#define ATTN_NORM	1
#define ATTN_IDLE	2
#define ATTN_STATIC	3

// update types

#define UPDATE_GENERAL	0
#define UPDATE_STATIC	1
#define UPDATE_BINARY	2
#define UPDATE_TEMP	3

// entity effects

#define EF_BRIGHTFIELD	1
#define EF_MUZZLEFLASH	2
#define EF_BRIGHTLIGHT	4
#define EF_DIMLIGHT	8
#define EF_FLAG1	16
#define EF_FLAG2	32
// GLQuakeWorld Stuff
#define EF_BLUE		64	// Blue Globe effect for Quad
#define EF_RED		128	// Red Globe effect for Pentagram

// messages
#define MSG_BROADCAST	0		// unreliable to all
#define MSG_ONE		1 		// reliable to one (msg_entity)
#define MSG_ALL		2 		// reliable to all
#define MSG_INIT	3 		// write to the init string
#define MSG_MULTICAST   4

// message levels
#define	PRINT_LOW	0		// pickup messages
#define	PRINT_MEDIUM	1		// death messages
#define	PRINT_HIGH	2		// critical messages
#define PRINT_CHAT	3		// also goes to chat console

// multicast sets
#define MULTICAST_ALL	0    	// every client
#define MULTICAST_PHS	1    	// within hearing
#define MULTICAST_PVS	2    	// within sight
#define MULTICAST_ALL_R	3    	// every client, reliable
#define MULTICAST_PHS_R	4    	// within hearing, reliable
#define MULTICAST_PVS_R	5  	// within sight, reliable

// attack_state
#define AS_STRAIGHT	1
#define AS_SLIDING	2
#define AS_MELEE	3
#define AS_MISSILE	4

// qwmoba commands
#define MNU_OPEN    1

// qwmoba menus
#define MNU_INACTIVE 0
#define MNU_LOBBYTEAM 1
#define MNU_LOBBYCHAMP 2

// champs
#define CHAMP_UNDEFINED      0
#define CHAMP_ASHE      1
#define CHAMP_CAITLYN   2
#define CHAMP_ALISTAR   3
#define CHAMP_TARIC     4
#define CHAMP_MASTERYI  5
#define CHAMP_WARWICK   6
#define CHAMP_GAREN     7
#define CHAMP_KAYLE     8
#define CHAMP_AHRI      9
#define CHAMP_VEIGAR    10

// kill types
#define KT_CHAMPKILL    1
#define KT_CHAMPASSIST    2
#define KT_MINIONKILL    3
#define KT_SELFDEATH    4

// champ weapons
#define WEAPON_ASHE     1

// impulse defines
#define SKILLONE    1
#define SKILLTWO    2
#define SKILLTHREE    3
#define SKILLFOUR    4
#define SKILL_USEACTIVE 5
#define SKILL_USEONE    6
#define SKILL_USETWO    7
#define SKILL_USETHREE   8
#define SKILL_USEFOUR    9

// global rules
#define REGEN_TICKTIME  1

// champ skills
#define SKILLONE_ASHE   1
#define SKILLTWO_ASHE   2
#define SKILLTHREE_ASHE  3
#define SKILLFOUR_ASHE   4

// ashe defs
#define BASEAD_ASHE     50
#define BASEHEALTH_ASHE 500
#define BASEHEALTH_REGEN_ASHE 5
#define BASEMANA_ASHE  330
#define BASEMANA_REGEN_ASHE 5
#define BASESPEED_ASHE  330
#define BASEATTACKSPEED_ASHE    1
#define AASLOW_VALUE_ASHE       30 // slow percent
#define AASLOW_LIFETIME_ASHE   1
#define AASLOW_TICKRATE_ASHE   1
#define GROWTH_AD_ASHE  3
#define GROWTH_HEALTH_ASHE  50
#define GROWTH_AS_ASHE  3
#define GROWTH_MANA_ASHE    25


#define SKILLONE_VALUE_ASHE      30 // slow percent
#define SKILLONE_LIFETIME_ASHE   1
#define SKILLONE_TICKRATE_ASHE   5
#define SKILLONE_COOLDOWN_ASHE  20
#define SKILLONE_DAMAGE_ASHE  0
#define SKILLONE_MANACOST_ASHE  50

#define SKILLTWO_COOLDOWN_ASHE  20
#define SKILLTWO_DAMAGE_ASHE  20
#define SKILLTWO_MANACOST_ASHE  100
#define SKILLTWO_VALUE_ASHE  30 // slow percent
#define SKILLTWO_LIFETIME_ASHE   1
#define SKILLTWO_TICKRATE_ASHE   5

#define SKILLTHREE_COOLDOWN_ASHE  20
#define SKILLTHREE_DAMAGE_ASHE  0
#define SKILLTHREE_MANACOST_ASHE  0

#define SKILLFOUR_VALUE_ASHE      1 // meaningless
#define SKILLFOUR_LIFETIME_ASHE   1
#define SKILLFOUR_TICKRATE_ASHE   5
#define SKILLFOUR_COOLDOWN_ASHE  20
#define SKILLFOUR_DAMAGE_ASHE  100
#define SKILLFOUR_MANACOST_ASHE  200

// buff category
#define DEBUFF_MSSLOW       1
#define DEBUFF_STUN         3
#define BUFF_AASPEED        2

// buff type
#define MSSLOW_ASHE     1
#define AASPEED_SKILLONE_ASHE    2
#define MSSLOW_SKILLTWO_ASHE     3
#define STUN_SKILLFOUR_ASHE     4

// range?
#define RANGE_LOCAL 800

// creeps
#define CREEP_AGRO_RANGE    1000
#define CREEP_CHASE_DISTANCE    2500

#define CREEP_NONE          0
#define CREEP_RANGE         1
#define CREEP_MELEE         2
#define CREEP_CANNON        3
#define CREEP_SUPER         4
#define CREEP_SPAWNOFFSET_X     400
#define CREEP_SPAWNOFFSET_Y     200

#define CREEP_MELEE_EXP 59
#define CREEP_MELEE_GOLD    21
#define CREEP_MELEE_RANGE   110
#define CREEP_MELEE_BASEHEALTH  477
#define CREEP_MELEE_HEALTHGROWTH_EARLY    22
#define CREEP_MELEE_HEALTHGROWTH_LATE       34
#define CREEP_MELEE_BASEAD  12
#define CREEP_MELEE_AD_GROWTH_EARLY   0
#define CREEP_MELEE_AD_GROWTH_LATE   3.4
#define CREEP_MELEE_ARMOUR_GROWTH_EARLY   0
#define CREEP_MELEE_ARMOUR_GROWTH_LATE   1
#define CREEP_MELEE_BASEARMOUR  0
#define CREEP_MELEE_BASEMR  0
#define CREEP_MELEE_MOVESPEED   325
#define CREEP_MELEE_ATTACKSPEED 1.25

#define CREEP_RANGE_EXP 29
#define CREEP_RANGE_GOLD    14
#define CREEP_RANGE_RANGE   550
#define CREEP_RANGE_BASEHEALTH  296
#define CREEP_RANGE_HEALTHGROWTH_EARLY    6
#define CREEP_RANGE_HEALTHGROWTH_LATE       8.25
#define CREEP_RANGE_BASEAD  24
#define CREEP_RANGE_AD_GROWTH_EARLY   1.5
#define CREEP_RANGE_AD_GROWTH_LATE   4.5
#define CREEP_RANGE_ARMOUR_GROWTH   0
#define CREEP_RANGE_BASEARMOUR  0
#define CREEP_RANGE_BASEMR  0
#define CREEP_RANGE_MOVESPEED   325
#define CREEP_RANGE_ATTACKSPEED .667

#define CREEP_CANNON_EXP 92
#define CREEP_CANNON_GOLD    60
#define CREEP_CANNON_RANGE   300
#define CREEP_CANNON_BASEHEALTH  912
#define CREEP_CANNON_HEALTHGROWTH_EARLY    62
#define CREEP_CANNON_HEALTHGROWTH_LATE     87
#define CREEP_CANNON_BASEAD  41
#define CREEP_CANNON_AD_GROWTH_EARLY   1.5
#define CREEP_CANNON_AD_GROWTH_LATE   1.5
#define CREEP_CANNON_ARMOUR_GROWTH   0
#define CREEP_CANNON_BASEARMOUR  0
#define CREEP_CANNON_BASEMR  0
#define CREEP_CANNON_MOVESPEED   325
#define CREEP_CANNON_ATTACKSPEED 1

#define CREEP_SUPER_EXP 97
#define CREEP_SUPER_GOLD    60
#define CREEP_SUPER_RANGE   170
#define CREEP_SUPER_BASEHEALTH  1600
#define CREEP_SUPER_HEALTHGROWTH_EARLY    100
#define CREEP_SUPER_HEALTHGROWTH_LATE     100
#define CREEP_SUPER_BASEAD  230
#define CREEP_SUPER_AD_GROWTH_EARLY   5
#define CREEP_SUPER_AD_GROWTH_LATE   5
#define CREEP_SUPER_ARMOUR_GROWTH   0
#define CREEP_SUPER_BASEARMOUR  100
#define CREEP_SUPER_BASEMR  -30
#define CREEP_SUPER_MOVESPEED   325
#define CREEP_SUPER_ATTACKSPEED 0.85

// builds
#define STRUCTURE_NEXUS     1
#define STRUCTURE_INHIB     2
#define STRUCTURE_TOWER     3
#define STRUCTURE_SHOP      4

#define STRUCTURE_TOWER_NEXUS   1
#define STRUCTURE_TOWER_INHIB   2
#define STRUCTURE_TOWER_INNER   3
#define STRUCTURE_TOWER_OUTER   4

#define STRUCTURE_INHIB_EXP         0
#define STRUCTURE_INHIB_HEALTH    4000
#define STRUCTURE_INHIB_HEALTH_REGEN    15
#define STRUCTURE_INHIB_ARMOUR_BASE    20
#define STRUCTURE_INHIB_MR_BASE    0
#define STRUCTURE_INHIB_GOLD_GLOBAL    0
#define STRUCTURE_INHIB_GOLD_ASSIST    0
#define STRUCTURE_INHIB_GOLD_KILL    50

#define STRUCTURE_NEXUS_HEALTH    5500
#define STRUCTURE_NEXUS_HEALTH_REGEN    25
#define STRUCTURE_NEXUS_ARMOUR_BASE    0
#define STRUCTURE_NEXUS_MR_BASE    0
#define STRUCTURE_NEXUS_GOLD_GLOBAL    0
#define STRUCTURE_NEXUS_GOLD_ASSIST    0
#define STRUCTURE_NEXUS_GOLD_KILL    50

#define STRUCTURE_TOWER_RANGE       1000
#define STRUCTURE_TOWER_EXP             0
#define STRUCTURE_TOWER_OUTER_HEALTH    5000
#define STRUCTURE_TOWER_OUTER_HEALTH_REGEN  0
#define STRUCTURE_TOWER_OUTER_AD    152
#define STRUCTURE_TOWER_OUTER_AD_GROWTH    9
#define STRUCTURE_TOWER_OUTER_AD_MAX    278
#define STRUCTURE_TOWER_OUTER_ATTACKSPEED    .833
#define STRUCTURE_TOWER_OUTER_ARMOUR_BASE    40
#define STRUCTURE_TOWER_OUTER_MR_BASE    40
#define STRUCTURE_TOWER_OUTER_GOLD_GLOBAL    50
#define STRUCTURE_TOWER_OUTER_GOLD_ASSIST    250
#define STRUCTURE_TOWER_OUTER_GOLD_KILL    0

#define STRUCTURE_TOWER_INNER_HEALTH    3600
#define STRUCTURE_TOWER_INNER_HEALTH_REGEN  0
#define STRUCTURE_TOWER_INNER_AD    170
#define STRUCTURE_TOWER_INNER_AD_GROWTH    9
#define STRUCTURE_TOWER_INNER_AD_MAX    305
#define STRUCTURE_TOWER_INNER_ATTACKSPEED    .833
#define STRUCTURE_TOWER_INNER_ARMOUR_BASE    55
#define STRUCTURE_TOWER_INNER_ARMOUR_GROWTH    1
#define STRUCTURE_TOWER_INNER_MR_BASE    55
#define STRUCTURE_TOWER_INNER_MR_GROWTH    1
#define STRUCTURE_TOWER_INNER_GOLD_GLOBAL    50
#define STRUCTURE_TOWER_INNER_GOLD_ASSIST    300
#define STRUCTURE_TOWER_INNER_GOLD_KILL    0

#define STRUCTURE_TOWER_INHIB_HEALTH    3600
#define STRUCTURE_TOWER_INHIB_HEALTH_REGEN    3
#define STRUCTURE_TOWER_INHIB_AD    170
#define STRUCTURE_TOWER_INHIB_AD_GROWTH    9
#define STRUCTURE_TOWER_INHIB_AD_MAX    305
#define STRUCTURE_TOWER_INHIB_ATTACKSPEED    .833
#define STRUCTURE_TOWER_INHIB_ARMOUR_BASE    55
#define STRUCTURE_TOWER_INHIB_ARMOUR_GROWTH    0
#define STRUCTURE_TOWER_INHIB_MR_BASE    55
#define STRUCTURE_TOWER_INHIB_MR_GROWTH    0
#define STRUCTURE_TOWER_INHIB_GOLD_GLOBAL    50
#define STRUCTURE_TOWER_INHIB_GOLD_ASSIST    50
#define STRUCTURE_TOWER_INHIB_GOLD_KILL    0

#define STRUCTURE_TOWER_NEXUS_HEALTH    2700
#define STRUCTURE_TOWER_NEXUS_HEALTH_REGEN    6
#define STRUCTURE_TOWER_NEXUS_AD    150
#define STRUCTURE_TOWER_NEXUS_AD_GROWTH    9
#define STRUCTURE_TOWER_NEXUS_AD_MAX    285
#define STRUCTURE_TOWER_NEXUS_ATTACKSPEED    .833
#define STRUCTURE_TOWER_NEXUS_ARMOUR_BASE    55
#define STRUCTURE_TOWER_NEXUS_ARMOUR_GROWTH    1
#define STRUCTURE_TOWER_NEXUS_MR_BASE    55
#define STRUCTURE_TOWER_NEXUS_MR_GROWTH    1
#define STRUCTURE_TOWER_NEXUS_GOLD_GLOBAL    50
#define STRUCTURE_TOWER_NEXUS_GOLD_ASSIST    0
#define STRUCTURE_TOWER_NEXUS_GOLD_KILL    0

// info_qwmgoal
#define INFO_WAYPOINT   1

// levels
#define EXP_LEVELTWO    280
#define EXP_LEVELTHREE    380
#define EXP_LEVELFOUR    480
#define EXP_LEVELFIVE    580
#define EXP_LEVELSIX    680
#define EXP_LEVELSEVEN    780
#define EXP_LEVELEIGHT    880
#define EXP_LEVELNINE    980
#define EXP_LEVELTEN    1080
#define EXP_LEVELELEVEN    1180
#define EXP_LEVELTWELVE    1280
#define EXP_LEVELTHIRTEEN    1380
#define EXP_LEVELFOURTEEN    1480
#define EXP_LEVELFIFTEEN    1580
#define EXP_LEVELSIXTEEN    1680
#define EXP_LEVELSEVENTEEN    1780
#define EXP_LEVELEIGHTEEN    1880