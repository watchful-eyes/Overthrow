// Modified/added for the unofficial Garrison and Command Expansion, 14-16 November 2026.
// Original author/copyright notices are retained; see LICENSE.md (GNU GPL v2).
params ["_defaults", "_saved"];
private _result = +_defaults;
{
    if (isNil "_x" || { !(_x isEqualType []) } || { count _x != 2 }) then { continue };
    if !((_x # 0) isEqualType "" && { (_x # 1) isEqualType [] }) then { continue };
    _x params ["_cls", "_loadout"];
    private _index = _result findIf { (_x # 0) isEqualTo _cls };
    private _entry = [_cls, +_loadout];
    if (_index isEqualTo -1) then { _result pushBack _entry } else { _result set [_index, _entry] };
} forEach _saved;
_result;
