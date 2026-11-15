// Modified/added for the unofficial Garrison and Command Expansion, 14-16 November 2026.
// Original author/copyright notices are retained; see LICENSE.md (GNU GPL v2).
// This function should only be called on the server

params ["_baseCode", "_pos", "_soldier", "_charge", ["_takeFromWarehouse", true]];

private _group = spawner getVariable [format ["resgarrison%1", _baseCode], grpNull];
private _doinit = false;
if (isNull _group) then {
    _group = createGroup independent;
    _group setVariable ["VCM_TOUGHSQUAD", true, true];
    _group setVariable ["VCM_NORESCUE", true, true];
    spawner setVariable [format ["resgarrison%1", _baseCode], _group, true];
    _doinit = true;
};

private _unit = [_soldier, _pos, _group, _takeFromWarehouse] call OT_fnc_createSoldier;
if (isNull _unit) exitWith { objNull };

if (_doinit) then {
    _group call OT_fnc_initMilitaryPatrol;
};
if (_charge) then {
    private _cls = _soldier # 1;
    private _loadout = getUnitLoadout _unit;
    private _garrison = server getVariable [format ["resgarrison%1", _baseCode], []];
    _garrison pushBack [_cls, _loadout];
    server setVariable [format ["resgarrison%1", _baseCode], _garrison, true];
};
_unit;
