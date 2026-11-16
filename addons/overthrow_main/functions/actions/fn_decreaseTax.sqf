// Localized 16 November 2026. Original author notices apply (GNU GPL v2).
private _rate = server getVariable ["taxrate", 0];
_rate = _rate - 5;
if (_rate < 0) then { _rate = 0 };
server setVariable ["taxrate", _rate, true];
hint (format ["Tax rate is now %1%2", _rate, "%"] call OT_fnc_localizeText);
