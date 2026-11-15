// Modified/added for the unofficial Garrison and Command Expansion, 14-16 November 2026.
// Original author/copyright notices are retained; see LICENSE.md (GNU GPL v2).
params ["_unit", "_id", "_uid", "_name"];

[_unit, _uid] call OT_fnc_savePlayerData;

private _highCommandModule = missionNamespace getVariable [format ["%1_hc_module", _uid], objNull];

deleteVehicle _highCommandModule;
missionNamespace setVariable [format ["%1_hc_module", _uid], objNull, true];
false;
