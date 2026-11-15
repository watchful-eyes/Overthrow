// Modified/added for the unofficial Garrison and Command Expansion, 14-16 November 2026.
// Original author/copyright notices are retained; see LICENSE.md (GNU GPL v2).
/*
	Author: ThomasAngel
	Steam: https://steamcommunity.com/id/Thomasangel/
	Github: https://github.com/rekterakathom

	Description:
	Returns the nearest (owned) warehouse object

	Parameters:
		_this # 0: POSITION OR OBJECT

	Usage: [player] call OT_fnc_nearestWarehouse;

	Returns: Warehouse object, objNull if not found.
*/

params [
    ["_searchPos", [0, 0, 0], [objNull, []], [2, 3]],
    ["_resolveShared", true, [true]]
];

private _warehouse = objNull;

if (_searchPos isEqualType objNull) then {
    _searchPos = getPosASL _searchPos;
    _searchPos = [_searchPos # 0, _searchPos # 1]; // Convert to 2D to increase chances of match in cache
};

// Check the cache for _searchPos. Function will often get called from same position multiple times
if (_searchPos in OT_warehouseLocationCache) then {
    _warehouse = OT_warehouseLocationCache get _searchPos;
} else {
    private _owned = warehouse getVariable ["owned", []];
    if (_owned isNotEqualTo []) then {
        private _closestWarehouse = ([_owned, [], { _x distance2D _searchPos }, "ASCEND"] call BIS_fnc_sortBy) # 0;
        if ((_closestWarehouse distance2D _searchPos) < 2000) then { _warehouse = _closestWarehouse };

        // Cache the physical warehouse, not its mutable shared-inventory destination.
        OT_warehouseLocationCache set [_searchPos, _warehouse];
    } else {
        // Last resort
        private _range = 50;
        private _found = false;
        while { !_found && _range < 1550 } do {
            private _objects = nearestObjects [_searchPos, [OT_warehouse], _range];
            if (_objects isNotEqualTo []) then {
                _warehouse = _objects # 0;
                _found = true;
            };
            _range = _range + 100;
        };
    };
};

if (_warehouse isEqualTo objNull) then {
    diag_log "Overthrow: Couldn't find warehouse, defaulted to objNull";
};

if (_resolveShared && { !isNull _warehouse } && { _warehouse getVariable ["is_shared", false] }) then {
    _warehouse = warehouse_shared;
};

_warehouse;
