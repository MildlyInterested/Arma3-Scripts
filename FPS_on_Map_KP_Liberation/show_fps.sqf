/*
All credit goes to KP_Liberation and Wyqer for creating this script

	MIT License
	Copyright (c) 2015 GreuhZbug, Wyqer
	Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
	The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

HOW TO USE:
1. Place down headless client modules in editor
2. Name them "HC1", "HC2" and "HC3". More headless clients are not supported by this sctipt and will not show up
3. Put this script (show_fps.sqf) in a folder called "scripts" into the root of your missions folder 
	Sould look like this:
		- [YourAwesomeMission.MAPNAME]
			- mission.sqm 
			- init.sqf
			- initserver.sqf
			- [scripts]
				- show_fps.sqf

4. Place down init.sqf and initserver.sqf in the root of your mission folder. If they already exist copy the entries of the provided files to the bottom of your init.sqf and initserver.sqf 
*/

private _sourcestr = "Server";
private _position = 0;

if (!isServer) then {
    if (!isNil "HC1") then {
        if (!isNull HC1) then {
            if (local HC1) then {
                _sourcestr = "HC1";
                _position = 1;
            };
        };
    };

    if (!isNil "HC2") then {
        if (!isNull HC2) then {
            if (local HC2) then {
                _sourcestr = "HC2";
                _position = 2;
            };
        };
    };

    if (!isNil "HC3") then {
        if (!isNull HC3) then {
            if (local HC3) then {
                _sourcestr = "HC3";
                _position = 3;
            };
        };
    };
};

private _myfpsmarker = createMarker [format ["fpsmarker%1", _sourcestr], [0, -500 - (500 * _position)]];
_myfpsmarker setMarkerType "mil_start";
_myfpsmarker setMarkerSize [0.7, 0.7];

while {true} do {

    private _myfps = diag_fps;
    private _localgroups = {local _x} count allGroups;
    private _localunits = {local _x} count allUnits;

    _myfpsmarker setMarkerColor "ColorGREEN";
    if (_myfps < 30) then {_myfpsmarker setMarkerColor "ColorYELLOW";};
    if (_myfps < 20) then {_myfpsmarker setMarkerColor "ColorORANGE";};
    if (_myfps < 10) then {_myfpsmarker setMarkerColor GRLIB_color_enemy_bright;};

    _myfpsmarker setMarkerText format ["%1: %2 fps, %3 local groups, %4 local units", _sourcestr, (round (_myfps * 100.0)) / 100.0, _localgroups, _localunits];

    sleep 15; //updates FPS and markers every 15 secounds
};
