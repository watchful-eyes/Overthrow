// Localized 16 November 2026. Original author notices apply (GNU GPL v2).
private _aug = (_this select 0) getVariable ["OT_Attached", false];
if ((crew _aug) isNotEqualTo []) exitWith { hint ('Weapon must be empty to mount' call OT_fnc_localizeText) };
(_this select 1) moveInGunner _aug;
