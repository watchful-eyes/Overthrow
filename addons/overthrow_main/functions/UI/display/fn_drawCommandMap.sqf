// Modified/added for the unofficial Garrison and Command Expansion, 14-16 November 2026.
// Original author/copyright notices are retained; see LICENSE.md (GNU GPL v2).
params ["_map"];
if (isNull player) exitWith {};
_map drawIcon ["\a3\ui_f\data\map\vehicleicons\iconMan_ca.paa", [0.35, 1, 0.75, 1], getPosWorld player, 24, 24, getDir player, "YOUR POSITION", 1, 0.03, "PuristaMedium", "right"];
private _qrf = server getVariable ["QRFpos", []];
if (count _qrf >= 2) then { _map drawEllipse [_qrf, 200, 200, 0, [1, 0.38, 0.25, 0.8], ""] };
