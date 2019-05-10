#include "../share/defs.h"

.float menu;
.float team_no;
.float champ_id;
.float id;

// champ fields
.float attackdamage;
.float attackspeed;
.float skill_one;
.float skill_two;
.float skill_three;
.float skill_four;
.float skill_selected;
.float mana;
.float max_mana;
.float regentick;
.float healthregen;
.float manaregen;
.float stacks;
.float skill_one_damage;
.float skill_one_cooldown;
.float skill_one_cooldown_time;
.float skill_one_manacost;
.float skill_one_range;
.float skill_one_value;
.float skill_two_damage;
.float skill_two_cooldown;
.float skill_two_cooldown_time;
.float skill_two_manacost;
.float skill_two_range;
.float skill_two_value;
.float skill_three_damage;
.float skill_three_cooldown;
.float skill_three_cooldown_time;
.float skill_three_manacost;
.float skill_three_range;
.float skill_three_value;
.float skill_four_damage;
.float skill_four_cooldown;
.float skill_four_cooldown_time;
.float skill_four_manacost;
.float skill_four_range;
.float skill_four_value;
.float gold;
.float gold_global;
.float gold_assist;
.float gold_kill;
.float gold_extra;
.float gold_minion;
.float assist_count;
.float item_one;
.float item_two;
.float item_three;
.float item_four;
.float item_five;
.float item_six;
.float item_seven;
.float can_shop;
.float item_selected;
.float item_one_cooldown;
.float item_two_cooldown;
.float item_three_cooldown;
.float item_four_cooldown;
.float item_five_cooldown;
.float item_six_cooldown;
.float item_seven_cooldown;

.float consecutive_deaths;
.float consecutive_kills;
.float kill_tier;

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
float GameStarted;