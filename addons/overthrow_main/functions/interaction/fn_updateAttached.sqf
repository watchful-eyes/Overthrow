// Modified/added for the unofficial Garrison and Command Expansion, 14-16 November 2026.
// Original author/copyright notices are retained; see LICENSE.md (GNU GPL v2).
params ["_vehicle", "_text", "_icon"];
private _action = _vehicle getVariable ["OT_Act_GetIn", -1];
if (_action >= 0) then { _vehicle setUserActionText [_action, _text, _icon] };
