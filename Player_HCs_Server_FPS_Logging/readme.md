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

2. Place down init.sqf, initserver.sqf and exit.sqf in the root of your mission folder. If they already exist copy the entries of the provided files to the bottom of your init.sqf, initserver.sqf and exit.sqf. 

Below only applies to CSV option
1. 	If you want to use the powershell script type in cd **path to your RPT folder** eg. "cd C:\Users\Mildly\Downloads" and then rename the RPT you want to extract data from to "in.txt"
2. 	Copy paste the line from "clean_rpt.ps1" into your powershell and run it
3. 	Make sure to replace in the csv the time in the first line (the "20:23:59") with "time" and you're done. 
	First line are the collumn names and everything below should be data for you to look at.