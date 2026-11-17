// Localized 16 November 2026. Original author notices apply (GNU GPL v2).
private _owner = players_NS getVariable ("name" + ((vehicle player) call OT_fnc_getOwner));
if (isNil "_owner") then { _owner = "Someone" };
if ((vehicle player) getVariable ["stolen", false]) then { _owner = format ["%1 (Stolen)", _owner] };
format ["%1<br/>Owner: %2", (typeOf vehicle player) call OT_fnc_vehicleGetName, _owner] call OT_fnc_notifyMinor;
