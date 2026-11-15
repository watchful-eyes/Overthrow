// Modified/added for the unofficial Garrison and Command Expansion, 14-16 November 2026.
// Original author/copyright notices are retained; see LICENSE.md (GNU GPL v2).
disableSerialization;
params [["_mode", "refresh"], ["_args", []]];
private _display = findDisplay 8099;
if (isNull _display) exitWith {};
if (isNil { _display getVariable "settings" }) then {
    _display setVariable ["settings", [server getVariable ["OT_difficulty", 1], server getVariable ["OT_fastTravelType", 1], server getVariable ["OT_fastTravelRules", 1]]];
    private _list = _display displayCtrl 2100;
    private _i = _list lbAdd "Random start"; _list lbSetData [_i, ""];
    private _towns = +OT_spawnTowns; _towns sort true;
    { private _index = _list lbAdd _x; _list lbSetData [_index, _x] } forEach _towns;
    _display setVariable ["startIcon", getText (configFile >> "CfgMarkers" >> "mil_start" >> "icon")];
    _list lbSetCurSel 0;
};
private _settings = _display getVariable "settings";
if (_mode isEqualTo "setting") then { _settings set [_args # 0, _args # 1]; _display setVariable ["settings", _settings] };
if (_mode isEqualTo "start") exitWith {
    private _list = _display displayCtrl 2100;
    private _town = _list lbData lbCurSel _list;
    private _validation = [_town, _settings] call OT_fnc_validateNewGameOptions;
    if !(_validation # 0) exitWith { (_validation # 1) call OT_fnc_notifyMinor };
    closeDialog 0;
    [_town, _settings] remoteExec ["OT_fnc_newGame", 2];
};
{
    private _selected = _settings # _forEachIndex;
    {
        (_display displayCtrl _x) ctrlSetBackgroundColor ([ [0.07, 0.11, 0.14, 1], [0.12, 0.46, 0.37, 1] ] select (_forEachIndex isEqualTo _selected));
        (_display displayCtrl _x) ctrlSetTextColor [0.91, 0.96, 0.98, 1];
    } forEach _x;
} forEach [[1600, 1601, 1602], [1603, 1604, 1605], [1607, 1608, 1609]];
private _list = _display displayCtrl 2100;
private _town = _list lbData lbCurSel _list;
private _pos = server getVariable [_town, getArray (configFile >> "CfgWorlds" >> worldName >> "centerPosition")];
_display setVariable ["startTown", _town];
_display setVariable ["startPosition", _pos];
(_display displayCtrl 1104) ctrlSetText (["A starting town will be selected at random when the campaign is prepared.", format ["Starting town: %1", _town]] select (_town isNotEqualTo ""));
private _map = _display displayCtrl 51;
_map ctrlMapAnimAdd [0.25, [0.7, 0.09] select (_town isNotEqualTo ""), _pos];
ctrlMapAnimCommit _map;
