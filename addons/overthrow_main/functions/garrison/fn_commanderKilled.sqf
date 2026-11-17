// Modified/added for the unofficial Garrison and Command Expansion, 14-16 November 2026.
// Original author/copyright notices are retained; see LICENSE.md (GNU GPL v2).
// Also called by the normal EntityKilled path; duplicate death events are safe.
if (!isServer) exitWith { false };
params ["_unit"];
if (isNull _unit || { alive _unit } || { _unit getVariable ["OT_commanderVirtualized", false] }) exitWith { false };
private _key = _unit getVariable ["OT_commanderKey", ""];
private _token = _unit getVariable ["OT_commanderToken", ""];
private _records = +(([] call OT_fnc_commanderRecords));
private _index = _records findIf { format ["%1:%2", _x # 0, _x # 1] isEqualTo _key && { (_x # 6) isEqualTo _token } };
if (_index < 0) exitWith { false };
_records deleteAt _index;
[_records, true] call OT_fnc_commanderRecords;
private _revisionKey = "commanderrev" + _key;
server setVariable [_revisionKey, (server getVariable [_revisionKey, 0]) + 1, true];
format ["%1 has been killed. A new commander can be appointed.", name _unit] remoteExecCall ["OT_fnc_notifyMinor", 0];
true;
