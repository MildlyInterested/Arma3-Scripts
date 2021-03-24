/*
	Title: FPS Monitoring Script
	Author: Dylan Plecki (Naught) & edited by Mildly_Interested
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
*/

FPSMON_fnc_monitor = {
	_this spawn {
		if (isNil "_this") then {_this = []};
		if (typeName(_this) != "ARRAY") then {_this = [_this]};
		private ["_delay","_syncTime"];
		_delay	= if ((count _this) > 0) then {_this select 0} else {0};
		_syncTime = 3; // Seconds
		if (_delay >= _syncTime) then {_delay = _delay - _syncTime};
		if (isNil "FPSMON_init") then { //this should always run? gets defined in next line, I think protects script from being called twice
			FPSMON_init = true;
			FPSMON_clientID = nil; //var init?
			FPSMON_syncData = [-1,0,0]; //var init?
			[0, {
				FPSMON_clientID = owner _this; //will retun 0 on server, if server == owner something different? MIGHT BE THIS, CHECK DOCUMENTATION for publicVariableClient, maybe has to be changed to publicVariableServer
				FPSMON_clientID publicVariableClient "FPSMON_clientID"; //sends to client, but server executed, possible cause, see line 75
				//FPSMON_clientID publicVariableServer "FPSMON_clientID"; //changed
			}, player] call CBA_fnc_globalExecute; //maybe add rpt log after that to see if this gets executed
			waitUntil {!isNil "FPSMON_clientID"}; //gets executed FPSMON_clientID==0
			"FPSMON_syncData" addPublicVariableEventHandler {
				private ["_value", "_machine", "_avgFPS", "_minFPS"];
				_value = _this select 1;
				_machine = _value select 0;
				_avgFPS = _value select 1;
				_minFPS = _value select 2;
				if ((_machine >= 0) && {_machine < (count FPSMON_data)}) then {
					(FPSMON_data select _machine) set [0, (((FPSMON_data select _machine) select 0) + _avgFPS)]; //pretty sure this stuff counts servers, headless clients and players
					(FPSMON_data select _machine) set [1, (((FPSMON_data select _machine) select 1) + _minFPS)];
					(FPSMON_data select _machine) set [2, (((FPSMON_data select _machine) select 2) + 1)];
				};
			};
		};
		if ((_delay > 0) && (isNil "FPSMON_handle")) then { //this in here should be the stuff that gets executed periodically
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
						FPSMON_syncData = [FPSMON_MACHINE, diag_fps, diag_fpsmin];
						//(_this select 0) publicVariableClient "FPSMON_syncData"; //THIS right here might be it, it sends it to the client computer, needs to be sent to SERVER
						/*(_this select 0)*/ publicVariableServer "FPSMON_syncData"; //changed
					}, [FPSMON_clientID]] call CBA_fnc_globalExecute; //should work just fine, simply calls {} part on everyone with parameter FPSMON_clientID, does that mean line above sends it to FPSMON_clientID defined in line 45 aka to whoever called the script?
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
					hintSilent format (["Local FPS: %1 - %2\nServer FPS: %3 - %4 / %5\nHeadless FPS: %6 - %7 / %8\nClient FPS: %9 - %10 / %11", //GUI hint
						round(diag_fpsmin), //%1
						round(diag_fps) //%2
					] + _output); //%3-%11
					diag_log text format (["[Local FPS: %1 - %2] [Server FPS: %3 - %4 Servers: %5] [Headless FPS: %6 - %7 HCs: %8] [Client FPS: %9 - %10 Players: %11]", //written to log
						round(diag_fpsmin),
						round(diag_fps)
					] + _output);
					uisleep (_this select 1); // Delay
					false;
				};
			};
			hint format["FPS Monitoring Started.\n%1 Second Interval.", (_delay + _syncTime)]; //shows hint in top right GUI first time script is called
			diag_log text ""; //empty line in log
			diag_log text format["----------[FPS MONIORING STARTED] [%1 Second Interval]----------", (_delay + _syncTime)]; //show hint in log file first time script is called, same as diag_log text below
			diag_log text "SYNTAX:";
			diag_log text "[Local FPS: minFPS - avgFPS] [Server FPS: minFPS - avgFPS Servers: Server count] [Headless FPS: avgMin - avg HCs: HC count] [Client FPS: avgMin - avg Players: Player count]";
			diag_log text "";
		} else {
			terminate FPSMON_handle;
			FPSMON_handle = nil;
			hint "FPS Monitoring Stopped."; //shows hint in top right GUI second time script is called (second script call terminates the script)
			diag_log text ""; //shows hint in log file second time script is called (second script called terminates the script)
			diag_log text "--------------------[FPS MONIORING STOPPED]--------------------";
			diag_log text "";
		};
	};
};