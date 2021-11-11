This will create markers located on the bottom left of the map stating Server and headless client FPS along with their respective local groups and units.

**HOW TO USE**
1. Place down headless client modules in editor
2. (Name them "HC1", "HC2" and "HC3". More headless clients are not supported by this sctipt and will not show up) ignore that, not true anymore
3. Put this script (show_fps.sqf) in a folder called "scripts" into the root of your missions folder 
	Sould look like this:
	- [YourAwesomeMission.MAPNAME]
		- mission.sqm 
		- init.sqf
		- initserver.sqf
		- [scripts]
			- show_fps.sqf

4. Copy init.sqf and initserver.sqf in the root of your mission folder (like file structure above). If they already exist copy the entries of the provided files to the TOP of your init.sqf and initserver.sqf 
