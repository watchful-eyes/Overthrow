// Modified/added for the unofficial Garrison and Command Expansion, 14-16 November 2026.
// Original author/copyright notices are retained; see LICENSE.md (GNU GPL v2).
// Current Arma/ACE/CBA integration checks; isolated dedicated VR mission only.
private _passed = 0;
private _check = {
    params ["_name", "_condition"];
    if (!_condition) then { throw format ["FAIL: %1", _name] };
    _passed = _passed + 1;
    diag_log format ["COMPAT PASS: %1", _name];
};
private _apis = [
    "ace_medical_fnc_setUnconscious", "ace_refuel_fnc_getFuel",
    "ace_refuel_fnc_getCapacity", "ace_refuel_fnc_setFuel",
    "CBA_fnc_addEventHandler", "CBA_fnc_targetEvent"
];
["Required current public integration functions exist", _apis findIf { isNil _x } isEqualTo -1] call _check;
["Blood setting is still registered with CBA", !isNil "ace_medical_blood_enabledFor"] call _check;

private _group = createGroup west;
private _customer = _group createUnit ["B_Soldier_F", [4500, 4500, 0], [], 0, "NONE"];
private _bystander = _group createUnit ["B_Soldier_F", [4501, 4500, 0], [], 0, "NONE"];
private _victim = _group createUnit ["B_Soldier_F", [4500, 4501, 0], [], 0, "NONE"];
_customer setCaptive true;
_victim disableAI "PATH";
_victim setVariable ["ace_medical_lastDamageSource", _customer];
[_victim, "body", 0.2, 0, "HitBody", objNull, objNull] call OT_fnc_EnemyDamagedHandler;
["ACE last damage source identifies the attacker", !captive _customer] call _check;
["Injured NPC movement is re-enabled", _victim checkAIFeature "PATH"] call _check;
_customer setCaptive true;
_victim setVariable ["ace_medical_lastDamageSource", objNull];
private _shot = "B_65x39_Caseless" createVehicle [4500, 4500, 50];
[_victim, "body", 0.3, 0, "HitBody", _customer, _shot] call OT_fnc_EnemyDamagedHandler;
["A projectile without parents preserves the known shooter", !captive _customer] call _check;
deleteVehicle _shot;

