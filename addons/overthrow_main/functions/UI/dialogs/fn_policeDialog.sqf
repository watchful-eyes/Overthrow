// Modified/added for the unofficial Garrison and Command Expansion, 14-16 November 2026.
// Original author/copyright notices are retained; see LICENSE.md (GNU GPL v2).
disableSerialization;
params [["_refreshOnly", false]];
if (isRemoteExecuted && { remoteExecutedOwner != 2 }) exitWith {};
if (_refreshOnly && { isNull (findDisplay 9000) }) exitWith {};

private _town = player call OT_fnc_nearestTown;
if !(_town in (server getVariable ["NATOabandoned", []])) exitWith { "This police station is under NATO control" call OT_fnc_notifyMinor };

private _garrison = server getVariable [format ['police%1', _town], 0];
if (!_refreshOnly) then { createDialog "OT_dialog_police" };

private _soldier = ["Police", player, false] call OT_fnc_getSoldier;
private _price = _soldier param [0, 500];

private _effect = floor (_garrison / 2);
if (_effect isEqualTo 0) then { _effect = "None" } else { _effect = format ["+%1 Stability/10 mins", _effect] };

if !(call OT_fnc_playerIsGeneral) then {
    ctrlEnable [1608, false];
    ctrlEnable [1612, false];
    ctrlEnable [1613, false];
};

((findDisplay 9000) displayCtrl 1100) ctrlSetStructuredText parseText (format ["<t size=""2"" align=""center"">%1 Police Station</t>", _town] call OT_fnc_localizeText);
((findDisplay 9000) displayCtrl 1103) ctrlSetStructuredText parseText (format ["<t align=""center"">Hire police ($-%1)</t>", _price] call OT_fnc_localizeText);
((findDisplay 9000) displayCtrl 1101) ctrlSetStructuredText parseText (format ["<t size=""1.5"" align=""center"">Police: %1</t>", _garrison] call OT_fnc_localizeText);
((findDisplay 9000) displayCtrl 1104) ctrlSetStructuredText parseText (format ["<t size=""1.2"" align=""center"">Effects</t><br/><br/><t size=""0.8"" align=""center"">%1</t>", _effect] call OT_fnc_localizeText);
