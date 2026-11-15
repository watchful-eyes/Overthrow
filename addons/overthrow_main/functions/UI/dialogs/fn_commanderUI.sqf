// Modified/added for the unofficial Garrison and Command Expansion, 14-16 November 2026.
// Original author/copyright notices are retained; see LICENSE.md (GNU GPL v2).
disableSerialization;
params [["_mode", "open"], ["_args", []]];
if (!hasInterface || { isRemoteExecuted && { remoteExecutedOwner != 2 } }) exitWith {};
if (_mode isEqualTo "open") exitWith {
    if !(call OT_fnc_playerIsGeneral) exitWith { "Only a general can manage commanders." call OT_fnc_notifyMinor };
    private _town = player call OT_fnc_nearestTown;
    if !(_town in (server getVariable ["NATOabandoned", []])) exitWith { "A friendly-controlled town is required." call OT_fnc_notifyMinor };
    closeDialog 0;
    createDialog "OT_dialog_commanders";
    private _display = findDisplay 9220;
    _display setVariable ["town", _town];
    private _scope = _display displayCtrl 2100;
    { private _i = _scope lbAdd (_x # 0); _scope lbSetData [_i, _x # 1] } forEach [["Town commander", "TOWN"], ["Regional general", "REGION"]];
    _scope lbSetCurSel 0;
    ["refresh"] call OT_fnc_commanderUI;
};
private _display = findDisplay 9220;
if (isNull _display) exitWith {};
private _town = _display getVariable ["town", ""];
private _scope = _display displayCtrl 2100;
private _kind = _scope lbData lbCurSel _scope;
switch (_mode) do {
    case "refresh": {
        if (_display getVariable ["pending", false]) exitWith {};
        private _target = if (_kind isEqualTo "TOWN") then { _town } else { server getVariable ["region_" + _town, ""] };
        private _details = _args param [0, []];
        if (_details isEqualTo []) then { _details = [_kind, _target] call OT_fnc_commanderDetails };
        _display setVariable ["details", _details];
        { (_display displayCtrl _x) ctrlEnable false } forEach [1600, 1601, 1602];
        if (_details isEqualTo []) exitWith { (_display displayCtrl 1101) ctrlSetStructuredText parseText "No valid region is configured for this town." };
        _details params ["_label", "_population", "_title", "", "_price", "_record"];
        private _person = "Unassigned";
        private _headquarters = _town;
        private _status = "Available for recruitment";
        if (_record isNotEqualTo []) then {
            _person = (_record # 3) # 0;
            _headquarters = _record # 2;
            _status = ["Headquarters is not friendly-controlled; assignment suspended", "On duty"] select (_headquarters in (server getVariable ["NATOabandoned", []]));
        };
        (_display displayCtrl 1100) ctrlSetText format ["%1 / COMMAND", _label];
        (_display displayCtrl 1101) ctrlSetStructuredText parseText format ["<t size='1.45' color='#6ee7b7'>%1</t><br/><br/>Population: %2<br/>Hiring cost: $%3<br/><br/>Commander: %4<br/>Headquarters: %5<br/>Status: %6", _title, _population, _price, _person, _headquarters, _status];
        private _friendly = _town in (server getVariable ["NATOabandoned", []]);
        (_display displayCtrl 1600) ctrlEnable (_friendly && { _record isEqualTo [] });
        (_display displayCtrl 1601) ctrlEnable (_friendly && { _record isNotEqualTo [] });
        (_display displayCtrl 1602) ctrlEnable (_friendly && { _kind isEqualTo "REGION" } && { _record isNotEqualTo [] } && { _headquarters isNotEqualTo _town });
    };
    case "hire";
    case "dismiss";
    case "relocate": {
        if (_display getVariable ["pending", false]) exitWith {};
        private _details = _display getVariable ["details", []];
        if (_details isEqualTo []) exitWith {};
        private _request = diag_tickTime;
        _display setVariable ["request", _request];
        _display setVariable ["pending", true];
        { (_display displayCtrl _x) ctrlEnable false } forEach [1600, 1601, 1602, 1603, 2100];
        (_display displayCtrl 1102) ctrlSetText "Request sent to the server...";
        [player, _mode, _kind, _town, _details # 6, _details # 4, _request] remoteExecCall ["OT_fnc_processCommander", 2];
        [{ ["timeout", _this] call OT_fnc_commanderUI }, [_request], 15] call CBA_fnc_waitAndExecute;
    };
    case "response": {
        _args params ["_responseTown", "_responseKind", "_request", "", "_message", ["_serverDetails", [], [[]]]];
        if (_responseTown isNotEqualTo _town || { _responseKind isNotEqualTo _kind } || { _request isNotEqualTo (_display getVariable ["request", -1]) }) exitWith {};
        _display setVariable ["pending", false];
        { (_display displayCtrl _x) ctrlEnable true } forEach [1603, 2100];
        ["refresh", [_serverDetails]] call OT_fnc_commanderUI;
        (_display displayCtrl 1102) ctrlSetText _message;
    };
    case "timeout": {
        if (!(_display getVariable ["pending", false]) || { (_args # 0) isNotEqualTo (_display getVariable ["request", -1]) }) exitWith {};
        _display setVariable ["pending", false];
        _display setVariable ["request", -1];
        { (_display displayCtrl _x) ctrlEnable true } forEach [1603, 2100];
        ["refresh"] call OT_fnc_commanderUI;
        (_display displayCtrl 1102) ctrlSetText "No response received. Press Refresh before submitting another request.";
    };
};
