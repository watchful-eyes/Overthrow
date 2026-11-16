// Modified/added for the unofficial Garrison and Command Expansion, 14-16 November 2026.
// Original author/copyright notices are retained; see LICENSE.md (GNU GPL v2).
params [["_weapon", objNull, [objNull]]];
if (isNull _weapon || { isNull attachedTo _weapon }) exitWith {};
if (_weapon getVariable ["OT_getOutHandlerAdded", false]) exitWith {};
_weapon setVariable ["OT_getOutHandlerAdded", true];
_weapon addEventHandler ["GetOut", {
   (_this # 2) moveInAny (attachedTo (_this # 0));
    doGetOut (_this # 2);
}];
