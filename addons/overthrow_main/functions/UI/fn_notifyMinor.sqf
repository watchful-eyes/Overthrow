// Modified/added for the unofficial Garrison and Command Expansion, 14-16 November 2026.
// Original author/copyright notices are retained; see LICENSE.md (GNU GPL v2).
if (!hasInterface) exitWith {};
private _txt = format ["<t size='0.5' color='#ffffff'>%1</t>", _this];
OT_notifies pushBack _txt;
OT_notifyHistory pushBack format ["(%1) %2", call OT_fnc_formatTime, _this];
if (count OT_notifyHistory > 16) then {
    OT_notifyHistory deleteAt 0;
};
