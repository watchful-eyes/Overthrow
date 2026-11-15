// Modified/added for the unofficial Garrison and Command Expansion, 14-16 November 2026.
// Original author/copyright notices are retained; see LICENSE.md (GNU GPL v2).
/*
	Author: ThomasAngel
	Steam: https://steamcommunity.com/id/Thomasangel/
	Github: https://github.com/rekterakathom

	Description:
	Makes a warehouse global. Merges inventory with the global inventory

	Parameters:
		_this # 0: POSITION OR OBJECT
		_this # 1: OBJECT

	Usage: _this call OT_fnc_makeWarehouseGlobal;

	Returns: True if successful
*/

params [
    ["_position", [0, 0, 0], [[], objNull]],
    ["_caller", objNull, [objNull]]
];

if (!isServer) exitWith {
    [_position, _caller] remoteExecCall ["OT_fnc_makeWarehouseGlobal", 2];
    false;
};
if (isNull _caller || { !isPlayer _caller }) exitWith { false };
if (isRemoteExecuted && { remoteExecutedOwner != 2 } && { remoteExecutedOwner != owner _caller }) exitWith { false };
private _warehouse = [_position, false] call OT_fnc_nearestWarehouse;
if (isNull _warehouse || { _caller distance _warehouse > 50 } || { _warehouse getVariable ["is_shared", false] }) exitWith { false };

private _callerMoney = _caller getVariable ["money", 0];
if (_callerMoney < 10000) exitWith {
    "You don't have enough money!" remoteExecCall ["OT_fnc_notifyMinor", _caller];
    false;
};

// We convert to hashmap for easier handling of data.
private _warehouseItems = createHashMapFromArray ((allVariables _warehouse) select { (toLower _x select [0, 5]) isEqualTo "item_" } apply { _warehouse getVariable [_x, ["", 0]] });
private _globalItems = createHashMapFromArray ((allVariables warehouse_shared) select { (toLower _x select [0, 5]) isEqualTo "item_" } apply { warehouse_shared getVariable [_x, ["", 0]] });
private _result = createHashMap;

// Handle most of the merge here, including common items and items unique to the warehouse
{
    private _key = _x;
    private _value = _y;
    if (_key in _globalItems) then {
        _result set [_key, (_globalItems get _key) + _value];
        continue;
    };
    _result set [_key, _value];
} forEach _warehouseItems;

// Handle what's left, items unique to global items
{
    private _key = _x;
    private _value = _y;
    if !(_key in _warehouseItems) then {
        _result set [_key, _value];
    };
} forEach _globalItems;

// Apply the result
{
    private _key = _x;
    private _value = _y;
    warehouse_shared setVariable [format ["item_%1", _key], [_key, _value], true];
} forEach _result;

// Set all the current variables to nil so the save system (hopefully) clears them up
{
    private _key = _x;
    _warehouse setVariable [format ["item_%1", _key], nil, true];
} forEach _warehouseItems;

[_caller, -10000, "Shared warehouse"] call OT_fnc_changeMoney;
_warehouse setVariable ["is_shared", true, true];
true;
