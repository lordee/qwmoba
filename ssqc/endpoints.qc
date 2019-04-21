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
    self.champ_id = c;
    self.level = 1;
    // force a respawn as that champ
    ClientKill();
}

float CheckComponents(IT_Base checkitem, float equippeditemf, float gold_needed)
{
    // go through component items of item
    for (float i = 0; i < ItemComponents.length; i++)
    {
        if (ItemComponents[i].item_id == checkitem.item_id)
        {
            for (float i2 = 0; i2 < ItemComponents[i].components.length; i2++)
            {
                // if the item owned is in component, take away that amount from the bought item gold cost
                IT_Base itempart;
                float checkid;
                checkid = ItemComponents[i].components[i2];
                itempart = Items[checkid];

                if (checkid == equippeditemf)
                {
                    gold_needed = gold_needed - itempart.gold;
                    break;
                }
                else
                {
                    // if checkid has components, check them
                    gold_needed = CheckComponents(itempart, equippeditemf, gold_needed);
                }
            }
            break;
        }
    }

    return gold_needed;
}

void Cmd_BuyItem_f(float item_id)
{
    IT_Base buyitem = Items[item_id];
    float gold_needed = 0;
    gold_needed = buyitem.gold;
    float used[5];
    float u = 0;
    float gold_precheck = buyitem.gold;
    // TODO make this better
    gold_needed = CheckComponents(buyitem, self.item_one, gold_needed);
    if (gold_needed != gold_precheck)
    {
        u = used.length;
        used[u] = 1;
    }
    gold_needed = CheckComponents(buyitem, self.item_two, gold_needed);
    if (gold_needed != gold_precheck)
    {
        u = used.length;
        used[u] = 2;
    }
    gold_needed = CheckComponents(buyitem, self.item_three, gold_needed);
    if (gold_needed != gold_precheck)
    {
        u = used.length;
        used[u] = 3;
    }
    gold_needed = CheckComponents(buyitem, self.item_five, gold_needed);
    if (gold_needed != gold_precheck)
    {
        u = used.length;
        used[u] = 5;
    }
    gold_needed = CheckComponents(buyitem, self.item_six, gold_needed);
    if (gold_needed != gold_precheck)
    {
        u = used.length;
        used[u] = 6;
    }
    gold_needed = CheckComponents(buyitem, self.item_seven, gold_needed);
    if (gold_needed != gold_precheck)
    {
        u = used.length;
        used[u] = 7;
    }
    
    if (gold_needed <= self.gold)
    {
        // an equipped item was used, get rid of it
        for (float i = 0; i < used.length; i++)
        {
            switch (used[i])
            {
                case 1:
                    self.item_one = 0;
                    break;
                case 2:
                    self.item_two = 0;
                    break;
                case 3:
                    self.item_three = 0;
                    break;
                case 5:
                    self.item_five = 0;
                    break;
                case 6:
                    self.item_six = 0;
                    break;
                case 7:
                    self.item_seven = 0;
                    break;
            }
        }

        // TODO need special case on item four for wards etc. also make it a switch
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

        self.gold = self.gold - gold_needed;
    }
    else
    {
        sprint(self, PRINT_HIGH, "Not enough gold to buy that");
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
	WriteFloat(MSG_ENTITY, self.champ_id);
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
    WriteFloat(MSG_ENTITY, self.experience);
    WriteFloat(MSG_ENTITY, self.item_one);
    WriteFloat(MSG_ENTITY, self.item_two);
    WriteFloat(MSG_ENTITY, self.item_three);
    WriteFloat(MSG_ENTITY, self.item_four);
    WriteFloat(MSG_ENTITY, self.item_five);
    WriteFloat(MSG_ENTITY, self.item_six);
    WriteFloat(MSG_ENTITY, self.item_seven);
    WriteFloat(MSG_ENTITY, self.stunned);

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