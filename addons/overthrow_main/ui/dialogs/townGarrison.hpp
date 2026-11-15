// Modified/added for the unofficial Garrison and Command Expansion, 14-16 November 2026.
// Original author/copyright notices are retained; see LICENSE.md (GNU GPL v2).
class OT_dialog_townGarrison {
    idd = 9210;
    movingEnable = 0;
    enableSimulation = 1;
    class controlsBackground {
        class Background: RscOverthrowText {
            x = "safeZoneX + 0.025 * safeZoneW"; y = "safeZoneY + 0.045 * safeZoneH";
            w = "0.95 * safeZoneW"; h = "0.91 * safeZoneH";
            colorBackground[] = {0.025, 0.035, 0.03, 0.96};
        };
    };
    class controls {
        class Title: RscOverthrowText {
            idc = 1100;
            x = "safeZoneX + 0.04 * safeZoneW"; y = "safeZoneY + 0.06 * safeZoneH";
            w = "0.8 * safeZoneW"; h = "0.045 * safeZoneH";
            sizeEx = 0.038;
        };
        class CompanyLabel: RscOverthrowText {
            idc = -1;
            x = "safeZoneX + 0.04 * safeZoneW"; y = "safeZoneY + 0.14 * safeZoneH";
            w = "0.28 * safeZoneW"; h = "0.035 * safeZoneH";
            text = "Companies";
            sizeEx = 0.03;
        };
        class Companies: RscOverthrowListBox {
            idc = 1500;
            x = "safeZoneX + 0.04 * safeZoneW"; y = "safeZoneY + 0.18 * safeZoneH";
            w = "0.28 * safeZoneW"; h = "0.25 * safeZoneH";
            sizeEx = 0.028;
            onLBSelChanged = "['select', _this] call OT_fnc_townGarrisonUI";
        };
        class Add: RscOverthrowButton {
            idc = 1600;
            x = "safeZoneX + 0.04 * safeZoneW"; y = "safeZoneY + 0.44 * safeZoneH";
            w = "0.135 * safeZoneW"; h = "0.036 * safeZoneH";
            text = "New company";
            sizeEx = 0.026;
            action = "['add'] call OT_fnc_townGarrisonUI";
        };
        class Remove: RscOverthrowButton {
            idc = 1601;
            x = "safeZoneX + 0.185 * safeZoneW"; y = "safeZoneY + 0.44 * safeZoneH";
            w = "0.135 * safeZoneW"; h = "0.036 * safeZoneH";
            text = "Remove company";
            sizeEx = 0.026;
            action = "['delete'] call OT_fnc_townGarrisonUI";
        };
        class Clear: RscOverthrowButton {
            idc = 1602;
            x = "safeZoneX + 0.04 * safeZoneW"; y = "safeZoneY + 0.755 * safeZoneH";
            w = "0.135 * safeZoneW"; h = "0.036 * safeZoneH";
            text = "Clear route";
            sizeEx = 0.026;
            action = "['clear'] call OT_fnc_townGarrisonUI";
        };
        class Undo: RscOverthrowButton {
            idc = 1603;
            x = "safeZoneX + 0.185 * safeZoneW"; y = "safeZoneY + 0.755 * safeZoneH";
            w = "0.135 * safeZoneW"; h = "0.036 * safeZoneH";
            text = "Remove last point";
            sizeEx = 0.026;
            action = "['undo'] call OT_fnc_townGarrisonUI";
        };
        class Apply: RscOverthrowButton {
            idc = 1604;
            x = "safeZoneX + 0.04 * safeZoneW"; y = "safeZoneY + 0.905 * safeZoneH";
            w = "0.135 * safeZoneW"; h = "0.036 * safeZoneH";
            text = "Apply";
            sizeEx = 0.026;
            action = "['apply'] call OT_fnc_townGarrisonUI";
        };
        class Reload: RscOverthrowButton {
            idc = 1605;
            x = "safeZoneX + 0.185 * safeZoneW"; y = "safeZoneY + 0.905 * safeZoneH";
            w = "0.135 * safeZoneW"; h = "0.036 * safeZoneH";
            text = "Reload";
            sizeEx = 0.026;
            action = "['reload'] call OT_fnc_townGarrisonUI";
        };
        class NameLabel: RscOverthrowText {
            idc = -1;
            x = "safeZoneX + 0.04 * safeZoneW"; y = "safeZoneY + 0.495 * safeZoneH";
            w = "0.28 * safeZoneW"; h = "0.025 * safeZoneH";
            text = "Company name";
            sizeEx = 0.025;
        };
        class Name: RscOverthrowEdit {
            idc = 1400;
            x = "safeZoneX + 0.04 * safeZoneW"; y = "safeZoneY + 0.527 * safeZoneH";
            w = "0.28 * safeZoneW"; h = "0.037 * safeZoneH";
            sizeEx = 0.028;
            onKillFocus = "['edit'] call OT_fnc_townGarrisonUI";
        };
        class StrengthLabel: RscOverthrowText {
            idc = -1;
            x = "safeZoneX + 0.04 * safeZoneW"; y = "safeZoneY + 0.585 * safeZoneH";
            w = "0.1 * safeZoneW"; h = "0.025 * safeZoneH";
            text = "Strength";
            sizeEx = 0.025;
        };
        class Strength: RscOverthrowEdit {
            idc = 1401;
            x = "safeZoneX + 0.04 * safeZoneW"; y = "safeZoneY + 0.615 * safeZoneH";
            w = "0.09 * safeZoneW"; h = "0.036 * safeZoneH";
            sizeEx = 0.028;
            onKillFocus = "['edit'] call OT_fnc_townGarrisonUI";
        };
        class SpeedLabel: RscOverthrowText {
            idc = -1;
            x = "safeZoneX + 0.15 * safeZoneW"; y = "safeZoneY + 0.585 * safeZoneH";
            w = "0.17 * safeZoneW"; h = "0.025 * safeZoneH";
            text = "Patrol speed";
            sizeEx = 0.025;
        };
        class Speed: RscOverthrowCombo {
            idc = 2100;
            x = "safeZoneX + 0.15 * safeZoneW"; y = "safeZoneY + 0.615 * safeZoneH";
            w = "0.17 * safeZoneW"; h = "0.036 * safeZoneH";
            sizeEx = 0.025;
            onLBSelChanged = "['edit'] call OT_fnc_townGarrisonUI";
        };
        class ModeLabel: RscOverthrowText {
            idc = -1;
            x = "safeZoneX + 0.04 * safeZoneW"; y = "safeZoneY + 0.67 * safeZoneH";
            w = "0.28 * safeZoneW"; h = "0.025 * safeZoneH";
            text = "Task";
            sizeEx = 0.025;
        };
        class Mode: RscOverthrowCombo {
            idc = 2101;
            x = "safeZoneX + 0.04 * safeZoneW"; y = "safeZoneY + 0.7 * safeZoneH";
            w = "0.28 * safeZoneW"; h = "0.036 * safeZoneH";
            sizeEx = 0.025;
            onLBSelChanged = "['edit'] call OT_fnc_townGarrisonUI";
        };
        class Summary: RscOverthrowStructuredText {
            idc = 1101;
            x = "safeZoneX + 0.04 * safeZoneW"; y = "safeZoneY + 0.815 * safeZoneH";
            w = "0.28 * safeZoneW"; h = "0.065 * safeZoneH";
        };
        class Map: RscMapControl {
            idc = 51;
            x = "safeZoneX + 0.35 * safeZoneW"; y = "safeZoneY + 0.13 * safeZoneH";
            w = "0.61 * safeZoneW"; h = "0.745 * safeZoneH";
            onDraw = "_this call OT_fnc_drawTownGarrison";
            onMouseButtonDown = "['map', _this] call OT_fnc_townGarrisonUI";
        };
        class Feedback: RscOverthrowText {
            idc = 1102;
            x = "safeZoneX + 0.36 * safeZoneW"; y = "safeZoneY + 0.14 * safeZoneH";
            w = "0.59 * safeZoneW"; h = "0.037 * safeZoneH";
            sizeEx = 0.025;
            colorBackground[] = {0.02, 0.03, 0.02, 0.85};
        };
        class Instructions: RscOverthrowStructuredText {
            idc = -1;
            x = "safeZoneX + 0.35 * safeZoneW"; y = "safeZoneY + 0.89 * safeZoneH";
            w = "0.61 * safeZoneW"; h = "0.06 * safeZoneH";
            text = "Shift + left click: add route point / Right click: remove last point<br/>Drag to pan the map; scroll to zoom.";
        };
        class Close: RscOverthrowButton {
            idc = 1606;
            x = "safeZoneX + 0.86 * safeZoneW"; y = "safeZoneY + 0.065 * safeZoneH";
            w = "0.1 * safeZoneW"; h = "0.035 * safeZoneH";
            text = "Close";
            sizeEx = 0.026;
            action = "closeDialog 0";
        };
    };
};
