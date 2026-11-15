// Modified/added for the unofficial Garrison and Command Expansion, 14-16 November 2026.
// Original author/copyright notices are retained; see LICENSE.md (GNU GPL v2).
// Server-local authority is separate from the published UI/save view.
// Only trusted server functions call the write form; this is not an RPC.
params [["_records", [], [[]]], ["_write", false, [true]]];
if (!isServer) exitWith { server getVariable ["OT_commanders", []] };
if (_write) then {
    server setVariable ["OT_commanderRecords", +_records];
    server setVariable ["OT_commanders", +_records, true];
} else {
    if (isNil { server getVariable "OT_commanderRecords" }) then {
        private _initial = +(server getVariable ["OT_commanders", []]);
        server setVariable ["OT_commanderRecords", _initial];
        server setVariable ["OT_commanders", +_initial, true];
    };
};
server getVariable ["OT_commanderRecords", []];
