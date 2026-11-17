// Modified/added for the unofficial Garrison and Command Expansion, 14-16 November 2026.
// Original author/copyright notices are retained; see LICENSE.md (GNU GPL v2).
// Server-internal, called unscheduled by the faction PFH. Reserve the battle
// and its budget together, before either scheduled attack script can start.
if (!isServer) exitWith { false };
params ["_target", "_strength", "_cost", "_kind"];
if !(_kind in ["TOWN", "OBJECTIVE"]) exitWith { false };
if (!finite _strength || { !finite _cost } || { _strength <= 0 } || { _cost <= 0 }) exitWith { false };
if !(_target in (server getVariable ["NATOabandoned", []])) exitWith { false };
if ((server getVariable ["NATOattacking", ""]) isNotEqualTo "") exitWith { false };
if ((time - (server getVariable ["NATOlastattack", 0])) < 1200) exitWith { false };
private _resources = server getVariable ["NATOresources", 2000];
if (_resources < _cost) exitWith { false };

server setVariable ["NATOresources", _resources - _cost, true];
server setVariable ["NATOlastcounter", _target, true];
server setVariable ["NATOattacking", _target, true];
server setVariable ["NATOattackstart", time, true];
server setVariable ["NATOlastattack", time, true];
private _attack = [OT_fnc_NATOCounterObjective, OT_fnc_NATOCounterTown] select (_kind isEqualTo "TOWN");
// Runtime handle only; do not put scripts into the persisted server namespace.
OT_NATOCounterScript = [_target, _strength] spawn _attack;
diag_log format ["Overthrow: Counter-attacking %1", _target];
true;
