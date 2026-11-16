// Added 16 November 2026 for the community fork. GNU GPL v2.
// Server helper, deliberately not exposed via CfgRemoteExec. Apply before NATO
// initialization so faction-based unit and group selection uses the new army.
if (!isServer || { isNil "server" }) exitWith { false };
params [["_requested", ""]];
private _previous = missionNamespace getVariable ["OT_faction_NATO", "BLU_F"];
if !(_requested isEqualType "") then { _requested = "" };
if (_requested isEqualTo "") then { _requested = server getVariable ["OT_enemyFaction", _previous] };
private _mapDefault = missionNamespace getVariable ["OT_mapEnemyFaction", "BLU_F"];
private _resolved = [_requested, _mapDefault] call OT_fnc_resolveEnemyFaction;
if (_resolved isNotEqualTo _requested) then { diag_log format ["Overthrow: Saved occupation force %1 is unavailable; using %2.", _requested, _resolved] };
OT_faction_NATO = _resolved;
publicVariable "OT_faction_NATO";
server setVariable ["OT_enemyFaction", _resolved, true];
// Refresh the cached selected-army/RHS pools without rerunning world init.
if (_previous isNotEqualTo _resolved || { isNil "OT_NATOGarrisonPools" }) then { [] call OT_fnc_initNATOGarrisonPool };
true
