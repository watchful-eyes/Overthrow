// Modified/added for the unofficial Garrison and Command Expansion, 14-16 November 2026.
// Original author/copyright notices are retained; see LICENSE.md (GNU GPL v2).
params [["_requested", "", [""]]];
if (_requested in OT_spawnTowns) exitWith { _requested };
if (OT_spawnTowns isEqualTo []) exitWith { "" };
selectRandom OT_spawnTowns;
