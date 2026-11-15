// Modified/added for the unofficial Garrison and Command Expansion, 14-16 November 2026.
// Original author/copyright notices are retained; see LICENSE.md (GNU GPL v2).
// This function should only be called on the server
if (!isServer) exitWith {};

params ["_town", "_soldier", "_amount"];

private _posTown = server getVariable [format ["policepos%1", _town], server getVariable _town];

private _group = createGroup independent;
if (isNull _group) exitWith { [] };
private _created = [];
_group setVariable ["VCM_TOUGHSQUAD", true, true];
_group setVariable ["VCM_NORESCUE", true, true];

for "_i" from 1 to _amount do {
    private _pos = [[[_posTown, 35]]] call BIS_fnc_randomPos;

    private _unit = [_soldier, _pos, _group, false] call OT_fnc_createSoldier;
    if (isNull _unit) then { continue };
    _created pushBack _unit;
    _unit setVariable ["OT_garrisonPreset", _soldier # 1, true];
    [_unit] joinSilent _group;
    _unit setRank "SERGEANT";
    [_unit, _town] call OT_fnc_initPolice;
    _unit setBehaviour "SAFE";
};

_group call OT_fnc_initPolicePatrol;

private _spawnid = spawner getVariable [format ["townspawnid%1", _town], ""];
private _groups = spawner getVariable [_spawnid, []];
_groups pushBack _group;
spawner setVariable [_spawnid, _groups, false];
[_town] call OT_fnc_assignTownGarrison;
_created;
