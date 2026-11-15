// Modified/added for the unofficial Garrison and Command Expansion, 14-16 November 2026.
// Original author/copyright notices are retained; see LICENSE.md (GNU GPL v2).
if !([true] call OT_fnc_isServerController) exitWith {};
if ((server getVariable ["StartupType", ""]) isNotEqualTo "" || { server getVariable ["OT_startupInProgress", false] }) exitWith {};
params [["_town", ""], ["_settings", [1, 1, 1]]];
private _validation = [_town, _settings] call OT_fnc_validateNewGameOptions;
if !(_validation # 0) exitWith {
    private _owner = if (isRemoteExecuted) then { remoteExecutedOwner } else { 2 };
    (_validation # 1) remoteExecCall ["OT_fnc_notifyMinor", _owner];
    [] remoteExecCall ["OT_fnc_showStartDialog", _owner];
};
server setVariable ["OT_requestedStartTown", _town, true];
server setVariable ["OT_difficulty", _settings # 0, true];
server setVariable ["OT_fastTravelType", _settings # 1, true];
server setVariable ["OT_fastTravelRules", _settings # 2, true];
server setVariable ["OT_startupInProgress", true, true];
"Preparing the campaign in the selected area..." remoteExec ['OT_fnc_notifyStart', 0, false];
[] spawn OT_fnc_initEconomy;
waitUntil { sleep 0.1; !isNil "OT_economyInitDone" };
server setVariable ["StartupType", "NEW", true];
server setVariable ["OT_startupInProgress", false, true];
