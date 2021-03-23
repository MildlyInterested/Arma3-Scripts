[] execVM "scripts\FPS_monitor.sqf";

if (!isDedicated && !hasInterface && isMultiplayer) then {//everything in here gets executed on HC1
    sleep 30;
    15 call FPSMON_fnc_monitor;
};
