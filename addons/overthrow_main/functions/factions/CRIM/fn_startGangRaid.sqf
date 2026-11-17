// Modified/added for the unofficial Garrison and Command Expansion, 14-16 November 2026.
// Original author/copyright notices are retained; see LICENSE.md (GNU GPL v2).
// Uses the existing gang group: no added members, resources, or recruit rate.
if (!isServer) exitWith { false };
params ["_gangid", "_target"];
private _gang = OT_civilians getVariable [format ["gang%1", _gangid], []];
if (count _gang != 9) exitWith { false };
private _group = spawner getVariable [format ["gangspawn%1", _gangid], grpNull];
if (isNull _group || { !local _group } || { side _group isNotEqualTo opfor }) exitWith { false };
if ((units _group) findIf { isPlayer _x || { _x call OT_fnc_hasOwner } } != -1) exitWith { false };
if ({ alive _x && { !(_x getVariable ["ace_isunconscious", false]) } } count units _group < 3) exitWith { false };
private _raids = +(spawner getVariable ["OT_gangRaids", []]);
if (count _raids >= 2 || { _raids findIf { (_x # 0) isEqualTo _gangid || { (_x # 1) isEqualTo _group } } != -1 }) exitWith { false };
if (time - (spawner getVariable [format ["gangRaidLast%1", _gangid], -1200]) < 1800) exitWith { false };
if !(_target in ([_gangid] call OT_fnc_gangRaidTargets)) exitWith { false };
while { waypoints _group isNotEqualTo [] } do { deleteWaypoint ((waypoints _group) # 0) };
private _wp = _group addWaypoint [_target # 2, 40];
_wp setWaypointType "MOVE";
_wp setWaypointSpeed "NORMAL";
_wp setWaypointBehaviour "AWARE";
_wp = _group addWaypoint [_target # 2, 120];
_wp setWaypointType "SAD";
_group setCombatMode "RED";
_group setVariable ["OT_gangRaiding", true];
_group setVariable ["lambs_danger_disableGroupAI", true];
_raids pushBack [_gangid, _group, _gang # 2, _target # 0, _target # 1, _target # 2, time, "OUTBOUND", time];
spawner setVariable ["OT_gangRaids", _raids];
spawner setVariable [format ["gangRaidLast%1", _gangid], time];
format ["%1 is raiding %2.", _gang # 8, _target # 1] remoteExecCall ["OT_fnc_notifyMinor", 0];
true;
