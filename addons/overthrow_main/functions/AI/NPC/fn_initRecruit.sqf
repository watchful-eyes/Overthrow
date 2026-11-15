// Modified/added for the unofficial Garrison and Command Expansion, 14-16 November 2026.
// Original author/copyright notices are retained; see LICENSE.md (GNU GPL v2).
params ["_civ"];

removeAllActions _civ;
_civ removeAllEventHandlers "FiredNear";

[_civ, selectRandom OT_voices_local] remoteExecCall ["setSpeaker", 0, _civ];

_civ setSkill 0.1 + (random 0.3);
_civ setRank "PRIVATE";
_civ setVariable ["NOAI", true, true];

_civ call OT_fnc_wantedSystem;

private _nameparts = [name _civ];
_nameparts append (name _civ splitString " ");

private _recruit = [getPlayerUID player, _nameparts, _civ, "PRIVATE", [], typeOf _civ, 0];
[player, [_recruit], [], false] remoteExecCall ["OT_fnc_updatePlayerArmy", 2];
