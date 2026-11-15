// Modified/added for the unofficial Garrison and Command Expansion, 14-16 November 2026.
// Original author/copyright notices are retained; see LICENSE.md (GNU GPL v2).
// Allocate existing personnel only. Vacancies remain in the plan; extra personnel form reserves.
params ["_plan", "_strength"];
private _remaining = (floor _strength) max 0;
private _result = [];
{
    private _amount = (_x # 2) min _remaining;
    if (_amount > 0) then { _result pushBack [+_x, _amount] };
    _remaining = _remaining - _amount;
} forEach _plan;
private _counter = 1;
private _reserveSize = 4 max ceil (_remaining / 32);
while { _remaining > 0 } do {
    private _id = format ["reserve_%1", _counter];
    if (_plan findIf { (_x # 0) isEqualTo _id } isEqualTo -1) then {
        private _amount = _reserveSize min _remaining;
        private _name = format [["Reserve %1", "Patrol %1"] select (_plan isEqualTo []), _counter];
        _result pushBack [[_id, _name, _amount, [], "LIMITED", "AUTO"], _amount];
        _remaining = _remaining - _amount;
    };
    _counter = _counter + 1;
};
_result;
