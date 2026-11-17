// Modified/added for the unofficial Garrison and Command Expansion, 14-16 November 2026.
// Original author/copyright notices are retained; see LICENSE.md (GNU GPL v2).
private _passed = 0;
private _check = { params ["_name", "_ok"]; if (!_ok) then { throw format ["FAIL: %1", _name] }; _passed = _passed + 1; diag_log format ["START PASS: %1", _name] };
OT_spawnTowns = ["StartA", "StartB"];
["A configured starting town is accepted", (["StartA", [0, 1, 2]] call OT_fnc_validateNewGameOptions) # 0] call _check;
["Random start remains available", (["", [1, 1, 1]] call OT_fnc_validateNewGameOptions) # 0] call _check;
["Unknown starting towns cannot reach economy generation", !((["EnemyBase", [1, 1, 1]] call OT_fnc_validateNewGameOptions) # 0)] call _check;
["Malformed setting arrays are rejected", !((["StartA", [1, 1]] call OT_fnc_validateNewGameOptions) # 0)] call _check;
["Undefined entries are rejected without script errors", !((["StartA", [nil, 1, 1]] call OT_fnc_validateNewGameOptions) # 0)] call _check;
["Invalid difficulty or travel choices are rejected", !((["StartA", [3, 1, 1]] call OT_fnc_validateNewGameOptions) # 0) && { !((["StartA", [1, "bad", 1]] call OT_fnc_validateNewGameOptions) # 0) }] call _check;
["A chosen town survives start resolution", (["StartB"] call OT_fnc_resolveStartTown) isEqualTo "StartB"] call _check;
["A missing or legacy selection resolves to an allowed town", (["old-town"] call OT_fnc_resolveStartTown) in OT_spawnTowns] call _check;
["Random resolution stays within configured spawn towns", ([""] call OT_fnc_resolveStartTown) in OT_spawnTowns] call _check;
OT_spawnTowns = [];
["Empty map data fails safely", ([""] call OT_fnc_resolveStartTown) isEqualTo "" && { !((["", [1, 1, 1]] call OT_fnc_validateNewGameOptions) # 0) }] call _check;
["New campaign setup includes a real map and spawn selector", getNumber (configFile >> "OT_dialog_newgame" >> "controls" >> "Preview" >> "type") isEqualTo 101 && { getNumber (configFile >> "OT_dialog_newgame" >> "controls" >> "SpawnTown" >> "type") isEqualTo 4 }] call _check;
["The redesigned dashboard retains contextual building actions", getNumber (configFile >> "OT_dialog_main" >> "controls" >> "Context1608" >> "idc") isEqualTo 1608 && { getNumber (configFile >> "OT_dialog_main" >> "controls" >> "Property" >> "idc") isEqualTo 1102 }] call _check;
diag_log format ["OVERTHROW_START_PASSED=%1", _passed];
