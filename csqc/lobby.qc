void () LobbyJoinTeam = {
    sendevent("JoinTeam", "f", self.team_no);
}

void (vector vid_size) ShowLobbyMenu = {
    vector men;                  // position of the first menu button
    vector but_size;               // size of all the buttons
    string buttonback;            // Button image
    entity btn;
    float btnID;
    btnID = 1;

    but_size = '160 35 0';
    men_x = (vid_size_x*0.5) - (but_size_x*0.5);      // first button will be displayed in the dead center of the horizontal area
    men_y = vid_size_y*0.2;                     // first button will be displayed 20% of the vertical value from the top of the screen

    btn = CreateButton( "Join Team One", LobbyJoinTeam, men, BTN_BG, but_size, BTNFLAGS_ACTIVE, btnID); men_y+=but_size_y; btnID++;
    btn.team_no = 1;
    btn = CreateButton( "Join Team Two", LobbyJoinTeam, men, BTN_BG, but_size, BTNFLAGS_ACTIVE, btnID); men_y+=but_size_y; btnID++;
    btn.team_no = 2;
}

void () ChooseChamp = {
    sendevent("ChooseChamp", "f", self.champ_id);
}

void (vector vid_size) ShowLobbyChampMenu = {
    vector men;                  // position of the first menu button
    vector but_size;               // size of all the buttons
    string buttonback;            // Button image
    entity btn;
    float btnID;
    btnID = 1;

    but_size = '160 35 0';
    men_x = (vid_size_x*0.5) - (but_size_x*0.5);      // first button will be displayed in the dead center of the horizontal area
    men_y = vid_size_y*0.2;                     // first button will be displayed 20% of the vertical value from the top of the screen
    buttonback = "progs/csqc/csqcguiback.tga";

    btn = CreateButton( "Frost Archer", ChooseChamp, men, buttonback, but_size, BTNFLAGS_ACTIVE, btnID); men_y+=but_size_y; btnID++;
    btn.champ_id = CHAMP_FROSTARCHER;
    btn = CreateButton( "Tristana", ChooseChamp, men, buttonback, but_size, BTNFLAGS_INACTIVE, btnID); men_y+=but_size_y; btnID++;
    btn.champ_id = CHAMP_TRISTANA;
    btn = CreateButton( "Shambler", ChooseChamp, men, buttonback, but_size, BTNFLAGS_ACTIVE, btnID); men_y+=but_size_y; btnID++;
    btn.champ_id = CHAMP_SHAMBLER;
    btn = CreateButton( "Taric", ChooseChamp, men, buttonback, but_size, BTNFLAGS_INACTIVE, btnID); men_y+=but_size_y; btnID++;
    btn.champ_id = CHAMP_TARIC;
    btn = CreateButton( "Master Yi", ChooseChamp, men, buttonback, but_size, BTNFLAGS_INACTIVE, btnID); men_y+=but_size_y; btnID++;
    btn.champ_id = CHAMP_MASTERYI;
    btn = CreateButton( "Warwick", ChooseChamp, men, buttonback, but_size, BTNFLAGS_INACTIVE, btnID); men_y+=but_size_y; btnID++;
    btn.champ_id = CHAMP_WARWICK;

    btn = CreateButton( "Garen", ChooseChamp, men, buttonback, but_size, BTNFLAGS_INACTIVE, btnID); men_y+=but_size_y; btnID++;
    btn.champ_id = CHAMP_GAREN;
    btn = CreateButton( "Kayle", ChooseChamp, men, buttonback, but_size, BTNFLAGS_INACTIVE, btnID); men_y+=but_size_y; btnID++;
    btn.champ_id = CHAMP_KAYLE;

    btn = CreateButton( "Ahri", ChooseChamp, men, buttonback, but_size, BTNFLAGS_INACTIVE, btnID); men_y+=but_size_y; btnID++;
    btn.champ_id = CHAMP_AHRI;
    btn = CreateButton( "Veigar", ChooseChamp, men, buttonback, but_size, BTNFLAGS_INACTIVE, btnID); men_y+=but_size_y; btnID++;
    btn.champ_id = CHAMP_VEIGAR;
}