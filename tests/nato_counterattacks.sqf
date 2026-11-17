// Modified/added for the unofficial Garrison and Command Expansion, 14-16 November 2026.
// Original author/copyright notices are retained; see LICENSE.md (GNU GPL v2).
// Isolated dedicated VR mission only. Exercise actual selectors with real NPCs.
// Reserve/spawn runs unscheduled, then terminate the recorded attack script
// before it can deploy troops. No final function overrides or mocked selectors.
private _passed = 0;
private _check = {
    params ["_name", "_condition"];
    if (!_condition) then { diag_log ["NATO_FAILURE_STATE", _name, server getVariable "NATOabandoned", server getVariable "NATOattacking", diag_activeSQFScripts]; throw format ["FAIL: %1", _name] };
    _passed = _passed + 1;
    diag_log format ["NATO PASS: %1", _name];
};
server = true call CBA_fnc_createNamespace;
spawner = true call CBA_fnc_createNamespace;
sleep 0.2; // Let newly created global namespace objects finish their first engine frames.
private _a = "CodexCapturedA";
private _b = "CodexCapturedB";
private _occupied = "CodexNATOTown";
private _objective = "CodexCapturedBase";
OT_allTowns = [_a, _b, _occupied];
OT_townsSortedByPopulation = [_occupied, _a, _b];
OT_objectiveData = [];
OT_NATOComms = [];
OT_spawnDistance = 500;
server setVariable [_a, [6000, 6000, 0], true];
server setVariable [_b, [6300, 6000, 0], true];
server setVariable [_occupied, [8000, 8000, 0], true];
server setVariable [format ["population%1", _a], 600, true];
server setVariable [format ["population%1", _b], 400, true];
server setVariable [format ["population%1", _occupied], 2000, true];
server setVariable ["OT_difficulty", 1, true];
private _resistance = createGroup independent;
private _defenders = [];
{
    private _unit = _resistance createUnit ["I_soldier_F", _x, [], 0, "NONE"];
    _unit enableSimulationGlobal false;
    _unit allowDamage false;
    _defenders pushBack _unit;
} forEach [[6000, 6000, 0], [6300, 6000, 0], [8000, 8000, 0]];
OT_trackedUnitCache = [+_defenders, time + 100000];

private _reset = {
    server setVariable ["NATOabandoned", [_a], true];
    server setVariable ["NATOattacking", "", true];
    server setVariable ["NATOlastcounter", "", true];
    server setVariable ["NATOlastattack", time - 1300, true];
    server setVariable ["NATOresources", 5000, true];
};
private _townCounter = {
    private _started = false;
    isNil {
        _started = [-1] call OT_fnc_NATOcounterTowns; // Guaranteed roll, real rules.
        if (_started) then { terminate OT_NATOCounterScript };
    };
    _started;
};
private _objectiveCounter = {
    private _started = false;
    isNil {
        // Preserve production probability. At 4% per attempt the bounded loop
        // makes a missed positive path less likely than 1 in 10^18.
        for "_attempt" from 1 to 1024 do {
            _started = [] call OT_fnc_NATOcounterObjectives;
            if (_started) exitWith { terminate OT_NATOCounterScript };
        };
    };
    _started;
};
private _reserve = {
    params ["_target", "_strength", "_cost", "_kind"];
    private _started = false;
    isNil {
        _started = [_target, _strength, _cost, _kind] call OT_fnc_NATOstartCounterattack;
        if (_started) then { terminate OT_NATOCounterScript };
    };
    _started;
};

call _reset;
["Captured towns are valid counterattack targets", call _townCounter] call _check;
["NATO-owned towns are skipped even with resistance nearby", (server getVariable "NATOattacking") isEqualTo _a] call _check;
["Town attack budget is charged exactly once", (server getVariable "NATOresources") isEqualTo 3200] call _check;
private _cancelDeadline = diag_tickTime + 2;
waitUntil { sleep 0.01; scriptDone OT_NATOCounterScript || { diag_tickTime > _cancelDeadline } };
["The launched attack script is recorded and cancellable", scriptDone OT_NATOCounterScript] call _check;
["A second town attack is blocked while one is reserved", !(call _townCounter)] call _check;
["A blocked second attack cannot spend resources", (server getVariable "NATOresources") isEqualTo 3200] call _check;

