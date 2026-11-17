// Modified/added for the unofficial Garrison and Command Expansion, 14-16 November 2026.
// Original author/copyright notices are retained; see LICENSE.md (GNU GPL v2).
params ["_i", "_s", "_e", "_c", "_p"];
private _groups = spawner getVariable [_i, []];
spawner setVariable [_i, [], false];
{
    // Cleanup a group
    if (_x isEqualType grpNull) then {
        // Raiding members can be visible at a different town/base. Their raid
        // manager streams them back; all other hometown objects may despawn.
        if (_x getVariable ["OT_gangRaiding", false]) then { continue };
        private _units = units _x;
        if (_units isEqualTo []) then {
            [_x] call OT_fnc_cleanupEmptyGroup;
        };
        {
            if !(_x call OT_fnc_hasOwner) then {
                [_x] call OT_fnc_cleanupUnit;
                sleep 0.1;
            };
        } forEach (_units);
        continue;
    };

    // Cleanup a vehicle / object
    if (_x isEqualType objNull) then {
        if !(_x call OT_fnc_hasOwner) then {
            [_x] call OT_fnc_cleanupVehicle;
        };
        continue;
    };

    // Cleanup a marker
    if (_x isEqualType "") then {
        deleteMarker _x;
        continue;
    };

    // We don't know what it is
    diag_log format ["Overthrow: Failed to despawn %1", _x];
} forEach (_groups);
