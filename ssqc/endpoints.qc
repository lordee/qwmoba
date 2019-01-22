void (float team) Cmd_JoinTeam_f = {
    self.team_no = team;
    self.menu = MNU_LOBBYCHAMP;
}

void (float menu) Cmd_AckMenu_f = {
    self.menu_active = menu;
}

void (float c) Cmd_ChooseChamp_f = {
    self.champ = c;
    self.menu = MNU_INACTIVE;
}