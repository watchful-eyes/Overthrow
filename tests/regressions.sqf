// Modified/added for the unofficial Garrison and Command Expansion, 14-16 November 2026.
// Original author/copyright notices are retained; see LICENSE.md (GNU GPL v2).
// Run against the actual source functions, using SQF-VM (see tests/README.md).
OT_fnc_mergePlayerArmy = compile preprocessFileLineNumbers "\overthrow_main\functions\save\fn_mergePlayerArmy.sqf";
OT_fnc_mergeRecruitables = compile preprocessFileLineNumbers "\overthrow_main\functions\save\fn_mergeRecruitables.sqf";
OT_fnc_serializeSquads = compile preprocessFileLineNumbers "\overthrow_main\functions\save\fn_serializeSquads.sqf";
OT_fnc_removeWeaponStock = compile preprocessFileLineNumbers "\overthrow_main\functions\inventory\fn_removeWeaponStock.sqf";
OT_fnc_nearestWarehouse = compile preprocessFileLineNumbers "\overthrow_main\functions\geography\fn_nearestWarehouse.sqf";
// The fixtures use base class names, so no Arma config database is needed here.
private _originalBaseWeapon = missionNamespace getVariable ["BIS_fnc_baseWeapon", {}];
private _originalSortBy = missionNamespace getVariable ["BIS_fnc_sortBy", {}];
BIS_fnc_baseWeapon = { _this };

