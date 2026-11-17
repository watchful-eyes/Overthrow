// Modified/added for the unofficial Garrison and Command Expansion, 14-16 November 2026.
// Original author/copyright notices are retained; see LICENSE.md (GNU GPL v2).
// A single unscheduled server transaction updates both sides of each transfer.
if (!isServer) exitWith {};
params [
    ["_player", objNull, [objNull]],
    ["_action", "", [""]],
    ["_amount", 0, [0]],
    ["_recipientUID", "", [""]]
];
if (isNull _player || { !isPlayer _player } || { !finite _amount } || { _amount <= 0 }) exitWith {};
if (isRemoteExecuted && { remoteExecutedOwner != 2 } && { remoteExecutedOwner != owner _player }) exitWith {};
if !(_action in ["donate", "withdraw", "transfer"]) exitWith {};
private _uid = getPlayerUID _player;
if (_action isNotEqualTo "donate" && { !(_uid in (server getVariable ["generals", []])) }) exitWith {};

private _funds = server getVariable ["money", 0];
if (_action isEqualTo "donate") exitWith {
    _amount = _amount min (_player getVariable ["money", 0]);
    if (_amount > 0 && { [_player, -_amount, "Donation"] call OT_fnc_changeMoney }) then {
        [_amount] call OT_fnc_resistanceFunds;
        format ["%1 donated $%2 to the resistance", name _player, [_amount, 1, 0, true] call CBA_fnc_formatNumber] remoteExec ["OT_fnc_notifyMinor", 0];
    };
};
_amount = _amount min _funds;
if (_amount <= 0) exitWith {};
if (_action isEqualTo "withdraw") then { _recipientUID = _uid };
if !(_recipientUID in (players_NS getVariable ["OT_allplayers", []])) exitWith {};
private _recipient = objNull;
{ if (getPlayerUID _x isEqualTo _recipientUID) exitWith { _recipient = _x } } forEach ([] call CBA_fnc_players);
if (isNull _recipient) then {
    private _balance = [_recipientUID, "money", 0] call OT_fnc_getOfflinePlayerAttribute;
    if !(_balance isEqualType 0) exitWith {};
    [_recipientUID, "money", _balance + _amount] call OT_fnc_setOfflinePlayerAttribute;
    [-_amount] call OT_fnc_resistanceFunds;
} else {
    if ([_recipient, _amount, "Resistance funds"] call OT_fnc_changeMoney) then {
        [-_amount] call OT_fnc_resistanceFunds;
    };
};
