// Modified/added for the unofficial Garrison and Command Expansion, 14-16 November 2026.
// Original author/copyright notices are retained; see LICENSE.md (GNU GPL v2).
// [display rank, supported engine rank, purchase price]. Population is the
// settlement size; a region uses the combined population of all its towns.
params ["_kind", "_population"];
if (!(_kind in ["TOWN", "REGION"]) || { !(_population isEqualType 0) } || { !finite _population } || { _population < 0 }) exitWith { [] };
if (_kind isEqualTo "REGION") exitWith {
    if (_population >= 6000) exitWith { ["Lieutenant General", "COLONEL", 20000] };
    if (_population >= 2000) exitWith { ["Major General", "COLONEL", 15000] };
    ["Brigadier General", "COLONEL", 10000];
};
if (_population >= 1000) exitWith { ["Colonel", "COLONEL", 6000] };
if (_population >= 500) exitWith { ["Major", "MAJOR", 4000] };
if (_population >= 100) exitWith { ["Captain", "CAPTAIN", 3000] };
["Lieutenant", "LIEUTENANT", 2000];
