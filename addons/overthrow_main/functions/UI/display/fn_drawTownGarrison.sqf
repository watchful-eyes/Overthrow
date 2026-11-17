// Modified/added for the unofficial Garrison and Command Expansion, 14-16 November 2026.
// Original author/copyright notices are retained; see LICENSE.md (GNU GPL v2).
disableSerialization;
params ["_map"];
private _display = ctrlParent _map;
private _selected = _display getVariable ["selected", -1];
private _draft = _display getVariable ["draft", []];
{
    _x params ["", "", "", "_route", "", "_mode"];
    private _color = [[0.4, 0.6, 0.5, 0.45], [0.15, 0.9, 0.45, 1]] select (_forEachIndex isEqualTo _selected);
    private _companyIndex = _forEachIndex;
    private _points = [];
    if (_mode isEqualTo "PATROL") then { _points = _route };
    if (_mode isEqualTo "HOLD") then { _points = [_route param [0, _display getVariable "station"]] };
    for "_i" from 1 to (count _points - 1) do { _map drawLine [_points # (_i - 1), _points # _i, _color] };
    if (_mode isEqualTo "PATROL" && { count _points > 1 }) then { _map drawLine [_points select -1, _points # 0, _color] };
    {
        _map drawIcon ["\A3\ui_f\data\map\markers\military\dot_CA.paa", _color, _x, 18, 18, 0, (format ["%1.%2", _companyIndex + 1, _forEachIndex + 1] call OT_fnc_localizeText), 1, 0.035, "PuristaMedium"];
    } forEach _points;
} forEach _draft;
if (_selected < 0 || { _selected >= count _draft }) exitWith {};
private _id = (_draft # _selected) # 0;
{
    if (!isNull _x && { (_x getVariable ["OT_garrisonCompany", ""]) isEqualTo _id } && { alive leader _x }) then {
        _map drawIcon ["iconMan", [0.2, 0.6, 1, 1], getPos leader _x, 24, 24, getDir leader _x, (format ["%1 (%2)", groupId _x, { alive _x } count units _x] call OT_fnc_localizeText), 1, 0.035, "PuristaMedium"];
    };
} forEach (spawner getVariable [format ["garrisongroups%1", _display getVariable "town"], []]);
