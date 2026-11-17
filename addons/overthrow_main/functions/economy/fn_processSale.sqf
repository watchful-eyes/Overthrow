// Modified/added for the unofficial Garrison and Command Expansion, 14-16 November 2026.
// Original author/copyright notices are retained; see LICENSE.md (GNU GPL v2).
if (!isServer) exitWith {};
params [
    ["_player", objNull, [objNull]],
    ["_target", objNull, [objNull]],
    ["_cls", "", [""]],
    ["_quantity", 1, [0]]
];
if (isNull _player || { !isPlayer _player }) exitWith {};
if (isRemoteExecuted && { remoteExecutedOwner != 2 } && { remoteExecutedOwner != owner _player }) exitWith {};

private _sold = 0;
private _total = 0;
private _sellAll = _quantity isEqualTo -1;
call {
    if (!alive _player || { isNull _target } || { !(_quantity in [1, -1]) }) exitWith {};
    if (_target isNotEqualTo _player && { _target isNotEqualTo vehicle _player }) exitWith {};
    if (_cls isEqualTo "" || { _cls isKindOf "Bag_Base" } || { _cls in OT_allClothing }) exitWith {};
    private _building = nearestBuilding _player;
    private _atShop = _player distance _building <= 20 && { (_building getVariable ["OT_shopCategory", ""]) isNotEqualTo "" };
    private _atHardware = (nearestObjects [_player, [OT_hardwareStore], 20, false]) isNotEqualTo [];
    private _nearDealer = (_player nearEntities ["CAManBase", 20]) findIf { _x getVariable ["shopcheck", false] } != -1;
    if !(_atShop || _atHardware || _nearDealer) exitWith {};

    private _stock = _target call OT_fnc_unitStock;
    private _index = _stock findIf { (_x # 0) isEqualTo _cls };
    if (_index isEqualTo -1) exitWith {};
    private _available = (_stock # _index) # 1;
    if (_quantity isEqualTo -1) then { _quantity = _available };
    private _town = _player call OT_fnc_nearestTown;
    private _standing = ([_town] call OT_fnc_support) * -1;
    private _price = [_town, _cls, _standing] call OT_fnc_getSellPrice;
    if (isNil "_price" || { !finite _price } || { _price < 0 }) exitWith {};

    _sold = [_target, _cls, _quantity min _available] call OT_fnc_removeStock;
    _total = _sold * _price;
    if (_sold > 0) then {
        [_player, _total] call OT_fnc_changeMoney;
        if (_sellAll && { _total > 100 }) then { [_town, round (_total / 100)] call OT_fnc_support };
    };
};
[_sold, _total] remoteExecCall ["OT_fnc_saleCompleted", _player];
