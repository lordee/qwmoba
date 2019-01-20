void (entity player, float menutype) ShowMenu = {
    sprint("sending showmenu");
    msg_entity = player;
    WriteByte(MSG_MULTICAST, SVC_CGAMEPACKET); 
    WriteByte(MSG_MULTICAST, MNU_LOBBY); 
    WriteByte(MSG_MULTICAST, 1); 
    multicast('0 0 0', MULTICAST_ONE); 
    
}