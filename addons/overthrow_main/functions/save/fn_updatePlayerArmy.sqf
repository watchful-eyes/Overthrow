// Modified/added for the unofficial Garrison and Command Expansion, 14-16 November 2026.
// Original author/copyright notices are retained; see LICENSE.md (GNU GPL v2).
// Called unscheduled on the server: merge into the latest lists, never a client snapshot.
if (!isServer) exitWith {};
params [
    ["_player", objNull, [objNull]],
    ["_recruits", [], [[]]],
    ["_squads", [], [[]]],
    ["_replace", true, [true]]
];
if (isNull _player || { !isPlayer _player }) exitWith {};
if (isRemoteExecuted && { remoteExecutedOwner != 2 } && { remoteExecutedOwner != owner _player }) exitWith {};

private _uid = getPlayerUID _player;
if (_uid isEqualTo "") exitWith {};
if ((_recruits + _squads) findIf {
    !(_x isEqualType []) || { count _x < 4 } || { (_x # 0) isNotEqualTo _uid }
} != -1) exitWith {};

private _allRecruits = server getVariable ["recruits", []];
private _allSquads = server getVariable ["squads", []];
server setVariable ["recruits", [_allRecruits, _uid, _recruits, _replace] call OT_fnc_mergePlayerArmy, true];
server setVariable ["squads", [_allSquads, _uid, _squads, _replace] call OT_fnc_mergePlayerArmy, true];
_player setVariable ["OT_armyLoaded", true, true];
