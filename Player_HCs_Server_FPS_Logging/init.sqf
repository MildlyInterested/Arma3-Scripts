[] execVM "scripts\FPS_monitor.sqf";

if (!isDedicated && !hasInterface && isMultiplayer) then {//everything in here gets executed on all headless clients 
    sleep 30;
    15 call FPSMON_fnc_monitor;
};
