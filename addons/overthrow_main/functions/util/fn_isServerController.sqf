// Modified/added for the unofficial Garrison and Command Expansion, 14-16 November 2026.
// Original author/copyright notices are retained; see LICENSE.md (GNU GPL v2).
// Validate the real network sender, not an actor object supplied by the client.
params [["_allowStartup", false, [true]]];
if (!isServer) exitWith { false };
if (!isRemoteExecuted || { remoteExecutedOwner isEqualTo 2 }) exitWith { true };
private _sender = remoteExecutedOwner;
private _players = [] call CBA_fnc_players;
private _index = _players findIf { owner _x isEqualTo _sender };
if (_index isEqualTo -1) exitWith { false };
private _caller = _players # _index;
if (isDedicated && { admin _sender isEqualTo 2 }) exitWith { true };
if (_allowStartup && { (server getVariable ["StartupType", ""]) isEqualTo "" }) exitWith {
    _caller isEqualTo (server getVariable ["OT_startupOwner", objNull]);
};
(getPlayerUID _caller) in (server getVariable ["generals", []]);
