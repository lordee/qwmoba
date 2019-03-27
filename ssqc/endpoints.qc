// qwmoba
void (float team) Cmd_JoinTeam_f = {
    self.team_no = team;
    self.menu = MNU_LOBBYCHAMP;
}

void (float menu) Cmd_AckMenu_f = {
    self.menu_active = menu;
}

void (float c) Cmd_ChooseChamp_f = {
    self.menu = MNU_INACTIVE;
    self.champ = c;
    self.level = 1;
    // force a respawn as that champ
    ClientKill();
}

void CheckComponents(float buy_id, entity checkitem)
{
    // TODO finish this when you can think again
    if (checkitem.components.length > 0)
    {
        entity itempart;
        for (int i = 0; i < checkitem.components.length; i = i + 1)
        {
            float checkid = checkitem.components[i];
            // if checkid is the buyid, take gold away
            
            // if checkid not the item_id, check its components
            // recursion, check for more components
            // need to check components of higher order components to make sure we don't double dip
            
            if (checkid == self.item_one)
            {
                itempart = GetItem(checkid);
                gold_needed = gold_needed - itempart.gold;
                continue;
            }
            else if (checkid == self.item_two)
            {

            }
                
        }
    }
}

void Cmd_BuyItem_f(float item_id)
{
    entity buyitem = Items[item_id];
    float gold_needed = 0;
    gold_needed = buyitem.gold;
    // is it a combine?
    CheckComponents(item_id, buyitem);
    
    
    if (gold_needed <= self.gold)
    {
        
        // is there a slot free?

        // TODO need special case on item four for wards etc
        // find an item slot
        if (!self.item_one)
            self.item_one = item_id;
        else if (!self.item_two)
            self.item_two = item_id;
        else if (!self.item_three)
            self.item_three = item_id;
        else if (!self.item_four)
            self.item_four = item_id;
        else if (!self.item_five)
            self.item_five = item_id;
        else if (!self.item_six)
            self.item_six = item_id;
        else if (!self.item_seven)
            self.item_seven = item_id;
    }
    else
    {
        // TODO can't buy
    }
    
}

// meh.. outgoing
float Player_SendEntity(entity ePVEnt, float flChanged) {
    WriteByte(MSG_ENTITY, SE_PLAYER); // Unique Identifier, I suggest you use enums to make it easy on yourself
    WriteCoord(MSG_ENTITY, self.origin_x); // Position X
    WriteCoord(MSG_ENTITY, self.origin_y); // Position Y
    WriteCoord(MSG_ENTITY, self.origin_z); // Position Z
    WriteCoord(MSG_ENTITY, self.angles_x); // Angle X
    WriteCoord(MSG_ENTITY, self.angles_y); // Angle Y
    WriteCoord(MSG_ENTITY, self.angles_z); // Angle Z
    WriteShort(MSG_ENTITY, self.velocity_x); // Velocity X
    WriteShort(MSG_ENTITY, self.velocity_y); // Velocity X
    WriteShort(MSG_ENTITY, self.velocity_z); // Velocity X
    WriteFloat(MSG_ENTITY, self.flags); // Flags, important for physics

	WriteString(MSG_ENTITY, self.netname);
	WriteFloat(MSG_ENTITY, self.champ);
	WriteFloat(MSG_ENTITY, self.ready);
	WriteFloat(MSG_ENTITY, self.mana);
	WriteFloat(MSG_ENTITY, self.max_mana);
	WriteFloat(MSG_ENTITY, self.health);
	WriteFloat(MSG_ENTITY, self.max_health);
    WriteFloat(MSG_ENTITY, self.skill_selected);
    WriteFloat(MSG_ENTITY, self.skill_one_cooldown);
    WriteFloat(MSG_ENTITY, self.skill_two_cooldown);
    WriteFloat(MSG_ENTITY, self.skill_three_cooldown);
    WriteFloat(MSG_ENTITY, self.skill_four_cooldown);
    WriteFloat(MSG_ENTITY, self.gold);
    WriteFloat(MSG_ENTITY, self.level);
    WriteFloat(MSG_ENTITY, self.item_one);
    WriteFloat(MSG_ENTITY, self.item_two);
    WriteFloat(MSG_ENTITY, self.item_three);
    WriteFloat(MSG_ENTITY, self.item_four);
    WriteFloat(MSG_ENTITY, self.item_five);
    WriteFloat(MSG_ENTITY, self.item_six);
    WriteFloat(MSG_ENTITY, self.item_seven);

    return TRUE;
}

void (entity player, float upd_type, float multicast_type) SendUpdate = {
    msg_entity = player;
    WriteByte(MSG_MULTICAST, SVC_CGAMEPACKET); 
    WriteByte(MSG_MULTICAST, upd_type); 
    switch (upd_type)
    {
        /*case SE_READY:
            WriteByte(MSG_MULTICAST, player.id);
            WriteByte(MSG_MULTICAST, player.ready);
            break;*/
    }
    if (multicast_type == MULTICAST_ONE)
    {
        multicast('0 0 0', multicast_type); 
    }
    else
    {
        multicast(player.origin, multicast_type);     
    }
}

void (entity player, float menutype) ShowMenu = {
    
    if (player.menu_active != menutype)
    {
        msg_entity = player;
        WriteByte(MSG_MULTICAST, SVC_CGAMEPACKET); 
        WriteByte(MSG_MULTICAST, SE_MNU_OPEN); 
        WriteByte(MSG_MULTICAST, menutype); 
        multicast('0 0 0', MULTICAST_ONE); 
    }
    
}