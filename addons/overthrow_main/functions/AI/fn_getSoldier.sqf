// Modified/added for the unofficial Garrison and Command Expansion, 14-16 November 2026.
// Original author/copyright notices are retained; see LICENSE.md (GNU GPL v2).
private _cls = _this;
private _customer = player;
private _useWarehouse = true;
if (_this isEqualType []) then {
    _cls = _this param [0, "", [""]];
    _customer = _this param [1, player, [objNull]];
    _useWarehouse = _this param [2, true, [true]];
};
private _loadout = [];

if (_cls == "Police") then {
    _loadout = server getVariable [if (isServer) then { "OT_policePreset" } else { "OT_policePresetView" }, OT_Loadout_Police];
} else {
    private _data = [];
    {
        if ((_x select 0) isEqualTo _cls) exitWith { _data = _x };
    } forEach ([] call OT_fnc_recruitPresets);
    if (_data isNotEqualTo []) then { _loadout = _data # 1 };
};
if (count _loadout != 10) exitWith { [] };

//calculate cost
private _cost = floor (([OT_nation, "CIV", 0, _customer] call OT_fnc_getPrice) * 1.5);

_loadout params ["_primary", "_secondary", "_handgun", "_uniform", "_vest", "_backpack", "_helmet", "_goggles", "", "_assigned"];

private _allitems = [];
{
    if (_x isEqualType "") then { _allitems pushBack _x } else { _allitems pushBack _x # 0 };
} forEach (_primary);
{
    if (_x isEqualType "") then { _allitems pushBack _x } else { _allitems pushBack _x # 0 };
} forEach (_secondary);
{
    if (_x isEqualType "") then { _allitems pushBack _x } else { _allitems pushBack _x # 0 };
} forEach (_handgun);
private _clothes = "";
if (_uniform isNotEqualTo []) then {
    _uniform params ["_item", "_items"];
    _clothes = _item;
    _allitems pushBack _item;
    {
        _x params ["_cls", "_num"];
        private _t = 0;
        while { _t < _num } do {
            _allitems pushBack _cls;
            _t = _t + 1;
        };
    } forEach (_items);
};
if (_vest isNotEqualTo []) then {
    _vest params ["_item", "_items"];
    _allitems pushBack _item;
    {
        _x params ["_cls", "_num"];
        private _t = 0;
        while { _t < _num } do {
            _allitems pushBack _cls;
            _t = _t + 1;
        };
    } forEach (_items);
};
if (_backpack isNotEqualTo []) then {
    _backpack params ["_item", "_items"];
    _allitems pushBack _item;
    {
        _x params ["_cls", "_num"];
        private _t = 0;
        while { _t < _num } do {
            _allitems pushBack _cls;
            _t = _t + 1;
        };
    } forEach (_items);
};
_allitems pushBack _helmet;
_allitems pushBack _goggles;
_allitems append _assigned;
_allitems = _allitems - [""];

private _itemqty = _allitems call BIS_fnc_consolidateArray;
private _bought = [];
private _warehouse = if (_useWarehouse && { !isNull _customer }) then { [_customer] call OT_fnc_nearestWarehouse } else { objNull };
{
    _x params ["_cls", "_num"];
    if (_cls isNotEqualTo "ItemMap") then {
        private _whqty = if (isNull _warehouse) then { 0 } else { (_warehouse getVariable ["item_" + _cls, [_cls, 0]]) param [1, 0] };
        if (_whqty < _num) then { _num = _num - _whqty } else { _num = 0 };
        if (_num > 0) then {
            _cost = _cost + (([OT_nation, _cls, 30, _customer] call OT_fnc_getPrice) * _num);
            _bought pushBack [_cls, _num];
        };
    };
} forEach (_itemqty);

[_cost, _cls, _loadout, _clothes, _allitems, _bought];
