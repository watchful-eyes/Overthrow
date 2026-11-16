// Added 16 November 2026 for the unofficial community fork. GNU GPL v2.
if (!hasInterface || { !(_this in ["en", "tr"]) }) exitWith { false };
profileNamespace setVariable ["OT_uiLanguage", _this];
saveProfileNamespace;
uiNamespace setVariable ["OT_uiLanguage", _this];
uiNamespace setVariable ["OT_translationCache", createHashMap];
private _tasks = missionNamespace getVariable ["OT_taskDescriptions", createHashMap];
{
    if ([_x] call BIS_fnc_taskExists) then { [_x, _tasks get _x] call OT_fnc_localizeTask } else { _tasks deleteAt _x };
} forEach keys _tasks;
// Language controls exist on these two screens, which contain no unsaved forms.
if (!isNull findDisplay 9230) then { closeDialog 0; call OT_fnc_optionsDialog } else {
    if (!isNull findDisplay 8098) then { closeDialog 0; createDialog "OT_dialog_start" };
};
true
