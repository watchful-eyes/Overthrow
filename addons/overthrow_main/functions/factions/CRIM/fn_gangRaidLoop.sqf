// Modified/added for the unofficial Garrison and Command Expansion, 14-16 November 2026.
// Original author/copyright notices are retained; see LICENSE.md (GNU GPL v2).
if (!isServer) exitWith {};
{
    private _raid = _x;
    _raid params ["_gangid", "_group", "_town", "_kind", "_target", "_pos", "_start", "_phase", "_phaseStart"];
    private _gang = OT_civilians getVariable [format ["gang%1", _gangid], []];
    if (isNull _group || { side _group isNotEqualTo opfor } || { { alive _x } count units _group isEqualTo 0 } || { count _gang != 9 } || { (units _group) findIf { isPlayer _x || { _x call OT_fnc_hasOwner } } != -1 }) then { [_gangid] call OT_fnc_finishGangRaid; continue };
    private _return = time - _start >= 600 || { _kind isEqualTo "NATO" && { _target in (server getVariable ["NATOabandoned", []]) } };
    if (_phase isEqualTo "OUTBOUND" && { leader _group distance2D _pos < 180 }) then { _raid set [7, "ASSAULT"]; _raid set [8, time] };
    if (_phase isEqualTo "ASSAULT" && { time - _phaseStart >= 180 }) then { _return = true };
    if (_return && { _phase isNotEqualTo "RETURN" }) then {
        while { waypoints _group isNotEqualTo [] } do { deleteWaypoint ((waypoints _group) # 0) };
        private _wp = _group addWaypoint [_gang # 4, 25];
        _wp setWaypointType "MOVE"; _wp setWaypointBehaviour "AWARE"; _wp setWaypointSpeed "NORMAL";
        _raid set [7, "RETURN"]; _raid set [8, time];
    };
    if (_phase isEqualTo "RETURN") then {
        private _near = (units _group) findIf { alive _x && { [_x] call OT_fnc_inSpawnDistance } } != -1;
        private _arrived = (units _group) findIf { alive _x && { _x distance2D (_gang # 4) > 200 } } isEqualTo -1;
        if (_arrived || { !_near && { time - _phaseStart >= 120 } }) then { [_gangid] call OT_fnc_finishGangRaid };
    };
    private _current = +(spawner getVariable ["OT_gangRaids", []]);
    private _i = _current findIf { (_x # 0) isEqualTo _gangid };
    if (_i >= 0) then { _current set [_i, _raid]; spawner setVariable ["OT_gangRaids", _current] };
} forEach (+(spawner getVariable ["OT_gangRaids", []]));
if (count (spawner getVariable ["OT_gangRaids", []]) >= 2) exitWith {};
{
    private _gangids = OT_civilians getVariable ["gangs" + _x, []];
    {
        if (count (spawner getVariable ["OT_gangRaids", []]) >= 2) exitWith {};
        private _gangid = _x;
        private _group = spawner getVariable [format ["gangspawn%1", _gangid], grpNull];
        // Reject ineligible groups before scanning every town and NATO objective.
        if (isNull _group || { !local _group } || { side _group isNotEqualTo opfor }) then { continue };
        if (time - (spawner getVariable [format ["gangRaidLast%1", _gangid], -1200]) < 1800) then { continue };
        private _units = units _group;
        if ({ alive _x && { !(_x getVariable ["ace_isunconscious", false]) } } count _units < 3) then { continue };
        if (_units findIf { isPlayer _x || { _x call OT_fnc_hasOwner } } != -1) then { continue };
        private _raids = spawner getVariable ["OT_gangRaids", []];
        if (_raids findIf { (_x # 0) isEqualTo _gangid || { (_x # 1) isEqualTo _group } } != -1) then { continue };
        if (random 1 < 0.12) then {
            private _targets = [_x] call OT_fnc_gangRaidTargets;
            if (_targets isNotEqualTo []) then { [_x, selectRandom _targets] call OT_fnc_startGangRaid };
        };
    } forEach _gangids;
    if (count (spawner getVariable ["OT_gangRaids", []]) >= 2) exitWith {};
} forEach OT_allTowns;
