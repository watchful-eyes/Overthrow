// Modified/added for the unofficial Garrison and Command Expansion, 14-16 November 2026.
// Original author/copyright notices are retained; see LICENSE.md (GNU GPL v2).
if (!isServer) exitWith { false };
params [["_actor", objNull, [objNull]], ["_kind", "BASE", [""]], ["_town", "", [""]], ["_preset", "", [""]], ["_amount", 1, [0]], ["_quote", -1, [0]]];
if (isNull _actor || { isRemoteExecuted && { remoteExecutedOwner != 2 } && { remoteExecutedOwner != owner _actor || { !isPlayer _actor } } }) exitWith { false };
private _success = false;
private _message = "";
call {
    if (!finite _amount || { _amount < 1 } || { _amount > 32 } || { _amount != floor _amount } || { !finite _quote }) exitWith { _message = "Invalid recruitment quantity." };
    private _site = [_actor, _kind, _town] call OT_fnc_presetRecruitSite;
    if (_site isEqualTo []) exitWith { _message = "You must be near a friendly garrison." };
    if (_preset isNotEqualTo "Police" && { !isClass (configFile >> "CfgVehicles" >> _preset) }) exitWith { _message = "The mod required by this preset is not loaded." };
    if (_kind isEqualTo "BASE" && { _preset isEqualTo "Police" }) exitWith { _message = "Select a soldier preset for the base garrison." };
    private _soldier = [_preset, _actor, false] call OT_fnc_getSoldier;
    if (_soldier isEqualTo []) exitWith { _message = "Soldier preset not found." };
    private _price = (_soldier # 0) * _amount;
    if (!finite _price || { _price < 0 }) exitWith { _message = "Unable to calculate a valid recruitment price." };
    if (_quote isNotEqualTo _price) exitWith { _message = "The preset or price has changed. Refresh the list." };
    _site params ["_code", "_pos"];
    if ((_pos nearEntities ["CAManBase", 50]) findIf { alive _x && { side group _x in [west, east] } } >= 0) exitWith { _message = "You cannot recruit for a garrison while enemies are nearby." };
    if (_kind isEqualTo "TOWN" && { spawner getVariable ["garrisonSpawning" + _town, false] || { (spawner getVariable ["townspawnid" + _town, ""]) isEqualTo "" } }) exitWith { _message = "The garrison is being prepared. Try again in a few seconds." };
    if !([_actor, -_price, "Garrison personnel"] call OT_fnc_changeMoney) exitWith { _message = "Insufficient funds." };
    private _created = [];
    if (_kind isEqualTo "TOWN") then {
        _created = [_town, _soldier, _amount] call OT_fnc_createPoliceGroup;
    } else {
        for "_i" from 1 to _amount do {
            private _unit = [_code, _pos, _soldier, true, false] call OT_fnc_createGarrisonUnit;
            if (!isNull _unit) then { _created pushBack _unit };
        };
    };
    if (count _created < _amount) then { [_actor, (_amount - count _created) * (_soldier # 0), "Refund for unspawned personnel"] call OT_fnc_changeMoney };
    _amount = count _created;
    if (_amount isEqualTo 0) exitWith { _message = "No soldiers could be created; payment has been refunded." };
    if (_kind isEqualTo "TOWN") then {
        private _strength = [_town, _preset, _amount] call OT_fnc_changeGarrisonRoster;
        [_town, 5 * _amount] call OT_fnc_support;
        (_town + "-police") setMarkerText str _strength;
    };
    _success = true;
    _message = format ["%1 x %2 joined the garrison.", _amount, [_preset] call OT_fnc_soldierPresetName];
};
[_message, _success] remoteExecCall ["OT_fnc_garrisonPresetUI", _actor];
_success;
