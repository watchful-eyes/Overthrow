// Localized 16 November 2026. Original author notices apply (GNU GPL v2).
params ["_personOne", "_personTwo", "_lines", ["_onFinish", {}], ["_params", []]];

private _person = _personOne;
{
    _person setRandomLip true;
    _person globalChat (_x call OT_fnc_localizeText);
    sleep ceil ((count _x) * 0.08) + 1;
    _person setRandomLip false;
    if (_person isEqualTo _personOne) then {
        _person = _personTwo;
    } else {
        _person = _personOne;
    };
} forEach (_lines);

_params call _onFinish;
