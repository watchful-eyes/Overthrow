// Modified/added for the unofficial Garrison and Command Expansion, 14-16 November 2026.
// Original author/copyright notices are retained; see LICENSE.md (GNU GPL v2).
private _idx = lbCurSel 1500;
inputData = lbData [1500, _idx];
if (inputData isEqualTo "") exitWith {};
closeDialog 0;
OT_inputHandler = {
    private _input = ctrlText 1400;
    if (count _input > 64) exitWith { hint "You can't send that much!" };
    private _amount = parseNumber _input;
    if (_amount > 0) then {
        [player, "transfer", _amount, inputData] remoteExecCall ["OT_fnc_processFunds", 2];
    };
};
["How much to send to this player?", 1000] call OT_fnc_inputDialog;
