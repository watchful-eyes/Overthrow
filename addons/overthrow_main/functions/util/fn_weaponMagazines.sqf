// Modified/added for the unofficial Garrison and Command Expansion, 14-16 November 2026.
// Original author/copyright notices are retained; see LICENSE.md (GNU GPL v2).
// Read current engine magazine wells while retaining each muzzle's legacy order.
// Empty muzzle means all muzzles; "this" means the primary muzzle only.
params [["_weapon", "", [""]], ["_muzzle", "this", [""]]];
private _cfg = configFile >> "CfgWeapons" >> _weapon;
if (!isClass _cfg) exitWith { [] };
private _muzzles = [_muzzle];
if (_muzzle isEqualTo "") then {
    _muzzles = getArray (_cfg >> "muzzles");
    if (_muzzles isEqualTo []) then { _muzzles = ["this"] };
};
private _magazines = [];
{
    private _muzzleCfg = if (_x isEqualTo "this") then { _cfg } else { _cfg >> _x };
    { if (isClass (configFile >> "CfgMagazines" >> _x)) then { _magazines pushBackUnique _x } } forEach getArray (_muzzleCfg >> "magazines");
    { _magazines pushBackUnique _x } forEach (compatibleMagazines [_weapon, _x]);
} forEach _muzzles;
_magazines;
