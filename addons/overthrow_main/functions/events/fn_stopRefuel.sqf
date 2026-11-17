// Modified/added for the unofficial Garrison and Command Expansion, 14-16 November 2026.
// Original author/copyright notices are retained; see LICENSE.md (GNU GPL v2).
// Only the server may reject a paid refuel tick.
if (isRemoteExecuted && { remoteExecutedOwner != 2 }) exitWith { false };
params ["_nozzle", "_sink", "_level", "_cargo", "_token"];
if (isNull _nozzle || { isNull _sink }) exitWith { false };
private _context = _nozzle getVariable ["OT_refuelContext", []];
if (count _context != 5 || { (_context # 4) isNotEqualTo _token } || { (_context # 2) != _sink }) exitWith { false };
_nozzle setVariable ["ace_refuel_isRefueling", false, true];
_nozzle setVariable ["ace_refuel_lastTickMissionTime", nil];
_nozzle setVariable ["ace_refuel_tempFuel", if (_cargo) then { fuel _sink } else { _level }];
if (_cargo) then {
    [_sink, _level] call ace_refuel_fnc_setFuel;
} else {
    ["ace_common_setFuel", [_sink, _level], _sink] call CBA_fnc_targetEvent;
};
true;