call _reset;
server setVariable ["NATOabandoned", [], true];
["No liberated towns means no town counterattack", !(call _townCounter)] call _check;
call _reset;
server setVariable ["NATOlastattack", time, true];
["A recent attack enforces the cooldown", !(call _townCounter)] call _check;
server setVariable ["NATOlastattack", time - 1199, true];
["Cooldown cannot end at 1199 seconds", !(call _townCounter)] call _check;
server setVariable ["NATOlastattack", time - 1200, true];
["The 1200-second boundary permits an attack", call _townCounter] call _check;
call _reset;
server setVariable ["NATOlastcounter", _a, true];
["The only captured town remains attackable after a previous attack", call _townCounter] call _check;
call _reset;
server setVariable ["NATOabandoned", [_a, _b], true];
server setVariable ["NATOlastcounter", _a, true];
["Another eligible town is preferred before the last target", (call _townCounter) && { (server getVariable "NATOattacking") isEqualTo _b }] call _check;
call _reset;
OT_trackedUnitCache = [[], time + 100000];
["Towns outside tracked spawn range are not attacked", !(call _townCounter)] call _check;
OT_trackedUnitCache = [+_defenders, time + 100000];
call _reset;
server setVariable ["NATOresources", 600, true];
["Insufficient campaign resources block town selection", !(call _townCounter)] call _check;
call _reset;
server setVariable ["NATOresources", 1000, true];
["A town attack is capped at the available budget", (call _townCounter) && { (server getVariable "NATOresources") isEqualTo 0 }] call _check;

call _reset;
["Invalid attack kinds are rejected", !([_a, 100, 100, "INVALID"] call _reserve)] call _check;
["An unaffordable reservation cannot start an attack", !([_a, 100, 5001, "TOWN"] call _reserve)] call _check;
["A NATO-owned target cannot be reserved", !([_occupied, 100, 100, "TOWN"] call _reserve)] call _check;
["Zero or negative attack budgets are rejected", !([_a, 100, -1, "TOWN"] call _reserve)] call _check;
["Rejected reservations preserve the campaign budget", (server getVariable "NATOresources") isEqualTo 5000] call _check;

// Real objective selector: captured objectives need no nearby player.
OT_objectiveData = [[[7000, 7000, 0], _objective, 1000]];
OT_NATOComms = [];
call _reset;
server setVariable [format ["population%1", _a], 3000, true];
server setVariable ["NATOabandoned", [_a, _objective], true];
["A captured objective is selected with the corrected elapsed time", call _objectiveCounter] call _check;
["Objective selection reserves its own target and budget", (server getVariable "NATOattacking") isEqualTo _objective && { (server getVariable "NATOresources") isEqualTo 4000 }] call _check;
call _reset;
server setVariable ["NATOabandoned", [_a, _objective], true];
server setVariable ["NATOlastcounter", _objective, true];
["The only captured objective is not permanently exempt", call _objectiveCounter] call _check;
call _reset;
server setVariable ["NATOabandoned", [_a, _objective], true];
server setVariable ["NATOlastattack", time, true];
["Objective selector also respects a recent attack", !([] call OT_fnc_NATOcounterObjectives)] call _check;
call _reset;
server setVariable ["NATOabandoned", [_a, _objective], true];
["A town attack can begin with a captured objective present", call _townCounter] call _check;
private _budget = server getVariable "NATOresources";
["The objective check in the same faction turn cannot start another battle", !([] call OT_fnc_NATOcounterObjectives) && { (server getVariable "NATOattacking") isEqualTo _a } && { (server getVariable "NATOresources") isEqualTo _budget }] call _check;

// Successful NATO callbacks share a safe, published ownership update.
server setVariable ["NATOabandoned", [_a, _b, _objective], true];
[_a] call OT_fnc_NATOrestoreControl;
["NATO retaking a town preserves other captured regions", (server getVariable "NATOabandoned") isEqualTo [_b, _objective]] call _check;
[_a] call OT_fnc_NATOrestoreControl;
["Repeated ownership updates cannot delete an unrelated region", (server getVariable "NATOabandoned") isEqualTo [_b, _objective]] call _check;
[_objective] call OT_fnc_NATOrestoreControl;
["Objective retakes update the shared control list", (server getVariable "NATOabandoned") isEqualTo [_b]] call _check;
["An empty target cannot change ownership", !([""] call OT_fnc_NATOrestoreControl) && { (server getVariable "NATOabandoned") isEqualTo [_b] }] call _check;

