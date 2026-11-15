// Modified/added for the unofficial Garrison and Command Expansion, 14-16 November 2026.
// Original author/copyright notices are retained; see LICENSE.md (GNU GPL v2).
private _api = [["ace", ["ace_arsenal_fnc_addDefaultLoadout", "ace_arsenal_fnc_addVirtualItems", "ace_arsenal_fnc_openBox", "ace_arsenal_fnc_removeVirtualItems", "ace_dragging_fnc_setCarryable", "ace_explosives_fnc_scriptedExplosive", "ace_interact_menu_fnc_addActionToObject", "ace_interact_menu_fnc_createAction", "ace_medical_fnc_setUnconscious", "ace_refuel_fnc_getCapacity", "ace_refuel_fnc_getFuel", "ace_refuel_fnc_setFuel", "ace_repair_fnc_addSpareParts", "ace_repair_fnc_isInRepairFacility", "ace_repair_fnc_moduleAssignRepairFacility"]], ["CBA", ["CBA_fnc_addBackpackCargo", "CBA_fnc_addClassEventHandler", "CBA_fnc_addEventHandler", "CBA_fnc_addEventHandlerArgs", "CBA_fnc_addItemCargo", "CBA_fnc_addKeyHandler", "CBA_fnc_addMagazineCargo", "CBA_fnc_addPerFrameHandler", "CBA_fnc_addWeaponCargo", "CBA_fnc_createNamespace", "CBA_fnc_directCall", "CBA_fnc_error", "CBA_fnc_execNextFrame", "CBA_fnc_formatNumber", "CBA_fnc_getKeybind", "CBA_fnc_globalEvent", "CBA_fnc_players", "CBA_fnc_removeBackpackCargo", "CBA_fnc_removeEventHandler", "CBA_fnc_removeItem", "CBA_fnc_removeItemCargo", "CBA_fnc_removeMagazineCargo", "CBA_fnc_removePerFrameHandler", "CBA_fnc_removeUnitTrackProjectiles", "CBA_fnc_removeWeaponCargo", "CBA_fnc_targetEvent", "CBA_fnc_taskPatrol", "CBA_fnc_waitAndExecute", "CBA_fnc_waitUntilAndExecute"]], ["lambs", ["lambs_wp_fnc_taskArtilleryRegister"]]];
private _data = [];
// Run only in an isolated Altis mission after the real OT_fnc_initOverthrow.
// ACE/CBA are required; LAMBS/RHS branches also verify optional-mod absence.
private _passed = 0;
private _check = {
    params ["_name", "_condition"];
    if (!_condition) then { throw format ["FAIL: %1", _name] };
    _passed = _passed + 1;
    diag_log format ["MOD INTEGRATION PASS: %1", _name];
};
{
    _x params ["_mod", "_symbols"];
    private _missing = _symbols select { isNil { missionNamespace getVariable _x } || { !((missionNamespace getVariable _x) isEqualType {}) } };
    _data pushBack [_mod + "_api", [count _symbols, _missing]];
    if (_mod isNotEqualTo "lambs" || { isClass (configFile >> "CfgPatches" >> "lambs_wp") }) then {
        [_mod + " referenced APIs exist", _missing isEqualTo []] call _check;
    };
} forEach _api;
{
    _data pushBack [_x, [isClass (configFile >> "CfgPatches" >> _x), getText (configFile >> "CfgPatches" >> _x >> "versionStr"), getArray (configFile >> "CfgPatches" >> _x >> "versionAr")]];
} forEach ["ace_main", "cba_main", "lambs_main", "lambs_wp", "rhs_main", "rhsusf_main", "rhsgref_main", "rhssaf_main", "ace_compat_rhs_afrf3", "ace_compat_rhs_usf3", "ace_compat_rhs_gref3", "ace_compat_rhs_saf3"];
_data pushBack ["selected_enemy", [OT_faction_NATO, isClass (configFile >> "CfgFactionClasses" >> OT_faction_NATO), isClass (configFile >> "CfgGroups" >> "West" >> OT_faction_NATO)]];
_data pushBack ["catalog_sizes", [count OT_allWeapons, count OT_allMagazines, count OT_allBLURifles, count OT_allBLUMachineGuns, count OT_allBLURifleMagazines]];
private _mg = ("getNumber (_x >> 'scope') == 2 && { configName _x isKindOf ['Rifle', configFile >> 'CfgWeapons'] }" configClasses (configFile >> "CfgWeapons")) select { (([configName _x] call BIS_fnc_itemType) # 1) isEqualTo "MachineGun" };
_data pushBack ["machineguns_available", count _mg];
private _wellOnly = ("getNumber (_x >> 'scope') == 2" configClasses (configFile >> "CfgWeapons")) select { getArray (_x >> "magazines") isEqualTo [] && { compatibleMagazines [configName _x, "this"] isNotEqualTo [] } };
_data pushBack ["magwell_only", [count _wellOnly, (_wellOnly select [0, 10]) apply { configName _x }]];
{
    private _faction = _x;
    private _units = format ["getNumber (_x >> 'scope') == 2 && { getText (_x >> 'faction') == '%1' } && { configName _x isKindOf 'SoldierWB' }", _faction] configClasses (configFile >> "CfgVehicles");
    _data pushBack [_faction, [isClass (configFile >> "CfgFactionClasses" >> _faction), count _units, count ("true" configClasses (configFile >> "CfgGroups" >> "West" >> _faction))]];
} forEach ["rhs_faction_usarmy_wd", "rhs_faction_usarmy_d", "rhs_faction_usmc_wd", "rhs_faction_usmc_d", "rhsgref_faction_hidf"];
if (isClass (configFile >> "CfgPatches" >> "lambs_wp")) then {
    private _mortar = createVehicle ["B_Mortar_01_F", [4000, 4000, 0], [], 0, "NONE"];
    createVehicleCrew _mortar;
    private _registered = false;
    isNil { _registered = [group gunner _mortar] call lambs_wp_fnc_taskArtilleryRegister };
    _data pushBack ["lambs_artillery_register", _registered];
    ["LAMBS accepts a real crewed mortar group", _registered] call _check;
    { deleteVehicle _x } forEach crew _mortar;
    deleteVehicle _mortar;
};
private _globalFunctions = "true" configClasses (configFile >> "CfgRemoteExec" >> "Functions");
private _missingRPC = _globalFunctions select { !isClass (missionConfigFile >> "CfgRemoteExec" >> "Functions" >> configName _x) };
_data pushBack ["mod_rpc", [count _globalFunctions, count _missingRPC, (_missingRPC select [0, 15]) apply { configName _x }]];
_data pushBack ["global_commands", ("true" configClasses (configFile >> "CfgRemoteExec" >> "Commands")) apply { configName _x }];

["Occupation faction exists with BLUFOR groups", isClass (configFile >> "CfgFactionClasses" >> OT_faction_NATO) && { isClass (configFile >> "CfgGroups" >> "West" >> OT_faction_NATO) }] call _check;
private _rhsPresent = isClass (configFile >> "CfgPatches" >> "rhsusf_main");
["Optional RHS selection resolves correctly", OT_faction_NATO isEqualTo (if (_rhsPresent) then { "rhs_faction_usarmy_wd" } else { "BLU_F" })] call _check;
["Unknown faction falls back to the map army", (["OT_missing_faction", "BLU_F"] call OT_fnc_resolveEnemyFaction) isEqualTo "BLU_F"] call _check;
["Wrong-side occupation faction is rejected", (["OPF_F", "BLU_F"] call OT_fnc_resolveEnemyFaction) isEqualTo "BLU_F"] call _check;
["Valid occupation faction is retained", (["BLU_F", "OT_missing_faction"] call OT_fnc_resolveEnemyFaction) isEqualTo "BLU_F"] call _check;
["Machine gun pool is populated", OT_allBLUMachineGuns isNotEqualTo []] call _check;
["Machine gun pool contains machine guns", OT_allBLUMachineGuns findIf { (([_x] call BIS_fnc_itemType) # 1) isNotEqualTo "MachineGun" } isEqualTo -1] call _check;
["Rifle ammunition pool is populated", OT_allBLURifleMagazines isNotEqualTo []] call _check;
["Supply rifle magazines are public and compatible", OT_allBLURifleMagazines findIf {
    private _mag = _x;
    getNumber (configFile >> "CfgMagazines" >> _mag >> "scope") isNotEqualTo 2 || { OT_allBLURifles findIf { _mag in ([_x] call OT_fnc_weaponMagazines) } isEqualTo -1 }
} isEqualTo -1] call _check;
["Supply magazine entries are unique", count OT_allBLURifleMagazines isEqualTo count (OT_allBLURifleMagazines arrayIntersect OT_allBLURifleMagazines)] call _check;
["Unknown weapon returns no magazines", (["OT_missing_weapon"] call OT_fnc_weaponMagazines) isEqualTo []] call _check;

private _weapon = "arifle_MX_GL_F";
private _primary = [_weapon] call OT_fnc_weaponMagazines;
private _legacy = getArray (configFile >> "CfgWeapons" >> _weapon >> "magazines");
private _muzzles = getArray (configFile >> "CfgWeapons" >> _weapon >> "muzzles");
private _grenadeMuzzle = (_muzzles select { _x isNotEqualTo "this" }) # 0;
private _grenades = [_weapon, _grenadeMuzzle] call OT_fnc_weaponMagazines;
private _allMags = [_weapon, ""] call OT_fnc_weaponMagazines;
["Legacy magazine preference is preserved", (_primary select [0, count _legacy]) isEqualTo _legacy] call _check;
["Primary muzzle matches engine compatibility", (compatibleMagazines [_weapon, "this"]) findIf { !(_x in _primary) } isEqualTo -1] call _check;
["Grenade muzzle matches engine compatibility", _grenades isNotEqualTo [] && { (compatibleMagazines [_weapon, _grenadeMuzzle]) findIf { !(_x in _grenades) } isEqualTo -1 }] call _check;
["Grenade rounds cannot become the rifle's primary magazine", _primary arrayIntersect _grenades isEqualTo []] call _check;
["All-muzzle lookup includes bullets and grenades", (_primary + _grenades) findIf { !(_x in _allMags) } isEqualTo -1] call _check;
["Magazine-well-only fixture is present", count _wellOnly > 0] call _check;
private _wellWeapon = configName (_wellOnly # 0);
private _wellMagazines = [_wellWeapon] call OT_fnc_weaponMagazines;
["Magazine-well-only weapon receives ammunition", _wellMagazines isNotEqualTo [] && { (compatibleMagazines [_wellWeapon, "this"]) findIf { !(_x in _wellMagazines) } isEqualTo -1 }] call _check;

private _rpc = missionConfigFile >> "CfgRemoteExec";
["All mod-declared RPCs survive mission overrides", _missingRPC isEqualTo []] call _check;
["Imported RPC restrictions and JIP flags are retained", _globalFunctions findIf {
    private _from = _x;
    private _to = _rpc >> "Functions" >> configName _from;
    ["allowedTargets", "jip"] findIf { getNumber (_from >> _x) isNotEqualTo getNumber (_to >> _x) } isNotEqualTo -1
} isEqualTo -1] call _check;
["Functions and commands remain whitelisted", getNumber (_rpc >> "Functions" >> "mode") isEqualTo 1 && { getNumber (_rpc >> "Commands" >> "mode") isEqualTo 1 }] call _check;
["Economy RPCs remain server-only", ["OT_fnc_processFunds", "OT_fnc_processSale", "OT_fnc_processRefuel", "OT_fnc_processCommander"] findIf { getNumber (_rpc >> "Functions" >> _x >> "allowedTargets") isNotEqualTo 2 } isEqualTo -1] call _check;
["Own RPCs retain their explicit JIP settings", getNumber (_rpc >> "Functions" >> "OT_fnc_initBuilding" >> "jip") isEqualTo 0 && { getNumber (_rpc >> "Functions" >> "OT_fnc_updateAttached" >> "jip") isEqualTo 1 }] call _check;
["No arbitrary code execution is exposed", ["call", "spawn", "compile", "execVM"] findIf { isClass (_rpc >> "Commands" >> _x) || { isClass (_rpc >> "Functions" >> _x) } } isEqualTo -1] call _check;
{
    _x params ["_rhs", "_compat"];
    private _loaded = isClass (configFile >> "CfgPatches" >> _rhs);
    private _cfg = configFile >> "CfgPatches" >> _compat;
    [_compat + " tracks the loaded ACE version", (isClass _cfg) isEqualTo _loaded && { !_loaded || { getArray (_cfg >> "versionAr") isEqualTo getArray (configFile >> "CfgPatches" >> "ace_main" >> "versionAr") } }] call _check;
} forEach [["rhs_main", "ace_compat_rhs_afrf3"], ["rhsusf_main", "ace_compat_rhs_usf3"], ["rhsgref_main", "ace_compat_rhs_gref3"], ["rhssaf_main", "ace_compat_rhs_saf3"]];

private _group = createGroup west;
_group setVariable ["lambs_danger_disableGroupAI", true];
private _unit = _group createUnit ["B_soldier_AR_F", [4100, 4100, 0], [], 0, "NONE"];
_unit disableAI "ALL";
private _input = getUnitLoadout _unit;
private _output = [_input] call OT_fnc_randomizeLoadout;
_unit setUnitLoadout _output;
private _actual = getUnitLoadout _unit;
["Automatic rifleman retains a machine gun", (primaryWeapon _unit) in OT_allBLUMachineGuns] call _check;
["Randomized machine gun has compatible loaded ammunition", ((_actual # 0) # 4) isNotEqualTo [] && { (((_actual # 0) # 4) # 0) in ([primaryWeapon _unit] call OT_fnc_weaponMagazines) }] call _check;

private _grenadier = _group createUnit [if (_rhsPresent) then { "rhsusf_army_ocp_grenadier" } else { "B_Soldier_GL_F" }, [4102, 4100, 0], [], 0, "NONE"];
_grenadier disableAI "ALL";
private _grenadeInput = getUnitLoadout _grenadier;
private _grenadeOutput = [_grenadeInput, [_weapon], [_weapon]] call OT_fnc_randomizeLoadout;
private _loadedGrenade = (_grenadeOutput # 0) # 5;
["Replacement grenade rifle retains a compatible loaded grenade", _loadedGrenade isNotEqualTo [] && { (_loadedGrenade # 0) in _grenades }] call _check;
_grenadier setUnitLoadout _grenadeOutput;
private _grenadeActual = (getUnitLoadout _grenadier) # 0;
["Engine accepts both muzzles of the replacement grenade rifle", (_grenadeActual # 4) isNotEqualTo [] && { ((_grenadeActual # 4) # 0) in _primary } && { (_grenadeActual # 5) isNotEqualTo [] } && { ((_grenadeActual # 5) # 0) in _grenades }] call _check;
deleteVehicle _grenadier;

// Force a modern magazine-well-only launcher through the real loadout path.
_input set [1, [_wellWeapon, "", "", "", [], [], ""]];
_output = [_input, OT_allBLURifles, OT_allBLUGLRifles, OT_allBLUMachineGuns, OT_allBLUSniperRifles, [_wellWeapon]] call OT_fnc_randomizeLoadout;
["Magazine-well-only launcher loadout is populated", ((_output # 1) # 4) isNotEqualTo [] && { (((_output # 1) # 4) # 0) in _wellMagazines }] call _check;
_unit setUnitLoadout _output;
_actual = getUnitLoadout _unit;
["Engine accepts magazine-well-only launcher ammunition", ((_actual # 1) # 4) isNotEqualTo [] && { (((_actual # 1) # 4) # 0) in _wellMagazines }] call _check;
if (_rhsPresent) then {
    ["RHS machine guns enter the equipment pool", OT_allBLUMachineGuns findIf { "rhs_" in _x } isNotEqualTo -1] call _check;
    ["RHS grenade rifles are detected by muzzles", OT_allBLUGLRifles findIf { "rhs_" in _x && { !("_GL_" in _x) } } isNotEqualTo -1] call _check;
    private _disposable = "rhs_weap_m72a7";
    private _disposableMagazines = [_disposable] call OT_fnc_weaponMagazines;
    ["RHS disposable launcher retains its hidden loaded magazine", _disposableMagazines isNotEqualTo [] && { getNumber (configFile >> "CfgMagazines" >> (_disposableMagazines # 0) >> "scope") < 2 }] call _check;
    _output = [_input, OT_allBLURifles, OT_allBLUGLRifles, OT_allBLUMachineGuns, OT_allBLUSniperRifles, [_disposable]] call OT_fnc_randomizeLoadout;
    ["RHS disposable loadout is loaded without spare backpack rockets", (((_output # 1) # 4) # 0) in _disposableMagazines && { (_output # 5) isEqualTo [] }] call _check;
};
deleteVehicle _unit;
deleteGroup _group;
{ diag_log ["OT_MOD_AUDIT_ROW", _x] } forEach _data;
diag_log format ["OVERTHROW_MOD_INTEGRATION_PASSED=%1", _passed];
diag_log "OT_MOD_AUDIT_FINISHED";
