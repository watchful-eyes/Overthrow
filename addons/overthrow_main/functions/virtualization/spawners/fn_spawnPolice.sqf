// Modified/added for the unofficial Garrison and Command Expansion, 14-16 November 2026.
// Original author/copyright notices are retained; see LICENSE.md (GNU GPL v2).
if (!isServer) exitWith {};
sleep random 0.2;
params ["_town", "_spawnid"];
if !(_town in (server getVariable ["NATOabandoned", []])) exitWith {};
spawner setVariable [format ["garrisonSpawning%1", _town], true];
spawner setVariable [format ["townspawnid%1", _town], _spawnid];
private _posTown = server getVariable [format ["policepos%1", _town], server getVariable _town];
private _plan = server getVariable [format ["garrisonplan%1", _town], []];
private _personnel = [];
{ for "_i" from 1 to (_x # 1) do { _personnel pushBack (_x # 0) } } forEach ([_town] call OT_fnc_townGarrisonRoster);
private _layout = [_plan, count _personnel] call OT_fnc_townGarrisonLayout;
private _groups = [];
private _personIndex = 0;
private _soldiers = createHashMap;
{
    _x params ["_entry", "_amount"];
    private _group = createGroup [independent, true];
    _group setVariable ["VCM_TOUGHSQUAD", true, true];
    _group setVariable ["VCM_NORESCUE", true, true];
    _group setVariable ["OT_townGarrison", _town, true];
    _group setVariable ["OT_garrisonCompany", _entry # 0, true];
    _group setGroupIdGlobal [format ["%1 / %2", _town, _entry # 1]];
    _groups pushBack _group;
    private _start = [[[_posTown, 15 + 25 * _forEachIndex]]] call BIS_fnc_randomPos;
    for "_i" from 1 to _amount do {
        private _preset = _personnel # _personIndex;
        _personIndex = _personIndex + 1;
        private _soldier = _soldiers getOrDefault [_preset, []];
        if (_soldier isEqualTo []) then {
            _soldier = _preset call OT_fnc_getSoldier;
            if (_soldier isEqualTo [] || { _preset isNotEqualTo "Police" && { !isClass (configFile >> "CfgVehicles" >> _preset) } }) then { _soldier = "Police" call OT_fnc_getSoldier };
            _soldiers set [_preset, _soldier];
        };
        private _civ = [_soldier, _start, _group, false] call OT_fnc_createSoldier;
        if (!isNull _civ) then {
            _civ setVariable ["OT_garrisonPreset", _preset, true];
            _civ setRank "SERGEANT";
            [_civ, _town] call OT_fnc_initPolice;
            _civ setBehaviour "SAFE";
        };
        sleep 0.3;
    };
    [_group, _entry, _posTown] call OT_fnc_applyTownGarrisonRoute;
} forEach _layout;
spawner setVariable [_spawnid, (spawner getVariable [_spawnid, []]) + _groups];
spawner setVariable [format ["garrisongroups%1", _town], _groups, true];
spawner setVariable [format ["garrisonSpawning%1", _town], false];
if (spawner getVariable [format ["garrisonRebuildPending%1", _town], false]) then {
    spawner setVariable [format ["garrisonRebuildPending%1", _town], false];
    [_town] call OT_fnc_assignTownGarrison;
};
