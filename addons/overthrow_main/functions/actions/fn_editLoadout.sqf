// Modified/added for the unofficial Garrison and Command Expansion, 14-16 November 2026.
// Original author/copyright notices are retained; see LICENSE.md (GNU GPL v2).
// Edit a named template on a disposable local preview; only the server saves it.
if (!hasInterface) exitWith {};
params [["_preset", "", [""]]];
if !(call OT_fnc_playerIsGeneral) exitWith { "Only a general can edit presets." call OT_fnc_notifyMinor };
if (_preset isEqualTo "") then { _preset = lbData [1500, lbCurSel 1500] };
private _soldier = [_preset, player, false] call OT_fnc_getSoldier;
if (_soldier isEqualTo []) exitWith { "Soldier preset not found." call OT_fnc_notifyMinor };
private _expected = +(_soldier # 2);
private _class = if (_preset isEqualTo "Police") then { OT_Unit_Police } else { _preset };
if (!isClass (configFile >> "CfgVehicles" >> _class)) exitWith {};
private _items = +(_soldier # 4);
private _warehouse = [player] call OT_fnc_nearestWarehouse;
if (!isNull _warehouse) then {
    {
        if (_x select [0, 5] isEqualTo "item_") then {
            private _entry = _warehouse getVariable [_x, []];
            if (_entry isEqualType [] && { count _entry >= 2 } && { (_entry # 1) > 0 }) then { _items pushBackUnique (_entry # 0) };
        };
    } forEach allVariables _warehouse;
};
closeDialog 0;
private _group = createGroup [independent, true];
_group setVariable ["lambs_danger_disableGroupAI", true];
private _start = (getPosATL player) findEmptyPosition [3, 30, _class];
if (_start isEqualTo []) then { _start = getPosATL player };
private _unit = _group createUnit [_class, _start, [], 0, "NONE"];
if (isNull _unit) exitWith { deleteGroup _group };
[_unit] joinSilent _group;
_unit allowDamage false;
_unit setCaptive true;
_unit disableAI "ALL";
_unit setVariable ["lambs_danger_disableAI", true];
_unit setUnitLoadout [_expected, false];
[_unit, true, false] call ace_arsenal_fnc_removeVirtualItems;
[_unit, _items, false] call ace_arsenal_fnc_addVirtualItems;
[
    "ace_arsenal_displayClosed",
    {
        _thisArgs params ["_unit", "_preset", "_expected"];
        if (!isNull _unit) then {
            [player, _preset, getUnitLoadout _unit, _expected] remoteExecCall ["OT_fnc_saveSoldierPreset", 2];
            deleteVehicle _unit;
        };
        [_thisType, _thisId] call CBA_fnc_removeEventHandler;
    },
    [_unit, _preset, _expected]
] call CBA_fnc_addEventHandlerArgs;
[_unit, _unit] call ace_arsenal_fnc_openBox;
