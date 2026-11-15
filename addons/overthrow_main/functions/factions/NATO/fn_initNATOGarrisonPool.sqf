// Modified/added for the unofficial Garrison and Command Expansion, 14-16 November 2026.
// Original author/copyright notices are retained; see LICENSE.md (GNU GPL v2).
// Scan once at startup. Each spawn then performs only a small role lookup.
if (!isServer) exitWith { [] };
private _pools = [];
{
    private _class = configName _x;
    private _faction = getText (_x >> "faction");
    private _rhs = (toLowerANSI _class select [0, 3]) isEqualTo "rhs";
    if (_faction isNotEqualTo OT_faction_NATO && { !_rhs }) then { continue };
    private _role = [_class] call OT_fnc_soldierRole;
    if (_role isEqualTo "") then { continue };
    private _index = _pools findIf { (_x # 0) isEqualTo _role };
    if (_index < 0) then { _index = _pools pushBack [_role, [], []] };
    if (_faction isEqualTo OT_faction_NATO) then { ((_pools # _index) # 1) pushBackUnique _class };
    if (_rhs) then { ((_pools # _index) # 2) pushBackUnique _class };
} forEach ("getNumber (_x >> 'scope') == 2 && { getNumber (_x >> 'side') == 1 } && { configName _x isKindOf 'CAManBase' }" configClasses (configFile >> "CfgVehicles"));
OT_NATOGarrisonPools = _pools;
_pools;
