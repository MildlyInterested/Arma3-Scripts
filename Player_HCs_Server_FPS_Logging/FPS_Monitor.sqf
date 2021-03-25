/*
	Title: FPS Monitoring Script
	Author: Dylan Plecki (Naught)
	https://github.com/dylanplecki/ArmaScripts/tree/master/Arma%202/FPS%20Monitor
	https://forums.bohemia.net/forums/topic/161247-fps-monitoring-script/
	& edited by Mildly_Interested
	Version: 1.0.2.1 - v1.0 RC b1
	
	Description:
		Monitors and displays FPS of the server and clients on
		a regular interval with a silent hint in this format:
			Local FPS: minFPS - avgFPS
			Server FPS: minFPS - avgFPS / count
			Headless FPS: avgMinFPS - avgAvgFPS / count
			Client FPS: avgMinFPS - avgAvgFPS / count
		This script can be loaded and executed on any machine,
		without a need to install anything on the others.
	
	Syntax:
		call FPSMON_fnc_monitor; // Turns off script
		delayInt call FPSMON_fnc_monitor; // Turns on/off script with delay
		[delayInt] call FPSMON_fnc_monitor; // Turns on/off script with delay
		
	Requirements:
		Arma 3 1.0
		Arma 2 OA 1.62
		CBA A2/OA/A3 1.0
	
	License:
		Copyright � 2013 Dylan Plecki. All rights reserved.
		Except where otherwise noted, this work is licensed under CC BY 4.0,
		available for reference at <http://creativecommons.org/licenses/by/4.0/>.


	HOW TO USE:
		1. Put this script (FPS_Monitor.sqf) in a folder called "scripts" into the root of your missions folder 
		Sould look like this:
		- [YourAwesomeMission.MAPNAME]
			- mission.sqm 
			- init.sqf
			- initserver.sqf
			- exit.sqf
			- [scripts]
				- FPS_Monitor.sqf

		2. Place down init.sqf, initserver.sqf and exit.sqf in the root of your mission folder. If they already exist copy the entries of the provided files to the bottom of your init.sqf, initserver.sqf and exit.sqf
		3. If you want to use the powershell script type in cd <path to your folder> eg. "cd C:\Users\Mildly\Downloads" and then rename the RPT you want to extract data from to "in.txt"
		4. Copy paste the line from "clean_rpt.ps1" into your powershell and run it
		5. Make sure to replace in the csv the time in the first line (the "20:23:59") with "time" and you're done. First line are the collumn names and everything below should be data for you to look at.

*/

