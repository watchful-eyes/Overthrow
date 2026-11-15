// Modified/added for the unofficial Garrison and Command Expansion, 14-16 November 2026.
// Original author/copyright notices are retained; see LICENSE.md (GNU GPL v2).
class OT_dialog_garrisonPresets {
    idd = 9240; movingEnable = 0; enableSimulation = 1;
    class controlsBackground {
        class Background: RscOverthrowText {
            x = "safeZoneX + 0.12 * safeZoneW"; y = "safeZoneY + 0.13 * safeZoneH";
            w = "0.76 * safeZoneW"; h = "0.74 * safeZoneH";
            colorBackground[] = {0.025, 0.04, 0.055, 0.98};
        };
    };
    class controls {
        class Title: RscOverthrowText {
            idc = 1100; text = "GARRISON / SOLDIER PRESETS";
            x = "safeZoneX + 0.15 * safeZoneW"; y = "safeZoneY + 0.16 * safeZoneH";
            w = "0.66 * safeZoneW"; h = "0.05 * safeZoneH";
        };
        class Search: RscOverthrowEdit {
            idc = 1400; text = ""; tooltip = "Search unit, faction or role";
            x = "safeZoneX + 0.15 * safeZoneW"; y = "safeZoneY + 0.23 * safeZoneH";
            w = "0.35 * safeZoneW"; h = "0.035 * safeZoneH";
            onKeyUp = "['list'] call OT_fnc_garrisonPresetUI";
        };
        class Presets: RscOverthrowListBox {
            idc = 1500;
            x = "safeZoneX + 0.15 * safeZoneW"; y = "safeZoneY + 0.28 * safeZoneH";
            w = "0.35 * safeZoneW"; h = "0.49 * safeZoneH";
            onLBSelChanged = "['select'] call OT_fnc_garrisonPresetUI";
        };
        class Info: RscOverthrowStructuredText {
            idc = 1101;
            x = "safeZoneX + 0.52 * safeZoneW"; y = "safeZoneY + 0.25 * safeZoneH";
            w = "0.33 * safeZoneW"; h = "0.33 * safeZoneH";
        };
        class HireOne: RscOverthrowButton {
            idc = 1600; text = "+1 soldier";
            x = "safeZoneX + 0.52 * safeZoneW"; y = "safeZoneY + 0.60 * safeZoneH";
            w = "0.10 * safeZoneW"; h = "0.045 * safeZoneH";
            action = "['hire', 1] call OT_fnc_garrisonPresetUI";
        };
        class HireFour: HireOne {
            idc = 1601; text = "+4 soldiers"; x = "safeZoneX + 0.635 * safeZoneW";
            action = "['hire', 4] call OT_fnc_garrisonPresetUI";
        };
        class HireEight: HireOne {
            idc = 1602; text = "+8 soldiers"; x = "safeZoneX + 0.75 * safeZoneW";
            action = "['hire', 8] call OT_fnc_garrisonPresetUI";
        };
        class Edit: RscOverthrowButton {
            idc = 1603; text = "Edit preset in ACE Arsenal";
            x = "safeZoneX + 0.52 * safeZoneW"; y = "safeZoneY + 0.66 * safeZoneH";
            w = "0.33 * safeZoneW"; h = "0.045 * safeZoneH";
            action = "['edit'] call OT_fnc_garrisonPresetUI";
        };
        class Feedback: RscOverthrowText {
            idc = 1105;
            x = "safeZoneX + 0.15 * safeZoneW"; y = "safeZoneY + 0.79 * safeZoneH";
            w = "0.64 * safeZoneW"; h = "0.045 * safeZoneH";
        };
        class Close: RscOverthrowButton {
            text = "X"; x = "safeZoneX + 0.82 * safeZoneW"; y = "safeZoneY + 0.16 * safeZoneH";
            w = "0.03 * safeZoneW"; h = "0.04 * safeZoneH"; action = "closeDialog 0";
        };
    };
};
