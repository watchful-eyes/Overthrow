// Modified/added for the unofficial Garrison and Command Expansion, 14-16 November 2026.
// Original author/copyright notices are retained; see LICENSE.md (GNU GPL v2).
params ["_veh", "_pos", "_fnc"];
if !(_fnc isEqualType "") exitWith {};
if ((_fnc select [0, 6]) != "OT_fnc") then {
    //Legacy building Init

    private _code = {};
    if ("policeStation" in _fnc) then {
        _code = OT_fnc_initPoliceStation;
    };
    if ("trainingCamp" in _fnc) then {
        _code = OT_fnc_initTrainingCamp;
    };
    if ("warehouse" in _fnc) then {
        _code = OT_fnc_initWarehouse;
    };
    if ("workshop" in _fnc) then {
        _code = OT_fnc_initWorkshop;
    };
    [_pos, _veh] spawn _code;
} else {
    if !(_fnc in [
        "OT_fnc_initObservationPost", "OT_fnc_initPoliceStation", "OT_fnc_initWorkshop",
        "OT_fnc_initTrainingCamp", "OT_fnc_initWarehouse", "OT_fnc_initRadar"
    ]) exitWith {};
    [_pos, _veh] spawn (missionNamespace getVariable _fnc);
};
