// Modified/added for the unofficial Garrison and Command Expansion, 14-16 November 2026.
// Original author/copyright notices are retained; see LICENSE.md (GNU GPL v2).
if (!isServer) exitWith {};
params [["_player", objNull, [objNull]], ["_town", "", [""]], ["_amount", 0, [0]]];
if (isNull _player || { !isPlayer _player }) exitWith {};
if (isRemoteExecuted && { remoteExecutedOwner != 2 } && { remoteExecutedOwner != owner _player }) exitWith {};
if (!finite _amount || { _amount < 1 } || { _amount > 32 } || { _amount != floor _amount }) exitWith {};
if !(_town in OT_allTowns && { _town in (server getVariable ["NATOabandoned", []]) }) exitWith {};
if (spawner getVariable [format ["garrisonSpawning%1", _town], false]
    || { (spawner getVariable [format ["townspawnid%1", _town], ""]) isEqualTo "" }
) exitWith { "The garrison is being prepared. Try again in a few seconds." remoteExecCall ["OT_fnc_notifyMinor", _player] };
private _center = server getVariable [format ["policepos%1", _town], server getVariable _town];
if (_player distance2D _center > 100) exitWith {};
private _soldier = ["Police", _player, false] call OT_fnc_getSoldier;
private _price = (_soldier # 0) * _amount;
if !([_player, -_price, "Garrison personnel"] call OT_fnc_changeMoney) exitWith {
    "Insufficient funds." remoteExecCall ["OT_fnc_notifyMinor", _player];
};
private _created = [_town, _soldier, _amount] call OT_fnc_createPoliceGroup;
if (count _created < _amount) then { [_player, (_amount - count _created) * (_soldier # 0), "Refund for unspawned personnel"] call OT_fnc_changeMoney };
_amount = count _created;
private _strength = [_town, "Police", _amount] call OT_fnc_changeGarrisonRoster;
[_town, 5 * _amount] call OT_fnc_support;
(format ["%1-police", _town]) setMarkerText str _strength;
[true] remoteExecCall ["OT_fnc_policeDialog", _player];
