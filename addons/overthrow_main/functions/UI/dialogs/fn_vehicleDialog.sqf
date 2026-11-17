// Localized 16 November 2026. Original author notices apply (GNU GPL v2).
private _ft = server getVariable ["OT_fastTravelType", 1];
if (!OT_adminMode && _ft > 1) then {
    ctrlEnable [1600, false];
};

private _veh = vehicle player;

if !(_veh call OT_fnc_playerIsOwner) then {
    ctrlEnable [1605, false];
} else {
    if (_veh getVariable ["OT_locked", false]) then {
        ctrlSetText [1605, ("Unlock Vehicle" call OT_fnc_localizeText)];
    };
};

if (typeOf _veh != "OT_I_Truck_recovery") then {
    ctrlShow [1614, false];
};
