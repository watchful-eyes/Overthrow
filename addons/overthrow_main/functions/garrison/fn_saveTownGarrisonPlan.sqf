// Modified/added for the unofficial Garrison and Command Expansion, 14-16 November 2026.
// Original author/copyright notices are retained; see LICENSE.md (GNU GPL v2).
if (!isServer) exitWith {};
params [["_player", objNull, [objNull]], ["_town", "", [""]], ["_plan", [], [[]]], ["_revision", -1, [0]], ["_request", 0, [0]]];
if (isNull _player || { !isPlayer _player }) exitWith {};
if (isRemoteExecuted && { remoteExecutedOwner != 2 } && { remoteExecutedOwner != owner _player }) exitWith {};
private _key = format ["garrisonplan%1", _town];
private _versionKey = format ["garrisonrevision%1", _town];
private _version = server getVariable [_versionKey, 0];
private _success = false;
private _message = "";
call {
    if !([false] call OT_fnc_isServerController) exitWith { _message = "General authority is required for this operation." };
    if !(_town in OT_allTowns && { _town in (server getVariable ["NATOabandoned", []]) }) exitWith { _message = "Only friendly town garrisons can be managed." };
    if (_revision isNotEqualTo _version) exitWith { _message = "Another player has changed the plan. Reload it first." };
    private _validation = [_plan, server getVariable _town, 2000, worldSize] call OT_fnc_validateTownGarrisonPlan;
    if !(_validation # 0) exitWith { _message = _validation # 1 };
    _plan = _validation # 2;
    _version = _version + 1;
    server setVariable [_key, _plan, true];
    server setVariable [_versionKey, _version, true];
    [_town] call OT_fnc_assignTownGarrison;
    _success = true;
    _message = "Companies and patrol routes have been applied.";
};
["saved", [_town, _plan, _version, _success, _message, _request]] remoteExecCall ["OT_fnc_townGarrisonUI", _player];
