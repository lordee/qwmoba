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
}

float stitems, stitems2, stweapon;
void Hud_Draw(vector scrsz)
{
	vector pos = [(scrsz_x-320)/2, pos_y = scrsz_y - 24, 0];	//calculate the top-left of the sbar, assuming it is 320 units wide and placed in the bottom-middle of the screen
	//get some commonly refered to values
	stitems = getstatbits(STAT_ITEMS, 0, 23);			//this is the player's self.items value (STAT_ITEMS is generated specially by the server)
	stitems2 = getstatbits(STAT_ITEMS, 23, 9);			//this is the player's self.items2 value if it exists, otherwise it is the serverflags global
	stweapon = getstatf(STAT_ACTIVEWEAPON);				//this is the player's self.weapon value.

	drawpic(pos, "sbar", '320 24 0', '1 1 1', 0.5, 0);		//draw the sbar background image slightly transparently

	//Hud_DrawLargeValue(pos+'24 0 0', getstatf(STAT_ARMOR), 25);
	Hud_DrawLargeValue(pos+'136 0 0', getstatf(STAT_HEALTH), 25);
	Hud_DrawLargeValue(pos+'248 0 0', getstatf(STAT_AMMO), 10);

	entity p = findfloat(world, entnum, player_localentnum); 
	float manaval = p.mana;
	float mana_max = p.max_mana;
	vector mana_pos = pos+'24 0 0';
	vector color = '0 0 255';

	Hud_DrawBar(mana_pos, manaval, mana_max, color);
};