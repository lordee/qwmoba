void(vector pos, float value, float threshhold) Hud_DrawLargeValue =
{
	float c;
	float len;
	string s;
	if (value < 0)
		value = 0;	//hrm
	if (value>999)
		value = 999;
	s = ftos(floor(value));
	len = strlen(s);
	pos_x += 24 * (3-len);
	if (value <= threshhold)
	{	//use alternate (red) numbers

		while(len>0)
		{
			len-=1;
			c = str2chr(s, len);
			drawpic(pos+len * '24 0 0', sprintf("anum_%g", c-'0'), '24 24 0', '1 1 1', 1, 0);
		}
	}
	else
	{	//use normal numbers

		while(len>0)
		{
			len-=1;
			c = str2chr(s, len);
			drawpic(pos+len * '24 0 0', sprintf("num_%g", c-'0'), '24 24 0', '1 1 1', 1, 0);
		}
	}
};

void (vector pos, float val, float max_val, vector color) Hud_DrawBar = {
	float barlength = 150;
	float perc = val / max_val * 100;
	float barperc = barlength / 100 * perc;
	float colorchange = barperc / 100;

	drawfill(pos, [barperc, 10, 0], color, 0.6, 0);
	drawfill(pos, [barlength, 10, 0], color, 0.2, 0);

	string msg = strcat(ftos(val), "/", ftos(max_val));

	vector stringpos = pos;
	stringpos_x = stringpos_x + (barlength / 2);

	float msgwidth = stringwidth(msg, 0, '8 8');
	stringpos_x = stringpos_x - (msgwidth*.5);

	drawstring(stringpos, msg, [8, 8, 0], [1, 1, 1], 1, 0);
}

void (vector pos, string image, float selected, float cooldown) Hud_DrawSkillIcon = {
	vector size = [20, 20, 0];
	drawpic(pos, image, size, [1, 1, 1], 1, 0);

	if (selected)
	{
		drawfill(pos - '0 2 0', [22, 2, 0], [0, 255, 0], 0.6, 0);
		drawfill(pos + '0 20 0', [20, 2, 0], [0, 255, 0], 0.6, 0);
		drawfill(pos - '2 2 0', [2, 24, 0], [0, 255, 0], 0.6, 0);
		drawfill(pos + '20 0 0', [2, 22, 0], [0, 255, 0], 0.6, 0);
	}

	float cd = ceil(cooldown - time);

	if (cd > 0)
	{
		drawfill(pos, size, [128, 128, 128], 0.6, 0);
		
		float msgwidth = stringwidth(ftos(cd), 0, [6, 8, 0]);
		vector stringpos = pos;
		stringpos = stringpos + [10, 10, 0];
		stringpos_x = stringpos_x - (msgwidth * .5);
		stringpos_y = stringpos_y - 4;

		drawstring(stringpos, ftos(cd), [6, 8, 0], [1, 1, 1], 1, 0);
	}
}

// this should not be tested every frame... fix it later
string (float champ, float skillnum) GetChampIcon = {
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

void Hud_Draw(vector scrsz)
{
	vector pos = [(scrsz_x-320)/2, pos_y = scrsz_y - 24, 0];	//calculate the top-left of the sbar, assuming it is 320 units wide and placed in the bottom-middle of the screen
	
	float stitems = getstatbits(STAT_ITEMS, 0, 23);			//this is the player's self.items value (STAT_ITEMS is generated specially by the server)

	entity p = findfloat(world, entnum, player_localentnum); 
	if (p.champ)
	{
		float manaval = p.mana;
		float mana_max = p.max_mana;
		pos = pos+'24 0 0';
		vector color = '0 0 255';
		Hud_DrawBar(pos, manaval, mana_max, color);

		float hval = p.health;
		float h_max = p.max_health;
		color = '255 0 0';
		pos = pos + '0 12 0';
		Hud_DrawBar(pos, hval, h_max, color);

		// skills
		// based on champ, show champ skill icons
		string icon = GetChampIcon(p.champ, 1);
		pos = pos - '0 40 0';
		Hud_DrawSkillIcon(pos, icon, (p.activeskill == 1) ? TRUE : FALSE, p.skillonecooldown);

		icon = GetChampIcon(p.champ, 2);
		pos = pos + '25 0 0';
		Hud_DrawSkillIcon(pos, icon, (p.activeskill == 2) ? TRUE : FALSE, p.skilltwocooldown);

		icon = GetChampIcon(p.champ, 3);
		pos = pos + '25 0 0';
		Hud_DrawSkillIcon(pos, icon, (p.activeskill == 3) ? TRUE : FALSE, p.skillthreecooldown);

		icon = GetChampIcon(p.champ, 4);
		pos = pos + '25 0 0';
		Hud_DrawSkillIcon(pos, icon, (p.activeskill == 4) ? TRUE : FALSE, p.skillfourcooldown);

        // level and experience
        float bar = GetExpBar(p.level);
		// gold

		// items

		// minimap
	}
	
};