// Modified/added for the unofficial Garrison and Command Expansion, 14-16 November 2026.
// Original author/copyright notices are retained; see LICENSE.md (GNU GPL v2).
params ["_group", "_entry", "_center"];
if (isNull _group) exitWith {};
if (!isServer && { isRemoteExecuted } && { remoteExecutedOwner != 2 }) exitWith {};
if (!local _group) exitWith {
    [_group, _entry, _center] remoteExecCall ["OT_fnc_applyTownGarrisonRoute", groupOwner _group];
};
_entry params ["", "", "", "_route", "_speed", "_mode"];
for "_i" from (count waypoints _group - 1) to 0 step -1 do { deleteWaypoint [_group, _i] };
_group setVariable ["VCM_Disable", true, true];
_group setVariable ["lambs_danger_disableGroupAI", true, true];
_group setBehaviour "SAFE";
_group setSpeedMode _speed;
_group setCombatMode "YELLOW";
if (_mode isEqualTo "AUTO") exitWith {
    [_group, _center, 100, 6] call CBA_fnc_taskPatrol;
    { _x setWaypointSpeed _speed } forEach waypoints _group;
};
if (_mode isEqualTo "HOLD") exitWith {
    private _position = _route param [0, _center];
    private _waypoint = _group addWaypoint [_position, 0];
    _waypoint setWaypointType "HOLD";
    _waypoint setWaypointSpeed _speed;
    _group setCurrentWaypoint _waypoint;
};
if (count _route < 2) exitWith {};
private _first = [];
{
    private _waypoint = _group addWaypoint [_x, 0];
    if (_first isEqualTo []) then { _first = _waypoint };
    _waypoint setWaypointType "MOVE";
    _waypoint setWaypointBehaviour "SAFE";
    _waypoint setWaypointSpeed _speed;
    _waypoint setWaypointCompletionRadius 8;
    _waypoint setWaypointTimeout [3, 5, 8];
} forEach _route;
private _cycle = _group addWaypoint [_route # 0, 0];
_cycle setWaypointType "CYCLE";
_group setCurrentWaypoint _first;
