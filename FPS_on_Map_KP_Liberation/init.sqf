if (!isDedicated && !hasInterface && isMultiplayer) then { //anything in here gets executed on the headless clients
    [] execVM "scripts\show_fps.sqf";
    diag_log text "--------------------[Executed show_fps on HC]--------------------"; //this will only show in  the HCs logs
};

