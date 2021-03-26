if(isServer) then {//everything in here gets executed on the server after mission end
	diag_log text "--------------------[MISSION STOPPED]--------------------";
	call FPSMON_fnc_monitor;
};
