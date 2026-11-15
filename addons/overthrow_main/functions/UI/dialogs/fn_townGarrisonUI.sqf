// Modified/added for the unofficial Garrison and Command Expansion, 14-16 November 2026.
// Original author/copyright notices are retained; see LICENSE.md (GNU GPL v2).
disableSerialization;
params [["_mode", "open"], ["_args", []]];
if (!hasInterface || { isRemoteExecuted && { remoteExecutedOwner != 2 } }) exitWith {};
if (_mode isEqualTo "open") exitWith {
    if !(call OT_fnc_playerIsGeneral) exitWith { "Only a general can manage the garrison." call OT_fnc_notifyMinor };
    private _town = player call OT_fnc_nearestTown;
    if !(_town in (server getVariable ["NATOabandoned", []])) exitWith { "This town is not under friendly control." call OT_fnc_notifyMinor };
    closeDialog 0;
    createDialog "OT_dialog_townGarrison";
    private _display = findDisplay 9210;
    _display setVariable ["town", _town];
    _display setVariable ["center", server getVariable _town];
    _display setVariable ["station", server getVariable [format ["policepos%1", _town], server getVariable _town]];
    _display setVariable ["loading", true];
    _display setVariable ["selected", -1];
    { private _i = (_display displayCtrl 2100) lbAdd (_x # 0); (_display displayCtrl 2100) lbSetData [_i, _x # 1] } forEach [["Limited", "LIMITED"], ["Normal", "NORMAL"], ["Full speed", "FULL"]];
    { private _i = (_display displayCtrl 2101) lbAdd (_x # 0); (_display displayCtrl 2101) lbSetData [_i, _x # 1] } forEach [["Automatic patrol", "AUTO"], ["Custom route (loop)", "PATROL"], ["Hold position", "HOLD"]];
    (_display displayCtrl 1100) ctrlSetText format ["%1 - Friendly town garrison", _town];
    private _map = _display displayCtrl 51;
    _map ctrlMapAnimAdd [0, 0.08, _display getVariable "center"];
    ctrlMapAnimCommit _map;
    ["reload"] call OT_fnc_townGarrisonUI;
};
private _display = findDisplay 9210;
if (isNull _display) exitWith {};
private _town = _display getVariable ["town", ""];
private _draft = _display getVariable ["draft", []];
private _selected = _display getVariable ["selected", -1];
private _list = _display displayCtrl 1500;
private _feedback = _display displayCtrl 1102;
switch (_mode) do {
    case "reload": {
        _draft = +(server getVariable [format ["garrisonplan%1", _town], []]);
        if (_draft isEqualTo []) then {
            _draft = ([[], server getVariable [format ["police%1", _town], 0]] call OT_fnc_townGarrisonLayout) apply { _x # 0 };
        };
        _display setVariable ["draft", _draft];
        _display setVariable ["revision", server getVariable [format ["garrisonrevision%1", _town], 0]];
        _display setVariable ["pending", false];
        ["refresh", [0]] call OT_fnc_townGarrisonUI;
        _feedback ctrlSetText "Press Apply to save your changes.";
    };
    case "refresh": {
        _display setVariable ["loading", true];
        _display setVariable ["selected", -1];
        lbClear _list;
        { _list lbAdd format ["%1  (%2 troops / %3 points)", _x # 1, _x # 2, count (_x # 3)] } forEach _draft;
        private _index = (_args param [0, 0]) min (count _draft - 1);
        _list lbSetCurSel _index;
        _display setVariable ["loading", false];
        ["select", [_list, _index]] call OT_fnc_townGarrisonUI;
        (_display displayCtrl 1604) ctrlEnable true;
    };
    case "summary": {
        private _planned = 0;
        { _planned = _planned + (_x # 2) } forEach _draft;
        private _strength = server getVariable [format ["police%1", _town], 0];
        private _extra = [format ["Reserve personnel: %1", _strength - _planned], format ["Personnel shortage: %1", _planned - _strength]] select (_planned > _strength);
        (_display displayCtrl 1101) ctrlSetStructuredText parseText format ["Garrison: %1 troops / Planned: %2 troops<br/>%3", _strength, _planned, _extra];
    };
    case "edit": {
        if (_display getVariable ["loading", false] || { _display getVariable ["pending", false] } || { _selected < 0 } || { _selected >= count _draft }) exitWith {};
        private _entry = _draft # _selected;
        _entry set [1, ctrlText (_display displayCtrl 1400)];
        _entry set [2, parseNumber ctrlText (_display displayCtrl 1401)];
        { private _ctrl = _display displayCtrl (_x # 0); _entry set [_x # 1, _ctrl lbData lbCurSel _ctrl] } forEach [[2100, 4], [2101, 5]];
        _draft set [_selected, _entry];
        _display setVariable ["draft", _draft];
        _list lbSetText [_selected, format ["%1  (%2 troops / %3 points)", _entry # 1, _entry # 2, count (_entry # 3)]];
        ["summary"] call OT_fnc_townGarrisonUI;
    };
    case "select": {
        if (_display getVariable ["loading", false]) exitWith {};
        ["edit"] call OT_fnc_townGarrisonUI;
        _selected = _args param [1, -1];
        _display setVariable ["selected", _selected];
        private _valid = _selected >= 0 && { _selected < count _draft };
        { (_display displayCtrl _x) ctrlEnable _valid } forEach [1400, 1401, 2100, 2101, 1601, 1602, 1603];
        _display setVariable ["loading", true];
        if (_valid) then {
            private _entry = (_display getVariable "draft") # _selected;
            (_display displayCtrl 1400) ctrlSetText (_entry # 1);
            (_display displayCtrl 1401) ctrlSetText str (_entry # 2);
            (_display displayCtrl 2100) lbSetCurSel (["LIMITED", "NORMAL", "FULL"] find (_entry # 4));
            (_display displayCtrl 2101) lbSetCurSel (["AUTO", "PATROL", "HOLD"] find (_entry # 5));
        } else {
            (_display displayCtrl 1400) ctrlSetText "";
            (_display displayCtrl 1401) ctrlSetText "";
        };
        _display setVariable ["loading", false];
        ["summary"] call OT_fnc_townGarrisonUI;
    };
    case "add": {
        if (_display getVariable ["pending", false]) exitWith {};
        ["edit"] call OT_fnc_townGarrisonUI;
        if (count _draft >= 32) exitWith { _feedback ctrlSetText "You can create at most 32 companies." };
        private _number = 1;
        while { _draft findIf { (_x # 0) isEqualTo format ["company_%1", _number] } != -1 } do { _number = _number + 1 };
        _draft pushBack [format ["company_%1", _number], format ["Company %1", _number], 4, [], "LIMITED", "AUTO"];
        _display setVariable ["draft", _draft];
        ["refresh", [count _draft - 1]] call OT_fnc_townGarrisonUI;
    };
    case "delete": {
        if (_display getVariable ["pending", false] || { _selected < 0 }) exitWith {};
        _draft deleteAt _selected;
        _display setVariable ["draft", _draft];
        ["refresh", [_selected]] call OT_fnc_townGarrisonUI;
    };
    case "clear";
    case "undo";
    case "map": {
        if (_display getVariable ["pending", false] || { _selected < 0 }) exitWith { false };
        if (_mode isEqualTo "map" && { !((_args # 1) isEqualTo 1 || { (_args # 1) isEqualTo 0 && { _args # 4 } }) }) exitWith { false };
        ["edit"] call OT_fnc_townGarrisonUI;
        private _entry = _draft # _selected;
        private _route = +(_entry # 3);
        private _button = -1;
        if (_mode isEqualTo "map") then {
            _args params ["_map", "_btn", "_mx", "_my", "_shift"];
            _button = _btn;
            if (_button isEqualTo 0) then {
                private _point = _map ctrlMapScreenToWorld [_mx, _my];
                if (_point distance2D (_display getVariable "center") > 2000) exitWith { _feedback ctrlSetText "Points must stay within 2 km of the town center." };
                if (count _route >= 32 && { (_entry # 5) isNotEqualTo "HOLD" }) exitWith { _feedback ctrlSetText "A route can contain at most 32 points." };
                if ((_entry # 5) isEqualTo "HOLD") then { _route = [[_point # 0, _point # 1, 0]] } else {
                    _route pushBack [_point # 0, _point # 1, 0];
                    _entry set [5, "PATROL"];
                };
            };
        };
        if (_mode isEqualTo "undo" || { _button isEqualTo 1 }) then { if (_route isNotEqualTo []) then { _route deleteAt (count _route - 1) } };
        if (_mode isEqualTo "clear") then { _route = [] };
        if (_route isEqualTo [] && { (_entry # 5) isEqualTo "PATROL" }) then { _entry set [5, "AUTO"] };
        _entry set [3, _route];
        _draft set [_selected, _entry];
        _display setVariable ["draft", _draft];
        ["refresh", [_selected]] call OT_fnc_townGarrisonUI;
        true;
    };
    case "apply": {
        if (_display getVariable ["pending", false]) exitWith {};
        ["edit"] call OT_fnc_townGarrisonUI;
        private _validation = [_display getVariable "draft", _display getVariable "center", 2000, worldSize] call OT_fnc_validateTownGarrisonPlan;
        if !(_validation # 0) exitWith { _feedback ctrlSetText (_validation # 1) };
        _display setVariable ["pending", true];
        private _request = diag_tickTime;
        _display setVariable ["request", _request];
        { (_display displayCtrl _x) ctrlEnable false } forEach [1400, 1401, 2100, 2101, 1500, 1600, 1601, 1602, 1603, 1605];
        (_display displayCtrl 1604) ctrlEnable false;
        _feedback ctrlSetText "Applying the garrison plan...";
        [player, _town, _validation # 2, _display getVariable "revision", _request] remoteExecCall ["OT_fnc_saveTownGarrisonPlan", 2];
        [{ ["timeout", _this] call OT_fnc_townGarrisonUI }, [_request], 15] call CBA_fnc_waitAndExecute;
    };
    case "timeout": {
        if (!(_display getVariable ["pending", false]) || { (_display getVariable ["request", -1]) isNotEqualTo (_args # 0) }) exitWith {};
        _display setVariable ["pending", false];
        _display setVariable ["request", -1];
        { (_display displayCtrl _x) ctrlEnable true } forEach [1500, 1600, 1605];
        ["refresh", [_selected]] call OT_fnc_townGarrisonUI;
        _feedback ctrlSetText "No server response received. Reload the plan status.";
    };
    case "saved": {
        _args params ["_responseTown", "_plan", "_revision", "_success", "_message", "_request"];
        if (_responseTown isNotEqualTo _town || { (_display getVariable ["request", -1]) isNotEqualTo _request }) exitWith {};
        _display setVariable ["pending", false];
        if (_success) then {
            _display setVariable ["draft", _plan];
            _display setVariable ["revision", _revision];
        };
        { (_display displayCtrl _x) ctrlEnable true } forEach [1500, 1600, 1605];
        ["refresh", [_selected]] call OT_fnc_townGarrisonUI;
        (_display displayCtrl 1604) ctrlEnable true;
        _feedback ctrlSetText _message;
    };
};
