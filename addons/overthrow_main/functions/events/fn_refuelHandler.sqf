// Modified/added for the unofficial Garrison and Command Expansion, 14-16 November 2026.
// Original author/copyright notices are retained; see LICENSE.md (GNU GPL v2).
// ACE refuel events run on the nozzle operator's machine, not the vehicle owner.
// Keep the customer supplied by ace_refuel_started; never guess from proximity.
params ["_event", "_args"];
if (isNil "OT_fuelPumps") exitWith {};
switch (_event) do {
    case "started": {
        _args params ["_source", "_sink", "_nozzle", "_unit"];
        if (isNull _unit || { !local _unit } || { !isPlayer _unit } || { !((typeOf _source) in OT_fuelPumps) }) exitWith {};
        private _cargo = _nozzle getVariable ["ace_refuel_refuelContainer", false];
        private _level = if (_cargo) then { [_sink] call ace_refuel_fnc_getFuel } else { fuel _sink };
        private _token = format ["%1:%2:%3", clientOwner, diag_frameNo, diag_tickTime];
        // Another player may turn on a connected nozzle whose PFH still runs
        // on its original owner. Share the customer and session with that owner.
        _nozzle setVariable ["OT_refuelContext", [_unit, _source, _sink, _cargo, _token], true];
        ["start", _unit, _source, _sink, _nozzle, _level, _cargo, _token] remoteExecCall ["OT_fnc_processRefuel", 2];
    };
    case "tick": {
        _args params ["_source", "_sink", "", "_cargo", "_nozzle"];
        private _context = _nozzle getVariable ["OT_refuelContext", []];
        if (count _context != 5 || { !((typeOf _source) in OT_fuelPumps) }) exitWith {};
        _context params ["_unit", "_expectedSource", "_expectedSink", "_expectedCargo", "_token"];
        if (_source != _expectedSource || { _sink != _expectedSink } || { _cargo != _expectedCargo }) exitWith {};
        // Remote fuel readings lag behind. ACE's temporary level also avoids
        // charging for overflow in the last tick of a nearly full tank.
        private _level = if (_cargo) then { [_sink] call ace_refuel_fnc_getFuel } else { _nozzle getVariable ["ace_refuel_tempFuel", fuel _sink] };
        ["tick", _unit, _source, _sink, _nozzle, _level, _cargo, _token] remoteExecCall ["OT_fnc_processRefuel", 2];
    };
};
