// Modified/added for the unofficial Garrison and Command Expansion, 14-16 November 2026.
// Original author/copyright notices are retained; see LICENSE.md (GNU GPL v2).
params [["_loadout", [], [[]]]];
if (count _loadout != 10 || { count str _loadout > 60000 } || { _loadout findIf { isNil "_x" } >= 0 }) exitWith { false };
if ([0,1,2,3,4,5,8,9] findIf { !((_loadout # _x) isEqualType []) } >= 0) exitWith { false };
if (!((_loadout # 6) isEqualType "") || { !((_loadout # 7) isEqualType "") }) exitWith { false };
private _valid = true;
private _number = { _this isEqualType 0 && { finite _this } && { _this >= 0 } && { _this <= 10000 } };
{
    private _weapon = _loadout # _x;
    if (_weapon isEqualTo []) then { continue };
    if (count _weapon < 7 || { count _weapon > 8 } || { _weapon findIf { isNil "_x" } >= 0 }) exitWith { _valid = false };
    {
        if (!((_weapon # _x) isEqualType "")) exitWith { _valid = false };
    } forEach [0,1,2,3,6];
    if (!_valid) exitWith {};
    if (count _weapon > 7 && { !((_weapon # 7) isEqualType "") }) exitWith { _valid = false };
    if (!isClass (configFile >> "CfgWeapons" >> (_weapon # 0))) exitWith { _valid = false };
    {
        private _mag = _weapon # _x;
        if (!(_mag isEqualType [])) exitWith { _valid = false };
        if (_mag isEqualTo []) then { continue };
        if (count _mag != 2 || { isNil { _mag # 0 } } || { isNil { _mag # 1 } } || { !((_mag # 0) isEqualType "") } || { !((_mag # 1) call _number) }) exitWith { _valid = false };
        if (!isClass (configFile >> "CfgMagazines" >> (_mag # 0))) exitWith { _valid = false };
    } forEach [4,5];
    if (!_valid) exitWith {};
} forEach [0,1,2,8];
if (!_valid) exitWith { false };
{
    private _container = _loadout # _x;
    if (_container isEqualTo []) then { continue };
    if (count _container != 2 || { isNil { _container # 0 } } || { isNil { _container # 1 } } || { !((_container # 0) isEqualType "") } || { !((_container # 1) isEqualType []) }) exitWith { _valid = false };
    {
        if (isNil "_x" || { !(_x isEqualType []) } || { count _x < 2 } || { count _x > 3 }) exitWith { _valid = false };
        if (isNil { _x # 0 } || { isNil { _x # 1 } } || { !((_x # 0) isEqualType "") } || { !((_x # 1) call _number) }) exitWith { _valid = false };
        if (count _x > 2 && { isNil { _x # 2 } || { !((_x # 2) call _number) } }) exitWith { _valid = false };
    } forEach (_container # 1);
    if (!_valid) exitWith {};
} forEach [3,4,5];
_valid && { (_loadout # 9) findIf { isNil "_x" || { !(_x isEqualType "") } } < 0 };
