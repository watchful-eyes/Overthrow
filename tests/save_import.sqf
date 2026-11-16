// Isolated native solo-host fixture only; never run in a real campaign.
if (!isServer || { !hasInterface } || { !(missionNamespace getVariable ["OT_saveImportTestFixture", false]) }) then { throw "Save import tests require an isolated fixture" };
disableSerialization;
private _checks = 0;
private _check = {
    params ["_name", "_ok"];
    if (!_ok) then { throw ("Save import regression: " + _name) };
    _checks = _checks + 1;
};
private _valid = [["server", [["populationPanochori", 212], ["stabilityPanochori", 83], ["populationNegades", 63], ["stabilityNegades", 6]]]];
["Canonical data parses intact", ([str _valid] call OT_fnc_parseSaveData) isEqualTo [true, "", _valid]] call _check;
private _spacing = "  " + str _valid + toString [13, 10];
["Outer whitespace is accepted", ([ _spacing ] call OT_fnc_parseSaveData) # 0] call _check;
private _quotes = [["server", [["custom", "A ""quoted"" name, [with brackets] and Türkçe"], ["stabilityPanochori", 0]]]];
["Quoted punctuation and Unicode remain data", ([str _quotes] call OT_fnc_parseSaveData) isEqualTo [true, "", _quotes]] call _check;
{
    ["Malformed input is rejected before partial parsing: " + str _forEachIndex, !(([_x] call OT_fnc_parseSaveData) # 0)] call _check;
} forEach [
    "", "[", "[]", "[[""server"",[]]", "[[""server"",[]]],", "[[""server"",[]]] garbage",
    "[[""server"",[[""x"",bigboss]]]]", "[[""server"",[[""x"",{hint 'unsafe'}]]]]",
    "[[""server"",[[""x"",1 2]]]]", "[[""server"",[[""x"",1,]]]]",
    "[[""server"",[[""x"",1.2.3]]]]", "[[""server"",[[""x"",truE]]]]",
    "[[""server"",[[""x"",""unterminated]]]]", "[[""server"",[]],[""server"",[]]]",
    "[[""server"",42]]", "[[""other"",[]]]", "[[""server"",[[""x""]]]]"
];
server = true call CBA_fnc_createNamespace;
spawner = true call CBA_fnc_createNamespace;
owners = true call CBA_fnc_createNamespace;
buildingpositions = true call CBA_fnc_createNamespace;
players_NS = true call CBA_fnc_createNamespace;
warehouse = true call CBA_fnc_createNamespace;
warehouse_shared = true call CBA_fnc_createNamespace;
OT_civilians = true call CBA_fnc_createNamespace;
OT_allTowns = ["Panochori", "Negades"];
OT_objectiveData = [];
OT_airportData = [];
OT_Recruitables = [];
OT_Loadout_Police = getUnitLoadout "I_Soldier_F";
OT_mapEnemyFaction = "BLU_F";
OT_faction_NATO = "BLU_F";
OT_saving = false;
OT_NATOInitDone = true;
OT_autoSave_time = 0;
OT_saveName = "SaveImportRegressionOnly";
OT_flag_IND = "Flag_Altis_F";
OT_item_safe = "Land_PlasticCase_01_small_F";
OT_item_Storage = "Box_NATO_Ammo_F";
player setVariable ["OT_loaded", false];
player setVehicleVarName "saveImportFixturePlayer";
{ server setVariable [_x # 0, _x # 1] } forEach ((_valid # 0) # 1);
server setVariable ["OT_startupOwner", player];
server setVariable ["OT_startupInProgress", false];
server setVariable ["OT_startupAutoLoad", true];
[objNull, true, true] call OT_fnc_saveGame;
private _saved = missionProfileNamespace getVariable [OT_saveName, []];
private _records = ((_saved select { (_x # 0) isEqualTo "server" }) # 0) # 1;
["Live startup player objects are excluded from real saves", _records findIf { toLower (_x # 0) isEqualTo "ot_startupowner" } isEqualTo -1] call _check;
["Session startup flags are excluded from real saves", _records findIf { toLower (_x # 0) in ["ot_startupinprogress", "ot_startupautoload"] } isEqualTo -1] call _check;
private _roundtrip = [str _saved] call OT_fnc_parseSaveData;
["The actual save survives text export and strict import", _roundtrip # 0] call _check;
["Persistent town metrics remain in the exported data", (_records select { toLower (_x # 0) isEqualTo "stabilitypanochori" }) isEqualTo [["stabilitypanochori", 83]]] call _check;
private _legacy = [["server", [["OT_startupOwner", objNull], ["OT_startupAutoLoad", false], ["OT_startupInProgress", false], ["populationPanochori", 212], ["stabilityPanochori", 83]]]];
[_legacy] call OT_fnc_loadGame;
["Loading ignores stale session ownership from older native saves", server getVariable ["OT_startupOwner", objNull] isEqualTo player] call _check;
["Loading retains current autoload configuration", server getVariable ["OT_startupAutoLoad", false]] call _check;
server setVariable ["StartupType", ""];
server setVariable ["OT_startupInProgress", false];
server setVariable ["populationPanochori", 777];
createDialog "OT_dialog_load";
(findDisplay 15150 displayCtrl 1400) ctrlSetText "[[""server"",[[""populationPanochori"",212],[""OT_startupOwner"",bigboss],[""stabilityPanochori"",83]]]]";
private _action = getText (configFile >> "OT_dialog_load" >> "controls" >> "LoadString" >> "action");
call compile _action; // Trusted mod UI action, never the pasted data.
["Malformed imports leave the dialog open", !isNull findDisplay 15150] call _check;
["Malformed imports leave the campaign untouched", server getVariable ["populationPanochori", 0] isEqualTo 777 && { server getVariable ["StartupType", ""] isEqualTo "" }] call _check;
(findDisplay 15150 displayCtrl 1400) ctrlSetText str _saved;
call compile _action;
private _deadline = diag_tickTime + 10;
waitUntil { uiSleep 0.01; server getVariable ["StartupType", ""] isEqualTo "LOAD" || { diag_tickTime > _deadline } };
["Valid text imports complete the actual load RPC", isNull findDisplay 15150 && { server getVariable ["StartupType", ""] isEqualTo "LOAD" }] call _check;
["Panochori population is preserved by real import", server getVariable ["populationPanochori", -1] isEqualTo 212] call _check;
["Panochori stability is preserved by real import", server getVariable ["stabilityPanochori", -1] isEqualTo 83] call _check;
["Low stability remains six rather than a false zero", server getVariable ["stabilityNegades", -1] isEqualTo 6] call _check;
"tr" call OT_fnc_setLanguage;
private _markup = [["server", [["customText", "<t>Close</t>"], ["stabilityPanochori", 83]]]];
[_markup] call OT_fnc_uploadData;
["Export is not translated, including embedded markup", ctrlText (findDisplay 49558 displayCtrl 1) isEqualTo str _markup] call _check;
closeDialog 0;
"en" call OT_fnc_setLanguage;
diag_log format ["OVERTHROW_SAVE_IMPORT_PASSED=%1", _checks];
