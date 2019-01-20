void() CSQC_Parse_Event = {
    float first = readbyte(); 
    switch (first)
    {
        case MNU_LOBBY:
            // open menu
            ShowMenu(MNU_LOBBY);
        break;
        default:
    }
}