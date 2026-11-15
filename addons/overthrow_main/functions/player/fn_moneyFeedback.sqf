// Modified/added for the unofficial Garrison and Command Expansion, 14-16 November 2026.
// Original author/copyright notices are retained; see LICENSE.md (GNU GPL v2).
if (!hasInterface || { isRemoteExecuted && { remoteExecutedOwner != 2 } && { remoteExecutedOwner != clientOwner } }) exitWith {};
params ["_amount", ["_reason", ""]];
playSound "3DEN_notificationDefault";
private _prefix = ["", "+"] select (_amount > 0);
private _text = format ["%1$%2", _prefix, [_amount, 1, 0, true] call CBA_fnc_formatNumber];
if (_reason isNotEqualTo "") then { _text = format ["%1: %2", _reason, _text] };
_text call OT_fnc_notifyMinor;
