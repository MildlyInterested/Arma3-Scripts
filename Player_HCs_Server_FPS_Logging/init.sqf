[] execVM "scripts\FPS_monitor.sqf";

if (!isDedicated && !hasInterface && isMultiplayer) then {//everything in here gets executed on all headless clients
    if !(missionNamespace getVariable ["HCrun", false]) then { //if executed already this will return sth, stopping execution of the following part --> only gets executed once
        missionNamespace setVariable ["HCrun", true, true];
        sleep 30;
        15 call FPSMON_fnc_monitor;
    }

};


/*
if !(missionNamespace getVariable ["someVar", false]) then {
  missionNamespace setVariable ["someVar", true, true]
}
*/