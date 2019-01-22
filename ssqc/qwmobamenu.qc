void (entity player, float menutype) ShowMenu = {
    
    if (player.menu_active != menutype)
    {
        msg_entity = player;
        WriteByte(MSG_MULTICAST, SVC_CGAMEPACKET); 
        WriteByte(MSG_MULTICAST, MNU_OPEN); 
        WriteByte(MSG_MULTICAST, menutype); 
        multicast('0 0 0', MULTICAST_ONE); 
    }
    
}