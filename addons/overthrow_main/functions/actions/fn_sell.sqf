// Modified/added for the unofficial Garrison and Command Expansion, 14-16 November 2026.
// Original author/copyright notices are retained; see LICENSE.md (GNU GPL v2).
params [["_all", false, [true]]];
if (OT_selling) exitWith {};
private _cls = lbData [1500, lbCurSel 1500];
if (_cls isEqualTo "") exitWith {};
private _target = player;
if ((player getVariable ["OT_shopTarget", "Self"]) isEqualTo "Vehicle") then {
    _target = vehicle player;
};
OT_selling = true;
[player, _target, _cls, [1, -1] select _all] remoteExecCall ["OT_fnc_processSale", 2];
