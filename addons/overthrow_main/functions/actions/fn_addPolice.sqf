// Modified/added for the unofficial Garrison and Command Expansion, 14-16 November 2026.
// Original author/copyright notices are retained; see LICENSE.md (GNU GPL v2).
private _town = player call OT_fnc_nearestTown;
[player, _town, _this] remoteExecCall ["OT_fnc_hireTownGarrison", 2];
