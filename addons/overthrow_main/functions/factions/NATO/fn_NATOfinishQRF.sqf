// Modified/added for the unofficial Garrison and Command Expansion, 14-16 November 2026.
// Original author/copyright notices are retained; see LICENSE.md (GNU GPL v2).
// Finish only after QRF survivors have been assigned to their new garrison.
// This is server-internal; callbacks are never accepted over remoteExec.
if (!isServer) exitWith { false };
params ["_natoWon", "_remainingStrength", "_success", "_fail", "_params"];
private _remaining = 0 max _remainingStrength;
if (_natoWon) then {
    // Recover the unused part of this operation without overwriting the rest
    // of NATO's campaign budget or applying the defeat penalty to a victory.
    private _resources = server getVariable ["NATOresources", 0];
    server setVariable ["NATOresources", _resources + round (_remaining * 0.5), true];
    _params call _success;
} else {
    // Preserve the existing retreat debt policy, on defeat only. An overspent
    // operation must not turn a negative remainder into a positive reward.
    server setVariable ["NATOresourceGain", 0, true];
    server setVariable ["NATOresources", -_remaining, true];
    _params call _fail;
};
server setVariable ["NATOlastattack", time, true];
server setVariable ["QRFpos", nil, true];
server setVariable ["QRFprogress", nil, true];
server setVariable ["NATOattacking", "", true];
["OT_QRFend", []] call CBA_fnc_globalEvent;
true;
