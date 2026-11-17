// Modified/added for the unofficial Garrison and Command Expansion, 14-16 November 2026.
// Original author/copyright notices are retained; see LICENSE.md (GNU GPL v2).
if (!isServer) exitWith {};
params [["_player", objNull, [objNull]], ["_enabled", false, [true]]];
if (isNull _player || { !isPlayer _player }) exitWith {};
private _sender = owner _player;
if (isRemoteExecuted && { remoteExecutedOwner != _sender }) exitWith {};
private _allowed = _sender isEqualTo 2 || { isDedicated && { admin _sender isEqualTo 2 } };
if (!_allowed) exitWith { "You need to be logged in admin to access Zeus!" remoteExecCall ["OT_fnc_notifyBig", _player] };
if (_enabled) then { _player assignCurator zeusCurator } else { unassignCurator zeusCurator };
_player setVariable ["OT_zeusEnabled", _enabled, true];
(["Zeus Disabled", "Zeus Enabled"] select _enabled) remoteExecCall ["OT_fnc_notifyMinor", _player];