FPSMON_fnc_monitor = {
	_this spawn {
		if (isNil "_this") then {_this = []};
		if (typeName(_this) != "ARRAY") then {_this = [_this]};
		private ["_delay","_syncTime"];
		_delay	= if ((count _this) > 0) then {_this select 0} else {0};
		_syncTime = 3; // Seconds
		if (_delay >= _syncTime) then {_delay = _delay - _syncTime};
		if (isNil "FPSMON_init") then { // checks if script has been called already
			FPSMON_init = true; //not needed
			FPSMON_clientID = nil; //var init
			FPSMON_syncData = [-1,0,0]; //var init
			[0, {
				FPSMON_clientID = owner _this; //server executed means ID==0
				FPSMON_clientID publicVariableClient "FPSMON_clientID"; //not needed, sends Player ID to client
				//FPSMON_clientID publicVariableServer "FPSMON_clientID"; //old code for client execution
			}, player] call CBA_fnc_globalExecute;
			waitUntil {!isNil "FPSMON_clientID"}; //waits until clientID has been defined
			"FPSMON_syncData" addPublicVariableEventHandler {
				private ["_value", "_machine", "_avgFPS", "_minFPS"];
				_value = _this select 1;
				_machine = _value select 0;
				_avgFPS = _value select 1;
				_minFPS = _value select 2;
				if ((_machine >= 0) && {_machine < (count FPSMON_data)}) then {
					(FPSMON_data select _machine) set [0, (((FPSMON_data select _machine) select 0) + _avgFPS)];
					(FPSMON_data select _machine) set [1, (((FPSMON_data select _machine) select 1) + _minFPS)];
					(FPSMON_data select _machine) set [2, (((FPSMON_data select _machine) select 2) + 1)];
				};
			};
		};
		if ((_delay > 0) && (isNil "FPSMON_handle")) then { //checks if FPSMON_handle has been terminated
			FPSMON_handle = [_syncTime, _delay] spawn {
				waitUntil {
					FPSMON_data = [[0,0,0],[0,0,0],[0,0,0]]; // Clear Data
					[-2, {
						if (isNil "FPSMON_MACHINE") then {
							FPSMON_MACHINE = switch (true) do { //check if server (0), HC (1) or player (2)
								case (isServer): {0}; //server check
								case (!hasInterface && !isDedicated): {1}; //HC check
								default {2};
							};
						};
						FPSMON_syncData = [FPSMON_MACHINE, diag_fps, diag_fpsmin]; // TypeID and FPS data
						//(_this select 0) publicVariableClient "FPSMON_syncData"; //old code for client execution
						publicVariableServer "FPSMON_syncData"; //changed
					}, [FPSMON_clientID]] call CBA_fnc_globalExecute;
					uisleep (_this select 0); // Sync Time
					private ["_output"];
					_output = [];
					{ // forEach
						_output = _output + [
							round((_x select 1) / ((_x select 2) max (1))),
							round((_x select 0) / ((_x select 2) max (1))),
							(_x select 2)
						];
					} forEach FPSMON_data;
					/*hintSilent format (["Local FPS: %1 - %2\nServer FPS: %3 - %4 / %5\nHeadless FPS: %6 - %7 / %8\nClient FPS: %9 - %10 / %11", //old code for client execution, GUI hint
						round(diag_fpsmin), //%1
						round(diag_fps) //%2
					] + _output); //%3-%11*/


					//following human friendly output, uncomment if wanted
					/*diag_log text format (["[Local FPS: %1 - %2] [Server FPS: %3 - %4 Servers: %5] [Headless FPS: %6 - %7 HCs: %8] [Client FPS: %9 - %10 Players: %11]", //written to log
						round(diag_fpsmin),
						round(diag_fps)
					] + _output);*/


					//following CSV friendly output, uncomment if wanted, to import into other software use the powershell script to export FPS data
					diag_log text format ([";[FPS_Mon];%1;%2;%3;%4;%5;%6;%7;%8;%9;%10;%11", //written to log
						round(diag_fpsmin),
						round(diag_fps)
					] + _output);
					uisleep (_this select 1); // Delay
					false;
				};
			};
			//hint format["FPS Monitoring Started.\n%1 Second Interval.", (_delay + _syncTime)]; //old code for client execution, GUI hint


			//following human friendly output, uncomment if wanted
			/*diag_log text ""; //empty line in log
			diag_log text format["----------[FPS MONIORING STARTED] [%1 Second Interval] [human option]---------", (_delay + _syncTime)];
			diag_log text "[Local FPS: minFPS - avgFPS] [Server FPS: minFPS - avgFPS Servers: Server count] [Headless FPS: avgMin - avg HCs: HC count] [Client FPS: avgMin - avg Players: Player count]";
			diag_log text "";*/


			//following CSV friendly output, uncomment if wanted, to import into other software use the powershell script to export FPS data from logfile
			diag_log text format["----------[FPS MONIORING STARTED] [%1 Second Interval] [CSV option]----------", (_delay + _syncTime)];
			diag_log text ";[FPS_Mon];Local_minFPS;Local_avgFPS;Server_minFPS;Server_avgFPS;Server_count;HC_avg_minFPS;HC_avg_avgFPS;HC_Count;Player_avg_minFPS;Player_avg_avgFPS;Player_Count"; //there is one line left to that! its local time but can't give it title
		} else {
			terminate FPSMON_handle;
			FPSMON_handle = nil;
			//hint "FPS Monitoring Stopped."; //old code for client execution, GUI hint


			diag_log text "";
			diag_log text "--------------------[FPS MONIORING STOPPED]--------------------";
			diag_log text "";
		};
	};
};