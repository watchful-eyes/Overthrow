// Modified/added for the unofficial Garrison and Command Expansion, 14-16 November 2026.
// Original author/copyright notices are retained; see LICENSE.md (GNU GPL v2).
params ["_gangid"];
private _gang = OT_civilians getVariable [format ["gang%1", _gangid], []];
if (count _gang != 9) exitWith { [] };
private _home = _gang # 4;
private _targets = [];
{
    if (_x isEqualTo (_gang # 2)) then { continue };
    private _pos = server getVariable [_x, []];
    if (count _pos != 3) then { continue };
    if (_home distance2D _pos <= 3000 && { [_home, _pos] call OT_fnc_regionIsConnected }) then { _targets pushBack ["TOWN", _x, _pos] };
} forEach OT_allTowns;
private _abandoned = server getVariable ["NATOabandoned", []];
{
    _x params ["_pos", "_name"];
    if (!(_name in _abandoned) && { _home distance2D _pos <= 3000 } && { [_home, _pos] call OT_fnc_regionIsConnected }) then { _targets pushBackUnique ["NATO", _name, _pos] };
} forEach ((missionNamespace getVariable ["OT_NATOobjectives", []]) + (missionNamespace getVariable ["OT_NATOcomms", []]));
_targets;
