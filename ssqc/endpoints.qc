void (float team) Cmd_JoinTeam_f = {
    self.team_no = team;
}

void (float menu) Cmd_AckMenu_f = {
    self.menu_active = menu;
}