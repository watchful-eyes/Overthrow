// Modified/added for the unofficial Garrison and Command Expansion, 14-16 November 2026.
// Original author/copyright notices are retained; see LICENSE.md (GNU GPL v2).
// Independent streaming: commanders are not police personnel or player recruits.
if (!isServer) exitWith {};
params [["_friendlyTowns", server getVariable ["NATOabandoned", []], [[]]]];
// Purchases/PFHs and scheduled QRF callbacks share one atomic runtime update.
if (canSuspend) exitWith { isNil { [_friendlyTowns] call OT_fnc_syncCommanders } };
[] call OT_fnc_snapshotCommanders;
private _entries = spawner getVariable ["OT_commanderUnits", []];
{ if (!isNull (_x # 2) && { !alive (_x # 2) }) then { [_x # 2] call OT_fnc_commanderKilled } } forEach _entries;
private _records = ([] call OT_fnc_commanderRecords);
private _byKey = createHashMap;
private _activeHomes = createHashMap;
private _friendly = createHashMapFromArray (_friendlyTowns apply { [_x, true] });
{
    _x params ["_kind", "_target", "_home"];
    _byKey set [format ["%1:%2", _kind, _target], _x];
    // City and region officers at one headquarters share the same distance check.
    if (isNil { _activeHomes get _home }) then {
        private _pos = server getVariable ["policepos" + _home, []];
        _activeHomes set [_home, (_friendly getOrDefault [_home, false]) && { count _pos isEqualTo 3 } && { [_pos] call OT_fnc_inSpawnDistance }];
    };
} forEach _records;
private _live = [];
private _liveByKey = createHashMap;
{
    _x params ["_key", "_token", "_unit"];
    private _record = _byKey getOrDefault [_key, []];
    private _keep = _record isNotEqualTo [] && { (_record # 6) isEqualTo _token } && { !isNull _unit } && { alive _unit } && { _activeHomes get (_record # 2) };
    if (_keep) then { _live pushBack _x; _liveByKey set [_key, _unit] } else {
        if (!isNull _unit && { alive _unit }) then {
            _unit setVariable ["OT_commanderVirtualized", true];
            // These groups already auto-delete when empty. Avoid a queued
            // deleteGroup RPC racing a newly created replacement headquarters.
            if (local _unit) then { deleteVehicle _unit } else { [_unit] call OT_fnc_cleanupUnit };
        };
    };
} forEach _entries;
{
    private _record = _x;
    _record params ["_kind", "_target", "_home", "_identity", "", "", "_token"];
    // Invisible/suspended officers need no population aggregation or rank lookup.
    // Their current rank is derived when a player next opens the UI or streams them in.
    if !(_activeHomes get _home) then { continue };
    private _details = [_kind, _target] call OT_fnc_commanderDetails;
    if (_details isEqualTo []) then { continue };
    private _key = _details # 7;
    private _unit = _liveByKey getOrDefault [_key, objNull];
    if (isNull _unit) then {
        _unit = [_record] call OT_fnc_spawnCommander;
        if (!isNull _unit) then { _live pushBack [_key, _token, _unit]; _liveByKey set [_key, _unit] };
    };
    if (!isNull _unit && { (_unit getVariable ["OT_commanderRank", ""]) isNotEqualTo (_details # 2) }) then {
        _unit setRank (_details # 3);
        _unit setVariable ["OT_commanderRank", _details # 2, true];
        [_unit, format ["%1 %2", _details # 2, _identity # 0]] remoteExecCall ["setName", 0, _unit];
        (group _unit) setGroupIdGlobal [format ["%1 / %2", _details # 0, _details # 2]];
    };
} forEach _records;
spawner setVariable ["OT_commanderUnits", _live];

// Repair the replicated view without using it as purchase/death authority.
if ((server getVariable ["OT_commanders", []]) isNotEqualTo _records) then { [_records, true] call OT_fnc_commanderRecords };
