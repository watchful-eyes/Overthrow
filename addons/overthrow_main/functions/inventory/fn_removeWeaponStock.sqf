// Modified/added for the unofficial Garrison and Command Expansion, 14-16 November 2026.
// Original author/copyright notices are retained; see LICENSE.md (GNU GPL v2).
// Mutate one loadout weapon entry, keeping unrelated attachments and loaded magazines.
params ["_weapon", "_cls"];
if (_weapon isEqualTo []) exitWith { false };
if (((_weapon # 0) call BIS_fnc_baseWeapon) isEqualTo _cls) exitWith {
    _weapon resize 0;
    true;
};
private _index = [1, 2, 3, 6] findIf { (_weapon param [_x, ""]) isEqualTo _cls };
if (_index != -1) exitWith { _weapon set [[1, 2, 3, 6] # _index, ""]; true };
_index = [4, 5] findIf { ((_weapon param [_x, []]) param [0, ""]) isEqualTo _cls };
if (_index != -1) exitWith { _weapon set [[4, 5] # _index, []]; true };
false;
