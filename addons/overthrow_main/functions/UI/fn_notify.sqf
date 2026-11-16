// Added 16 November 2026 for the community fork. GNU GPL v2.
disableSerialization;
if (!hasInterface) exitWith {};
params [["_message", "", ["", []]], ["_kind", "minor"], ["_duration", -1], ["_sound", ""]];
if (_message isEqualType []) then { _message = _message param [0, "", [""]] };
if (_message isEqualTo "") exitWith {};
if (isNil "OT_notifyHistory") then { OT_notifyHistory = [] };
// Keep canonical history so opening the menu after a language switch re-localizes it.
OT_notifyHistory pushBack format ["(%1) %2", call OT_fnc_formatTime, _message];
if (count OT_notifyHistory > 16) then { OT_notifyHistory deleteAt 0 };
if (_kind isEqualTo "silent") exitWith {};
private _state = [] call OT_fnc_initNotifications;
[_state, _message, _kind, diag_tickTime, _duration, _sound] call OT_fnc_queueNotification;
[] call OT_fnc_notificationLoop;
