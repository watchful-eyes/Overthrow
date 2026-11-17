// Modified/added for the unofficial Garrison and Command Expansion, 14-16 November 2026.
// Original author/copyright notices are retained; see LICENSE.md (GNU GPL v2).
params ["_soldier", "_pos", "_group", ["_takeFromWarehouse", true]];
if (isNull _group) exitWith { objNull };
_soldier params ["_cost", "_cls", "_loadout", "_clothes", "_allitems"];
if (_cls == "Police") then { _cls = OT_Unit_Police };
//Take from warehouse
if (_takeFromWarehouse) then {
    {
        _x params ["_cls", "_num"];
        [_cls, _num] call OT_fnc_removeFromWarehouse;
    } forEach (_allitems call BIS_fnc_consolidateArray);
};

private _start = [[[_pos, 30]]] call BIS_fnc_randomPos;
private _civ = _group createUnit [_cls, _start, [], 0, "NONE"];
if (isNull _civ) exitWith { objNull };
// RHS templates can originate from another side; friendly garrisons remain IND.
[_civ] joinSilent _group;

private _identity = call OT_fnc_randomLocalIdentity;
_identity pushBack (selectRandom OT_voices_local);
[_civ, _identity] call OT_fnc_applyIdentity;

_civ setRank "LIEUTENANT";
_civ setSkill ["courage", 1];

_civ setUnitLoadout [_loadout, false];

_civ;
