void (entity player, float menutype) ShowMenu = {
    msg_entity = player; 
    WriteByte(MSG_MULTICAST, SVC_CGAMEPACKET); //when sending a SVC_CGAMEPACKET we can handle it clientside, note: it has to be a MSG_MULTICAST.
    WriteByte(MSG_MULTICAST, MNU_LOBBY); //it's smart to use the first byte of the actual message as an identifier, and it's also smart to name them.
    multicast('0 0 0', MULTICAST_ONE); 
}