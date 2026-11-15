// Modified/added for the unofficial Garrison and Command Expansion, 14-16 November 2026.
// Original author/copyright notices are retained; see LICENSE.md (GNU GPL v2).
// Server-only balance update. Not exposed through CfgRemoteExec.
if (!isServer) exitWith { false };
params ["_player", "_amount", ["_reason", ""]];
if (isNull _player || { !finite _amount }) exitWith { false };
private _balance = (_player getVariable ["money", 0]) + _amount;
if (_balance < 0) exitWith { false };
_player setVariable ["money", _balance, true];
[_amount, _reason] remoteExecCall ["OT_fnc_moneyFeedback", _player];
true;
