// Modified/added for the unofficial Garrison and Command Expansion, 14-16 November 2026.
// Original author/copyright notices are retained; see LICENSE.md (GNU GPL v2).
// Read-only on both server and clients. Never trust client prices or ranks.
params ["_kind", "_target"];
private _towns = [];
if (_kind isEqualTo "TOWN" && { _target in OT_allTowns }) then { _towns = [_target] };
if (_kind isEqualTo "REGION" && { _target in OT_regions }) then {
    _towns = OT_allTowns select { (server getVariable [format ["region_%1", _x], ""]) isEqualTo _target };
};
if (_towns isEqualTo []) exitWith { [] };
private _population = 0;
{ private _p = server getVariable [format ["population%1", _x], 0]; if (_p isEqualType 0 && { finite _p }) then { _population = _population + (0 max _p) } } forEach _towns;
private _rank = [_kind, _population] call OT_fnc_commanderRank;
private _key = format ["%1:%2", _kind, _target];
private _records = ([] call OT_fnc_commanderRecords);
private _index = _records findIf { (_x # 0) isEqualTo _kind && { (_x # 1) isEqualTo _target } };
private _record = if (_index < 0) then { [] } else { _records # _index };
private _label = _target;
if (_kind isEqualTo "REGION" && { markerText _target isNotEqualTo "" }) then { _label = markerText _target };
// label, population, rank title, engine rank, price, record, revision, key
[_label, _population, _rank # 0, _rank # 1, _rank # 2, _record, server getVariable ["commanderrev" + _key, 0], _key];
