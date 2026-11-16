// Added 16 November 2026 for the community fork. GNU GPL v2.
disableSerialization;
if (!hasInterface) exitWith { createHashMap };
params [["_reset", false, [true]]];
private _state = uiNamespace getVariable ["OT_notificationState", createHashMap];
if (!_reset && { count _state > 0 }) exitWith { _state };
if (!isNull (uiNamespace getVariable ["OT_notificationDisplay", displayNull])) then {
    ("OT_notifications" call BIS_fnc_rscLayer) cutText ["", "PLAIN"];
};
private _generation = 1 + (uiNamespace getVariable ["OT_notificationGeneration", 0]);
uiNamespace setVariable ["OT_notificationGeneration", _generation];
_state = createHashMapFromArray [
    ["pending", []], ["active", []], ["running", false], ["generation", _generation]
];
uiNamespace setVariable ["OT_notificationState", _state];
_state
