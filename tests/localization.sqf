// Native Arma regression checks for client language selection and text payloads.
private _checks = 0;
private _assert = {
    params ["_actual", "_expected", "_label"];
    if (_actual isNotEqualTo _expected) then { throw format ["LOCALIZATION %1: got %2, expected %3", _label, _actual, _expected] };
    _checks = _checks + 1;
};
private _catalog = call compile preprocessFileLineNumbers "\overthrow_main\localization\strings.sqf";
{
    _x params ["_english", "_turkish"];
    [[_english, "en"] call OT_fnc_localizeText, _english, "English exact " + str _forEachIndex] call _assert;
    [[_english, "tr"] call OT_fnc_localizeText, _turkish, "Turkish exact " + str _forEachIndex] call _assert;
    private _matches = _english regexFind ["%([1-9][0-9]*)/g"];
    if (_matches isNotEqualTo []) then {
        private _max = selectMax (_matches apply { parseNumber ((_x # 1) # 0) });
        private _args = [];
        for "_number" from 1 to _max do { _args pushBack ("Şahin-" + str _number) };
        private _message = format ([_english] + _args);
        [[_message, "en"] call OT_fnc_localizeText, _message, "English payload " + str _forEachIndex] call _assert;
        [[_message, "tr"] call OT_fnc_localizeText, format ([_turkish] + _args), "Turkish payload " + str _forEachIndex] call _assert;
    };
} forEach _catalog;
[["<t color='#6ee7b7'>Lieutenant General</t><br/>Status: On duty", "tr"] call OT_fnc_localizeText, "<t color='#6ee7b7'>Korgeneral</t><br/>Durum: Görevde", "markup and enum"] call _assert;
[["  New Recruit: Özgür Şahin  ", "tr"] call OT_fnc_localizeText, "  Yeni asker: Özgür Şahin  ", "whitespace and name"] call _assert;
[["Özel Bölük / < 50", "tr"] call OT_fnc_localizeText, "Özel Bölük / < 50", "literal angle bracket"] call _assert;
[["Oyuncu-Şirketi <t>Close</t> <", "tr"] call OT_fnc_localizeText, "Oyuncu-Şirketi <t>Kapat</t> <", "markup with literal tail"] call _assert;
[["player_custom_name_42", "tr"] call OT_fnc_localizeText, "player_custom_name_42", "unknown input"] call _assert;
[["New Recruit: Captain", "tr"] call OT_fnc_localizeText, "Yeni asker: Captain", "name matching a translated rank"] call _assert;
[["(12:30) New Recruit: Özgür Şahin", "tr"] call OT_fnc_localizeText, "(12:30) Yeni asker: Özgür Şahin", "canonical notification history"] call _assert;
[["<t>Please wait... Adjusting Bell Curves</t>", "tr"] call OT_fnc_localizeText, "<t>Lütfen bekleyin... Çan eğrileri ayarlanıyor</t>", "loading message argument"] call _assert;
[["Close", "invalid"] call OT_fnc_localizeText, "Close", "unsupported language fallback"] call _assert;
[uiNamespace getVariable ["OT_uiLanguage", "en"], "en", "fresh profile default"] call _assert;
private _oldLanguage = uiNamespace getVariable ["OT_uiLanguage", "en"];
uiNamespace setVariable ["OT_uiLanguage", "tr"];
["Close" call OT_fnc_localizeText, "Kapat", "local Turkish preference"] call _assert;
uiNamespace setVariable ["OT_uiLanguage", "en"];
["Close" call OT_fnc_localizeText, "Close", "switch back to English"] call _assert;
uiNamespace setVariable ["OT_uiLanguage", _oldLanguage];
[count (uiNamespace getVariable "OT_translationCache") <= 512, true, "bounded message cache"] call _assert;
diag_log format ["OVERTHROW_LOCALIZATION_PASSED=%1", _checks];
