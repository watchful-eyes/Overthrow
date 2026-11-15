// Modified/added for the unofficial Garrison and Command Expansion, 14-16 November 2026.
// Original author/copyright notices are retained; see LICENSE.md (GNU GPL v2).
// Unscheduled server transaction. The client reports an absolute fuel level;
// the server chooses the price, customer, capacity and cumulative rounded bill.
if (!isServer) exitWith { false };
params [
    ["_action", "", [""]], ["_unit", objNull, [objNull]],
    ["_source", objNull, [objNull]], ["_sink", objNull, [objNull]],
    ["_nozzle", objNull, [objNull]], ["_level", -1, [0]],
    ["_cargo", false, [false]], ["_token", "", [""]]
];
if (!(_action in ["start", "tick"]) || { isNull _unit } || { isNull _source } || { isNull _sink } || { isNull _nozzle }) exitWith { false };
if (!finite _level || { _level < 0 } || { _token isEqualTo "" } || { count _token > 128 }) exitWith { false };
if (isNil "OT_fuelPumps" || { !((typeOf _source) in OT_fuelPumps) }) exitWith { false };
if (_nozzle getVariable ["ace_refuel_source", objNull] != _source || { _nozzle getVariable ["ace_refuel_sink", objNull] != _sink }) exitWith { false };
private _sender = if (isRemoteExecuted) then { remoteExecutedOwner } else { 2 };
if (_sender != 2 && { !isPlayer _unit }) exitWith { false };
if (_action isEqualTo "start" && { _sender != 2 } && { _sender != owner _unit }) exitWith { false };
if (_action isEqualTo "tick" && { !(_sender in [2, owner _unit, owner _nozzle]) }) exitWith { false };
private _hoseLength = _source getVariable ["ace_refuel_hoseLength", missionNamespace getVariable ["ace_refuel_hoseLength", 30]];
if (_action isEqualTo "start" && { _unit distance _source > _hoseLength + 10 }) exitWith { false };

private _capacity = if (_cargo) then {
    [_sink] call ace_refuel_fnc_getCapacity
} else {
    private _aceCapacity = getNumber (configOf _sink >> "ace_refuel_fuelCapacity");
    if (_aceCapacity > 0) then { _aceCapacity } else { getNumber (configOf _sink >> "fuelCapacity") }
};
private _maxLevel = [1, _capacity] select _cargo;
if (_capacity <= 0 || { _level > _maxLevel + 0.001 }) exitWith { false };
_level = _level min _maxLevel;
if (_action isEqualTo "start") exitWith {
    private _existing = _nozzle getVariable ["OT_refuelPurchase", []];
    if ((_existing param [4, ""]) isNotEqualTo _token) then {
        private _price = 0 max ([OT_nation, "FUEL", 100, _unit] call OT_fnc_getPrice);
        _nozzle setVariable ["OT_refuelPurchase", [_unit, _source, _sink, _cargo, _token, _level, _level, _price, 0, false]];
    };
    true;
};
private _purchase = _nozzle getVariable ["OT_refuelPurchase", []];
if (count _purchase != 10 || { (_purchase select [0, 5]) isNotEqualTo [_unit, _source, _sink, _cargo, _token] }) exitWith { false };
_purchase params ["", "", "", "", "", "_start", "_paidLevel", "_price", "_charged", "_blocked"];
private _litres = (0 max (_level - _start)) * ([_capacity, 1] select _cargo);
private _bill = round (_litres * _price);
private _due = 0 max (_bill - _charged);
if (_blocked || { _due > (_unit getVariable ["money", 0]) }) exitWith {
    _purchase set [9, true];
    _nozzle setVariable ["OT_refuelPurchase", _purchase];
    // Return in-flight unpaid ticks to the last accepted level on the machine
    // running ACE's PFH. A session token protects a later connection.
    [_nozzle, _sink, _paidLevel, _cargo, _token] remoteExecCall ["OT_fnc_stopRefuel", _sender];
    if (!_blocked) then { "You cannot afford fuel" remoteExecCall ["OT_fnc_notifyMinor", _unit] };
    false;
};
// Replayed / out-of-order absolute levels can neither charge twice nor refund.
if (_level <= _paidLevel) exitWith { true };
if (_due > 0 && { !([_unit, -_due, "Fuel"] call OT_fnc_changeMoney) }) exitWith { false };
_purchase set [6, _level];
_purchase set [8, _bill];
_nozzle setVariable ["OT_refuelPurchase", _purchase];
true;
