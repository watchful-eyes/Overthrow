// Modified/added for the unofficial Garrison and Command Expansion, 14-16 November 2026.
// Original author/copyright notices are retained; see LICENSE.md (GNU GPL v2).
params [["_vehicle", objNull, [objNull]]];
if (!isServer || { isNull _vehicle }) exitWith { [] };
createVehicleCrew _vehicle;
{
    _x params ["_old", "_seat", "_cargo", "_turret"];
    if (isNull _old) then { continue };
    private _class = [typeOf _old] call OT_fnc_selectNATOGarrisonUnit;
    if (_class isEqualTo typeOf _old) then { continue };
    private _group = group _old;
    private _new = _group createUnit [_class, getPosATL _vehicle, [], 0, "NONE"];
    if (isNull _new) then { continue };
    private _board = {
        params ["_unit"];
        switch (_seat) do {
            case "driver": { _unit moveInDriver _vehicle };
            case "cargo": { _unit moveInCargo [_vehicle, _cargo] };
            default { _unit moveInTurret [_vehicle, _turret] };
        };
    };
    moveOut _old;
    [_new] call _board;
    if (objectParent _new isEqualTo _vehicle) then {
        deleteVehicle _old;
    } else {
        deleteVehicle _new;
        [_old] call _board;
    };
} forEach fullCrew [_vehicle, "", false];
{ [_x] call OT_fnc_initMilitary } forEach crew _vehicle;
crew _vehicle;
