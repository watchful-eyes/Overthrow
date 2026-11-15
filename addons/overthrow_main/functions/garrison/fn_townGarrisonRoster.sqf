// Modified/added for the unofficial Garrison and Command Expansion, 14-16 November 2026.
// Original author/copyright notices are retained; see LICENSE.md (GNU GPL v2).
params [["_town", "", [""]]];
private _key = "garrisonRoster" + _town;
private _stored = server getVariable [_key, []];
if (_stored isEqualTo []) exitWith {
    private _count = (server getVariable ["police" + _town, 0]) max 0;
    if (_count > 0) then { [["Police", _count]] } else { [] };
};
+_stored;
