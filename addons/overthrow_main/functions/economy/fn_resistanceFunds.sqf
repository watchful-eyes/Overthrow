// Modified/added for the unofficial Garrison and Command Expansion, 14-16 November 2026.
// Original author/copyright notices are retained; see LICENSE.md (GNU GPL v2).
private _funds = server getVariable ["money", 0];
// This helper is not exposed through CfgRemoteExec; transfers use processFunds.
if (_this isNotEqualTo []) then {
    if (!finite (_this select 0)) exitWith {};
    _funds = _funds + (_this select 0);
    server setVariable ["money", _funds, true];
};
_funds;
