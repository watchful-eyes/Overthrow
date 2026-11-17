// Added 16 November 2026 for the community fork. GNU GPL v2.
disableSerialization;
params ["_display", "_entry"];
private _card = _entry getOrDefault ["group", controlNull];
if (isNull _card) then {
    _card = _display ctrlCreate ["OT_NotificationCard", -1];
    _entry set ["group", _card];
    _entry deleteAt "targetY";
    _entry deleteAt "targetHeight";
};
private _style = switch (_entry get "kind") do {
    case "big": { ["ATTENTION", [1, 0.72, 0.30, 1]] };
    case "good": { ["SUCCESS", [0.35, 0.90, 0.65, 1]] };
    case "bad": { ["ALERT", [1, 0.40, 0.38, 1]] };
    default { ["INFORMATION", [0.38, 0.77, 0.90, 1]] };
};
_style params ["_heading", "_color"];
(_card controlsGroupCtrl 102) ctrlSetText (_heading call OT_fnc_localizeText);
(_card controlsGroupCtrl 102) ctrlSetTextColor _color;
(_card controlsGroupCtrl 101) ctrlSetBackgroundColor _color;
(_card controlsGroupCtrl 105) ctrlSetBackgroundColor _color;
private _repeats = _entry get "repeats";
private _badge = "";
if (_repeats > 1) then { _badge = format ["×%1", _repeats min 999] };
if (_repeats > 999) then { _badge = "×999+" };
(_card controlsGroupCtrl 103) ctrlSetText _badge;

// Normalize legacy markup to one readable type size. Full text stays in history.
private _plain = str parseText ((_entry get "message") call OT_fnc_localizeText);
private _characters = toArray _plain;
private _truncated = count _characters > 600;
if (_truncated) then { _characters resize 600 };
private _body = _card controlsGroupCtrl 104;
// Three maximum-height cards plus gaps fit above the chat area.
private _maxHeight = 0.12 * safeZoneH;
private _height = 0;
private _fits = false;
while { !_fits } do {
    private _text = toString _characters;
    if (_truncated) then { _text = _text + "…" };
    _text = _text regexReplace ["&/g", "&amp;"];
    _text = _text regexReplace ["</g", "&lt;"];
    _text = _text regexReplace [">/g", "&gt;"];
    _text = _text regexReplace ["\r?\n/g", "<br/>"];
    _body ctrlSetStructuredText parseText _text;
    _height = (ctrlTextHeight _body) + 0.002 * safeZoneH;
    _fits = _height <= _maxHeight || { count _characters <= 1 };
    if (!_fits) then {
        private _limit = ((floor (count _characters * _maxHeight / _height)) min (count _characters - 8)) max 1;
        _characters resize _limit;
        _truncated = true;
    };
};
_height = (_height max (0.025 * safeZoneH)) min _maxHeight;
_body ctrlSetPositionH _height;
_body ctrlCommit 0;
private _cardHeight = _height + 0.058 * safeZoneH;
{
    (_card controlsGroupCtrl _x) ctrlSetPositionH _cardHeight;
    (_card controlsGroupCtrl _x) ctrlCommit 0;
} forEach [100, 101];
(_card controlsGroupCtrl 105) ctrlSetPositionY (_cardHeight - 0.007 * safeZoneH);
(_card controlsGroupCtrl 105) ctrlCommit 0;
_entry set ["height", _cardHeight];
_entry set ["renderRevision", _entry get "revision"];
_entry set ["language", uiNamespace getVariable ["OT_uiLanguage", "en"]];
