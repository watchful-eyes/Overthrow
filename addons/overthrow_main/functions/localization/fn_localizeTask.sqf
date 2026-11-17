// Added 16 November 2026 for the unofficial community fork. GNU GPL v2.
if (!hasInterface || { isRemoteExecuted && { remoteExecutedOwner isNotEqualTo 2 } }) exitWith {};
params ["_id", "_description"];
if (isNil "OT_taskDescriptions") then { OT_taskDescriptions = createHashMap };
OT_taskDescriptions set [_id, _description];
[
    { !isNull ([_this # 0, player] call BIS_fnc_taskReal) },
    {
        params ["_id", "_description"];
        private _task = [_id, player] call BIS_fnc_taskReal;
        _task setSimpleTaskDescription (_description apply { _x call OT_fnc_localizeText });
    },
    [_id, _description], 30
] call CBA_fnc_waitUntilAndExecute;
