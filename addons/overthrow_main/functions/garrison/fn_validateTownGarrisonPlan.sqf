// Modified/added for the unofficial Garrison and Command Expansion, 14-16 November 2026.
// Original author/copyright notices are retained; see LICENSE.md (GNU GPL v2).
// No game-state changes: validate and normalize untrusted route data before saving.
params ["_plan", "_center", ["_radius", 2000], ["_worldSize", 50000]];
if !(_plan isEqualType []) exitWith { [false, "Invalid company list.", []] };
if (count _plan > 32) exitWith { [false, "A town can have at most 32 companies.", []] };
private _ids = [];
private _clean = [];
private _error = "";
{
    if !(_x isEqualType [] && { count _x isEqualTo 6 }) exitWith { _error = "Invalid company data." };
    _x params ["_id", "_name", "_size", "_route", "_speed", "_mode"];
    if !(_id isEqualType "" && { count _id > 0 } && { count _id <= 48 } && { !(_id in _ids) }) exitWith { _error = "Company IDs must be unique." };
    if !(_name isEqualType "" && { count _name > 0 } && { count _name <= 40 }) exitWith { _error = "Company names must contain 1-40 characters." };
    if !(_size isEqualType 0 && { finite _size } && { _size isEqualTo floor _size } && { _size >= 1 } && { _size <= 64 }) exitWith { _error = "Company strength must be an integer from 1 to 64." };
    if !(_speed in ["LIMITED", "NORMAL", "FULL"] && { _mode in ["AUTO", "PATROL", "HOLD"] }) exitWith { _error = "Invalid patrol behavior." };
    if !(_route isEqualType [] && { count _route <= 32 }) exitWith { _error = "Bir rotada en fazla 32 nokta olabilir." };
    if (_mode isEqualTo "PATROL" && { count _route < 2 }) exitWith { _error = "Add at least two points for a custom patrol route." };
    private _points = [];
    {
        if !(_x isEqualType [] && { count _x in [2, 3] }) exitWith { _error = "Invalid route point." };
        _x params ["_px", "_py"];
        if !(_px isEqualType 0 && { _py isEqualType 0 } && { finite _px } && { finite _py }) exitWith { _error = "Invalid route coordinates." };
        if (_px < 0 || { _py < 0 } || { _px > _worldSize } || { _py > _worldSize }) exitWith { _error = "The route is outside the map boundaries." };
        if (([_px, _py] distanceSqr [_center # 0, _center # 1]) > _radius ^ 2) exitWith { _error = "The route must stay within 2 km of the town center." };
        _points pushBack [_px, _py, 0];
    } forEach _route;
    if (_error isNotEqualTo "") exitWith {};
    _ids pushBack _id;
    _clean pushBack [_id, _name, _size, _points, _speed, _mode];
} forEach _plan;
[_error isEqualTo "", _error, _clean];
