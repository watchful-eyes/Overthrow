// Modified/added for the unofficial Garrison and Command Expansion, 14-16 November 2026.
// Original author/copyright notices are retained; see LICENSE.md (GNU GPL v2).
// Shared role keys keep mixed garrisons' specialists in their original jobs.
params [["_class", "", [""]]];
private _cfg = configFile >> "CfgVehicles" >> _class;
if (!isClass _cfg || { !(_class isKindOf "CAManBase") }) exitWith { "" };
private _name = toLowerANSI _class;
private _role = toLowerANSI getText (_cfg >> "role");
if (["story", "unarmed", "survivor", "pettka", "captain_jay", "competitor"] findIf { _x in _name } != -1) exitWith { "" };
if ("pilot" in _name || { _role isEqualTo "pilot" }) exitWith { "pilot" };
if ("crew" in _name || { _role isEqualTo "crewman" }) exitWith { "crew" };
if ("officer" in _name) exitWith { "officer" };
if ("spotter" in _name) exitWith { "spotter" };
if ("sniper" in _name) exitWith { "sniper" };
if (getNumber (_cfg >> "attendant") isEqualTo 1 || { _role isEqualTo "combatlifesaver" }) exitWith { "medic" };
if (getNumber (_cfg >> "engineer") isEqualTo 1 || { _role isEqualTo "sapper" }) exitWith { "engineer" };
if (getText (_cfg >> "icon") isEqualTo "iconManLeader" || { "_teamleader" in _name } || { "_squadleader" in _name } || { "_commander" in _name }) exitWith { "leader" };
if (_role isEqualTo "missilespecialist") exitWith {
    if (["_aa", "stinger", "igla"] findIf { _x in _name } != -1) then { "aa" } else { "at" };
};
if (_role isEqualTo "machinegunner") exitWith { "mg" };
if (_role isEqualTo "grenadier") exitWith { "gl" };
if (_role isEqualTo "marksman") exitWith { "marksman" };
if ("recon" in _name || { "diver" in _name }) exitWith { "recon" };
if (_role isEqualTo "rifleman") exitWith { "rifleman" };
"";
