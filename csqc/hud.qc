void Hud_DrawBar(vector pos, float val, float max_val, vector color)
{
	float barlength = 150;
	float perc = val / max_val * 100;
	float barperc = barlength / 100 * perc;
	float colorchange = barperc / 100;
    vector fontsize = [8, 8, 0];

	drawfill(pos, [barperc, 10, 0], color, 0.6, 0);
	drawfill(pos, [barlength, 10, 0], color, ALPHA_PANEL_BG, 0);

	string msg = strcat(ftos(val), "/", ftos(max_val));

	vector stringpos = pos;
	stringpos_x = stringpos_x + (barlength / 2);
	stringpos_y = stringpos_y + 2;

	float msgwidth = stringwidth(msg, 0, fontsize);
	stringpos_x = stringpos_x - (msgwidth*.5);

	drawstring(stringpos, msg, fontsize, [1, 1, 1], 1, 0);
}

void Hud_DrawSkillAndItemIcon(vector pos, string image, float selected, float cooldown)
{
	vector size = [20, 20, 0];
	drawpic(pos, image, size, [1, 1, 1], 1, 0);

	if (selected)
	{
		drawfill(pos + [0, -2, 0], [22, 2, 0], [0, 255, 0], 0.6, 0);
		drawfill(pos + [0, 20, 0], [20, 2, 0], [0, 255, 0], 0.6, 0);
		drawfill(pos + [-2, -2, 0], [2, 24, 0], [0, 255, 0], 0.6, 0);
		drawfill(pos + [20, 0, 0], [2, 22, 0], [0, 255, 0], 0.6, 0);
	}

	float cd = ceil(cooldown - time);

	if (cd > 0)
	{
		drawfill(pos, size, COLOR_PANEL_BG, 0.6, 0);
        vector fontsize = [6, 8, 0];
		
		float msgwidth = stringwidth(ftos(cd), 0, fontsize);
		vector stringpos = pos;
		stringpos = stringpos + [10, 10, 0];
		stringpos_x = stringpos_x - (msgwidth * .5);
		stringpos_y = stringpos_y - 4;

		drawstring(stringpos, ftos(cd), fontsize, [1, 1, 1], 1, 0);
	}
}

// TODO this should not be tested every frame... fix it later
string GetChampIcon(float champ, float skillnum)
{
	switch (champ)
	{
		case CHAMP_FROSTARCHER:
			switch (skillnum)
			{
				case 1:
					return SKILLONEICON_FROSTARCHER;
					break;
				case 2:
					return SKILLTWOICON_FROSTARCHER;
					break;
				case 3:
					return SKILLTHREEICON_FROSTARCHER;
					break;
				case 4:
					return SKILLFOURICON_FROSTARCHER;
					break;
			}
			break;
		default:
			return "";
	}
}

void Hud_DrawBarEXP(vector pos, float val, float max_val, float lvl, vector color)
{

	float barlength = 154; // get a little separation from other bars so we can highlight on levelup
	vector boxsize = [20, 20, 0];
    vector fontsize = [8, 8, 0];

	float perc = val / max_val * 100;
	float barperc = (barlength + boxsize_x) / 100 * perc;
	float colorchange = barperc / 100;
	float barcolorpx = 0;
	float boxcolorpx = 0;
	if (barperc > barlength)
	{
		barcolorpx = barlength;
		boxcolorpx = barperc - barlength;
	}
	else
	{
		barcolorpx = barperc;
	}

	drawfill(pos, [barcolorpx, 10, 0], color, 0.6, 0);
	drawfill(pos, [barlength, 10, 0], color, ALPHA_PANEL_BG, 0);

	string msg = strcat(ftos(val), "/", ftos(max_val));

	// exp numbers
	vector stringpos = pos;
	stringpos_x = stringpos_x + (barlength / 2);
	stringpos_y = stringpos_y + 2;

	float msgwidth = stringwidth(msg, 0, fontsize);
	stringpos_x = stringpos_x - (msgwidth*.5);
	drawstring(stringpos, msg, fontsize, [1, 1, 1], 1, 0);

	// level box
	vector boxpos = pos;
	boxpos_x = boxpos_x + barlength;
	boxpos_y = boxpos_y - 5;
	// for now just a string in a box
    drawfill(boxpos, boxsize, color, .2, 0);
	drawfill(boxpos, [boxcolorpx, boxsize_y, 0], color, .6, 0);

    msgwidth = stringwidth(ftos(lvl), 0, fontsize);
    stringpos = boxpos;
    stringpos = stringpos + (boxsize * .5);
    stringpos_x = stringpos_x - (msgwidth * .5);
    stringpos_y = stringpos_y - (fontsize_y * .5);
    drawstring(stringpos, ftos(lvl), fontsize, [1, 1, 1], 1, 0);    

	// if level up recently, do highlight new level
	float trans = leveluptime - time;
    if (trans > 0)
	{
		// top box
		drawfill(boxpos + [-2, -2, 0], [24, 2, 0], [255, 215, 0], trans, 0);
		// top left box
		drawfill(boxpos + [-2, 0, 0], [2, 5, 0], [255, 215, 0], trans, 0);
		// bot left box
		vector botpos = boxpos + [-2, 0, 0];
		botpos_y = botpos_y + 15;
		drawfill(botpos, [2, 7, 0], [255, 215, 0], trans, 0);
		// bot box
		drawfill(boxpos + [0, 20, 0], [20, 2, 0], [255, 215, 0], trans, 0);
		// right box
		drawfill(boxpos + [20, 0, 0], [2, 22, 0], [255, 215, 0], trans, 0);

		// left bar
		drawfill(pos + [-2, -2, 0], [2, 14, 0], [255, 215, 0], trans, 0);
		// top bar
		drawfill(pos + [0, -2, 0], [barlength, 2, 0], [255, 215, 0], trans, 0);
		// bot bar
		drawfill(pos + [0, 10, 0], [barlength, 2, 0], [255, 215, 0], trans, 0);
	}
}

