// Modified/added for the unofficial Garrison and Command Expansion, 14-16 November 2026.
// Original author/copyright notices are retained; see LICENSE.md (GNU GPL v2).
// Server authority and a JIP-safe view; client initBaseVar cannot erase edits.
params [["_records", [], [[]]], ["_write", false, [true]]];
if (isServer) exitWith {
    if (_write) then {
        server setVariable ["OT_recruitPresetRecords", +_records];
        server setVariable ["OT_recruitPresetView", +_records, true];
        OT_Recruitables = +_records;
        publicVariable "OT_Recruitables";
    };
    server getVariable ["OT_recruitPresetRecords", missionNamespace getVariable ["OT_Recruitables", []]];
};
server getVariable ["OT_recruitPresetView", missionNamespace getVariable ["OT_Recruitables", []]];
