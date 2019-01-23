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