// Modified/added for the unofficial Garrison and Command Expansion, 14-16 November 2026.
// Original author/copyright notices are retained; see LICENSE.md (GNU GPL v2).
params ["_map"];
private _display = ctrlParent _map;
private _town = _display getVariable ["startTown", ""];
if (_town isEqualTo "") exitWith {};
private _pos = _display getVariable ["startPosition", [0, 0, 0]];
_map drawEllipse [_pos, 140, 140, 0, [0.3, 0.9, 0.65, 0.8], ""];
_map drawIcon [_display getVariable ["startIcon", ""], [0.45, 1, 0.75, 1], _pos, 28, 28, 0, _town, 1, 0.04, "PuristaMedium", "right"];
