// Added 16 November 2026 for the unofficial community fork. GNU GPL v2.
disableSerialization;
params ["_display", ["_className", ""]];
private _displayConfig = configFile >> _className;
{
    private _type = ctrlType _x;
    // Edit fields, pictures, maps, and list data can contain player data/paths.
    if (_type in [0, 1, 13, 16]) then {
        private _text = ctrlText _x;
        if (_type isEqualTo 13 && { _className isNotEqualTo "" }) then {
            // Read the original markup rather than flattening its font/layout.
            private _controlConfig = _displayConfig >> "controls" >> ctrlClassName _x;
            if (isNull _controlConfig) then { _controlConfig = _displayConfig >> "controlsBackground" >> ctrlClassName _x };
            _text = getText (_controlConfig >> "text");
        };
        if (_text isNotEqualTo "") then {
            if (_type isEqualTo 13) then { _x ctrlSetStructuredText parseText (_text call OT_fnc_localizeText) } else { _x ctrlSetText (_text call OT_fnc_localizeText) };
        };
    };
    private _tooltip = ctrlTooltip _x;
    if (_tooltip isNotEqualTo "") then { _x ctrlSetTooltip (_tooltip call OT_fnc_localizeText) };
} forEach allControls _display;
private _language = uiNamespace getVariable ["OT_uiLanguage", "en"];
{
    private _button = _display displayCtrl (_x # 0);
    if (!isNull _button) then {
        _button ctrlSetBackgroundColor ([[0.07, 0.11, 0.14, 1], [0.12, 0.46, 0.37, 1]] select (_language isEqualTo (_x # 1)));
    };
} forEach [[1951, "en"], [1952, "tr"]];
