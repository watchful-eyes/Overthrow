// Localized 16 November 2026. Original author notices apply (GNU GPL v2).
/*
Donate money for the transformer mission
*/

private _money = player getVariable ["money", 0];
private _town = player call OT_fnc_nearestTown;

if (_money < 4000) exitWith { hint ("You don't have enough money" call OT_fnc_localizeText) };

player setVariable ["money", _money - 4000, true];
server_nosave setVariable [(_town + "transformerpaid"), true, true];
