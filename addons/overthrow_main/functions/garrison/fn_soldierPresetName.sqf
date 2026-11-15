// Modified/added for the unofficial Garrison and Command Expansion, 14-16 November 2026.
// Original author/copyright notices are retained; see LICENSE.md (GNU GPL v2).
params [["_class", "Police", [""]]];
if (_class isEqualTo "Police") exitWith { "Town police" };
private _cfg = configFile >> "CfgVehicles" >> _class;
private _name = getText (_cfg >> "displayName");
private _faction = getText (configFile >> "CfgFactionClasses" >> getText (_cfg >> "faction") >> "displayName");
if ((toLowerANSI _class select [0, 3]) isEqualTo "rhs") exitWith { format ["RHS / %1 / %2", _faction, _name] };
_name;
