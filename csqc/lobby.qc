void () LobbyJoinTeam = {
    sendevent("JoinTeam", "f", self.team_no);
}

void () ShowLobbyMenu = {
    vector men;                  // position of the first menu button
    vector but_size;               // size of all the buttons
    string buttonback;            // Button image
    entity btn;
    float btnID;
    btnID = 1;

    but_size = '160 35 0';
    men_x = (vid_realwidth*0.5) - (but_size_x*0.5);      // first button will be displayed in the dead center of the horizontal area
    men_y = vid_realheight*0.2;                     // first button will be displayed 20% of the vertical value from the top of the screen
    buttonback = "progs/csqc/csqcguiback.tga";

    btn = CreateButton( "Join Team One", LobbyJoinTeam, men, buttonback, but_size, 0, btnID); men_y+=but_size_y; btnID++;
    btn.team_no = 1;
    btn = CreateButton( "Join Team Two", LobbyJoinTeam, men, buttonback, but_size, 0, btnID); men_y+=but_size_y; btnID++;
    btn.team_no = 2;
}

void () ChooseChamp = {
    sendevent("ChooseChamp", "f", self.champ);
}

void () ShowLobbyChampMenu = {
    vector men;                  // position of the first menu button
    vector but_size;               // size of all the buttons
    string buttonback;            // Button image
    entity btn;
    float btnID;
    btnID = 1;

    but_size = '160 35 0';
    men_x = (vid_realwidth*0.5) - (but_size_x*0.5);      // first button will be displayed in the dead center of the horizontal area
    men_y = vid_realheight*0.2;                     // first button will be displayed 20% of the vertical value from the top of the screen
    buttonback = "progs/csqc/csqcguiback.tga";

    btn = CreateButton( "Frost Archer", ChooseChamp, men, buttonback, but_size, 0, btnID); men_y+=but_size_y; btnID++;
    btn.champ = CHAMP_FROSTARCHER;
    btn = CreateButton( "Caitlyn", ChooseChamp, men, buttonback, but_size, 0, btnID); men_y+=but_size_y; btnID++;
    btn.champ = CHAMP_CAITLYN;
    btn = CreateButton( "Alistar", ChooseChamp, men, buttonback, but_size, 0, btnID); men_y+=but_size_y; btnID++;
    btn.champ = CHAMP_ALISTAR;
    btn = CreateButton( "Taric", ChooseChamp, men, buttonback, but_size, 0, btnID); men_y+=but_size_y; btnID++;
    btn.champ = CHAMP_TARIC;
    btn = CreateButton( "Master Yi", ChooseChamp, men, buttonback, but_size, 0, btnID); men_y+=but_size_y; btnID++;
    btn.champ = CHAMP_MASTERYI;
    btn = CreateButton( "Warwick", ChooseChamp, men, buttonback, but_size, 0, btnID); men_y+=but_size_y; btnID++;
    btn.champ = CHAMP_WARWICK;

    btn = CreateButton( "Garen", ChooseChamp, men, buttonback, but_size, 0, btnID); men_y+=but_size_y; btnID++;
    btn.champ = CHAMP_GAREN;
    btn = CreateButton( "Kayle", ChooseChamp, men, buttonback, but_size, 0, btnID); men_y+=but_size_y; btnID++;
    btn.champ = CHAMP_KAYLE;

    btn = CreateButton( "Ahri", ChooseChamp, men, buttonback, but_size, 0, btnID); men_y+=but_size_y; btnID++;
    btn.champ = CHAMP_AHRI;
    btn = CreateButton( "Veigar", ChooseChamp, men, buttonback, but_size, 0, btnID); men_y+=but_size_y; btnID++;
    btn.champ = CHAMP_VEIGAR;
}