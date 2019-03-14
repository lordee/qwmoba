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
    // force a respawn as that champ
    ClientKill();
}


// meh.. outgoing
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