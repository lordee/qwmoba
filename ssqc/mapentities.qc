// creep spawn
info_creep_teamspawn

// tower
item_qwmgoal

// player/team spawn
void () info_player_teamspawn = {

    if ((self.team_no <= 0) || (self.team_no >= 3)) {
        objerror
            ("error: bad team_no associated with info_player_teamspawn\n");
        remove(self);
        return;
    }

    switch (self.team_no)
    {
        case 1:
            self.team_str = "teamspawnone"
            break;
        case 2:
            self.team_str = "teamspawntwo"
            break;
    }
    
}

// shop
info_qwmgoal