// Updated 16 November 2026 for animated notification cards. GNU GPL v2.
disableSerialization;
if (!hasInterface) exitWith {};
private _state = [] call OT_fnc_initNotifications;
private _generation = _state get "generation";
private _scheduled = _this isEqualType 0;
if (_scheduled && { _this isNotEqualTo _generation }) exitWith {};
if (!_scheduled && { _state get "running" }) exitWith {};
_state set ["running", true];
private _pending = _state get "pending";
private _active = _state get "active";
if (_pending isEqualTo [] && { _active isEqualTo [] }) exitWith {
    _state set ["running", false];
    ("OT_notifications" call BIS_fnc_rscLayer) cutText ["", "PLAIN"];
};
private _display = uiNamespace getVariable ["OT_notificationDisplay", displayNull];
if (isNull _display) then {
    ("OT_notifications" call BIS_fnc_rscLayer) cutRsc ["OT_notificationHUD", "PLAIN", 0, false];
    _display = uiNamespace getVariable ["OT_notificationDisplay", displayNull];
    // Retain visible messages when the engine recreates the HUD.
    { _x deleteAt "group"; _x set ["phase", "new"]; _x deleteAt "born" } forEach _active;
    _pending insert [0, _active];
    _active resize 0;
    if (count _pending > 16) then { _pending resize 16 };
};
if (isNull _display) exitWith { [OT_fnc_notificationLoop, _generation, 0.1] call CBA_fnc_waitAndExecute };
private _now = diag_tickTime;
private _language = uiNamespace getVariable ["OT_uiLanguage", "en"];
for "_index" from (count _active - 1) to 0 step -1 do {
    private _entry = _active # _index;
    private _card = _entry get "group";
    if ((_entry get "phase") isEqualTo "exit") then {
        if (_now >= (_entry get "exitAt")) then { ctrlDelete _card; _active deleteAt _index };
    } else {
        if (_now >= (_entry get "expires")) then {
            _entry set ["phase", "exit"];
            _entry set ["exitAt", _now + 0.20];
            _card ctrlSetFade 1;
            _card ctrlSetPositionX (safeZoneX - 0.04 * safeZoneW);
            _card ctrlCommit 0.18;
        } else {
            if ((_entry get "renderRevision") isNotEqualTo (_entry get "revision") || { (_entry get "language") isNotEqualTo _language }) then {
                [_display, _entry] call OT_fnc_renderNotification;
            };
        };
    };
};
while { count _active < 3 && { _pending isNotEqualTo [] } } do {
    private _entry = _pending deleteAt 0;
    [_display, _entry] call OT_fnc_renderNotification;
    _entry set ["born", _now];
    _entry set ["expires", _now + (_entry get "duration")];
    _active pushBack _entry;
};
private _y = safeZoneY + 0.13 * safeZoneH;
{
    private _entry = _x;
    private _card = _entry get "group";
    private _height = _entry get "height";
    if ((_entry get "phase") isEqualTo "new") then {
        _card ctrlSetPosition [safeZoneX - 0.28 * safeZoneW, _y, 0.27 * safeZoneW, _height];
        _card ctrlSetFade 1;
        _card ctrlCommit 0;
        _entry set ["phase", "hold"];
        private _sound = _entry get "sound";
        if (_sound isEqualTo "" && { (_entry get "kind") in ["good", "bad"] }) then {
            private _notification = ["TaskSucceeded", "TaskFailed"] select ((_entry get "kind") isEqualTo "bad");
            _sound = getText (configFile >> "CfgNotifications" >> _notification >> "sound");
        };
        if (_sound isNotEqualTo "") then { playSound [_sound, false] };
    };
    if ((_entry get "phase") isNotEqualTo "exit") then {
        if ((_entry getOrDefault ["targetY", -10]) isNotEqualTo _y || { (_entry getOrDefault ["targetHeight", -1]) isNotEqualTo _height }) then {
            _card ctrlSetPosition [safeZoneX + 0.025 * safeZoneW, _y, 0.27 * safeZoneW, _height];
            _card ctrlSetFade 0;
            _card ctrlCommit 0.22;
            _entry set ["targetY", _y];
            _entry set ["targetHeight", _height];
        };
        private _remaining = (((_entry get "expires") - _now) / (_entry get "duration")) max 0 min 1;
        (_card controlsGroupCtrl 105) ctrlSetPositionW (0.245 * safeZoneW * _remaining);
        (_card controlsGroupCtrl 105) ctrlCommit 0.05;
    };
    _y = _y + _height + 0.008 * safeZoneH;
} forEach _active;
[OT_fnc_notificationLoop, _generation, 0.05] call CBA_fnc_waitAndExecute;