// Real QRF completion, without waiting for a full 20-40 minute battle.
private _won = { params ["_target"]; OT_testNATOOutcome = "WIN"; [_target] call OT_fnc_NATOrestoreControl };
private _lost = { OT_testNATOOutcome = "LOSS" };
server setVariable ["NATOabandoned", [_a, _b], true];
server setVariable ["NATOresources", 500, true];
server setVariable ["NATOresourceGain", 100, true];
server setVariable ["NATOattacking", _a, true];
server setVariable ["QRFpos", [6000, 6000, 0], true];
server setVariable ["QRFprogress", 1, true];
[true, 200, _won, _lost, [_a]] call OT_fnc_NATOfinishQRF;
["A NATO victory calls only the victory callback", OT_testNATOOutcome isEqualTo "WIN"] call _check;
["Victory refunds unused strength without erasing campaign funds", (server getVariable "NATOresources") isEqualTo 600] call _check;
["Victory does not apply the retreat income penalty", (server getVariable "NATOresourceGain") isEqualTo 100] call _check;
["Victory publishes the recaptured target", (server getVariable "NATOabandoned") isEqualTo [_b]] call _check;
["Finished battles release the attack lock and QRF state", (server getVariable "NATOattacking") isEqualTo "" && { isNil { server getVariable "QRFpos" } } && { isNil { server getVariable "QRFprogress" } }] call _check;
["The cooldown starts again at battle completion", abs ((server getVariable "NATOlastattack") - time) < 1] call _check;
["A new attack cannot start immediately after completion", !([_b, 100, 100, "TOWN"] call _reserve)] call _check;
server setVariable ["NATOresources", 500, true];
server setVariable ["NATOresourceGain", 100, true];
server setVariable ["NATOattacking", _b, true];
[false, 200, _won, _lost, [_b]] call OT_fnc_NATOfinishQRF;
["A NATO defeat calls only the defeat callback", OT_testNATOOutcome isEqualTo "LOSS"] call _check;
["Retreat debt is applied to defeat instead of victory", (server getVariable "NATOresources") isEqualTo -200 && { (server getVariable "NATOresourceGain") isEqualTo 0 }] call _check;
["A defeated attack does not recapture the target", (server getVariable "NATOabandoned") isEqualTo [_b]] call _check;
[false, -100, _won, _lost, [_b]] call OT_fnc_NATOfinishQRF;
["A negative operation remainder cannot reward a defeat", (server getVariable "NATOresources") isEqualTo 0] call _check;
server setVariable ["NATOresources", 500, true];
[true, -100, _won, _lost, ["alreadyNATO"]] call OT_fnc_NATOfinishQRF;
["Overspending cannot subtract a second time on victory", (server getVariable "NATOresources") isEqualTo 500] call _check;
OT_testNATOOutcome = nil;
sleep 0.2; // Finish prior QRF callbacks before starting the independent save fixture.

// Real saveGame must not delete the final captured region on an idle save.
OT_saving = false;
OT_NATOInitDone = true;
OT_autoSave_time = 0;
OT_saveName = "CodexNATORegressionOnly";
server setVariable ["NATOabandoned", [_a, _b], true];
server setVariable ["NATOattacking", "", true];
[objNull, true, true] call OT_fnc_saveGame;
private _saved = missionProfileNamespace getVariable [OT_saveName, []];
private _world = (_saved select { (_x # 0) isEqualTo "server" }) # 0 # 1;
private _owned = (_world select { toLower (_x # 0) isEqualTo "natoabandoned" }) # 0 # 1;
["Saving without a battle preserves every captured region", _owned isEqualTo [_a, _b]] call _check;
["An idle save cannot mutate live ownership", (server getVariable "NATOabandoned") isEqualTo [_a, _b]] call _check;
sleep 0.1;
["Ownership remains stable after the save engine frame", (server getVariable "NATOabandoned") isEqualTo [_a, _b]] call _check;
server setVariable ["NATOattacking", _a, true];
[objNull, true, true] call OT_fnc_saveGame;
_saved = missionProfileNamespace getVariable [OT_saveName, []];
_world = (_saved select { (_x # 0) isEqualTo "server" }) # 0 # 1;
_owned = (_world select { toLower (_x # 0) isEqualTo "natoabandoned" }) # 0 # 1;
["An in-progress battle affects only its own saved target", _owned isEqualTo [_b]] call _check;
["Saving an active battle does not mutate live ownership", (server getVariable "NATOabandoned") isEqualTo [_a, _b]] call _check;
server setVariable ["NATOattacking", "", true];
{ deleteVehicle _x } forEach _defenders;
deleteGroup _resistance;
diag_log format ["OVERTHROW_NATO_PASSED=%1", _passed];
