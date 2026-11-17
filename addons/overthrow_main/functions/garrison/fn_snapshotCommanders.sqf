// Modified/added for the unofficial Garrison and Command Expansion, 14-16 November 2026.
// Original author/copyright notices are retained; see LICENSE.md (GNU GPL v2).
if (!isServer) exitWith {};
if (canSuspend) exitWith { isNil { [] call OT_fnc_snapshotCommanders } };
private _entries = spawner getVariable ["OT_commanderUnits", []];
if (_entries isEqualTo []) exitWith {};
private _records = +(([] call OT_fnc_commanderRecords));
private _indices = createHashMap;
{ _indices set [format ["%1:%2", _x # 0, _x # 1], _forEachIndex] } forEach _records;
private _changed = false;
{
    _x params ["_key", "_token", "_unit"];
    if (isNull _unit || { !alive _unit }) then { continue };
    private _i = _indices getOrDefault [_key, -1];
    if (_i < 0 || { ((_records # _i) # 6) isNotEqualTo _token }) then { continue };
    private _record = +(_records # _i);
    private _loadout = getUnitLoadout _unit;
    if (_loadout isNotEqualTo (_record # 4)) then { _record set [4, _loadout]; _records set [_i, _record]; _changed = true };
} forEach _entries;
if (_changed) then { [_records, true] call OT_fnc_commanderRecords };
