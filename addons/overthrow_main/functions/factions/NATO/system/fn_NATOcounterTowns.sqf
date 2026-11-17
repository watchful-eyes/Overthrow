// Modified/added for the unofficial Garrison and Command Expansion, 14-16 November 2026.
// Original author/copyright notices are retained; see LICENSE.md (GNU GPL v2).
/*
    Author: ThomasAngel, ARMAZac

    Description:
    NATO checks if it can try to capture a town for itself

    Parameters:
        -

    Usage: [] call OT_fnc_NATOcounterTowns;

    Returns: Boolean - was a town counter-attacked
*/

params [
    ["_chance", 0, [0]]
];
if (!isServer) exitWith { false };
if ((server getVariable ["NATOattacking", ""]) isNotEqualTo "") exitWith { false };
private _lastAttack = server getVariable ["NATOlastattack", 0];
if ((time - _lastAttack) < 1200) exitWith { false };

if (isNil "OT_townsSortedByPopulation") then {
    OT_townsSortedByPopulation = [OT_allTowns, [], { server getVariable format ["population%1", _x] }, "DESCEND"] call BIS_fnc_sortBy;
};

private _countered = false;
private _lastCounter = server getVariable ["NATOlastcounter", ""];
private _abandoned = server getVariable ["NATOabandoned", []];
private _resources = server getVariable ["NATOresources", 2000];
private _popControl = call OT_fnc_getControlledPopulation;
// Prefer another town, but do not permanently protect the last attacked town.
private _candidates = (OT_townsSortedByPopulation - [_lastCounter]) + (OT_townsSortedByPopulation select { _x isEqualTo _lastCounter });

{
    private _town = _x;
    if !(_town in _abandoned) then { continue };
    private _pos = server getVariable [_town, [0, 0, 0]];
    private _population = server getVariable [format ["population%1", _town], 100];
    if ([_pos] call OT_fnc_inSpawnDistance) then {
        private _numMil = { side _x isEqualTo blufor } count (_pos nearEntities ["CAManBase", 300]);
        private _numRes = { side _x isEqualTo independent || captive _x } count (_pos nearEntities ["CAManBase", 200]);
        if (_numMil < 3 && { _numRes > 0 }) then {
            if (_resources > _population && { (random 100) > _chance }) then {
                // Counter a town
                private _multiplier = 3;
                if (_popControl > 1000) then { _multiplier = 4 };
                if (_popControl > 2000) then { _multiplier = 5 };
                private _cost = _population * _multiplier;
                if (_resources < _cost) then { _cost = _resources };
                _countered = [_town, _cost, _cost, "TOWN"] call OT_fnc_NATOstartCounterattack;
                _resources = server getVariable ["NATOresources", _resources];
            };
        };
    };
    if (_countered) exitWith {};
} forEach _candidates;

server setVariable ["NATOresources", _resources];

_countered;
