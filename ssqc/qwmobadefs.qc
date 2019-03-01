#include "../share/defs.h"

.float menu;
.float team_no;
.float menu_active;
.float champ;

// champ fields
.float attackdamage;
.float attackspeed;
.float skillone;
.float skilltwo;
.float skillthree;
.float skillfour;
.float activeskill;
.float mana;
.float max_mana;
.float regentick;
.float healthregen;
.float manaregen;
.float stacks;
.float skillonedamage;
.float skillonecooldown;
.float skillonemanacost;
.float skilltwodamage;
.float skilltwocooldown;
.float skilltwomanacost;
.float skillthreedamage;
.float skillthreecooldown;
.float skillthreemanacost;
.float skillfourdamage;
.float skillfourcooldown;
.float skillfourmanacost;
.float gold;
.float respawntime;
.float cnt2;
.float ready;
.float level;
.float experience;
.float tower_no;
.float mrvalue;
.float healthlastregen;
.float manalastregen;

// buff fields
.float bufftype;
.float buffcategory;
.float nextthinkinterval;
.float buffvalue;
.float stunned;


// npc fields
.float lane;
.float type;
.string team_str;
.float wave;
.float deadtime;
.vector attackstartorigin;

// waypoints
.float chainnum;

entity oldself;