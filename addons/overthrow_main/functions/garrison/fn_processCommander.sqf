// Modified/added for the unofficial Garrison and Command Expansion, 14-16 November 2026.
// Original author/copyright notices are retained; see LICENSE.md (GNU GPL v2).
// Only this server endpoint changes assignments or purchases an officer.
if (!isServer) exitWith { [false, "Server required."] };
params [
    ["_player", objNull, [objNull]], ["_action", "", [""]],
    ["_kind", "", [""]], ["_town", "", [""]],
    ["_revision", -1, [0]], ["_quotedPrice", -1, [0]], ["_request", 0, [0]]
];
if (isNull _player) exitWith { [false, "Player not found."] };
if (isRemoteExecuted && { remoteExecutedOwner != 2 } && { remoteExecutedOwner != owner _player || { !isPlayer _player } }) exitWith { [false, "Unable to verify the sender."] };
private _success = false;
private _message = "";
private _replyDetails = [];
call {
    if !([false] call OT_fnc_isServerController) exitWith { _message = "Only a general can manage commanders." };
    if (!finite _revision || { !finite _quotedPrice } || { !finite _request } || { !(_action in ["hire", "dismiss", "relocate"]) } || { !(_kind in ["TOWN", "REGION"]) }) exitWith { _message = "Invalid operation." };
    if !(_town in OT_allTowns && { _town in (server getVariable ["NATOabandoned", []]) }) exitWith { _message = "A friendly-controlled town is required." };
    private _station = server getVariable ["policepos" + _town, []];
    if (count _station != 3 || { _player distance2D _station > 100 }) exitWith { _message = "You must be within 100 meters of a friendly police station." };
    private _target = if (_kind isEqualTo "TOWN") then { _town } else { server getVariable ["region_" + _town, ""] };
    private _details = [_kind, _target] call OT_fnc_commanderDetails;
    if (_details isEqualTo []) exitWith { _message = "No region is configured for this town." };
    _replyDetails = _details;
    if (_revision isNotEqualTo (_details # 6)) exitWith { _message = "The assignment has changed. Refresh and try again." };
    private _key = _details # 7;
    private _records = +(([] call OT_fnc_commanderRecords));
    private _index = _records findIf { (_x # 0) isEqualTo _kind && { (_x # 1) isEqualTo _target } };
    private _next = _revision + 1;
    private _token = format ["%1:%2", _key, _next];
    if (_action isEqualTo "hire") then {
        if (_index >= 0) exitWith { _message = "A commander is already assigned here." };
        private _price = _details # 4;
        if (_quotedPrice isNotEqualTo _price) exitWith { _message = "The population and hiring cost have changed. Refresh the details." };
        if ((_player getVariable ["money", 0]) < _price) exitWith { _message = "Insufficient funds." };
        private _firstNames = missionNamespace getVariable ["OT_firstNames_local", ["Alex"]];
        private _lastNames = missionNamespace getVariable ["OT_lastNames_local", ["Demir"]];
        if (_firstNames isEqualTo []) then { _firstNames = ["Alex"] };
        if (_lastNames isEqualTo []) then { _lastNames = ["Demir"] };
        private _faces = missionNamespace getVariable ["OT_faces_local", ["GreekHead_A3_01"]];
        private _voices = missionNamespace getVariable ["OT_voices_local", ["Male01GRE"]];
        if (_faces isEqualTo []) then { _faces = ["GreekHead_A3_01"] };
        if (_voices isEqualTo []) then { _voices = ["Male01GRE"] };
        private _identity = [format ["%1 %2", selectRandom _firstNames, selectRandom _lastNames], selectRandom _faces, selectRandom _voices];
        private _class = missionNamespace getVariable ["OT_Unit_Police", "I_officer_F"];
        private _record = [_kind, _target, _town, _identity, +OT_Loadout_Police, _class, _token];
        private _unit = [_record] call OT_fnc_spawnCommander;
        if (isNull _unit) exitWith { _message = "The commander could not be created. No payment was taken." };
        if !([_player, -_price, "Commander recruitment"] call OT_fnc_changeMoney) exitWith { [_unit] call OT_fnc_cleanupUnit; _message = "Payment could not be completed." };
        _records pushBack _record;
        private _units = +(spawner getVariable ["OT_commanderUnits", []]);
        _units pushBack [_key, _token, _unit];
        spawner setVariable ["OT_commanderUnits", _units];
        _message = format ["%1 %2 has assumed command.", _details # 2, _identity # 0];
        _success = true;
    } else {
        if (_index < 0) exitWith { _message = "No commander is assigned." };
        if (_action isEqualTo "dismiss") then {
            _records deleteAt _index;
            _message = "The commander has been dismissed. No refund is issued.";
            _success = true;
        } else {
            if (_kind isNotEqualTo "REGION") exitWith { _message = "Only a regional headquarters can be relocated." };
            private _record = +(_records # _index);
            if ((_record # 2) isEqualTo _town) exitWith { _message = "The headquarters is already in this town." };
            // Snapshot live equipment before replacing this officer's location.
            [] call OT_fnc_snapshotCommanders;
            _records = +(([] call OT_fnc_commanderRecords));
            _record = +(_records # _index);
            _record set [2, _town];
            _record set [6, _token];
            _records set [_index, _record];
            _message = "The regional headquarters has been moved to this town.";
            _success = true;
        };
    };
    if (_success) then {
        [_records, true] call OT_fnc_commanderRecords;
        server setVariable ["commanderrev" + _key, _next, true];
        [] call OT_fnc_syncCommanders;
        _replyDetails = [_kind, _target] call OT_fnc_commanderDetails;
    };
};
if (isPlayer _player) then { ["response", [_town, _kind, _request, _success, _message, _replyDetails]] remoteExecCall ["OT_fnc_commanderUI", _player] };
[_success, _message];
