// Added 16 November 2026 for the unofficial community fork. GNU GPL v2.
if (!hasInterface) exitWith {};
private _message = _this;
if (_message isEqualType []) then { _message = _message param [0, ""] };
if !(_message isEqualType "") then { _message = str _message };
hint parseText (_message call OT_fnc_localizeText);
