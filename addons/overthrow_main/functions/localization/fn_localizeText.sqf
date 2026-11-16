// Added 16 November 2026 for the unofficial community fork. GNU GPL v2.
// Translate at presentation boundaries. Network payloads and saved IDs stay
// canonical English, so clients can use different languages on one server.
private _text = _this;
private _language = uiNamespace getVariable ["OT_uiLanguage", "en"];
if (_this isEqualType []) then { _text = _this param [0, ""]; _language = _this param [1, _language] };
if !(_text isEqualType "") exitWith { _text };
if (_language isNotEqualTo "tr" || { _text isEqualTo "" }) exitWith { _text };
private _dictionary = uiNamespace getVariable ["OT_translations", createHashMap];
private _cache = uiNamespace getVariable ["OT_translationCache", createHashMap];
private _cached = _cache get _text;
if (!isNil "_cached") exitWith { _cached };
private _result = _dictionary getOrDefault [_text, ""];
if (_result isEqualTo "") then {
    if ((_text find "<") >= 0 && { (_text find ">") > (_text find "<") }) then {
        // Keep markup untouched and translate its visible text nodes separately.
        _result = "";
        {
            private _part = (_x # 0) # 0;
            if ((_part select [0, 1]) isNotEqualTo "<") then { _part = [_part, _language] call OT_fnc_localizeText };
            _result = _result + _part;
        } forEach (_text regexFind ["<[^>]*>|[^<]+|</g"]);
    } else {
        _result = _text;
        {
            _x params ["_pattern", "_numbers", "_turkish", "_prefix", "_suffix", "_anchor", "_translateArguments"];
            if ((_text find _prefix) isEqualTo 0 && { (_text find _anchor) >= 0 } && { _suffix isEqualTo "" || { (_text select [(count _text - count _suffix) max 0]) isEqualTo _suffix } }) then {
                private _matches = _text regexFind [_pattern];
                if (_matches isNotEqualTo []) then {
                    private _args = [_turkish];
                    _args resize ((selectMax _numbers) + 1);
                    private _valid = true;
                    {
                        private _number = _x;
                        private _value = ((_matches # 0) # (_forEachIndex + 1)) # 0;
                        if (_number in _translateArguments) then { _value = [_value, _language] call OT_fnc_localizeText };
                        if (!isNil { _args # _number } && { (_args # _number) isNotEqualTo _value }) then { _valid = false };
                        _args set [_number, _value];
                    } forEach _numbers;
                    if (_valid) then { _result = format _args };
                };
            };
            if (_result isNotEqualTo _text) exitWith {};
        } forEach (uiNamespace getVariable ["OT_translationTemplates", []]);
        // A final space can delimit an empty format argument. Match the intact
        // message first, then fall back to trimming surrounding layout padding.
        if (_result isEqualTo _text) then {
            private _trimmed = _text regexReplace ["^\s+|\s+$/g", ""];
            if (_trimmed isNotEqualTo _text && { _trimmed isNotEqualTo "" }) then {
                private _start = _text find _trimmed;
                _result = (_text select [0, _start]) + ([_trimmed, _language] call OT_fnc_localizeText) + (_text select [_start + count _trimmed]);
            };
        };
    };
};
// Bound dynamic messages containing names, timestamps, or monetary amounts.
if (count _cache >= 512) then { _cache = createHashMap; uiNamespace setVariable ["OT_translationCache", _cache] };
_cache set [_text, _result];
_result
