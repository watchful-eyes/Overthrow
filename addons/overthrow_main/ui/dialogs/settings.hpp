// Modified/added for the unofficial Garrison and Command Expansion, 14-16 November 2026.
// Original author/copyright notices are retained; see LICENSE.md (GNU GPL v2).
class OT_dialog_options {
    onLoad = "[_this # 0, 'OT_dialog_options'] call OT_fnc_localizeDisplay";
    idd = 9230; movingEnable = 0; enableSimulation = 1;
    class controlsBackground {
        class Backdrop: RscOTPanel {
            idc = -1; text = "";
            x = "safeZoneX + 0.21 * safeZoneW"; y = "safeZoneY + 0.13 * safeZoneH";
            w = "0.58 * safeZoneW"; h = "0.74 * safeZoneH";
        };
        class Accent: RscOverthrowText {
            idc = -1; text = "";
            x = "safeZoneX + 0.21 * safeZoneW"; y = "safeZoneY + 0.13 * safeZoneH";
            w = "0.58 * safeZoneW"; h = "0.004 * safeZoneH";
            colorBackground[] = {0.27,0.86,0.63,1};
        };
    };
    class controls {
        class Title: RscOTHeading {
            idc = -1; text = "SETTINGS / CAMPAIGN";
            x = "safeZoneX + 0.235 * safeZoneW"; y = "safeZoneY + 0.165 * safeZoneH";
            w = "0.53 * safeZoneW"; h = "0.05 * safeZoneH";
        };
        class Option1600: RscOTPrimaryButton {
            idc = 1600; text = "SAVE CAMPAIGN";
            x = "safeZoneX + 0.235 * safeZoneW"; y = "safeZoneY + 0.26 * safeZoneH";
            w = "0.53 * safeZoneW"; h = "0.048 * safeZoneH";
            action = "closeDialog 0; [player] remoteExec ['OT_fnc_saveGame', 2, false];";
        };
        class Option1607: RscOverthrowButton {
            idc = 1607; text = "Autosave interval";
            x = "safeZoneX + 0.235 * safeZoneW"; y = "safeZoneY + 0.335 * safeZoneH";
            w = "0.255 * safeZoneW"; h = "0.048 * safeZoneH";
            action = "[] remoteExec ['OT_fnc_autoSaveToggle', 2];";
        };
        class Option1608: RscOverthrowButton {
            idc = 1608; text = "Autoload save";
            x = "safeZoneX + 0.51 * safeZoneW"; y = "safeZoneY + 0.335 * safeZoneH";
            w = "0.255 * safeZoneW"; h = "0.048 * safeZoneH";
            action = "[] remoteExec ['OT_fnc_autoloadToggle', 2]";
        };
        class Option1605: RscOverthrowButton {
            idc = 1605; text = "Clear bodies / wrecks";
            x = "safeZoneX + 0.235 * safeZoneW"; y = "safeZoneY + 0.455 * safeZoneH";
            w = "0.255 * safeZoneW"; h = "0.048 * safeZoneH";
            action = "call OT_fnc_cleanDead;";
        };
        class LanguageEnglish: RscOverthrowButton {
            idc = 1951; text = "English";
            x = "safeZoneX + 0.235 * safeZoneW"; y = "safeZoneY + 0.40 * safeZoneH";
            w = "0.255 * safeZoneW"; h = "0.04 * safeZoneH";
            action = "'en' call OT_fnc_setLanguage";
        };
        class LanguageTurkish: LanguageEnglish {
            idc = 1952; text = "Türkçe";
            x = "safeZoneX + 0.51 * safeZoneW";
            action = "'tr' call OT_fnc_setLanguage";
        };
        class Option1606: RscOverthrowButton {
            idc = 1606; text = "Clear fog";
            x = "safeZoneX + 0.51 * safeZoneW"; y = "safeZoneY + 0.455 * safeZoneH";
            w = "0.255 * safeZoneW"; h = "0.048 * safeZoneH";
            action = "[0, 0] remoteExecCall ['setFog', 0, false]";
        };
        class Option1601: RscOverthrowButton {
            idc = 1601; text = "Civilian density −";
            x = "safeZoneX + 0.235 * safeZoneW"; y = "safeZoneY + 0.565 * safeZoneH";
            w = "0.255 * safeZoneW"; h = "0.048 * safeZoneH";
            action = "OT_spawnCivPercentage = OT_spawnCivPercentage - 0.01; if (OT_spawnCivPercentage < 0) then { OT_spawnCivPercentage = 0 }; publicVariable 'OT_spawnCivPercentage'; hint  (format ['Civilian spawn now at %1%2', OT_spawnCivPercentage * 100, '%'] call OT_fnc_localizeText);";
        };
        class Option1602: RscOverthrowButton {
            idc = 1602; text = "Civilian density +";
            x = "safeZoneX + 0.51 * safeZoneW"; y = "safeZoneY + 0.565 * safeZoneH";
            w = "0.255 * safeZoneW"; h = "0.048 * safeZoneH";
            action = "OT_spawnCivPercentage = OT_spawnCivPercentage + 0.01; if (OT_spawnCivPercentage < 0) then { OT_spawnCivPercentage = 0 }; publicVariable 'OT_spawnCivPercentage'; hint  (format ['Civilian spawn now at %1%2', OT_spawnCivPercentage * 100, '%'] call OT_fnc_localizeText);";
        };
        class Option1603: RscOverthrowButton {
            idc = 1603; text = "Decrease tax";
            x = "safeZoneX + 0.235 * safeZoneW"; y = "safeZoneY + 0.675 * safeZoneH";
            w = "0.255 * safeZoneW"; h = "0.048 * safeZoneH";
            action = "call OT_fnc_decreaseTax";
        };
        class AdminCheats: RscOTPrimaryButton {
            idc = 1610; text = "Admin cheat menu";
            x = "safeZoneX + 0.235 * safeZoneW"; y = "safeZoneY + 0.625 * safeZoneH";
            w = "0.53 * safeZoneW"; h = "0.037 * safeZoneH";
            sizeEx = "0.025 * safeZoneH";
            action = "['open'] call OT_fnc_adminCheatUI";
        };
        class Option1604: RscOverthrowButton {
            idc = 1604; text = "Increase tax";
            x = "safeZoneX + 0.51 * safeZoneW"; y = "safeZoneY + 0.675 * safeZoneH";
            w = "0.255 * safeZoneW"; h = "0.048 * safeZoneH";
            action = "call OT_fnc_increaseTax";
        };
        class Option1609: RscOverthrowButton {
            idc = 1609; text = "Zeus access";
            x = "safeZoneX + 0.235 * safeZoneW"; y = "safeZoneY + 0.785 * safeZoneH";
            w = "0.255 * safeZoneW"; h = "0.048 * safeZoneH";
            action = "call OT_fnc_toggleZeus;";
        };
        class Close: RscOverthrowButton {
            idc = 1900; text = "Close";
            x = "safeZoneX + 0.51 * safeZoneW"; y = "safeZoneY + 0.785 * safeZoneH";
            w = "0.255 * safeZoneW"; h = "0.048 * safeZoneH";
            action = "closeDialog 0";
        };
    };
};

