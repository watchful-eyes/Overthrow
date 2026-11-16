// Modified/added for the unofficial Garrison and Command Expansion, 14-16 November 2026.
// Original author/copyright notices are retained; see LICENSE.md (GNU GPL v2).
if !([false] call OT_fnc_isServerController) exitWith {};
if (profileNamespace getVariable ["OT_autoload", false]) then {
    profileNamespace setVariable ["OT_autoload", false];
    [format ["<t font='PuristaBold' size='1.15'>AUTOLOAD:<br/>DISABLED</t>"]] remoteExec ["OT_fnc_localizedHint", [0, -2] select isDedicated];
} else {
    profileNamespace setVariable ["OT_autoload", true];
    [format ["<t font='PuristaBold' size='1.15'>AUTOLOAD:<br/>ENABLED</t>"]] remoteExec ["OT_fnc_localizedHint", [0, -2] select isDedicated];
};
saveProfileNamespace;
