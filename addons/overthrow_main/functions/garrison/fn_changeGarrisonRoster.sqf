// Modified/added for the unofficial Garrison and Command Expansion, 14-16 November 2026.
// Original author/copyright notices are retained; see LICENSE.md (GNU GPL v2).
// Private server record is authoritative; public police strength is a UI view.
if (!isServer) exitWith { 0 };
params [["_town", "", [""]], ["_preset", "Police", [""]], ["_delta", 0, [0]], ["_reset", false, [true]]];
private _roster = if (_reset) then { [] } else { [_town] call OT_fnc_townGarrisonRoster };
if (!_reset && { _delta isNotEqualTo 0 }) then {
    if (_preset isEqualTo "" && { _delta < 0 }) then {
        private _total = 0;
        { _total = _total + (_x # 1) } forEach _roster;
        private _roll = random _total;
        { _roll = _roll - (_x # 1); if (_roll < 0) exitWith { _preset = _x # 0 } } forEach _roster;
    };
    private _index = _roster findIf { (_x # 0) isEqualTo _preset };
    if (_index < 0 && { _delta > 0 }) then { _index = _roster pushBack [_preset, 0] };
    if (_index >= 0) then { (_roster # _index) set [1, (((_roster # _index) # 1) + _delta) max 0] };
};
_roster = _roster select { (_x # 1) > 0 };
private _total = 0;
{ _total = _total + (_x # 1) } forEach _roster;
// An explicit zero record prevents a same-frame stale public count reviving NPCs.
server setVariable ["garrisonRoster" + _town, if (_roster isEqualTo []) then { [["Police", 0]] } else { _roster }];
server setVariable ["police" + _town, _total, true];
_total;
