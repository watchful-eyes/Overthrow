// Modified/added for the unofficial Garrison and Command Expansion, 14-16 November 2026.
// Original author/copyright notices are retained; see LICENSE.md (GNU GPL v2).
params [["_fallback", "B_Soldier_F", [""]]];
private _role = [_fallback] call OT_fnc_soldierRole;
private _pools = missionNamespace getVariable ["OT_NATOGarrisonPools", []];
private _index = _pools findIf { (_x # 0) isEqualTo _role };
if (_index < 0) exitWith { _fallback };
(_pools # _index) params ["", "_army", "_rhs"];
// Equal source probability avoids overwhelming the chosen army with RHS variants.
private _pool = if (_rhs isNotEqualTo [] && { random 1 < 0.5 }) then { _rhs } else { _army };
if (_pool isEqualTo []) then { _pool = if (_army isNotEqualTo []) then { _army } else { _rhs } };
if (_pool isEqualTo []) exitWith { _fallback };
selectRandom _pool;
