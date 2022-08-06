//stops AI from doing pretty much anything but moving until they are being suppressed, AI in vehicles wont be supressed to they will get out if vehicle is damaged and then get suppressed
//execute the following on group in zeus (execute on target), do not include this comment
{
    _x setVariable ["lambs_danger_disableAI", true]; 
    _x setVariable ["lambs_danger_forceMove", true]; 
    _x disableAI "TARGET"; 
    _x disableAI "FSM"; 
    _x disableAI "COVER"; 
    _x disableAI "SUPPRESSION"; 
    _x setUnitPos "AUTO";
	_x addEventhandler ["Suppressed", {
		params ["_unit"];
		_unit setVariable ["lambs_danger_disableAI", nil];
		_unit setVariable ["lambs_danger_forceMove", nil];
		_unit enableAI "TARGET"; 
		_unit enableAI "FSM";
		_unit enableAI "COVER";
		_unit enableAI "SUPPRESSION";
		_unit setUnitPos "AUTO";
		_unit removeEventHandler ["Suppressed", _thisEventHandler]; }];
} foreach units _this;
_this allowFleeing 0;