// Modified/added for the unofficial Garrison and Command Expansion, 14-16 November 2026.
// Original author/copyright notices are retained; see LICENSE.md (GNU GPL v2).
// Reorganize friendly city police; never include player groups or owned recruits.
if (!isServer) exitWith {};
params ["_town"];
if !(_town in (server getVariable ["NATOabandoned", []])) exitWith {};
if (spawner getVariable [format ["garrisonSpawning%1", _town], false]) exitWith {
    spawner setVariable [format ["garrisonRebuildPending%1", _town], true];
};
private _oldGroups = allGroups select {
    side _x isEqualTo independent
        && { (units _x) findIf { isPlayer _x || { _x call OT_fnc_hasOwner } } isEqualTo -1 }
        && { (units _x) findIf { (_x getVariable ["polgarrison", ""]) isEqualTo _town && { !(_x call OT_fnc_hasOwner) } } != -1 }
};
private _personnel = [];
{
    _personnel append (units _x select {
        alive _x && { (_x getVariable ["polgarrison", ""]) isEqualTo _town } && { !(_x call OT_fnc_hasOwner) }
    });
} forEach _oldGroups;
private _plan = server getVariable [format ["garrisonplan%1", _town], []];
private _layout = [_plan, count _personnel] call OT_fnc_townGarrisonLayout;
private _center = server getVariable [format ["policepos%1", _town], server getVariable _town];
private _cursor = 0;
private _groups = [];
{
    _x params ["_entry", "_amount"];
    private _group = createGroup [independent, true];
   (_personnel select [_cursor, _amount]) joinSilent _group;
    _cursor = _cursor + _amount;
    _group setVariable ["OT_townGarrison", _town, true];
    _group setVariable ["OT_garrisonCompany", _entry # 0, true];
    _group setGroupIdGlobal [format ["%1 / %2", _town, _entry # 1]];
    [_group, _entry, _center] call OT_fnc_applyTownGarrisonRoute;
    _groups pushBack _group;
} forEach _layout;
{
    if (units _x isEqualTo []) then { [_x] call OT_fnc_cleanupEmptyGroup };
} forEach _oldGroups;
private _spawnid = spawner getVariable [format ["townspawnid%1", _town], ""];
if (_spawnid isEqualType "" && { _spawnid isNotEqualTo "" }) then {
    private _objects = (spawner getVariable [_spawnid, []]) select { !(_x in _oldGroups) || { _x isEqualType grpNull && { units _x isNotEqualTo [] } } };
    spawner setVariable [_spawnid, _objects + _groups];
};
spawner setVariable [format ["garrisongroups%1", _town], _groups, true];
