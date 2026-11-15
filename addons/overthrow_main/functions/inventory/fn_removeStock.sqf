// Modified/added for the unofficial Garrison and Command Expansion, 14-16 November 2026.
// Original author/copyright notices are retained; see LICENSE.md (GNU GPL v2).
// Remove real inventory before paying for it. Returns the number actually removed.
params ["_target", "_cls", "_quantity"];
private _removed = 0;
private _matches = {
    params ["_actual"];
    _actual isEqualTo _cls || {
        OT_hasTFAR && { (_cls find "tf_") isEqualTo 0 } && { (_actual find (_cls + "_")) isEqualTo 0 }
    };
};
if (_target isKindOf "CAManBase") exitWith {
    for "_i" from 1 to _quantity do {
        private _items = itemsWithMagazines _target;
        private _index = _items findIf { [_x] call _matches };
        if (_index != -1) then {
            if ([_target, _items # _index] call CBA_fnc_removeItem) then { _removed = _removed + 1 };
        } else {
            private _loadout = getUnitLoadout _target;
            private _slot = [0, 1, 2, 8] findIf { [_loadout # _x, _cls] call OT_fnc_removeWeaponStock };
            if (_slot isEqualTo -1) exitWith {};
            _target setUnitLoadout _loadout;
            _removed = _removed + 1;
        };
    };
    _removed;
};

private _containers = [_target];
private _containerIndex = 0;
while { _containerIndex < count _containers } do {
    private _container = _containers # _containerIndex;
    _containerIndex = _containerIndex + 1;
    {
        _x params ["_cargo", "_remove"];
        private _classes = _cargo call OT_fnc_consolidateArray;
        {
            private _actual = _x;
            if ([_actual] call _matches) then {
                private _amount = _y min (_quantity - _removed);
                if (_amount > 0 && { [_container, _actual, _amount] call _remove }) then {
                    _removed = _removed + _amount;
                };
            };
        } forEach _classes;
    } forEach [
        [itemCargo _container, CBA_fnc_removeItemCargo],
        [magazineCargo _container, CBA_fnc_removeMagazineCargo],
        [backpackCargo _container, CBA_fnc_removeBackpackCargo]
    ];
    if (_removed >= _quantity) exitWith {};

    // Keep the ammo and attachments of every weapon that is not being sold.
    private _weapons = weaponsItemsCargo _container;
    private _changed = false;
    {
        while { _removed < _quantity && { [_x, _cls] call OT_fnc_removeWeaponStock } } do {
            _removed = _removed + 1;
            _changed = true;
        };
    } forEach _weapons;
    if (_changed) then {
        clearWeaponCargoGlobal _container;
        { _container addWeaponWithAttachmentsCargoGlobal [_x, 1] } forEach (_weapons select { _x isNotEqualTo [] });
    };
    if (_removed >= _quantity) exitWith {};
    if (_containerIndex isEqualTo 1) then {
        _containers append ((everyContainer _target) apply { _x # 1 });
    };
};
_removed;
