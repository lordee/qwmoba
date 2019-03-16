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

void Hud_Draw(vector scrsz)
{
	vector pos = [(scrsz_x-320)/2, pos_y = scrsz_y - 24, 0];	//calculate the top-left of the sbar, assuming it is 320 units wide and placed in the bottom-middle of the screen
	
	float stitems = getstatbits(STAT_ITEMS, 0, 23);			//this is the player's self.items value (STAT_ITEMS is generated specially by the server)

	entity p = findfloat(world, entnum, player_localentnum); 
	float manaval = p.mana;
	float mana_max = p.max_mana;
	pos = pos+'24 0 0';
	vector color = '0 0 255';
	Hud_DrawBar(pos, manaval, mana_max, color);

	float hval = p.health;
	float h_max = p.max_health;
	vector color = '255 0 0';
	pos = pos + '0 12 0';
	Hud_DrawBar(pos, hval, h_max, color);

	// skills

	// items

	// minimap
	
};