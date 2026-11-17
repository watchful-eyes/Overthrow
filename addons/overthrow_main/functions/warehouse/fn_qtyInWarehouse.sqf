// Localized 16 November 2026. Original author notices apply (GNU GPL v2).
private _warehouse = [player] call OT_fnc_nearestWarehouse;
if (_warehouse == objNull) exitWith { hint ("No warehouse near by!" call OT_fnc_localizeText) };

private _ret = 0;
private _d = _warehouse getVariable [format ["item_%1", _this], [_this, 0, [0]]];
if (_d isEqualType []) then {
    _d params ["", "_in"];
    _ret = _in;
};
_ret;
