// Added 16 November 2026 for the community fork. GNU GPL v2.
disableSerialization;
params [["_mode", "open"], ["_args", []]];
if (!hasInterface || { isMultiplayer && { isRemoteExecuted } && { remoteExecutedOwner isNotEqualTo 2 } }) exitWith {};
if (_mode isEqualTo "open") exitWith {
    if !(isServer || { call BIS_fnc_admin isEqualTo 2 }) exitWith { "Only the host or a logged-in server admin can use admin tools." call OT_fnc_notifyMinor };
    closeDialog 0;
    createDialog "OT_dialog_adminCheats";
    private _display = findDisplay 9250;
    _display setVariable ["loading", true];
    {
        _x params ["_idc", "_items"];
        private _combo = _display displayCtrl _idc;
        { private _index = _combo lbAdd ((_x # 0) call OT_fnc_localizeText); _combo lbSetData [_index, _x # 1] } forEach _items;
        _combo lbSetCurSel 0;
    } forEach [[2101, [["Player money", "money"], ["Influence", "influence"], ["Resistance funds", "funds"]]], [2102, [["Add", "add"], ["Set", "set"], ["Subtract", "subtract"]]]];
    _display setVariable ["loading", false];
    ["refresh"] call OT_fnc_adminCheatUI;
};
private _display = findDisplay 9250;
if (isNull _display || { _display getVariable ["loading", false] }) exitWith {};
private _feedback = {
    params ["_message"];
    (_display displayCtrl 1101) ctrlSetStructuredText parseText (_message call OT_fnc_localizeText);
};
private _enable = {
    private _pending = _display getVariable ["pending", false];
    private _uncertain = _display getVariable ["uncertain", false];
    { (_display displayCtrl _x) ctrlEnable (!_pending && { !_uncertain }) } forEach [1600, 1602, 2100, 2101, 2102, 1400, 1610, 1611, 1612];
    (_display displayCtrl 1601) ctrlEnable (!_pending);
    private _resource = _display displayCtrl 2101;
    if ((_resource lbData lbCurSel _resource) isEqualTo "funds") then { (_display displayCtrl 2100) ctrlEnable false };
};
switch (_mode) do {
    case "amount": { if !(_display getVariable ["pending", false] || { _display getVariable ["uncertain", false] }) then { (_display displayCtrl 1400) ctrlSetText str (_args # 0) } };
    case "refresh";
    case "selection";
    case "apply": {
        if (_display getVariable ["pending", false]) exitWith {};
        if (_mode isNotEqualTo "refresh" && { _display getVariable ["uncertain", false] }) exitWith {};
        if !(isServer || { call BIS_fnc_admin isEqualTo 2 }) exitWith { ["Only the host or a logged-in server admin can use admin tools."] call _feedback };
        private _players = _display displayCtrl 2100;
        if (_mode isEqualTo "refresh") then {
            private _selected = _players lbData lbCurSel _players;
            if (_selected isEqualTo "") then { _selected = getPlayerUID player };
            _display setVariable ["loading", true];
            lbClear _players;
            private _selection = 0;
            {
                private _index = _players lbAdd name _x;
                _players lbSetData [_index, getPlayerUID _x];
                if (getPlayerUID _x isEqualTo _selected) then { _selection = _index };
            } forEach ([] call CBA_fnc_players);
            _players lbSetCurSel _selection;
            _display setVariable ["loading", false];
        };
        private _operation = "read";
        private _amount = 0;
        private _valid = true;
        if (_mode isEqualTo "apply") then {
            private _text = (ctrlText (_display displayCtrl 1400)) regexReplace ["^\s+|\s+$/g", ""];
            // Validate the decimal text before parsing: 1000000001 rounds to
            // 1000000000 as an Arma scalar and must still be rejected.
            _valid = count _text <= 10 && { (_text regexFind ["^([0-9]{1,9}|0[0-9]{9}|1000000000)$"]) isNotEqualTo [] };
            if (_valid) then { _amount = parseNumber _text; _valid = finite _amount && { _amount <= 1000000000 } };
            private _operations = _display displayCtrl 2102;
            _operation = _operations lbData lbCurSel _operations;
        };
        if (!_valid) exitWith { ["Enter a whole number from 0 to 1,000,000,000."] call _feedback };
        private _resources = _display displayCtrl 2101;
        private _resource = _resources lbData lbCurSel _resources;
        private _request = (missionNamespace getVariable ["OT_adminCheatRequestID", 0]) + 1;
        missionNamespace setVariable ["OT_adminCheatRequestID", _request];
        _display setVariable ["request", _request];
        _display setVariable ["pending", true];
        call _enable;
        ["Request sent to the server..."] call _feedback;
        [player, _players lbData lbCurSel _players, _resource, _operation, _amount, _request] remoteExecCall ["OT_fnc_processAdminCheat", 2];
        [{ ["timeout", _this] call OT_fnc_adminCheatUI }, [_request], 15] call CBA_fnc_waitAndExecute;
    };
    case "response": {
        _args params ["_request", "_success", "_message", "", "_snapshot", "_operation"];
        if (_request isNotEqualTo (_display getVariable ["request", -1])) exitWith {};
        _display setVariable ["pending", false];
        if (_success) then {
            _display setVariable ["uncertain", false];
            _display setVariable ["snapshot", _snapshot];
            private _values = (_snapshot select [1, 3]) apply { [_x, 1, 0, true] call CBA_fnc_formatNumber };
            (_display displayCtrl 1100) ctrlSetStructuredText parseText (format ["Player money: $%1<br/>Influence: %2<br/>Resistance funds: $%3", _values # 0, _values # 1, _values # 2] call OT_fnc_localizeText);
        };
        [_message] call _feedback;
        call _enable;
    };
    case "timeout": {
        if (!(_display getVariable ["pending", false]) || { (_args # 0) isNotEqualTo (_display getVariable ["request", -1]) }) exitWith {};
        _display setVariable ["pending", false];
        _display setVariable ["uncertain", true];
        _display setVariable ["request", -1];
        call _enable;
        ["Request status unknown. Refresh balances before retrying."] call _feedback;
    };
};
