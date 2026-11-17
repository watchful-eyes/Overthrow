// Modified/added for the unofficial Garrison and Command Expansion, 14-16 November 2026.
// Original author/copyright notices are retained; see LICENSE.md (GNU GPL v2).
// An idempotent ownership update shared by all successful NATO QRF callbacks.
// deleteAt (find ...) would delete the last unrelated region when not found.
if (!isServer) exitWith { false };
params [["_target", "", [""]]];
if (_target isEqualTo "") exitWith { false };
private _abandoned = server getVariable ["NATOabandoned", []];
private _owned = _abandoned - [_target];
server setVariable ["NATOabandoned", _owned, true];
[_owned] call OT_fnc_syncCommanders;
true;
