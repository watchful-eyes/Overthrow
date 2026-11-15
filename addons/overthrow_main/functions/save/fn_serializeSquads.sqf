// Modified/added for the unofficial Garrison and Command Expansion, 14-16 November 2026.
// Original author/copyright notices are retained; see LICENSE.md (GNU GPL v2).
// Preserve squads whose owner has not connected yet, as well as active groups.
private _saved = [];
{
    _x params ["_owner", "_cls", "_group", ["_units", []], ["_name", ""]];
    if (_group isEqualType grpNull) then {
        _units = (units _group select { alive _x }) apply {
            [typeOf _x, getPos _x, getUnitLoadout _x];
        };
        _name = groupId _group;
    };
    if (_units isNotEqualTo []) then {
        if (_name isEqualTo "") then { _name = _cls };
        _saved pushBack [_owner, _cls, "Not a group, pls recreate", _units, _name];
    };
} forEach _this;
_saved;
