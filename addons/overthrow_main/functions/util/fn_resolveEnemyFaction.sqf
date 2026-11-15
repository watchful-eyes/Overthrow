// Modified/added for the unofficial Garrison and Command Expansion, 14-16 November 2026.
// Original author/copyright notices are retained; see LICENSE.md (GNU GPL v2).
// The occupation controller requires a BLUFOR faction with group definitions.
// Optional RHS/3CB menu entries must not leave an empty enemy army when absent.
params [["_requested", "", [""]], ["_mapDefault", "BLU_F", [""]]];
private _result = "BLU_F";
{
    private _cfg = configFile >> "CfgFactionClasses" >> _x;
    if (isClass _cfg && { getNumber (_cfg >> "side") isEqualTo 1 } && { isClass (configFile >> "CfgGroups" >> "West" >> _x) }) exitWith { _result = _x };
} forEach [_requested, _mapDefault, "BLU_F"];
_result;
