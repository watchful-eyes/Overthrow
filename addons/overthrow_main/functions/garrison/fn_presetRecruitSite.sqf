// Modified/added for the unofficial Garrison and Command Expansion, 14-16 November 2026.
// Original author/copyright notices are retained; see LICENSE.md (GNU GPL v2).
// Resolve only server-known friendly sites; no client-provided position or code.
params [["_actor", objNull, [objNull]], ["_kind", "BASE", [""]], ["_town", "", [""]]];
if (isNull _actor || { !alive _actor }) exitWith { [] };
if (_kind isEqualTo "TOWN") exitWith {
    private _pos = server getVariable ["policepos" + _town, []];
    if !(_town in (missionNamespace getVariable ["OT_allTowns", []]) && { _town in (server getVariable ["NATOabandoned", []]) } && { count _pos isEqualTo 3 } && { _actor distance2D _pos <= 100 }) exitWith { [] };
    [_town, _pos];
};
if (_kind isNotEqualTo "BASE") exitWith { [] };
private _sites = (server getVariable ["bases", []]) apply { [format ["fob%1", _x # 0], _x # 0] };
{
    if ((_x # 1) in (server getVariable ["NATOabandoned", []])) then { _sites pushBack [_x # 1, _x # 0] };
} forEach ((server getVariable ["NATOobjectives", []]) + (server getVariable ["NATOcomms", []]));
private _index = -1;
private _distance = 250;
{ private _d = _actor distance2D (_x # 1); if (_d <= _distance) then { _distance = _d; _index = _forEachIndex } } forEach _sites;
if (_index < 0) exitWith { [] };
_sites # _index;
