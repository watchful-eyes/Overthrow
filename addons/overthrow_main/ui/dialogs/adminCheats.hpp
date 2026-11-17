// Added 16 November 2026 for the community fork. GNU GPL v2.
class OT_dialog_adminCheats {
    idd = 9250;
    movingEnable = 0;
    enableSimulation = 1;
    onLoad = "[_this # 0, 'OT_dialog_adminCheats'] call OT_fnc_localizeDisplay";
    class controlsBackground {
        class Background: RscOTPanel {
            x = "safeZoneX + 0.19 * safeZoneW"; y = "safeZoneY + 0.10 * safeZoneH";
            w = "0.62 * safeZoneW"; h = "0.80 * safeZoneH";
        };
        class Accent: RscOverthrowText {
            x = "safeZoneX + 0.19 * safeZoneW"; y = "safeZoneY + 0.10 * safeZoneH";
            w = "0.62 * safeZoneW"; h = "0.004 * safeZoneH";
            colorBackground[] = {0.27, 0.86, 0.63, 1};
        };
    };
    class controls {
        class Title: RscOTHeading {
            text = "ADMIN / CHEATS";
            x = "safeZoneX + 0.22 * safeZoneW"; y = "safeZoneY + 0.13 * safeZoneH";
            w = "0.56 * safeZoneW"; h = "0.05 * safeZoneH";
        };
        class PlayerLabel: RscOverthrowText {
            text = "Target player";
            x = "safeZoneX + 0.22 * safeZoneW"; y = "safeZoneY + 0.205 * safeZoneH";
            w = "0.56 * safeZoneW"; h = "0.03 * safeZoneH";
        };
        class Players: RscOverthrowCombo {
            idc = 2100;
            x = "safeZoneX + 0.22 * safeZoneW"; y = "safeZoneY + 0.24 * safeZoneH";
            w = "0.56 * safeZoneW"; h = "0.045 * safeZoneH";
            onLBSelChanged = "['selection'] call OT_fnc_adminCheatUI";
        };
        class Balances: RscOverthrowStructuredText {
            idc = 1100;
            x = "safeZoneX + 0.22 * safeZoneW"; y = "safeZoneY + 0.31 * safeZoneH";
            w = "0.56 * safeZoneW"; h = "0.13 * safeZoneH";
            size = "0.026 * safeZoneH";
        };
        class ResourceLabel: PlayerLabel {
            text = "Resource";
            y = "safeZoneY + 0.46 * safeZoneH"; w = "0.30 * safeZoneW";
        };
        class ModeLabel: ResourceLabel {
            text = "Operation";
            x = "safeZoneX + 0.54 * safeZoneW"; w = "0.24 * safeZoneW";
        };
        class Resource: RscOverthrowCombo {
            idc = 2101;
            x = "safeZoneX + 0.22 * safeZoneW"; y = "safeZoneY + 0.50 * safeZoneH";
            w = "0.30 * safeZoneW"; h = "0.045 * safeZoneH";
            onLBSelChanged = "['selection'] call OT_fnc_adminCheatUI";
        };
        class Mode: RscOverthrowCombo {
            idc = 2102;
            x = "safeZoneX + 0.54 * safeZoneW"; y = "safeZoneY + 0.50 * safeZoneH";
            w = "0.24 * safeZoneW"; h = "0.045 * safeZoneH";
        };
        class AmountLabel: PlayerLabel {
            text = "Amount";
            y = "safeZoneY + 0.57 * safeZoneH";
        };
        class Amount: RscOverthrowEdit {
            idc = 1400; text = "10000";
            x = "safeZoneX + 0.22 * safeZoneW"; y = "safeZoneY + 0.61 * safeZoneH";
            w = "0.27 * safeZoneW"; h = "0.045 * safeZoneH";
        };
        class Preset1000: RscOverthrowButton {
            idc = 1610; text = "1,000";
            x = "safeZoneX + 0.51 * safeZoneW"; y = "safeZoneY + 0.61 * safeZoneH";
            w = "0.08 * safeZoneW"; h = "0.045 * safeZoneH";
            action = "['amount', [1000]] call OT_fnc_adminCheatUI";
        };
        class Preset10000: Preset1000 {
            idc = 1611; text = "10,000"; x = "safeZoneX + 0.605 * safeZoneW";
            action = "['amount', [10000]] call OT_fnc_adminCheatUI";
        };
        class Preset100000: Preset1000 {
            idc = 1612; text = "100,000"; x = "safeZoneX + 0.70 * safeZoneW";
            action = "['amount', [100000]] call OT_fnc_adminCheatUI";
        };
        class Apply: RscOTPrimaryButton {
            idc = 1600; text = "Apply";
            x = "safeZoneX + 0.22 * safeZoneW"; y = "safeZoneY + 0.69 * safeZoneH";
            w = "0.27 * safeZoneW"; h = "0.05 * safeZoneH";
            action = "['apply'] call OT_fnc_adminCheatUI";
        };
        class Refresh: RscOverthrowButton {
            idc = 1601; text = "Refresh";
            x = "safeZoneX + 0.51 * safeZoneW"; y = "safeZoneY + 0.69 * safeZoneH";
            w = "0.27 * safeZoneW"; h = "0.05 * safeZoneH";
            action = "['refresh'] call OT_fnc_adminCheatUI";
        };
        class Feedback: RscOverthrowStructuredText {
            idc = 1101;
            x = "safeZoneX + 0.22 * safeZoneW"; y = "safeZoneY + 0.755 * safeZoneH";
            w = "0.56 * safeZoneW"; h = "0.065 * safeZoneH";
            size = "0.022 * safeZoneH";
        };
        class Save: RscOverthrowButton {
            idc = 1602;
            text = "Save campaign";
            x = "safeZoneX + 0.22 * safeZoneW"; y = "safeZoneY + 0.835 * safeZoneH";
            w = "0.27 * safeZoneW"; h = "0.04 * safeZoneH";
            action = "[player] remoteExec ['OT_fnc_saveGame', 2, false]";
        };
        class Back: RscOverthrowButton {
            text = "Back";
            x = "safeZoneX + 0.51 * safeZoneW"; y = "safeZoneY + 0.835 * safeZoneH";
            w = "0.27 * safeZoneW"; h = "0.04 * safeZoneH";
            action = "closeDialog 0; call OT_fnc_optionsDialog";
        };
    };
};
