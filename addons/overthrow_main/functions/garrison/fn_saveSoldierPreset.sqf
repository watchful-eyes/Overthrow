// Modified/added for the unofficial Garrison and Command Expansion, 14-16 November 2026.
// Original author/copyright notices are retained; see LICENSE.md (GNU GPL v2).
if (!isServer) exitWith { false };
params [["_actor", objNull, [objNull]], ["_preset", "", [""]], ["_loadout", [], [[]]], ["_expected", [], [[]]]];
if (isNull _actor || { isRemoteExecuted && { remoteExecutedOwner != 2 } && { remoteExecutedOwner != owner _actor || { !isPlayer _actor } } }) exitWith { false };
private _success = false;
private _message = "";
call {
    if !([false] call OT_fnc_isServerController) exitWith { _message = "Only a general can edit presets." };
    if !([_loadout] call OT_fnc_validateSoldierPreset) exitWith { _message = "Invalid or unsupported loadout data." };
    private _soldier = _preset call OT_fnc_getSoldier;
    if (_soldier isEqualTo []) exitWith { _message = "Soldier preset not found." };
    if ((_soldier # 2) isNotEqualTo _expected) exitWith { _message = "This preset was changed by another general. Reopen the editor." };
    if (_preset isEqualTo "Police") then {
        server setVariable ["OT_policePreset", +_loadout];
        server setVariable ["OT_policePresetView", +_loadout, true];
        OT_Loadout_Police = +_loadout;
        publicVariable "OT_Loadout_Police";
    } else {
        private _records = +([] call OT_fnc_recruitPresets);
        private _index = _records findIf { (_x # 0) isEqualTo _preset };
        if (_index >= 0) then { _records set [_index, [_preset, +_loadout]]; [_records, true] call OT_fnc_recruitPresets };
    };
    private _label = if (_preset isEqualTo "Police") then { "Police" } else { [_preset] call OT_fnc_soldierPresetName };
    [_label, _loadout] remoteExecCall ["ace_arsenal_fnc_addDefaultLoadout", 0];
    _message = "Soldier preset saved. It will be used for future recruits and town garrison respawns.";
    _success = true;
};
_message remoteExecCall ["OT_fnc_notifyMinor", _actor];
_success;
