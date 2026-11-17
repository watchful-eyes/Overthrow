// Updated 16 November 2026 for notification cards. GNU GPL v2.
/*
=============================================================================================================================
  FILE: fn_topMessage.sqf
  AUTHOR: Asaayu
  DESCRIPTION: Show message that appears form the top of the screen for X minutes and then moves back out of frame.
  CALL: ["<t align='center' font='PuristaBold' size='1.5'>Example Message</t>", 10, true, "click"] spawn OT_fnc_topMessage;
=============================================================================================================================
*/

params [
    ["_text2show", "ERROR"],
    ["_time", 8],
    ["_playSound", false],
    ["_sound", "click"]
];
[_text2show, "big", _time, ["", _sound] select _playSound] call OT_fnc_notify;
