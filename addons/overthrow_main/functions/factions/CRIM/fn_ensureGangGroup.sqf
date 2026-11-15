// Modified/added for the unofficial Garrison and Command Expansion, 14-16 November 2026.
// Original author/copyright notices are retained; see LICENSE.md (GNU GPL v2).
// Materialize existing virtual members only. Never recruits or charges resources.
if (!isServer) exitWith { grpNull };
params ["_gangid", ["_register", true]];
private _gang = OT_civilians getVariable [format ["gang%1", _gangid], []];
if (count _gang != 9) exitWith { grpNull };
private _town = _gang # 2;
private _key = format ["gangspawn%1", _gangid];
private _group = spawner getVariable [_key, grpNull];
if (!isNull _group && { side _group isNotEqualTo opfor }) exitWith { grpNull };
if (!isNull _group && { (units _group) findIf { isPlayer _x || { _x call OT_fnc_hasOwner } } != -1 }) exitWith { grpNull };
if (isNull _group) then {
    _group = createGroup [opfor, true];
    _group setVariable ["VCM_TOUGHSQUAD", true];
    _group setVariable ["VCM_NORESCUE", true];
    spawner setVariable [_key, _group, true];
};
private _present = (units _group select { alive _x }) apply { _x getVariable ["OT_civid", -1] };
{
    private _civid = _x;
    if (_civid in _present) then { continue };
    private _data = OT_civilians getVariable [str _civid, []];
    if (_data isEqualTo []) then { continue };
    private _unit = _group createUnit [OT_CRIM_Unit, (_gang # 4) getPos [10, random 360], [], 0, "NONE"];
    if (isNull _unit) then { continue };
    [_unit, _town, _data # 0, _gangid] call OT_fnc_initCriminal;
    _unit setVariable ["OT_gangid", _gangid, true];
    _unit setVariable ["OT_civid", _civid, true];
    _unit setVariable ["hometown", _town, true];
    _unit setBehaviour "SAFE";
    { _x addCuratorEditableObjects [[_unit], true] } forEach allCurators;
    _present pushBack _civid;
} forEach (_gang # 0);
if (_register) then {
    private _spawnid = spawner getVariable ["townspawnid" + _town, ""];
    if (_spawnid isEqualType "" && { _spawnid isNotEqualTo "" }) then {
        private _objects = +(spawner getVariable [_spawnid, []]);
        _objects pushBackUnique _group;
        spawner setVariable [_spawnid, _objects];
    };
};
_group;
