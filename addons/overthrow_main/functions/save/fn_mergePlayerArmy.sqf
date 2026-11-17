// Modified/added for the unofficial Garrison and Command Expansion, 14-16 November 2026.
// Original author/copyright notices are retained; see LICENSE.md (GNU GPL v2).
// Merge one owner's records into the current server list without touching other owners.
params ["_current", "_uid", "_updates", ["_replace", true]];
private _result = +_current;
if (_replace) then { _result = _result select { (_x param [0, ""]) isNotEqualTo _uid } };
_result + _updates;