void Hud_DrawGold(vector pos, float goldval)
{
    vector fillsize = [50, 20, 0];
    drawfill(pos, fillsize, COLOR_PANEL_BG, ALPHA_PANEL_BG, 0);

    string msg = ftos(goldval);
    vector fontsize = [6, 6, 0];
    vector stringpos = pos;
    float msgwidth = stringwidth(msg, 0, fontsize);

    // let's right align
    stringpos_x = stringpos_x + (fillsize_x - msgwidth);

    // vertical middle align
    stringpos_y = stringpos_y + (fontsize_y * .5);
    drawstring(stringpos, msg, fontsize, [255, 215, 0], 1, 0);

    // TODO gold coin icon
}

void Hud_DrawMiniMap(vector pos, vector fillsize)
{
    drawfill(pos, fillsize, COLOR_PANEL_BG, ALPHA_PANEL_BG, 0);
}

void Hud_Draw(vector scrsz)
{
	vector pos = [(scrsz_x-320)/2, pos_y = scrsz_y - 24, 0];	//calculate the top-left of the sbar, assuming it is 320 units wide and placed in the bottom-middle of the screen
	
	float stitems = getstatbits(STAT_ITEMS, 0, 23);			//this is the player's self.items value (STAT_ITEMS is generated specially by the server)

	entity p = findfloat(world, entnum, player_localentnum); 
	if (p.champ_id)
	{
		float hval = p.health;
		float h_max = p.max_health;
		vector color = [255, 0, 0];
		pos = pos + [24, 12, 0];
		Hud_DrawBar(pos, hval, h_max, color);

		float manaval = p.mana;
		float mana_max = p.max_mana;
		pos = pos + [0, -12, 0];
		color = [0, 0, 255];
		Hud_DrawBar(pos, manaval, mana_max, color);

        // level and experience
		float exp = p.experience;
        float e_max = GetExpBar(p.level);
        color = [147, 112, 219];
        pos = pos + [0, -12, 0];
		float lvl = p.level;
		Hud_DrawBarEXP(pos, exp, e_max, lvl, color);
        
		// skills
		// based on champ, show champ skill icons
		string icon = GetChampIcon(p.champ_id, 1);
		pos = pos + [0, -40, 0];
		Hud_DrawSkillAndItemIcon(pos, icon, (p.skill_selected == 1) ? TRUE : FALSE, p.skill_one_cooldown);

		icon = GetChampIcon(p.champ_id, 2);
		pos = pos + [25, 0, 0];
		Hud_DrawSkillAndItemIcon(pos, icon, (p.skill_selected == 2) ? TRUE : FALSE, p.skill_two_cooldown);

		icon = GetChampIcon(p.champ_id, 3);
		pos = pos + [25, 0, 0];
		Hud_DrawSkillAndItemIcon(pos, icon, (p.skill_selected == 3) ? TRUE : FALSE, p.skill_three_cooldown);

		icon = GetChampIcon(p.champ_id, 4);
		pos = pos + [25, 0, 0];
		Hud_DrawSkillAndItemIcon(pos, icon, (p.skill_selected == 4) ? TRUE : FALSE, p.skill_four_cooldown);

		// gold
        pos = pos + [50, 64, 0];
        Hud_DrawGold(pos, p.gold);

		// items
        pos = pos + [0, -64, 0];

        icon = Items[p.item_one].icon;
        Hud_DrawSkillAndItemIcon(pos, icon, (p.item_selected == 1) ? TRUE : FALSE, p.item_one_cooldown);
        pos = pos + [22, 0, 0];
        icon = Items[p.item_two].icon;
        Hud_DrawSkillAndItemIcon(pos, icon, (p.item_selected == 2) ? TRUE : FALSE, p.item_two_cooldown);
        pos = pos + [22, 0, 0];
        icon = Items[p.item_three].icon;
        Hud_DrawSkillAndItemIcon(pos, icon, (p.item_selected == 3) ? TRUE : FALSE, p.item_three_cooldown);
        pos = pos + [22, 11, 0];
        icon = Items[p.item_four].icon;
        Hud_DrawSkillAndItemIcon(pos, icon, (p.item_selected == 4) ? TRUE : FALSE, p.item_four_cooldown);
        pos = pos + [-66, 11, 0];
        icon = Items[p.item_five].icon;
        Hud_DrawSkillAndItemIcon(pos, icon, (p.item_selected == 5) ? TRUE : FALSE, p.item_five_cooldown);
        pos = pos + [22, 0, 0];
        icon = Items[p.item_six].icon;
        Hud_DrawSkillAndItemIcon(pos, icon, (p.item_selected == 6) ? TRUE : FALSE, p.item_six_cooldown);
        pos = pos + [22, 0, 0];
        icon = Items[p.item_seven].icon;
        Hud_DrawSkillAndItemIcon(pos, icon, (p.item_selected == 7) ? TRUE : FALSE, p.item_seven_cooldown);

		// minimap
        pos = scrsz;
        vector fillsize = [100, 100, 0];
        pos = pos - fillsize;
        Hud_DrawMiniMap(pos, fillsize);
	}
};