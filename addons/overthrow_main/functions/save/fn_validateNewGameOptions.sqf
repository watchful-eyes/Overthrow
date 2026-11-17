// Modified/added for the unofficial Garrison and Command Expansion, 14-16 November 2026.
// Original author/copyright notices are retained; see LICENSE.md (GNU GPL v2).
// Validate before starting economy generation or publishing campaign settings.
params ["_town", "_settings", ["_force", ""]];
if (OT_spawnTowns isEqualTo []) exitWith { [false, "No starting towns are configured for this map."] };
if (!(_town isEqualType "") || { _town isNotEqualTo "" && { !(_town in OT_spawnTowns) } }) exitWith { [false, "Select a valid starting town."] };
if (!(_settings isEqualType []) || { count _settings != 3 }) exitWith { [false, "Invalid campaign settings."] };
if (_settings findIf { isNil "_x" || { !(_x isEqualType 0) } || { !finite _x } || { !(_x in [0, 1, 2]) } } != -1) exitWith { [false, "Campaign options must use the allowed values."] };
if !(_force isEqualType "" && { _force isEqualTo "" || { _force in (([] call OT_fnc_campaignForces) apply { _x # 0 }) } }) exitWith { [false, "Select an installed, supported occupying force."] };
[true, ""];
