// Modified/added for the unofficial Garrison and Command Expansion, 14-16 November 2026.
// Original author/copyright notices are retained; see LICENSE.md (GNU GPL v2).
if (isRemoteExecuted && { remoteExecutedOwner != 2 }) exitWith {};
params [["_flag", objNull, [objNull]], ["_name", "", [""]]];
if (isNull _flag) exitWith {};
_flag addAction [format ["Capture %1", _name], { call OT_fnc_triggerBattle }, nil, 0, false, true, "", "true", 5];
