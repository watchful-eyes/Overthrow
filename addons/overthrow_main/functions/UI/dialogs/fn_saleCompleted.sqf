// Modified/added for the unofficial Garrison and Command Expansion, 14-16 November 2026.
// Original author/copyright notices are retained; see LICENSE.md (GNU GPL v2).
if (!hasInterface || { isRemoteExecuted && { remoteExecutedOwner != 2 } }) exitWith {};
params ["_sold", "_total"];
OT_selling = false;
if (_sold isEqualTo 0) then { "Sale cancelled: stock or trading location changed" call OT_fnc_notifyMinor };
if (!dialog) exitWith {};
private _target = [player, vehicle player] select ((player getVariable ["OT_shopTarget", "Self"]) isEqualTo "Vehicle");
private _town = player call OT_fnc_nearestTown;
private _standing = ([_town] call OT_fnc_support) * -1;
private _category = player getVariable ["OT_shopTargetCategory", ""];
[[_target, _category] call OT_fnc_unitStock, _town, _standing] call OT_fnc_sellDialog;
