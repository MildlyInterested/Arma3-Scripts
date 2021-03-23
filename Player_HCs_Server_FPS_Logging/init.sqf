[] execVM "scripts\FPS_monitor.sqf";

if (!isDedicated && !hasInterface && isMultiplayer) then {//everything in here gets executed on HC1
    if !(missionNamespace getVariable ["HCrun", false]) then {
        sleep 30;
        15 call FPSMON_fnc_monitor;        
        missionNamespace setVariable ["HCrun", true, true]
    }

};


/*
if !(missionNamespace getVariable ["someVar", false]) then {
  missionNamespace setVariable ["someVar", true, true]
}
*/