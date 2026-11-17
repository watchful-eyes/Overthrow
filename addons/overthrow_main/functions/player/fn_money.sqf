// Modified/added for the unofficial Garrison and Command Expansion, 14-16 November 2026.
// Original author/copyright notices are retained; see LICENSE.md (GNU GPL v2).
if !(hasInterface) exitWith {};
if (isRemoteExecuted && { remoteExecutedOwner != 2 } && { remoteExecutedOwner != clientOwner }) exitWith {};
private _amount = _this select 0;
if (!finite _amount) exitWith {};
private _rep = (player getVariable ["money", 0]) + _amount;
if (_rep < 0) then {
    _rep = 0;
};
player setVariable ["money", _rep, true];
playSound "3DEN_notificationDefault";
private _plusmin = "";
if (_amount > 0) then {
    _plusmin = "+";
};
if (count _this > 1) then {
    format ["%3: %1$%2", _plusmin, [_amount, 1, 0, true] call CBA_fnc_formatNumber, _this select 1] call OT_fnc_notifyMinor;
} else {
    format ["%1$%2", _plusmin, [_amount, 1, 0, true] call CBA_fnc_formatNumber] call OT_fnc_notifyMinor;
};
