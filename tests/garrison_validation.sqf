// Modified/added for the unofficial Garrison and Command Expansion, 14-16 November 2026.
// Original author/copyright notices are retained; see LICENSE.md (GNU GPL v2).
private _passed = 0;
private _check = {
    params ["_name", "_condition"];
    if (!_condition) then { throw format ["FAIL: %1", _name] };
    _passed = _passed + 1;
    diag_log format ["PASS: %1", _name];
};
OT_fnc_validateTownGarrisonPlan = compile preprocessFileLineNumbers "\overthrow_main\functions\garrison\fn_validateTownGarrisonPlan.sqf";
OT_fnc_townGarrisonLayout = compile preprocessFileLineNumbers "\overthrow_main\functions\garrison\fn_townGarrisonLayout.sqf";
private _center = [5000, 5000, 0];
private _company = ["a", "Alpha", 4, [[5100, 5000], [5200, 5100]], "LIMITED", "PATROL"];
private _validation = [[_company], _center, 2000, 10000] call OT_fnc_validateTownGarrisonPlan;
["Valid custom garrison route is accepted", _validation # 0] call _check;
["Map points normalize to ground coordinates", (((_validation # 2) # 0) # 3) isEqualTo [[5100, 5000, 0], [5200, 5100, 0]]] call _check;
["Duplicate company IDs are rejected", !(([[_company, _company], _center] call OT_fnc_validateTownGarrisonPlan) # 0)] call _check;
private _bad = +_company; _bad set [3, [[5100, 5000]]];
["A custom patrol requires at least two stops", !(([[_bad], _center] call OT_fnc_validateTownGarrisonPlan) # 0)] call _check;
_bad = +_company; _bad set [3, [[5100, 5000], [9000, 9000]]];
["Route outside town patrol area is rejected", !(([[_bad], _center] call OT_fnc_validateTownGarrisonPlan) # 0)] call _check;
_bad = +_company; _bad set [3, [[5100, 5000], [10001, 5000]]];
["Route outside world bounds is rejected", !(([[_bad], _center, 20000, 10000] call OT_fnc_validateTownGarrisonPlan) # 0)] call _check;
_bad = +_company; _bad set [2, 1.5];
["Fractional company strength is rejected", !(([[_bad], _center] call OT_fnc_validateTownGarrisonPlan) # 0)] call _check;
_bad set [2, 0];
["Zero strength is rejected", !(([[_bad], _center] call OT_fnc_validateTownGarrisonPlan) # 0)] call _check;
_bad set [2, 65];
["Oversized company is rejected", !(([[_bad], _center] call OT_fnc_validateTownGarrisonPlan) # 0)] call _check;
_bad = +_company; _bad set [4, "invalid speed"];
["Only supported patrol speeds are accepted", !(([[_bad], _center] call OT_fnc_validateTownGarrisonPlan) # 0)] call _check;
["Malformed company record is rejected", !(([[["broken"]], _center] call OT_fnc_validateTownGarrisonPlan) # 0)] call _check;
["Empty plan can restore automatic patrols", ([[], _center] call OT_fnc_validateTownGarrisonPlan) # 0] call _check;

diag_log format ["OVERTHROW_VALIDATION_PASSED=%1", _passed];
