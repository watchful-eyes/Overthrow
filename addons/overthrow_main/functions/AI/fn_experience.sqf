// Modified/added for the unofficial Garrison and Command Expansion, 14-16 November 2026.
// Original author/copyright notices are retained; see LICENSE.md (GNU GPL v2).
private _who = _this select 0;
private _xp = _who getVariable ["OT_xp", 0];
if (count _this > 1) then {
    private _amount = _this select 1;
    _who setVariable ["OT_xp", _xp + _amount, true];
};
_xp;
