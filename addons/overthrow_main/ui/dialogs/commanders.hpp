// Modified/added for the unofficial Garrison and Command Expansion, 14-16 November 2026.
// Original author/copyright notices are retained; see LICENSE.md (GNU GPL v2).
class OT_dialog_commanders {
    onLoad = "[_this # 0, 'OT_dialog_commanders'] call OT_fnc_localizeDisplay";
    idd = 9220; movingEnable = 0; enableSimulation = 1;
    class controlsBackground {
        class Background: RscOverthrowText {
            x = "safeZoneX + 0.22 * safeZoneW"; y = "safeZoneY + 0.12 * safeZoneH";
            w = "0.56 * safeZoneW"; h = "0.76 * safeZoneH";
            colorBackground[] = {0.025, 0.04, 0.045, 0.98};
        };
    };
    class controls {
        class Title: RscOverthrowText {
            idc = 1100; text = "COMMAND / PERSONNEL";
            x = "safeZoneX + 0.25 * safeZoneW"; y = "safeZoneY + 0.15 * safeZoneH";
            w = "0.46 * safeZoneW"; h = "0.05 * safeZoneH"; sizeEx = 0.035;
        };
        class Scope: RscOverthrowCombo {
            idc = 2100;
            x = "safeZoneX + 0.25 * safeZoneW"; y = "safeZoneY + 0.23 * safeZoneH";
            w = "0.50 * safeZoneW"; h = "0.04 * safeZoneH";
            onLBSelChanged = "['refresh'] call OT_fnc_commanderUI";
        };
        class Information: RscOverthrowStructuredText {
            idc = 1101;
            x = "safeZoneX + 0.25 * safeZoneW"; y = "safeZoneY + 0.30 * safeZoneH";
            w = "0.50 * safeZoneW"; h = "0.32 * safeZoneH";
        };
        class Hire: RscOverthrowButton {
            idc = 1600; text = "Hire commander";
            x = "safeZoneX + 0.25 * safeZoneW"; y = "safeZoneY + 0.65 * safeZoneH";
            w = "0.24 * safeZoneW"; h = "0.045 * safeZoneH";
            action = "['hire'] call OT_fnc_commanderUI";
        };
        class Dismiss: RscOverthrowButton {
            idc = 1601; text = "Dismiss (no refund)";
            x = "safeZoneX + 0.51 * safeZoneW"; y = "safeZoneY + 0.65 * safeZoneH";
            w = "0.24 * safeZoneW"; h = "0.045 * safeZoneH";
            action = "['dismiss'] call OT_fnc_commanderUI";
        };
        class Move: RscOverthrowButton {
            idc = 1602; text = "Move regional HQ here";
            x = "safeZoneX + 0.25 * safeZoneW"; y = "safeZoneY + 0.71 * safeZoneH";
            w = "0.50 * safeZoneW"; h = "0.045 * safeZoneH";
            action = "['relocate'] call OT_fnc_commanderUI";
        };
        class Feedback: RscOverthrowText {
            idc = 1102;
            x = "safeZoneX + 0.25 * safeZoneW"; y = "safeZoneY + 0.77 * safeZoneH";
            w = "0.50 * safeZoneW"; h = "0.035 * safeZoneH"; sizeEx = 0.023;
        };
        class Refresh: RscOverthrowButton {
            idc = 1603; text = "Refresh";
            x = "safeZoneX + 0.25 * safeZoneW"; y = "safeZoneY + 0.82 * safeZoneH";
            w = "0.24 * safeZoneW"; h = "0.035 * safeZoneH";
            action = "['refresh'] call OT_fnc_commanderUI";
        };
        class Close: RscOverthrowButton {
            idc = 1604; text = "Close";
            x = "safeZoneX + 0.51 * safeZoneW"; y = "safeZoneY + 0.82 * safeZoneH";
            w = "0.24 * safeZoneW"; h = "0.035 * safeZoneH"; action = "closeDialog 0";
        };
    };
};
