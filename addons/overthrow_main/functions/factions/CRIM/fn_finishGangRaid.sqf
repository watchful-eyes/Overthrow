// Modified/added for the unofficial Garrison and Command Expansion, 14-16 November 2026.
// Original author/copyright notices are retained; see LICENSE.md (GNU GPL v2).
if (!isServer) exitWith { false };
params ["_gangid"];
private _raids = +(spawner getVariable ["OT_gangRaids", []]);
private _i = _raids findIf { (_x # 0) isEqualTo _gangid };
if (_i < 0) exitWith { false };
private _raid = _raids deleteAt _i;
spawner setVariable ["OT_gangRaids", _raids];
_raid params ["", "_group", "_town"];
if (isNull _group) exitWith { true };
_group setVariable ["OT_gangRaiding", false];
// A player-recruited gang must keep its new owner's orders and units.
if (side _group isNotEqualTo opfor || { (units _group) findIf { isPlayer _x || { _x call OT_fnc_hasOwner } } != -1 }) exitWith { true };
private _pos = server getVariable [_town, []];
private _near = (units _group) findIf { alive _x && { [_x] call OT_fnc_inSpawnDistance } } != -1;
if (!_near) then {
    { [_x] call OT_fnc_cleanupUnit } forEach units _group;
    private _key = format ["gangspawn%1", _gangid];
    if ((spawner getVariable [_key, grpNull]) isEqualTo _group) then { spawner setVariable [_key, grpNull, true] };
    if (count _pos isEqualTo 3 && { [_pos] call OT_fnc_inSpawnDistance }) then { [_gangid] call OT_fnc_ensureGangGroup };
} else {
    while { waypoints _group isNotEqualTo [] } do { deleteWaypoint ((waypoints _group) # 0) };
    if (count _pos isEqualTo 3) then { [_group, _pos] call OT_fnc_initCriminalGroup };
    private _spawnid = spawner getVariable ["townspawnid" + _town, ""];
    if (_spawnid isEqualType "" && { _spawnid isNotEqualTo "" }) then {
        private _objects = +(spawner getVariable [_spawnid, []]); _objects pushBackUnique _group; spawner setVariable [_spawnid, _objects];
    };
};
true;
