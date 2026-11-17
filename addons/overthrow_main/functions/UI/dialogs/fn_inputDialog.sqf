// Localized 16 November 2026. Original author notices apply (GNU GPL v2).
createDialog "OT_dialog_input";

[
    {
        disableSerialization;
        params ["_text", "_default"];
        private _ctrl = (findDisplay 8001) displayCtrl 1100;
        _ctrl ctrlSetStructuredText parseText (_text call OT_fnc_localizeText);
        ctrlSetText [1400, format ["%1", _default]];
    },
    _this
] call CBA_fnc_waitAndExecute;
