// Added 16 November 2026 for the community fork. GNU GPL v2.
// Use the same supported BLUFOR armies as the lobby, filtering missing mods.
params [["_mapDefault", missionNamespace getVariable ["OT_mapEnemyFaction", "BLU_F"], [""]]];
private _default = [_mapDefault, "BLU_F"] call OT_fnc_resolveEnemyFaction;
private _choices = [[_default, format ["Map default: %1", getText (configFile >> "CfgFactionClasses" >> _default >> "displayName")]]];
{
    _x params ["_faction", "_label"];
    if (_faction isNotEqualTo _default && { ([_faction, "BLU_F"] call OT_fnc_resolveEnemyFaction) isEqualTo _faction }) then { _choices pushBack [_faction, _label] };
} forEach [
    ["BLU_F", "Vanilla NATO"],
    ["BLU_T_F", "Vanilla NATO Pacific"],
    ["BLU_W_F", "Vanilla NATO Woodland"],
    ["rhs_faction_usarmy_wd", "RHS US Army Woodland"],
    ["rhs_faction_usarmy_d", "RHS US Army Desert"],
    ["rhs_faction_usmc_wd", "RHS USMC Woodland"],
    ["rhs_faction_usmc_d", "RHS USMC Desert"],
    ["rhsgref_faction_hidf", "RHS Horizon Islands Defence Force"],
    ["UK3CB_AAF_B", "3CB AAF"],
    ["UK3CB_LDF_B", "3CB Livonian Defence Force"],
    ["UK3CB_LSM_B", "3CB Livonia Separatist Militia"],
    ["UK3CB_MDF_B", "3CB Malden Defence Force"],
    ["UK3CB_MEI_B", "3CB Middle East Insurgents"]
];
_choices