private _passed = 0;
private _check = {
    params ["_name", "_condition"];
    if (!_condition) then { throw format ["FAIL: %1", _name] };
    _passed = _passed + 1;
    diag_log format ["PASS: %1", _name];
};
private _units = [["I_soldier_F", [10, 20, 0], ["saved loadout"]]];
private _a = ["A", "squad", "saved", +_units, "Alpha"];
private _b = ["B", "squad", "saved", +_units, "Bravo"];
private _initial = [_a, _b];
private _activeA = ["A", "squad", "active A", [], "Alpha"];
private _activeB = ["B", "squad", "active B", [], "Bravo"];
private _afterA = [_initial, "A", [_activeA]] call OT_fnc_mergePlayerArmy;
["A connects without deleting B's offline soldiers", (_afterA # 0) isEqualTo _b] call _check;
private _afterB = [_afterA, "B", [_activeB]] call OT_fnc_mergePlayerArmy;
["B connects without reverting A", _activeA in _afterB && { _activeB in _afterB }] call _check;
private _reverse = [[_initial, "B", [_activeB]] call OT_fnc_mergePlayerArmy, "A", [_activeA]] call OT_fnc_mergePlayerArmy;
["Both connection orders preserve both groups", _activeA in _reverse && { _activeB in _reverse }] call _check;
["Original army snapshot is unchanged", _initial isEqualTo [_a, _b]] call _check;
private _extra = ["A", "second squad", "active A2", [], "Alpha 2"];
private _appended = [_afterB, "A", [_extra], false] call OT_fnc_mergePlayerArmy;
["Recruitment appends without replacing other squads", count _appended isEqualTo 3 && { _activeB in _appended } && { _activeA in _appended }] call _check;

private _recruit = ["B", "Recruit", [10, 20, 0], "SERGEANT", [], "I_soldier_F", 850];
private _recruits = [[_recruit], "A", [], true] call OT_fnc_mergePlayerArmy;
["Offline recruit keeps experience", ((_recruits # 0) # 6) isEqualTo 850] call _check;
private _serialized = [_b] call OT_fnc_serializeSquads;
["Saving before B connects keeps soldiers and group name", count _serialized isEqualTo 1 && { ((_serialized # 0) # 3) isEqualTo _units } && { ((_serialized # 0) # 4) isEqualTo "Bravo" }] call _check;
private _serializedAgain = _serialized call OT_fnc_serializeSquads;
["Offline squad survives repeated save cycles", _serializedAgain isEqualTo _serialized] call _check;
private _legacySquad = [["B", "legacy squad", "saved", +_units]] call OT_fnc_serializeSquads;
["Older squad records get a usable fallback name", ((_legacySquad # 0) # 4) isEqualTo "legacy squad"] call _check;

private _defaults = [["rifleman", ["default rifle"]], ["medic", ["default medical"]]];
private _saved = [["rifleman", ["custom rifle"]], ["new AT", ["custom launcher"]], ["new AA", ["custom missile"]]];
private _merged = [_defaults, _saved] call OT_fnc_mergeRecruitables;
["Existing recruit template is restored", (_merged # 0) isEqualTo (_saved # 0)] call _check;
["Every missing template is appended after an existing match", count _merged isEqualTo 4 && { (_saved # 1) in _merged } && { (_saved # 2) in _merged }] call _check;
["Unmodified defaults stay available", (_defaults # 1) in _merged] call _check;
["Template merge does not change defaults in place", ((_defaults # 0) # 1) isEqualTo ["default rifle"]] call _check;
private _duplicate = [_defaults, [["rifleman", ["first"]], ["rifleman", ["last"]]]] call OT_fnc_mergeRecruitables;
["Duplicate saved templates update rather than duplicate", count _duplicate isEqualTo 2 && { ((_duplicate # 0) # 1) isEqualTo ["last"] }] call _check;

private _weapon = ["arifle_MX_F", "muzzle_snds_H", "acc_pointer_IR", "optic_Aco", ["30Rnd_65x39_caseless_mag", 17], [], "bipod_01_F_blk"];
private _changed = [_weapon, "optic_Aco"] call OT_fnc_removeWeaponStock;
["Selling an optic removes only the optic", _changed && { (_weapon # 3) isEqualTo "" } && { (_weapon # 1) isEqualTo "muzzle_snds_H" } && { (_weapon # 4) isEqualTo ["30Rnd_65x39_caseless_mag", 17] }] call _check;
_changed = [_weapon, "30Rnd_65x39_caseless_mag"] call OT_fnc_removeWeaponStock;
["Selling loaded magazine preserves other attachments", _changed && { (_weapon # 4) isEqualTo [] } && { (_weapon # 6) isEqualTo "bipod_01_F_blk" }] call _check;
private _before = +_weapon;
_changed = [_weapon, "missing item"] call OT_fnc_removeWeaponStock;
["Missing stock produces no removal or inventory changes", !_changed && { _weapon isEqualTo _before }] call _check;
_changed = [_weapon, "arifle_MX_F"] call OT_fnc_removeWeaponStock;
["Selling weapon removes one weapon entry", _changed && { _weapon isEqualTo [] }] call _check;
["Empty weapon cannot be sold twice", !([_weapon, "arifle_MX_F"] call OT_fnc_removeWeaponStock)] call _check;

warehouse_shared = "Land_HelipadEmpty_F" createVehicle [0, 0, 0];
warehouse = "Land_HelipadEmpty_F" createVehicle [0, 0, 0];
private _physical = "Land_HelipadEmpty_F" createVehicle [10, 20, 0];
OT_warehouseLocationCache = createHashMap;
OT_warehouseLocationCache set [[10, 20], _physical];
["Unshared warehouse resolves to its physical inventory", ([[10, 20]] call OT_fnc_nearestWarehouse) isEqualTo _physical] call _check;
_physical setVariable ["is_shared", true];
["Same cached position switches to shared inventory immediately", ([[10, 20]] call OT_fnc_nearestWarehouse) isEqualTo warehouse_shared] call _check;
["Save and upgrade can still resolve physical warehouse", ([[10, 20], false] call OT_fnc_nearestWarehouse) isEqualTo _physical] call _check;
warehouse setVariable ["owned", [_physical]];
BIS_fnc_sortBy = { _this # 0 }; // One candidate: sorting cannot change the result.
["Shared warehouse still obeys distance limit", isNull ([[10000, 10000]] call OT_fnc_nearestWarehouse)] call _check;

OT_fnc_townGarrisonLayout = compile preprocessFileLineNumbers "\overthrow_main\functions\garrison\fn_townGarrisonLayout.sqf";
private _company = ["a", "Alpha", 4, [[5100, 5000], [5200, 5100]], "LIMITED", "PATROL"];
private _bad = +_company;
private _layout = [[_company], 2] call OT_fnc_townGarrisonLayout;
["Company plan cannot create extra soldiers", count _layout isEqualTo 1 && { ((_layout # 0) # 1) isEqualTo 2 }] call _check;
["Shortages do not overwrite desired company strength", (((_layout # 0) # 0) # 2) isEqualTo 4 && { (_company # 2) isEqualTo 4 }] call _check;
_layout = [[_company], 7] call OT_fnc_townGarrisonLayout;
["Unassigned personnel form a reserve patrol", count _layout isEqualTo 2 && { ((_layout # 1) # 1) isEqualTo 3 }] call _check;
_layout = [[], 9] call OT_fnc_townGarrisonLayout;
["Default patrols allocate the whole garrison", (_layout apply { _x # 1 }) isEqualTo [4, 4, 1]] call _check;
["Empty city creates no groups", ([[_company], 0] call OT_fnc_townGarrisonLayout) isEqualTo []] call _check;
_bad = +_company; _bad set [0, "reserve_1"];
_layout = [[_bad], 8] call OT_fnc_townGarrisonLayout;
["Reserve IDs do not collide with saved companies", (((_layout # 1) # 0) # 0) isNotEqualTo "reserve_1"] call _check;

BIS_fnc_baseWeapon = _originalBaseWeapon;
BIS_fnc_sortBy = _originalSortBy;
diag_log format ["OVERTHROW_REGRESSIONS_PASSED=%1", _passed];
