// Modified/added for the unofficial Garrison and Command Expansion, 14-16 November 2026.
// Original author/copyright notices are retained; see LICENSE.md (GNU GPL v2).
// Isolated server stress measurements. No global FPS claim or speed threshold.
private _passed = 0;
private _check = { params ["_name", "_ok"]; if (!_ok) then { throw format ["FAIL: %1", _name] }; _passed = _passed + 1; diag_log format ["PERFORMANCE PASS: %1", _name] };
private _oldCommanders = compile preprocessFileLineNumbers "perf_baseline_syncCommanders.sqf";
private _oldRaids = compile preprocessFileLineNumbers "perf_baseline_gangRaidLoop.sqf";
private _measure = {
    params ["_label", "_before", "_after"];
    private _a = []; private _b = [];
    isNil { [] call _before; [] call _after }; // Initialize caches outside measurements.
    // Alternate to avoid always measuring one version with the warmer CPU/cache.
    for "_i" from 1 to 11 do {
        private _start = diag_tickTime;
        isNil { [] call _before };
        _a pushBack ((diag_tickTime - _start) * 1000);
        _start = diag_tickTime;
        isNil { [] call _after };
        _b pushBack ((diag_tickTime - _start) * 1000);
    };
    private _sortedA = +_a; _sortedA sort true;
    private _sortedB = +_b; _sortedB sort true;
    diag_log format ["OVERTHROW_PERF=%1|before_ms=%2|after_ms=%3|before_samples=%4|after_samples=%5", _label, _sortedA # 5, _sortedB # 5, _a, _b];
};
server = true call CBA_fnc_createNamespace;
spawner = true call CBA_fnc_createNamespace;
OT_civilians = true call CBA_fnc_createNamespace;
sleep 0.2; // Let newly created global namespace objects finish their first engine frames.
OT_allTowns = []; OT_regions = []; OT_NATOobjectives = []; OT_NATOcomms = [];
OT_spawnDistance = 1000; OT_trackedUnitCache = [[], time + 100000];
private _records = [];
for "_i" from 0 to 999 do {
    private _town = format ["PerfTown%1", _i];
    private _region = format ["PerfRegion%1", _i mod 40];
    OT_allTowns pushBack _town; OT_regions pushBackUnique _region;
    server setVariable [_town, [15000 + _i, 15000, 0]];
    server setVariable ["policepos" + _town, [15000 + _i, 15000, 0]];
    server setVariable ["region_" + _town, _region];
    server setVariable ["population" + _town, 200];
    if (_i < 200) then { _records pushBack ["TOWN", _town, _town, ["Test", "", ""], [], "I_officer_F", "test"] };
    if (_i < 40) then { _records pushBack ["REGION", _region, _town, ["Test", "", ""], [], "I_officer_F", "test"] };
};
server setVariable ["OT_commanders", _records];
server setVariable ["NATOabandoned", +OT_allTowns, true];
["commanders_240_distant_1000_towns", _oldCommanders, OT_fnc_syncCommanders] call _measure;
["Optimized commander scans preserve every persistent record", (server getVariable "OT_commanders") isEqualTo _records] call _check;
["Distant commander benchmark creates no NPCs", (spawner getVariable ["OT_commanderUnits", []]) isEqualTo []] call _check;
private _ids = [];
for "_i" from 0 to 149 do {
    _ids pushBack _i;
    OT_civilians setVariable [format ["gang%1", _i], [[], -1, "PerfTown0", "", [0, 0, 0], [], 350, 1, "Test"]];
};
OT_civilians setVariable ["gangsPerfTown0", _ids];
["gangs_150_unspawned_1000_towns", _oldRaids, OT_fnc_gangRaidLoop] call _measure;
["Ineligible gangs create no raid groups", (spawner getVariable ["OT_gangRaids", []]) isEqualTo []] call _check;
["Performance scans cannot recruit or spend gang resources", _ids findIf { private _g = OT_civilians getVariable format ["gang%1", _x]; (_g # 0) isNotEqualTo [] || { (_g # 6) isNotEqualTo 350 } } isEqualTo -1] call _check;
diag_log format ["OVERTHROW_PERFORMANCE_PASSED=%1", _passed];
