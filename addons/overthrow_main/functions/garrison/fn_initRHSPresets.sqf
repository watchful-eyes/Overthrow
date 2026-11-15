// Modified/added for the unofficial Garrison and Command Expansion, 14-16 November 2026.
// Original author/copyright notices are retained; see LICENSE.md (GNU GPL v2).
// One representative of each combat role per RHS faction, rather than hundreds
// of nearly identical cosmetic variants. Defaults stay first for old squad IDs.
if (!isServer) exitWith {};
private _records = +(missionNamespace getVariable ["OT_Recruitables", []]);
private _keys = [];
{
    private _class = configName _x;
    if ((toLowerANSI _class select [0, 3]) isNotEqualTo "rhs") then { continue };
    private _role = [_class] call OT_fnc_soldierRole;
    if !(_role in ["rifleman", "mg", "gl", "medic", "engineer", "leader", "at", "aa", "marksman", "sniper", "spotter"]) then { continue };
    private _key = (getText (_x >> "faction")) + ":" + _role;
    if (_key in _keys) then { continue };
    private _loadout = getUnitLoadout _x;
    if (count _loadout != 10 || { (_loadout # 0) isEqualTo [] }) then { continue };
    _keys pushBack _key;
    if (_records findIf { (_x # 0) isEqualTo _class } < 0) then { _records pushBack [_class, _loadout] };
} forEach ("getNumber (_x >> 'scope') == 2 && { getNumber (_x >> 'side') in [0,1,2] } && { configName _x isKindOf 'CAManBase' }" configClasses (configFile >> "CfgVehicles"));
[_records, true] call OT_fnc_recruitPresets;
server setVariable ["OT_policePreset", +OT_Loadout_Police];
server setVariable ["OT_policePresetView", +OT_Loadout_Police, true];
