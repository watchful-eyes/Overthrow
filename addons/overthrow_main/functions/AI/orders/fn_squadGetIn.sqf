// Localized 16 November 2026. Original author notices apply (GNU GPL v2).
{
    private _veh = _x getVariable ["OT_assigned", objNull];
   (units _x) allowGetIn true;
    if !(isNull _veh) then {
        _x addVehicle _veh;
       (units _x) orderGetIn true;
    };
    player hcSelectGroup [_x, false];
} forEach (hcSelected player);
