// Modified/added for the unofficial Garrison and Command Expansion, 14-16 November 2026.
// Original author/copyright notices are retained; see LICENSE.md (GNU GPL v2).
// Independent streaming: commanders are not police personnel or player recruits.
if (!isServer) exitWith {};
[] call OT_fnc_snapshotCommanders;
private _entries = spawner getVariable ["OT_commanderUnits", []];
{ if (!isNull (_x # 2) && { !alive (_x # 2) }) then { [_x # 2] call OT_fnc_commanderKilled } } forEach _entries;
private _records = server getVariable ["OT_commanders", []];
private _live = [];
{
    _x params ["_key", "_token", "_unit"];
    private _i = _records findIf { format ["%1:%2", _x # 0, _x # 1] isEqualTo _key && { (_x # 6) isEqualTo _token } };
    private _keep = false;
    if (_i >= 0 && { !isNull _unit } && { alive _unit }) then {
        private _home = (_records # _i) # 2;
        private _pos = server getVariable ["policepos" + _home, []];
        _keep = _home in (server getVariable ["NATOabandoned", []]) && { count _pos isEqualTo 3 } && { [_pos] call OT_fnc_inSpawnDistance };
    };
    if (_keep) then { _live pushBack _x } else { if (!isNull _unit && { alive _unit }) then { [_unit] call OT_fnc_cleanupUnit } };
} forEach _entries;
{
    private _record = _x;
    _record params ["_kind", "_target", "_home", "_identity", "", "", "_token"];
    private _details = [_kind, _target] call OT_fnc_commanderDetails;
    if (_details isEqualTo []) then { continue };
    private _key = _details # 7;
    private _i = _live findIf { (_x # 0) isEqualTo _key && { (_x # 1) isEqualTo _token } };
    private _unit = objNull;
    if (_i >= 0) then { _unit = (_live # _i) # 2 } else {
        private _pos = server getVariable ["policepos" + _home, []];
        if (_home in (server getVariable ["NATOabandoned", []]) && { count _pos isEqualTo 3 } && { [_pos] call OT_fnc_inSpawnDistance }) then {
            _unit = [_record] call OT_fnc_spawnCommander;
            if (!isNull _unit) then { _live pushBack [_key, _token, _unit] };
        };
    };
    if (!isNull _unit && { (_unit getVariable ["OT_commanderRank", ""]) isNotEqualTo (_details # 2) }) then {
        _unit setRank (_details # 3);
        _unit setVariable ["OT_commanderRank", _details # 2, true];
        [_unit, format ["%1 %2", _details # 2, _identity # 0]] remoteExecCall ["setName", 0, _unit];
        (group _unit) setGroupIdGlobal [format ["%1 / %2", _details # 0, _details # 2]];
    };
} forEach _records;
spawner setVariable ["OT_commanderUnits", _live];
