// Modified/added for the unofficial Garrison and Command Expansion, 14-16 November 2026.
// Original author/copyright notices are retained; see LICENSE.md (GNU GPL v2).
disableSerialization;
if (!hasInterface) exitWith {};
if (isRemoteExecuted) exitWith {
    if (remoteExecutedOwner != 2) exitWith {};
    params ["_message", "_success"];
    private _display = findDisplay 9240;
    if (isNull _display) exitWith { _message call OT_fnc_notifyMinor };
    _display setVariable ["pending", false];
   (_display displayCtrl 1105) ctrlSetText (_message call OT_fnc_localizeText);
    ["select"] call OT_fnc_garrisonPresetUI;
};
params [["_mode", "open", [""]], ["_args", []]];
if (_mode isEqualTo "open") exitWith {
    _args params [["_kind", "BASE"], ["_town", ""]];
    closeDialog 0;
    createDialog "OT_dialog_garrisonPresets";
    private _display = findDisplay 9240;
    _display setVariable ["kind", _kind];
    _display setVariable ["town", _town];
   (_display displayCtrl 1100) ctrlSetText ((if (_kind isEqualTo "TOWN") then { "TOWN GARRISON / " + _town } else { "BASE GARRISON / SOLDIER PRESETS" }) call OT_fnc_localizeText);
    ["list"] call OT_fnc_garrisonPresetUI;
};
private _display = findDisplay 9240;
if (isNull _display) exitWith {};
private _list = _display displayCtrl 1500;
switch (_mode) do {
    case "list": {
        private _selected = _list lbData lbCurSel _list;
        private _filter = toLowerANSI ctrlText (_display displayCtrl 1400);
        lbClear _list;
        private _classes = ([] call OT_fnc_recruitPresets) apply { _x # 0 };
        if ((_display getVariable ["kind", "BASE"]) isEqualTo "TOWN") then { _classes = ["Police"] + _classes };
        private _index = 0;
        {
            if (_x isNotEqualTo "Police" && { !isClass (configFile >> "CfgVehicles" >> _x) }) then { continue };
            private _label = [_x] call OT_fnc_soldierPresetName;
            if (_filter isNotEqualTo "" && { !(_filter in toLowerANSI (_label + " " + _x)) }) then { continue };
            private _row = _list lbAdd (_label call OT_fnc_localizeText);
            _list lbSetData [_row, _x];
            if (_x isEqualTo _selected) then { _index = _row };
        } forEach _classes;
        _list lbSetCurSel _index;
        ["select"] call OT_fnc_garrisonPresetUI;
    };
    case "select": {
        private _class = _list lbData lbCurSel _list;
        private _soldier = [_class, player, false] call OT_fnc_getSoldier;
        private _valid = _soldier isNotEqualTo [];
        { (_display displayCtrl _x) ctrlEnable (_valid && { !(_display getVariable ["pending", false]) }) } forEach [1600,1601,1602];
       (_display displayCtrl 1603) ctrlEnable (_valid && { call OT_fnc_playerIsGeneral });
        if (!_valid) exitWith { (_display displayCtrl 1101) ctrlSetStructuredText parseText ("No matching presets found." call OT_fnc_localizeText) };
        _display setVariable ["price", _soldier # 0];
        private _primary = ((_soldier # 2) # 0) param [0, ""];
        private _weapon = getText (configFile >> "CfgWeapons" >> _primary >> "displayName");
       (_display displayCtrl 1101) ctrlSetStructuredText parseText (format ["<t color='#6ee7b7' size='1.25'>%1</t><br/><br/>Per soldier: $%2<br/>Weapon: %3<br/><br/>Equipment is included in the recruitment price.<br/>Editing requires general authority.<br/>Changes apply to future recruits and town garrison respawns.", [_class] call OT_fnc_soldierPresetName, _soldier # 0, _weapon] call OT_fnc_localizeText);
    };
    case "hire": {
        if (_display getVariable ["pending", false]) exitWith {};
        private _class = _list lbData lbCurSel _list;
        if (_class isEqualTo "") exitWith {};
        private _amount = _args;
        _display setVariable ["pending", true];
        ["select"] call OT_fnc_garrisonPresetUI;
        [player, _display getVariable "kind", _display getVariable "town", _class, _amount, (_display getVariable ["price", -1]) * _amount] remoteExecCall ["OT_fnc_processGarrisonPreset", 2];
    };
    case "edit": { [_list lbData lbCurSel _list] call OT_fnc_editLoadout };
};
