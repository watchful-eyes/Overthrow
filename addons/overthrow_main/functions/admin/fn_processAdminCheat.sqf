// Added 16 November 2026 for the community fork. GNU GPL v2.
// Only the server mutates balances. Campaign generals are not server admins.
if (!isServer) exitWith { [false, "Admin tools are server-only.", []] };
if !(_this isEqualType [] && { count _this isEqualTo 6 }) exitWith { [false, "Invalid admin request.", []] };
if !((_this # 0) isEqualType objNull && { (_this # 1) isEqualType "" } && { (_this # 2) isEqualType "" } && { (_this # 3) isEqualType "" } && { (_this # 4) isEqualType 0 } && { (_this # 5) isEqualType 0 }) exitWith { [false, "Invalid admin request.", []] };
params ["_actor", "_targetUID", "_resource", "_operation", "_amount", "_request"];
private _players = [] call CBA_fnc_players;
if (isNull _actor || { !isPlayer _actor } || { !(_actor in _players) }) exitWith { [false, "Invalid admin request.", []] };
private _sender = owner _actor;
if (isMultiplayer && { isRemoteExecuted } && { remoteExecutedOwner isNotEqualTo _sender }) exitWith { [false, "Invalid admin request.", []] };
private _respond = {
    params ["_result"];
    _result params ["_success", "_message", "_snapshot"];
    ["response", [_request, _success, _message, _targetUID, _snapshot, _operation]] remoteExecCall ["OT_fnc_adminCheatUI", _actor];
    _result
};
// The engine reports owner 0 in single player, and owner 2 for a LAN host.
private _soloHost = !isMultiplayer && { hasInterface } && { _actor isEqualTo player };
if !(_soloHost || { _sender isEqualTo 2 } || { admin _sender isEqualTo 2 }) exitWith { [[false, "Only the host or a logged-in server admin can use admin tools.", []]] call _respond };
if (!finite _request || { _request < 1 } || { _request > 10000000 } || { floor _request isNotEqualTo _request }) exitWith { [false, "Invalid admin request.", []] };

// Keep only the last request per admin connection. Retries cannot mint money
// twice, and a fresh read invalidates any older delayed mutation.
private _requests = missionNamespace getVariable ["OT_adminCheatRequests", createHashMap];
missionNamespace setVariable ["OT_adminCheatRequests", _requests];
private _key = getPlayerUID _actor;
private _previous = _requests getOrDefault [_key, []];
private _fingerprint = [_targetUID, _resource, _operation, _amount];
if (_previous isNotEqualTo [] && { (_previous # 0) isEqualTo _sender } && { (_previous # 1) isEqualTo _actor } && { _request <= (_previous # 2) }) exitWith {
    private _result = [false, "This admin request is stale. Refresh balances and try again.", []];
    if (_request isEqualTo (_previous # 2) && { _fingerprint isEqualTo (_previous # 3) }) then { _result = _previous # 4 };
    [_result] call _respond
};
private _success = false;
private _message = "Invalid admin request.";
private _snapshot = [];
call {
    if !(_resource in ["money", "influence", "funds"] && { _operation in ["read", "add", "set", "subtract"] }) exitWith {};
    if (!finite _amount || { _amount < 0 } || { _amount > 1000000000 } || { floor _amount isNotEqualTo _amount }) exitWith { _message = "Enter a whole number from 0 to 1,000,000,000." };
    if (isNil "server") exitWith { _message = "Campaign is still initializing." };
    private _target = (_players select { getPlayerUID _x isEqualTo _targetUID }) param [0, objNull];
    if (_resource isNotEqualTo "funds" && { isNull _target }) exitWith { _message = "The target player is no longer connected. Refresh the player list." };
    if (_resource isNotEqualTo "funds" && { !(_target getVariable ["OT_loaded", false]) }) exitWith { _message = "Wait for the target player to finish loading." };
    private _holder = [_target, server] select (_resource isEqualTo "funds");
    private _variable = ["money", "influence"] select (_resource isEqualTo "influence");
    private _old = _holder getVariable [_variable, 0];
    if !(_old isEqualType 0 && { finite _old } && { _old >= 0 }) exitWith { _message = "The current balance is invalid. No changes were made." };
    if (_operation isNotEqualTo "read") then {
        private _new = switch (_operation) do {
            case "add": { _old + _amount };
            case "subtract": { (_old - _amount) max 0 };
            default { _amount };
        };
        if (!finite _new || { _new > 1000000000 }) exitWith { _message = "The resulting balance cannot exceed 1,000,000,000." };
        private _delta = _new - _old;
        private _oldText = [_old, 1, 0, true] call CBA_fnc_formatNumber;
        private _newText = [_new, 1, 0, true] call CBA_fnc_formatNumber;
        switch (_resource) do {
            case "money": {
                _message = format ["Player money updated: $%1 -> $%2.", _oldText, _newText];
                if (_delta isNotEqualTo 0) then { _message remoteExecCall ["OT_fnc_notifyMinor", _target] };
            };
            case "influence": {
                if (_delta isNotEqualTo 0) then { (format ["Admin influence adjustment: %1 -> %2.", _oldText, _newText]) remoteExecCall ["OT_fnc_notifyMinor", _target] };
                _message = format ["Influence updated: %1 -> %2.", _oldText, _newText];
            };
            case "funds": {
                _message = format ["Resistance funds updated: $%1 -> $%2.", _oldText, _newText];
            };
        };
        // Assign the absolute result: old + (new - old) loses low-order digits
        // when setting a very large Arma scalar balance to a small value.
        _holder setVariable [_variable, _new, true];
        diag_log format ["[Overthrow Admin] %1: %2 %3, target=%4, balance=%5 -> %6", name _actor, _operation, _resource, if (isNull _target) then { "Resistance" } else { name _target }, _old, _new];
        _success = true;
    } else {
        _success = true;
        _message = "Balances refreshed. Changes are included in normal campaign saves.";
    };
    if (_success) then {
        _snapshot = [if (isNull _target) then { "" } else { name _target }, _target getVariable ["money", 0], _target getVariable ["influence", 0], server getVariable ["money", 0]];
    };
};
private _result = [_success, _message, _snapshot];
_requests set [_key, [_sender, _actor, _request, _fingerprint, _result]];
[_result] call _respond