server = true call CBA_fnc_createNamespace;
cost = true call CBA_fnc_createNamespace;
OT_nation = "CompatNation";
OT_standardMarkup = 0;
cost setVariable ["FUEL", [50, 0, 0, 0]];
_customer setVariable ["OT_trade", 1];
_bystander setVariable ["OT_trade", 15];
private _price = [OT_nation, "FUEL", 100, _customer] call OT_fnc_getPrice;
["Server prices use the explicit customer's trading skill", _price > ([OT_nation, "FUEL", 100, _bystander] call OT_fnc_getPrice)] call _check;
private _pump = "Land_fs_feed_F" createVehicle [4500, 4500, 0];
private _vehicle = "B_MRAP_01_F" createVehicle [4505, 4500, 0];
private _nozzle = "ace_refuel_fuelNozzle" createVehicle [4501, 4500, 0];
OT_fuelPumps = [typeOf _pump];
_nozzle setVariable ["ace_refuel_source", _pump];
_nozzle setVariable ["ace_refuel_sink", _vehicle];
_nozzle setVariable ["OT_refuelContext", [_customer, _pump, _vehicle, false, "tank"]];
_customer setVariable ["money", 100000];
_bystander setVariable ["money", 12345];
private _capacity = getNumber (configOf _vehicle >> "ace_refuel_fuelCapacity");
["Fixture exercises ACE's real ground-vehicle tank capacity", _capacity > 0 && { _capacity != getNumber (configOf _vehicle >> "fuelCapacity") }] call _check;
["A fuel session starts for its actual customer", ["start", _customer, _pump, _vehicle, _nozzle, 0.2, false, "tank"] call OT_fnc_processRefuel] call _check;
["The first delivered increment is billed", ["tick", _customer, _pump, _vehicle, _nozzle, 0.3, false, "tank"] call OT_fnc_processRefuel] call _check;
private _bill = round (_capacity * 0.1 * _price);
["Charge uses litres from ACE capacity", (_customer getVariable "money") isEqualTo (100000 - _bill)] call _check;
["A nearby bystander is never charged", (_bystander getVariable "money") isEqualTo 12345] call _check;
["Duplicate ticks are accepted without another debit", (["tick", _customer, _pump, _vehicle, _nozzle, 0.3, false, "tank"] call OT_fnc_processRefuel) && { (_customer getVariable "money") isEqualTo (100000 - _bill) }] call _check;
["Replayed starts do not reset the paid total", (["start", _customer, _pump, _vehicle, _nozzle, 0.2, false, "tank"] call OT_fnc_processRefuel) && { ((_nozzle getVariable "OT_refuelPurchase") # 8) isEqualTo _bill }] call _check;
["Old ticks cannot refund a later fuel level", (["tick", _customer, _pump, _vehicle, _nozzle, 0.25, false, "tank"] call OT_fnc_processRefuel) && { (_customer getVariable "money") isEqualTo (100000 - _bill) }] call _check;
["An old session token is rejected", !(["tick", _customer, _pump, _vehicle, _nozzle, 0.4, false, "old"] call OT_fnc_processRefuel)] call _check;
["Fuel levels above the tank capacity are rejected", !(["tick", _customer, _pump, _vehicle, _nozzle, 1.1, false, "tank"] call OT_fnc_processRefuel)] call _check;
["A different customer cannot reuse this purchase", !(["tick", _bystander, _pump, _vehicle, _nozzle, 0.4, false, "tank"] call OT_fnc_processRefuel)] call _check;
_customer setVariable ["money", 0];
["Insufficient funds reject an unpaid tick", !(["tick", _customer, _pump, _vehicle, _nozzle, 0.4, false, "tank"] call OT_fnc_processRefuel)] call _check;
["An unpaid tick cannot make the balance negative", (_customer getVariable "money") isEqualTo 0] call _check;
["Purchase remains blocked for in-flight ticks", (_nozzle getVariable "OT_refuelPurchase") # 9] call _check;
_nozzle setVariable ["ace_refuel_isRefueling", true];
["Rejected fuel is rolled back by the operator endpoint", [_nozzle, _vehicle, 0.3, false, "tank"] call OT_fnc_stopRefuel] call _check;
["Rollback stops ACE's PFH and restores its cached level", !(_nozzle getVariable "ace_refuel_isRefueling") && { abs ((_nozzle getVariable "ace_refuel_tempFuel") - 0.3) < 0.0001 }] call _check;
["A delayed rejection cannot stop a new session", !([_nozzle, _vehicle, 0.1, false, "older"] call OT_fnc_stopRefuel)] call _check;

// Small deliveries must round once over the entire purchase, not each second.
_customer setVariable ["money", 100000];
["A fresh nozzle session can be opened after rejection", ["start", _customer, _pump, _vehicle, _nozzle, 0, false, "rounding"] call OT_fnc_processRefuel] call _check;
for "_i" from 1 to 20 do {
    ["tick", _customer, _pump, _vehicle, _nozzle, _i * 0.001, false, "rounding"] call OT_fnc_processRefuel;
};
["Cumulative billing has no per-tick rounding drift", (_customer getVariable "money") isEqualTo (100000 - round (_capacity * 0.02 * _price))] call _check;

// Fuel cargo uses litres from ACE, independently of the vehicle's engine tank.
_vehicle setVariable ["ace_refuel_capacity", 1000, true];
_vehicle setVariable ["ace_refuel_currentFuelCargo", 100];
_nozzle setVariable ["OT_refuelContext", [_customer, _pump, _vehicle, true, "cargo"]];
_customer setVariable ["money", 100000];
["Fuel cargo starts with a litre-based level", ["start", _customer, _pump, _vehicle, _nozzle, 100, true, "cargo"] call OT_fnc_processRefuel] call _check;
["Fuel cargo purchases use actual cargo litres", (["tick", _customer, _pump, _vehicle, _nozzle, 110, true, "cargo"] call OT_fnc_processRefuel) && { (_customer getVariable "money") isEqualTo (100000 - 10 * _price) }] call _check;
_vehicle setVariable ["ace_refuel_currentFuelCargo", 120];
[_nozzle, _vehicle, 110, true, "cargo"] call OT_fnc_stopRefuel;
["Unpaid cargo can be restored with the public ACE function", ([_vehicle] call ace_refuel_fnc_getFuel) isEqualTo 110] call _check;
_nozzle setVariable ["OT_refuelContext", [_customer, _pump, _vehicle, true, "event"]];
["start", _customer, _pump, _vehicle, _nozzle, 110, true, "event"] call OT_fnc_processRefuel;
_customer setVariable ["money", 100000, true];
_vehicle setVariable ["ace_refuel_currentFuelCargo", 112, true];
private _handler = ["ace_refuel_tick", { ["tick", _this] call OT_fnc_refuelHandler }] call CBA_fnc_addEventHandler;
["ace_refuel_tick", [_pump, _vehicle, 2, true, _nozzle]] call CBA_fnc_localEvent;
sleep 0.2;
["CBA's real tick reaches the server through the remote allowlist", (_customer getVariable "money") isEqualTo (100000 - 2 * _price)] call _check;
["ace_refuel_tick", _handler] call CBA_fnc_removeEventHandler;
_nozzle setVariable ["ace_refuel_sink", objNull];
["Disconnected or substituted nozzles cannot charge", !(["tick", _customer, _pump, _vehicle, _nozzle, 115, true, "cargo"] call OT_fnc_processRefuel)] call _check;
OT_noCopyMags = []; OT_hasTFAR = false;
// The real transfer must resolve the basic backpack before calling addBackpack.
private _lootGroup = createGroup [independent, true];
private _donor = _lootGroup createUnit ["I_soldier_F", [6500, 5000, 0], [], 0, "NONE"];
private _recipient = _lootGroup createUnit ["I_soldier_F", [6505, 5000, 0], [], 0, "NONE"];
{ _x enableSimulationGlobal false; _x allowDamage false; removeAllWeapons _x; removeAllAssignedItems _x; removeAllItems _x; removeBackpack _x } forEach [_donor, _recipient];
_donor addBackpack "B_AssaultPack_khk";
_donor addItemToBackpack "FirstAidKit";
[_donor, _recipient] call OT_fnc_takeStuff;
["Equipment transfer preserves a usable backpack and its contents", backpack _recipient isEqualTo "B_AssaultPack_khk" && { "FirstAidKit" in items _recipient } && { backpack _donor isEqualTo "" }] call _check;
deleteVehicle _donor; deleteVehicle _recipient;
sleep 0.2; // Let queued feedback finish before deleting the AI test customers.
{ deleteVehicle _x } forEach [_pump, _vehicle, _nozzle, _customer, _bystander, _victim];
deleteGroup _group;
diag_log format ["OVERTHROW_COMPATIBILITY_PASSED=%1", _passed];
