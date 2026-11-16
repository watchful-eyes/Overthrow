// Modified/added for the unofficial Garrison and Command Expansion, 14-16 November 2026.
// Original author/copyright notices are retained; see LICENSE.md (GNU GPL v2).
params ["_gangid", ["_amt", 1], ["_spawn", true]];

private _count = 0;
private _gang = OT_civilians getVariable [format ["gang%1", _gangid], []];
private _town = _gang select 2;
private _townpos = server getVariable _town;

while { _count < _amt } do {
    private _civid = (OT_civilians getVariable ["autocivid", -1]) + 1;
    OT_civilians setVariable ["autocivid", _civid];
   (_gang select 0) pushBack _civid;

    private _identity = call OT_fnc_randomLocalIdentity;
    _identity set [1, selectRandom OT_CRIM_Clothes];
    _identity set [3, selectRandom OT_CRIM_Goggles];
    _identity pushBack (selectRandom OT_voices_local);

    private _civ = [_identity, _gangid];
    OT_civilians setVariable [format ["%1", _civid], _civ];

    if (_spawn && [_townpos] call OT_fnc_inSpawnDistance) then {
        OT_civilians setVariable [format ["gang%1", _gangid], _gang, true];
        [_gangid] call OT_fnc_ensureGangGroup;
    };
    _count = _count + 1;
};
