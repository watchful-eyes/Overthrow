// Modified/added for the unofficial Garrison and Command Expansion, 14-16 November 2026.
// Original author/copyright notices are retained; see LICENSE.md (GNU GPL v2).
private _b = player call OT_fnc_nearestRealEstate;
if !(_b isEqualType []) exitWith {};
private _building = (_b select 0);
if (damage _building isEqualTo 1) exitWith { "Must repair before you can recruit" call OT_fnc_notifyMinor };

disableSerialization;

private _base = nil;
private _good = true;
if (typeOf _building isEqualTo OT_barracks) then {
    _base = player call OT_fnc_nearestObjective;
    if !((_base select 1) in (server getVariable "NATOabandoned")) then {
        _good = false;
    };
};
if ((typeOf _building == OT_barracks) && isNil "_base") exitWith {};
if ((typeOf _building == OT_barracks) && !_good) exitWith { "This barracks is under NATO control" call OT_fnc_notifyMinor };

createDialog "OT_dialog_recruit";
ctrlSetText [1600, ("Recruit" call OT_fnc_localizeText)];
lbClear 1500;
if (typeOf _building isEqualTo OT_barracks) then {
    {
        _x params ["_cls", "_comp"];
        private _idx = lbAdd [1500, (_cls call OT_fnc_localizeText)];
        lbSetData [1500, _idx, _cls];
    } forEach (OT_Squadables);
};
{
    _x params ["_cls"];
    if (!isClass (configFile >> "CfgVehicles" >> _cls)) then { continue };
    private _name = [_cls] call OT_fnc_soldierPresetName;

    private _idx = lbAdd [1500, (_name call OT_fnc_localizeText)];
    lbSetData [1500, _idx, _cls];
} forEach ([] call OT_fnc_recruitPresets);
