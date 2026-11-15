// Modified/added for the unofficial Garrison and Command Expansion, 14-16 November 2026.
// Original author/copyright notices are retained; see LICENSE.md (GNU GPL v2).
// Run only in the isolated VR test mission, never in a player's campaign.
private _passed = 0;
private _check = {
    params ["_name", "_condition"];
    if (!_condition) then { throw format ["FAIL: %1", _name] };
    _passed = _passed + 1;
    diag_log format ["ENGINE PASS: %1", _name];
};
server = true call CBA_fnc_createNamespace;
spawner = true call CBA_fnc_createNamespace;
owners = true call CBA_fnc_createNamespace;
buildingpositions = true call CBA_fnc_createNamespace;
players_NS = true call CBA_fnc_createNamespace;
warehouse = true call CBA_fnc_createNamespace;
warehouse_shared = true call CBA_fnc_createNamespace;
OT_civilians = true call CBA_fnc_createNamespace;
private _town = "CodexTown";
private _center = [4000, 4000, 0];
OT_allTowns = [_town];
server setVariable [_town, _center];
server setVariable ["NATOabandoned", [_town]];
server setVariable [format ["policepos%1", _town], _center];
server setVariable [format ["police%1", _town], 6];
spawner setVariable [format ["townspawnid%1", _town], "codexTownSpawn"];
private _original = createGroup independent;
private _personnel = [];
for "_i" from 1 to 6 do {
    private _unit = _original createUnit ["I_soldier_F", _center, [], 0, "NONE"];
    _unit allowDamage false;
    _unit setVariable ["polgarrison", _town];
    _personnel pushBack _unit;
};
private _protected = createGroup independent;
private _recruit = _protected createUnit ["I_soldier_F", _center, [], 0, "NONE"];
_recruit setVariable ["polgarrison", _town];
_recruit setVariable ["owner", "protected-player"];
private _protectedFollower = _protected createUnit ["I_soldier_F", _center, [], 0, "NONE"];
_protectedFollower setVariable ["polgarrison", _town];
spawner setVariable ["codexTownSpawn", [_original, _protected]];
private _plan = [
    ["alpha", "Alpha", 3, [[4010, 4010, 0], [4050, 4010, 0]], "LIMITED", "PATROL"],
    ["bravo", "Bravo", 2, [[4020, 4020, 0]], "NORMAL", "HOLD"]
];
server setVariable [format ["garrisonplan%1", _town], _plan];
[_town] call OT_fnc_assignTownGarrison;
private _groups = spawner getVariable [format ["garrisongroups%1", _town], []];
["Configured companies plus reserve are created", count _groups isEqualTo 3] call _check;
["Regrouping preserves all existing soldiers", (_groups apply { count units _x }) isEqualTo [3, 2, 1] && { _personnel findIf { !alive _x } isEqualTo -1 }] call _check;
["Owned groups keep even their unowned followers", group _recruit isEqualTo _protected && { group _protectedFollower isEqualTo _protected }] call _check;
private _patrol = _groups # 0;
private _types = (waypoints _patrol) apply { waypointType _x };
["Custom route has ordered MOVE stops and a CYCLE", _types isEqualTo ["MOVE", "MOVE", "CYCLE"]] call _check;
["Custom route uses the assigned coordinates", (waypointPosition ((waypoints _patrol) # 0)) distance2D [4010, 4010, 0] < 1] call _check;
["Hold company gets a HOLD waypoint", (waypoints (_groups # 1)) findIf { waypointType _x isEqualTo "HOLD" } != -1] call _check;
["Company identity survives regrouping", (_patrol getVariable "OT_garrisonCompany") isEqualTo "alpha"] call _check;
server setVariable ["NATOabandoned", []];
[_town] call OT_fnc_assignTownGarrison;
["An occupied town cannot be reorganized", (spawner getVariable [format ["garrisongroups%1", _town], []]) isEqualTo _groups] call _check;
server setVariable ["NATOabandoned", [_town]];

// Exercise the real save/load functions with isolated namespaces and a separate profile.
OT_saving = false;
OT_NATOInitDone = true;
OT_autoSave_time = 0;
OT_saveName = "CodexRegressionOnly";
OT_flag_IND = "Flag_Altis_F";
OT_item_safe = "Land_PlasticCase_01_small_F";
OT_item_Storage = "Box_NATO_Ammo_F";
OT_objectiveData = [];
OT_airportData = [];
OT_Recruitables = [];
OT_Loadout_Police = getUnitLoadout (_personnel # 0);
[objNull, true, true] call OT_fnc_saveGame;
private _data = missionProfileNamespace getVariable [OT_saveName, []];
["Real persistent save contains the world state", _data findIf { (_x # 0) isEqualTo "server" } != -1] call _check;
server = true call CBA_fnc_createNamespace;
[_data] call OT_fnc_loadGame;
["Real load restores the town company plan", (server getVariable [format ["garrisonplan%1", _town], []]) isEqualTo _plan] call _check;
["Real load completes its startup state", (server getVariable ["StartupType", ""]) isEqualTo "LOAD"] call _check;
[_town] call OT_fnc_assignTownGarrison;
private _restored = spawner getVariable [format ["garrisongroups%1", _town], []];
["Restored company routes can be applied again", count _restored isEqualTo 3 && { (_restored # 0) getVariable ["OT_garrisonCompany", ""] isEqualTo "alpha" }] call _check;
["Garrison dialog map inherits a real map control", getNumber (configFile >> "OT_dialog_townGarrison" >> "controls" >> "Map" >> "type") isEqualTo 101] call _check;
diag_log format ["OVERTHROW_ENGINE_PASSED=%1", _passed];
