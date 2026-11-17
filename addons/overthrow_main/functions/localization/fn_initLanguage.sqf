// Added 16 November 2026 for the unofficial community fork. GNU GPL v2.
// UI language belongs to this client, never to the shared campaign state.
private _language = profileNamespace getVariable ["OT_uiLanguage", "en"];
if !(_language in ["en", "tr"]) then { _language = "en" };
uiNamespace setVariable ["OT_uiLanguage", _language];
private _dictionary = createHashMap;
private _templates = [];
private _escape = {
    private _result = "";
    {
        if (_x in [92, 46, 94, 36, 124, 63, 42, 43, 40, 41, 123, 125, 91, 93]) then { _result = _result + "\" };
        _result = _result + toString [_x];
    } forEach toArray _this;
    _result
};
{
    _x params ["_english", "_turkish", ["_translateArguments", []]];
    _dictionary set [_english, _turkish];
    private _placeholders = _english regexFind ["%([1-9][0-9]*)/g"];
    if (_placeholders isNotEqualTo []) then {
        private _pattern = "^";
        private _numbers = [];
        private _offset = 0;
        private _anchor = "";
        private _prefix = "";
        {
            private _position = (_x # 0) # 1;
            private _literal = _english select [_offset, _position - _offset];
            if (_forEachIndex isEqualTo 0) then { _prefix = _literal };
            if (count _literal > count _anchor) then { _anchor = _literal };
            _pattern = _pattern + (_literal call _escape) + "([\s\S]*?)";
            _numbers pushBack parseNumber ((_x # 1) # 0);
            _offset = _position + count ((_x # 0) # 0);
        } forEach _placeholders;
        private _suffix = _english select [_offset];
        if (count _suffix > count _anchor) then { _anchor = _suffix };
        _pattern = _pattern + (_suffix call _escape) + "$/";
        private _specificity = count (_english regexReplace ["%[1-9][0-9]*/g", ""]);
        _templates pushBack [_specificity, _forEachIndex, [_pattern, _numbers, _turkish, _prefix, _suffix, _anchor, _translateArguments]];
    };
} forEach call compile preprocessFileLineNumbers "\overthrow_main\localization\strings.sqf";
uiNamespace setVariable ["OT_translations", _dictionary];
// Prefer complete sentences over short templates such as "You need $%1".
_templates sort false;
uiNamespace setVariable ["OT_translationTemplates", _templates apply { _x # 2 }];
uiNamespace setVariable ["OT_translationCache", createHashMap];
