// Added 16 November 2026 for the unofficial community fork. GNU GPL v2.
// BIS retains canonical task state; only each player's engine task is translated.
if (!isServer) exitWith { "" };
private _id = _this call BIS_fnc_taskCreate;
[_id, _this # 2] remoteExec ["OT_fnc_localizeTask", 0, "OT_languageTask_" + _id];
_id
