entity (float pid) GetPlayer = {

    entity player = find (world, classname, "player");
    
    while (player)
    {
        if (player.id == pid)
        {
            break;
        }
        player = find(player, classname, "player");
    }
    
    if (!player)
    {
        player = spawn();
        player.id = pid;
        player.classname = "player";
        selfplayer = player;
    }

    return player;
}

void (float pid, float send_event, float event_val) UpdatePlayer = {
    
    entity player = GetPlayer(pid);

    switch (send_event)
    {
        case SE_READY:
            player.ready = event_val;
            break;
        case SE_CHAMP:
            player.champ = event_val;
            break;
    }
}

void (float pid, float send_event, string event_val) UpdatePlayerS = {
    entity player = GetPlayer(pid);

    switch (send_event)
    {
        case SE_NETNAME:
            dprint("netname changed to: ", event_val, "\n");
            player.netname = event_val;
            break;
    }
}