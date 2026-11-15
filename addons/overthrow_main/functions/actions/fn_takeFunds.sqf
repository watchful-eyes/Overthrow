// Modified/added for the unofficial Garrison and Command Expansion, 14-16 November 2026.
// Original author/copyright notices are retained; see LICENSE.md (GNU GPL v2).
closeDialog 0;
OT_inputHandler = {
    private _input = ctrlText 1400;
    if (_input isEqualType "" && count _input > 64) exitWith { hint "You can't take that much!" };
    private _val = parseNumber _input;
    if (_val > 0) then {
        [player, "withdraw", _val] remoteExecCall ["OT_fnc_processFunds", 2];
    };
};

["How much to take from resistance?", 1000] call OT_fnc_inputDialog;
