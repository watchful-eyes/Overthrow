// Modified/added for the unofficial Garrison and Command Expansion, 14-16 November 2026.
// Original author/copyright notices are retained; see LICENSE.md (GNU GPL v2).
if (!hasInterface || { isRemoteExecuted && { remoteExecutedOwner != 2 } }) exitWith {};
[
    { !isNull (findDisplay 46) },
    {
        if ((server getVariable ["StartupType", ""]) isEqualTo ""
            && { player isEqualTo (server getVariable ["OT_startupOwner", objNull]) }
        ) then {
            closeDialog 0;
            createDialog "OT_dialog_start";
        };
    },
    []
] call CBA_fnc_waitUntilAndExecute;
